import Flutter
import UIKit
public class SwiftMediaCompressionPlugin: NSObject, FlutterPlugin {
    static  let queue = DispatchQueue(label: "com.mx.mediaCompressionqueue")
    private let registrar: FlutterPluginRegistrar
     private let controller: FlutterMethodChannel
    
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

    

}
