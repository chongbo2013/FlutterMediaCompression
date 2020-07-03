
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:path_provider/path_provider.dart';

class FileUtils{

//临时目录 getTemporaryDirectory  iOS：NSTemporaryDirectory()  android getCacheDir() 系统可以随时清理

//文档目录 getApplicationDocumentsDirectory  iOS：NSDocumentDirectory()  android AppData() 只有当应用程序被卸载时，系统才会清除该目录

//外部存储目录  getExternalStorageDirectory ios:UnsupportedError异常  android: getExternalStorageDirectory

  //获取文档目录
  static Future<File> getDocumnetsDirectory(String fileName) async{
    //获取应用目录// 获取本地文档目录
    String dir=(await getApplicationDocumentsDirectory()).path;
    return new File('$dir/$fileName');
  }

  //获取临时目录
  static Future<File> getCacheDirectory(String fileName) async{
    //获取应用目录// 获取本地文档目录
    String dir=(await getTemporaryDirectory()).path;
    return new File('$dir/$fileName');
  }


  //获取用户资源目录
  static Future<File> getUserLocalMediasDirectory(String fileName) async{
    String dir=(await getApplicationDocumentsDirectory()).path;

    Directory dirFile=Directory('$dir/medias/');

    bool exists = await dirFile.exists();
    if (!exists) {
      await dirFile.create(recursive: true);
    }
    return  new File('$dir/medias/$fileName');
  }


}