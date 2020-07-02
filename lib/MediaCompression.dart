import 'dart:async';

import 'package:flutter/services.dart';

class MediaCompression {
  static const MethodChannel _channel =
      const MethodChannel('MediaCompression');



  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String>  compressFileHandler(String file,String targetDir) async {
    final String version = await _channel.invokeMethod('CompressFileHandler',[file,targetDir]);
    return version;
  }

  static Future<String>  compressVideoFileHandler(String file,String targetDir) async {
    final String version = await _channel.invokeMethod('CompressVideoFileHandler',[file,targetDir]);
    return version;
  }
}
