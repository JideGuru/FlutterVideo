import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
// ignore: implementation_imports
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {

  final String header;
  final String video;

  Player({Key key, this.header, this.video}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  TargetPlatform _platform;

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    File videoFile = new File(widget.video);
    _videoPlayerController = VideoPlayerController.file(videoFile);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      autoInitialize: true,
      fullScreenByDefault: true,
    );

    print(_platform);
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
