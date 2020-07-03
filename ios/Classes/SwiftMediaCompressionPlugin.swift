import Flutter
import UIKit
import AVFoundation
public class SwiftMediaCompressionPlugin: NSObject, FlutterPlugin {
    static  let queue = DispatchQueue(label: "com.mx.mediaCompressionqueue")
    private let registrar: FlutterPluginRegistrar
    private let controller: FlutterMethodChannel
    private let avController = AvController()
     private var stopCommand = false
    private var exporter: AVAssetExportSession? = nil
    init(registrar: FlutterPluginRegistrar, controller: FlutterMethodChannel) {
        self.registrar = registrar
        self.controller = controller
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        
        let channel = FlutterMethodChannel(name: "MediaCompression", binaryMessenger: registrar.messenger())
        let instance = SwiftMediaCompressionPlugin(registrar: registrar, controller: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        SwiftMediaCompressionPlugin.queue.async {
            if(call.method.elementsEqual("getPlatformVersion")){
                result("iOS " + UIDevice.current.systemVersion)
            }else if(call.method.elementsEqual("CompressFileHandler")){
                self.handleCompressFileHandler(call,result: result)
            }else if(call.method.elementsEqual("CompressVideoFileHandler")){
                self.handleCompressVideoFileHandler(call,result: result)
            }else{
                result(FlutterMethodNotImplemented)
            }
        }
        
    }
    
    func handleCompressFileHandler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args:NSArray = call.arguments as! NSArray
        let path:String = args[0] as! String
        let targetDir:String = args[1] as! String
        
        //    contentsOfFile
        var image=UIImage.init(contentsOfFile: path);
        var data = image?.compressedData()
        NSData(data: data!).write(toFile: targetDir, atomically: true)
        result(targetDir)
    }
    
