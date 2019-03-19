import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_app/ui/player.dart';
import 'package:path/path.dart' as p;
import 'dart:async';
import 'dart:io';
import 'package:thumbnails/thumbnails.dart';
import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';



class Home extends StatefulWidget {

  final String header;

  Home({Key key, this.header}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Channel Platform: Check MainActivity.java
  static const platform = const MethodChannel('samples.flutter.io/videos');
  List vids;
  String thumbnail;

  //Check the MainActivity.java
  Future<void> _getVideos() async {
    List videos;
    try {
      final List result = await platform.invokeMethod('getVideos');
      videos = result;
      print(videos);
    } on PlatformException catch (e) {
      print("Error $e");
    }

    setState(() {
      vids = videos;
    });
  }

  @override
  void initState() {
    super.initState();
    _getVideos();
  }

  //Generate Thumbnail for videos
  void _genThumb(String vid) async {
    String thumb = await Thumbnails.getThumbnail(
        videoFile: '$vid',
        imageType: ThumbFormat.JPEG,
        quality: 30);
//    print('Path to cache folder $thumb');

    setState(() {
      thumbnail = thumb;
    });
//    return thumb;
  }

  List<Widget> createImageCardItem(
      List videos, BuildContext context) {
    // Children list for the list.
    List<Widget> listElementWidgetList = new List<Widget>();
    if (videos != null) {
      var lengthOfList = videos.length;
      for (int i = 0; i < lengthOfList; i++) {
        String vidSrc = videos[i];
        String vidName = p.basename(videos[i]);

//        _genThumb(vidSrc);
//        var vidImg = thumbnail == null ? 0 : thumbnail;

//        File imgFile = new File(vidImg);
//        print(vidImg);

        var listItem = GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black45,
              title: Text(vidName),
            ),
            child: GestureDetector(
              onTap: () {
                var router = MaterialPageRoute(
                    builder: (BuildContext context){
                      return Player(header: widget.header, video: vidSrc);
                    }
                );

                Navigator.of(context).push(router);
              },
              //Display delete alert when longPress on card
              onLongPress: () {
                var alert = new AlertDialog(
                  title: Text("Delete File?"),
                  content: Text("Are you sure you want to delete $vidName?"),

                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        File myFile = new File(vidSrc);
                        myFile.delete();
                      },
                      child: Text("Yes"),
                    ),
                    FlatButton(
                      child: Text("No"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );

                showDialog(context: context, builder: (context) => alert);
              }

//              child: Image.file(imgFile),
//              child: FadeInImage.(
//                placeholder: "$kTransparentImage",
//                image: img_src,
//                fit: BoxFit.cover,
//              ),
            ));
        listElementWidgetList.add(listItem);
      }
    }
    return listElementWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,


      appBar: AppBar(
        title: Text(
          widget.header,
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        actions: <Widget>[
          IconButton(
              icon:Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              onPressed: () => _showAlertInfo(context)
          ),
        ],
      ),

      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          new SliverPadding(
            padding: const EdgeInsets.all(10.0),
            sliver: new SliverGrid.count(
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              crossAxisCount: 2,
              children:
              createImageCardItem(vids, context),
            ),
          ),
        ],
      ),
    );
  }


  //Function to Show Alert Dialog for showing app details
  void _showAlertInfo(BuildContext context){
    var alert = new AlertDialog(
      title: Text("Info"),
      content: Text("Made With Flutter by JideGuru"),

      actions: <Widget>[

        FlatButton(
          onPressed: (){Navigator.pop(context);},
          child: Text("OK"),
        )
      ],
    );

    showDialog(context: context, builder: (context)=> alert);
  }
}
