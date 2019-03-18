import 'package:flutter/material.dart';
import 'package:flutter_video_app/ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  var title = "Flutter Video";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "$title",
      debugShowCheckedModeBanner: false,
      home: Home(
        header: "$title",
      ),

      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
    );
  }
}