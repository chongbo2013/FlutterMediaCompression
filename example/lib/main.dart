import 'dart:io';

import 'package:MediaCompression_example/FileUtils.dart';
import 'package:MediaCompression_example/PlayerVideoAndPopPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:MediaCompression/MediaCompression.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'DateUtils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MediaCompression.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  var data = List();
  String resultFinal = '结果';
  String resultPath;

  String resultVideoPath;
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    int countSize = 1;
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: countSize,
        enableCamera: true,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      data.clear();
      data.addAll(resultList);

      String curTime = DateUtils.currentTimeMillisString();
      File file = await FileUtils.getUserLocalMediasDirectory('$curTime.jpg');

      bool exists = await file.exists();
      if (!exists) {
        await file.create(recursive: true);
      }

      String curTime2 = DateUtils.currentTimeMillisString();
      File file2 = await FileUtils.getUserLocalMediasDirectory('$curTime2.jpg');
      bool exists2 = await file2.exists();
      if (!exists2) {
        await file2.create(recursive: true);
      }

      ByteData byteData = await data[0].getByteData(quality: 80);
      File result = await file.writeAsBytes(byteData.buffer.asInt8List(0));
      if (result != null) {
        String resultFinal2 =
            await MediaCompression.compressFileHandler(result.path, file2.path);
        setState(() {
          resultFinal = resultFinal2;
          resultPath = resultFinal2;
        });
      }
    } on Exception catch (e) {
      error = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin  example app'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text('Running on: $_platformVersion\n'),
                  GestureDetector(
                    onTap: () {
                      loadAssets();
                    },
                    child: Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(9)),
                      child: Text('点击选择图片压缩'),
                    ),
                  ),
                  Text(resultFinal),
                  showImage(),
                  SizedBox(height: 20,)
                  ,
                  GestureDetector(
                    onTap: () {
                      selectVideo().then((value) {
                        setState(() {
                          resultVideoPath=value;
                          print(resultVideoPath);
                        });



                      }).catchError((error){

                      }).whenComplete(() {

                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(9)),
                      child: Text('点击选择视频压缩'),
                    ),
                  ),
                  Text('$resultVideoPath'),
                  getVideoView()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getVideoView(){
    if(resultVideoPath==null){
      return Text('没有视频');
    }
    return Container(
      height: 500,
      width: double.infinity,
      child: PlayerVideoAndPopPage(resultVideoPath),
    );
  }
  Future<String> selectVideo() async{
  final PickedFile pickFile = await _picker.getVideo(
  source: ImageSource.gallery, maxDuration: const Duration(seconds: 1000));


  String curTime2 = DateUtils.currentTimeMillisString();
  File file2 = await FileUtils.getUserLocalMediasDirectory('$curTime2.mp4');
  bool exists2 = await file2.exists();
  if (!exists2) {
    await file2.create(recursive: true);
  }

  String resultFinal2 = await MediaCompression.compressVideoFileHandler(pickFile.path, file2.path);
  return resultFinal2;
}
  Widget showImage() {
    if (resultPath != null) {
      return Image.file(
        File(resultFinal),
        width: 300,
        height: 160,
      );
    } else {
      return Text('图片获取失败');
    }
  }
}


