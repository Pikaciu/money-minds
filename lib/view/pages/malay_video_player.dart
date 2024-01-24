import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MalayVideoPlayerPage extends StatefulWidget {
  final String title;
  final String videoUrl;
  final String? videoId; // Extracted videoId from the YouTube videoUrl

  MalayVideoPlayerPage({
    required this.title,
    required this.videoUrl,
  }) : videoId = YoutubePlayer.convertUrlToId(videoUrl);

  @override
  _MalayVideoPlayerPageState createState() => _MalayVideoPlayerPageState();
}

class _MalayVideoPlayerPageState extends State<MalayVideoPlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    print("Video ID:");
    print("Video ID: ${widget.videoId}");
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Watch Complete Video',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            progressColors: ProgressBarColors(
              playedColor: Colors.blue,
              handleColor: Colors.blueAccent,
            ),
            onEnded: (data) {
              // Update video progress to "Completed" when video ends
              // You should implement your logic to update the progress in Firestore
              updateVideoProgress(widget.videoId!, "Completed");
            },
          ),
        ],
      ),
    );
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
              var videos = userData['malayvideos'] ?? [];

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
