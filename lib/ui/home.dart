import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'dart:async';
import 'dart:io';

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

  //Check the MainActivity.java
  Future<void> _getVideos() async {
    List videos;
    try {
      final List result = await platform.invokeMethod('getVideos');
      videos = result;
      print(videos);
    } on PlatformException catch (e) {
      print("Error");
    }

    setState(() {
      vids = videos;
    });
  }

  @override
  void initState() {
    _getVideos();
  }

  List<Widget> createImageCardItem(
      List videos, BuildContext context) {
    // Children list for the list.
    List<Widget> listElementWidgetList = new List<Widget>();
    if (videos != null) {
      var lengthOfList = videos.length;
      for (int i = 0; i < lengthOfList; i++) {
        String vids_src = videos[i];
        String vids_name = p.basename(videos[i]);

//        File img_file = new File(img_src);
        print(vids_name);
        // Image URL
        // List item created with an image of the poster
        var listItem = GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black45,
              title: Text(vids_name),
            ),
            child: GestureDetector(
              onTap: () {
                var router = MaterialPageRoute(
                    builder: (BuildContext context){
//                      return Details(header: movie.title, img: imageURL, id: movie.id);
                    }
                );

                Navigator.of(context).push(router);
              },
              onLongPress: (){
                var alert = new AlertDialog(
                  title: Text("Delete?"),
                  content: Text("Are you sure you want to delete this file?"),

                  actions: <Widget>[

                    FlatButton(
                      onPressed: (){Navigator.pop(context);},
                      child: Text("No"),
                    ),
                    FlatButton(
                      onPressed: (){
                        var myFile = new File(vids_src);
                        myFile.delete();
                      },
                      child: Text("Yes"),
                    ),
                  ],
                );

                showDialog(context: context, builder: (context)=> alert);
              },

//              child: Image.file(img_file),
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
