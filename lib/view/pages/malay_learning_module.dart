import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:money_minds/view/pages/malay_video_player.dart';
import 'package:money_minds/view/pages/video_page_test.dart';
import 'package:money_minds/view/pages/video_player.dart';
import 'package:money_minds/view/pages/youtube_player.dart';
import '../../constants/color/color.dart';
import '../authentication/login/login_page.dart';
// ignore: depend_on_referenced_packages
import 'package:stroke_text/stroke_text.dart';

import '../widgets/Slider.dart';

class MalayLearningModulePage extends StatefulWidget {
  const MalayLearningModulePage({Key? key}) : super(key: key);

  @override
  State<MalayLearningModulePage> createState() => _MalayLearningModulePageState();
}

class _MalayLearningModulePageState extends State<MalayLearningModulePage> {
//fetch user date
  // Future getUserData() async {
  //   try {
  //     FirebaseAuth auth = FirebaseAuth.instance;
  //     var users = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(auth.currentUser!.uid)
  //         .get();
  //         print(users);
  //         print('users');
  //     return users;
  //   } on FirebaseAuthException catch (e) {
  //     print(e.message);
  //     return [];
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }

  Future<List<Map<String, dynamic>>?> getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();

      if (userSnapshot.exists) {
        // Access the data using .data()
        var userData = userSnapshot.data() as Map<String, dynamic>;

// Extract the "videos" field
        List<Map<String, dynamic>> videos =
            List<Map<String, dynamic>>.from(userData['malayvideos'] ?? []);
        // Filter videos based on status
        List<Map<String, dynamic>> trueStatusVideos =
            videos.where((video) => video['status'] == true).toList();

        // Print the filtered videos data
        print(userData);
        print('userData');

        return trueStatusVideos;
      } else {
        print('User not found');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

//fetch user date

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  var _isLoading = false;
  bool? _isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    loadingData();
  }

  void loadingData() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        // _isLoggedIn = prefs.getBool('isLoggedIn');
      });
    } catch (e) {
      print(e);
    }
  }

// final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Learning Module'),
      ),
      body: FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            print(snapshot.data);
            List<Map<String, dynamic>> userVideos =
                snapshot.data as List<Map<String, dynamic>>;

            List<Widget> videoRows = [];
            for (int i = 0; i < userVideos.length; i += 2) {
              int endIndex = i + 2;
              if (endIndex > userVideos.length) {
                endIndex = userVideos.length;
              }

              List<Map<String, dynamic>> rowVideos =
                  userVideos.sublist(i, endIndex);

              videoRows.add(VideoRow(videos: rowVideos));
            }
            return ListView(
              children: videoRows,
            );

            // return ListView.builder(
            //   itemCount: userVideos.length,
            //   itemBuilder: (context, index) {
            //     String title = userVideos[index]['title'];
            //     String videoUrl = userVideos[index]['videoUrl'];
            //     String progress = userVideos[index]['progress'];
            //     bool status = userVideos[index]['status'];

            //     return Card(
            //       child: ListTile(
            //         dense: true,
            //         visualDensity: const VisualDensity(vertical: 3),
            //         leading: CircleAvatar(
            //           child: Icon(
            //             Icons.play_arrow,
            //             color: Colors.white,
            //           ),
            //         ),
            //         title: Text(
            //           title,
            //           style: const TextStyle(
            //             color: Colors.black87,
            //             fontSize: 20,
            //           ),
            //         ),
            //         subtitle: Text('Progress: $progress\nStatus: $status'),
            //         // subtitle: Text('Video URL: $videoUrl\nStatus: $status'),

            //         onTap: () {
            //           // Navigate to VideoPlayerPage
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => MalayVideoPlayerPage(
            //                 title: title,
            //                 videoUrl: videoUrl,
            //               ),
            //             ),
            //           );

            //           // Navigator.push(
            //           //   context,
            //           //   MaterialPageRoute(
            //           //     builder: (context) => YouTubePlayerPage(
            //           //       videoUrl: videoUrl,
            //           //     ),
            //           //   ),
            //           // );
            //         },
            //       ),
            //     );
            //   },
            // );
          
          
          }
        },
      ),
    );
  }
}



class VideoRow extends StatelessWidget {
  final List<Map<String, dynamic>> videos;

  const VideoRow({Key? key, required this.videos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var video in videos)
          Expanded(
            child: Card(
              elevation: 6.0,
              // color: Colors.blue,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(color: Colors.blue, width: 5))),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to VideoPlayerPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPage(
                          // title: video["title"],
                          videoUrl: video['videoUrl'],
                        ),
    //                                          MaterialPageRoute(
    //   builder: (context) => VideoPage(videoUrl: video['videoUrl']),
    // ),
                      ),
                    );
                  },
                  child: Column(children: [
                    Container(
                      height: 100,
                      child: CircleAvatar(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(video["title"]),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Progress: ${video["progress"]}',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 14,
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Watch Lecture',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
              // child: ListTile(
              //   dense: true,
              //   visualDensity: const VisualDensity(vertical: 3),
              //   leading: CircleAvatar(
              //     child: Icon(
              //       Icons.play_arrow,
              //       color: Colors.white,
              //     ),
              //   ),
              //   title: Text(
              //     video['title'],
              //     style: TextStyle(
              //       color: Colors.black87,
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              //   subtitle: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text('Progress: ${video['progress']}'),
              //       Text('Status: ${video['status']}'),
              //     ],
              //   ),
              //   onTap: () {
              //     // Navigate to VideoPlayerPage
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => VideoPlayerPage(
              //           title: video['title'],
              //           videoUrl: video['videoUrl'],
              //         ),
              //       ),
              //     );
              //   },
              //   // ... (existing code for ListTile)
              // ),
            ),
          ),
      ],
    );
  }
}
