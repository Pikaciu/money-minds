import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';

class VideoPlayerPage2 extends StatefulWidget {
  // final String title;
  // final String videoUrl;
  // final String? videoId; // Extracted videoId from the YouTube videoUrl

  // VideoPlayerPage2({
  //   required this.title,
  //   required this.videoUrl,
  // }) : videoId = YoutubePlayer.convertUrlToId(videoUrl);

  @override
  _VideoPlayerPage2State createState() => _VideoPlayerPage2State();
}

class _VideoPlayerPage2State extends State<VideoPlayerPage2> {
  // late YoutubePlayerController _controller;
final videoUrl = 'https://www.youtube.com/watch?v=JhyGY7bKIUA';
// FlutterYoutubeViewController _controller;
  // @override
  // void initState() {
  //   final videoId = YoutubePlayer.convertUrlToId(videoUrl);
  //   print(videoId);
  //   // super.initState();
  //   // // print("Video ID:");
  //   // // // print("Video ID: ${widget.videoId}");
  //   // _controller = YoutubePlayerController(
  //   //   initialVideoId: videoId!,
  //   //   flags: YoutubePlayerFlags(
  //   //     // autoPlay: true,
  //   //     // mute: false,
  //   //   ),
  //   // );
  //   // _controller = YoutubePlayerController(
  //   //   initialVideoId:
  //   //     videoId!,
  //   //       // YoutubePlayer.convertUrlToId(videoUrl),
  //   //   flags: YoutubePlayerFlags(
  //   //       mute: false,
  //   //       autoPlay: true,
  //   //       disableDragSeek: true,
  //   //       loop: false,
  //   //       enableCaption: false),
  //   // );

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter YouTube View Example'),
        ),
        body: Center(
          child: FlutterYoutubeView(
            params: YoutubeParam(
              videoId: 'JhyGY7bKIUA',
              showUI: true,
              startSeconds: 0.0,
              autoPlay: true,
            ),
            onViewCreated: (controller) {
              // You can perform additional actions with the controller
            },
          ),
        ),
      ),
    );

}
  // @override
  // void dispose() {
  //   _controller?.dispose(); // Dispose the controller when the widget is disposed
  //   super.dispose();
  // }
  void updateVideoProgress(String videoId, String newProgress) {
    // Implement your logic to update the progress in Firestore here
    // You may use the videoId to uniquely identify the video in your Firestore collection
    print("Updating progress for video $videoId to $newProgress");
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Congratulations!'),
        content: Text('You got 1 coin...'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // Background color
            ),
            onPressed: () async {
              FirebaseAuth auth = FirebaseAuth.instance;
              FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

              DocumentReference userRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid);

              // Get the current videos array
              var userData = await userRef.get();
              var videos = userData['videos'] ?? [];

              // Find the index of the video in the array
              int videoIndex = videos.indexWhere((video) =>
                  video['videoUrl'] ==
                  'https://www.youtube.com/watch?v=$videoId');

              if (videoIndex != -1) {
                // Update the status of the existing video
                videos[videoIndex]['progress'] = newProgress;

                // Update the user document with the modified 'videos' array
                await userRef.update({
                  'coins': FieldValue.increment(1),
                  'videos': videos,
                });
              }
              //       firestoreInstance
              //           .collection('users')
              //           .doc(auth.currentUser!.uid)
              //           .update({
              //         'coins': FieldValue.increment(1),
              //         'videos': FieldValue.arrayUnion([
              //         {'videoUrl': 'https://www.youtube.com/watch?v=${videoId}', 'status': newProgress}
              // ])
              //       });
              Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => UserDahboard()),
              // );

              print('hello');
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
