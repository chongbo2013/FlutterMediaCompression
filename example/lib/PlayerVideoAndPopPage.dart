import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
class PlayerVideoAndPopPage extends StatefulWidget {
  String path;
  PlayerVideoAndPopPage(this.path,{ Key key }) : super(key: key);

  @override
  PlayerVideoAndPopPageState createState() => PlayerVideoAndPopPageState();
}

class PlayerVideoAndPopPageState extends State<PlayerVideoAndPopPage> {
  VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;


  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.file(File(widget.path));
    _videoPlayerController.addListener(() {
      if (startedPlaying && !_videoPlayerController.value.isPlaying) {
         _videoPlayerController.play();
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<bool> started() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    startedPlaying = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      child: Center(
        child: FutureBuilder<bool>(
          future: started(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              );
            } else {
              return const Text('waiting for video to load');
            }
          },
        ),
      ),
    );
  }
}