    func handleCompressVideoFileHandler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args:NSArray = call.arguments as! NSArray
        let path:String = args[0] as! String
        let targetDir:String = args[1] as! String
        
//        let url = Utility.getPathUrl(path)
//        let asset = avController.getVideoAsset(url)
//        guard let track = avController.getTrack(asset) else {return  }
//        let size = track.naturalSize.applying(track.preferredTransform)
//        let width = abs(size.width)
//        let height = abs(size.height)
//        let bitrate=0.05*25*width*height
        
        
        let quality = NSNumber(2)
        let deleteOrigin = false
        let startTime = Double(0)
        let duration = Double(-1)
        let includeAudio = true
        let frameRate = 25
        self.compressVideo(path, quality: quality, deleteOrigin:deleteOrigin, startTime:startTime, duration:duration, includeAudio:includeAudio,
                           frameRate:frameRate,targetDir:targetDir, result:result)
    }
    
    
    private func compressVideo(_ path: String,quality: NSNumber,deleteOrigin: Bool,startTime: Double?,
                               duration: Double?,includeAudio: Bool?,frameRate: Int?,targetDir:String,
                               result: @escaping FlutterResult) {
        let sourceVideoUrl = Utility.getPathUrl(path)
//        print(sourceVideoUrl);
       // let sourceVideoType = sourceVideoUrl.pathExtension
        
        let sourceVideoAsset = avController.getVideoAsset(sourceVideoUrl)
        
        let sourceVideoTrack = avController.getTrack(sourceVideoAsset)
        
        let compressionUrl =
            Utility.getPathUrl(targetDir)
        
        let timescale = sourceVideoAsset.duration.timescale
        let minStartTime = Double(startTime ?? 0)
        
        let videoDuration = sourceVideoAsset.duration.seconds
        let minDuration = Double(duration ?? videoDuration)
        let maxDurationTime = minStartTime + minDuration < videoDuration ? minDuration : videoDuration
        
        let cmStartTime = CMTimeMakeWithSeconds(minStartTime, preferredTimescale: timescale)
        let cmDurationTime = CMTimeMakeWithSeconds(maxDurationTime, preferredTimescale: timescale)
        let timeRange: CMTimeRange = CMTimeRangeMake(start: cmStartTime, duration: cmDurationTime)
        
        let isIncludeAudio = includeAudio != nil ? includeAudio! : false
        
        let session = getComposition(isIncludeAudio, timeRange, sourceVideoTrack!)
        
        let exporter = AVAssetExportSession(asset: session, presetName: getExportPreset(quality))!
        
        exporter.outputURL = compressionUrl
        exporter.outputFileType = AVFileType.mp4
        exporter.shouldOptimizeForNetworkUse = true
        
        if frameRate != nil {
            let videoComposition = AVMutableVideoComposition(propertiesOf: sourceVideoAsset)
            videoComposition.frameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate!))
            exporter.videoComposition = videoComposition
        }
        
        if !isIncludeAudio {
            exporter.timeRange = timeRange
        }
        Utility.deleteFile(compressionUrl.absoluteString)
        
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateProgress),
                                         userInfo: exporter, repeats: true)
        
        exporter.exportAsynchronously(completionHandler: {
            if(self.stopCommand) {
                timer.invalidate()
                self.stopCommand = false
//                var json = self.getMediaInfoJson(path)
//                json["isCancel"] = true
//                let jsonString = Utility.keyValueToJson(json)
                return result("")
            }
            
            if(exporter.status==AVAssetExportSession.Status.completed){
                 result(targetDir)
            }else if(exporter.status==AVAssetExportSession.Status.cancelled){
                 result("")
            }else if(exporter.status==AVAssetExportSession.Status.failed){
                result(exporter.error.debugDescription)
            }
           
        })
    }
    
    private func getComposition(_ isIncludeAudio: Bool,_ timeRange: CMTimeRange, _ sourceVideoTrack: AVAssetTrack)->AVAsset {
        let composition = AVMutableComposition()
        if !isIncludeAudio {
            let compressionVideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
            compressionVideoTrack!.preferredTransform = sourceVideoTrack.preferredTransform
            try? compressionVideoTrack!.insertTimeRange(timeRange, of: sourceVideoTrack, at: CMTime.zero)
        } else {
            return sourceVideoTrack.asset!
        }
        
        return composition
    }
    
    private func getExportPreset(_ quality: NSNumber)->String {
          switch(quality) {
          case 2:
              return AVAssetExportPresetMediumQuality
          case 3:
              return AVAssetExportPresetHighestQuality
          default:
              return AVAssetExportPresetLowQuality
          }
      }
      
    @objc private func updateProgress(timer:Timer) {
          let asset = timer.userInfo as! AVAssetExportSession
          if(!stopCommand) {
//              channel.invokeMethod("updateProgress", arguments: "\(String(describing: asset.progress * 100))")
          }
      }
   
       public func getMediaInfoJson(_ path: String)->[String : Any?] {
           let url = Utility.getPathUrl(path)
           let asset = avController.getVideoAsset(url)
           guard let track = avController.getTrack(asset) else { return [:] }
           
           let playerItem = AVPlayerItem(url: url)
           let metadataAsset = playerItem.asset
           
           let orientation = avController.getVideoOrientation(path)
           
           let title = avController.getMetaDataByTag(metadataAsset,key: "title")
           let author = avController.getMetaDataByTag(metadataAsset,key: "author")
           
           let duration = asset.duration.seconds * 1000
           let filesize = track.totalSampleDataLength
           
           let size = track.naturalSize.applying(track.preferredTransform)
           
           let width = abs(size.width)
           let height = abs(size.height)
           
           let dictionary = [
               "path":Utility.excludeFileProtocol(path),
               "title":title,
               "author":author,
               "width":width,
               "height":height,
               "duration":duration,
               "filesize":filesize,
               "orientation":orientation
               ] as [String : Any?]
           return dictionary
       }
}
