import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoAlertDialog extends StatefulWidget {
  VideoAlertDialog({required this.videoLinks});
  final List<VideoClass> videoLinks;

  @override
  _VideoAlertDialogState createState() => _VideoAlertDialogState();
}

class _VideoAlertDialogState extends State<VideoAlertDialog> {
  late YoutubePlayerController _controller;

  bool _isPlayerReady = false;
  List<VideoClass> videosList = [];
  String? selectedVideoId;

  @override
  void initState() {
    super.initState();
    videosList = widget.videoLinks;
    for (var i in videosList) {
      i.videoId = YoutubePlayer.convertUrlToId("${i.videoUrl}")!;
    }

    selectedVideoId = videosList[0].videoId;
    _controller = YoutubePlayerController(
      initialVideoId: videosList[0].videoId!,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            YoutubePlayer(
              controller: _controller,
              aspectRatio: 16 / 9,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              onReady: () {
                setState(() {
                  _isPlayerReady = true;
                });
              },
              onEnded: (data) {
                int index = videosList
                    .indexWhere((element) => element.videoId == data.videoId);
                _controller.load(videosList[(index + 1) % videosList.length].videoId!);
                selectedVideoId = videosList[(index + 1) % videosList.length].videoId!;
              },
            ),
            if (videosList.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  videosList.first.videoId == selectedVideoId
                      ? SizedBox.shrink()
                      : IconButton(
                          onPressed: () {
                            if (videosList[0].videoId != selectedVideoId) {
                              int index = videosList.indexWhere(
                                  (element) => element.videoId == selectedVideoId);
                              _controller.load(videosList[index - 1].videoId!);
                              selectedVideoId = videosList[index - 1].videoId!;
                            }
                          },
                          icon: Icon(Icons.arrow_back_ios),
                        ),
                  SizedBox(width: 8),
                  videosList.last.videoId == selectedVideoId
                      ? SizedBox.shrink()
                      : IconButton(
                          onPressed: () {
                            if (videosList.last.videoId != selectedVideoId) {
                              int index = videosList.indexWhere(
                                  (element) => element.videoId == selectedVideoId);
                              _controller.load(videosList[index + 1].videoId!);
                              selectedVideoId = videosList[index + 1].videoId!;
                            }
                          },
                          icon: Icon(Icons.arrow_forward_ios),
                        ),
                        Text('data'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

String? getYoutubeThumbnail(String videoUrl) {
  final Uri? uri = Uri.tryParse(videoUrl);
  if (uri == null) {
    return null;
  }
  return 'https://img.youtube.com/vi/${videoUrl}/0.jpg';
}

class VideoClass {
  String videoTitle;
  String videoUrl;
  String videoThumbnail;
  String? videoId;
  
  VideoClass({
    required this.videoTitle,
    required this.videoUrl,
    required this.videoThumbnail,
    this.videoId,
  });
}
