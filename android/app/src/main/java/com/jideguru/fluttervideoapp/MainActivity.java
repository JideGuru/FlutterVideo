package com.jideguru.fluttervideoapp;

import android.database.Cursor;
import android.os.Bundle;
import android.provider.MediaStore;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutter.io/videos";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            (call, result) -> {
                if (call.method.equals("getVideos")) {
                    ArrayList<String> vids = findVideos();
                    if (vids.size() <= 0) {
                        result.error("Empty", "No Videos.", null);
                    } else {
                        result.success(vids);                      }
                } else {
                    result.notImplemented();
                }

            });


  }

  public ArrayList<String> findVideos(){
    HashSet<String> videoItemHashSet = new HashSet<>();
    String[] projection = { MediaStore.Video.VideoColumns.DATA ,MediaStore.Video.Media.DISPLAY_NAME};
    Cursor cursor = getContentResolver().query(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, projection, null, null, null);
    try {
      cursor.moveToFirst();
      do{
        videoItemHashSet.add((cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Video.Media.DATA))));
      }while(cursor.moveToNext());

      cursor.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    ArrayList<String> downloadedList = new ArrayList<>(videoItemHashSet);
    return downloadedList;
  }
}
