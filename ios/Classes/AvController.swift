//
//  AvController.swift
//  BSGridCollectionViewLayout
//
//  Created by mx on 2020/7/2.
//


import AVFoundation
import MobileCoreServices

public class AvController: NSObject {
    public func getVideoAsset(_ url:URL)->AVURLAsset {
        return AVURLAsset(url: url)
    }
    
    public func getTrack(_ asset: AVURLAsset)->AVAssetTrack? {
        return asset.tracks(withMediaType: AVMediaType.video).first!
    }
    
    public func getVideoOrientation(_ path:String)-> Int? {
        let url = Utility.getPathUrl(path)
        let asset = getVideoAsset(url)
        guard let track = getTrack(asset) else {
            return nil
        }
        let size = track.naturalSize
        let txf = track.preferredTransform
        if size.width == txf.tx && size.height == txf.ty {
            return 0
        } else if txf.tx == 0 && txf.ty == 0 {
            return 90
        } else if txf.tx == 0 && txf.ty == size.width {
            return 180
        } else {
            return 270
        }
    }
    
    public func getMetaDataByTag(_ asset:AVAsset,key:String)->String {
        for item in asset.commonMetadata {
            if item.commonKey?.rawValue == key {
                return item.stringValue ?? "";
            }
        }
        return ""
    }
}