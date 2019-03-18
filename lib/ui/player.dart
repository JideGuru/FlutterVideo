import 'package:flutter/material.dart';

class Player extends StatefulWidget {

  final String header;
  final String video;

  Player({Key key, this.header, this.video}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
