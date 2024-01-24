import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String videoUrl;

  VideoPage({required this.videoUrl});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;

//   @override
//   void initState() {
//     super.initState();
// print(widget.videoUrl);
//     _chewieController = ChewieController(
//       videoPlayerController: VideoPlayerController.network(widget.videoUrl),
//       autoPlay: true,
//       looping: true,
//       aspectRatio: 16 / 9, // Adjust as needed
//       // other chewie options...
//     );
//   }

 @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false, // Set looping to false to detect when the video completes
      aspectRatio: 16 / 9, // Adjust as needed
      // other chewie options...
    );

    _videoPlayerController.addListener(() {
      // Check if the video has completed playback
      if (_videoPlayerController.value.position ==
          _videoPlayerController.value.duration) {
        // Video has completed
        // You can call your function here
        updateVideoProgress(widget.videoUrl, 'Completed');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lecture'),
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chewieController.dispose();
    super.dispose();
  }

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
                  videoId);

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
