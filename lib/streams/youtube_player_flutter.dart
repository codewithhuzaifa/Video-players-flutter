import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerExample extends StatefulWidget {
  const YouTubePlayerExample({super.key});

  @override
  _YouTubePlayerExampleState createState() => _YouTubePlayerExampleState();
}

class _YouTubePlayerExampleState extends State<YouTubePlayerExample> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // const videoUrl =
    //     "https://www.youtube.com/watch?v=dQw4w9WgXcQ"; // Replace with your video URL
    _controller = YoutubePlayerController(
      initialVideoId: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Player Example'),
      ),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        // onReady: () {
        //   debugPrint('Player is ready.');
        // },
        // onEnded: (metaData) {
        //   debugPrint('Video has ended');
        // },
      ),
    );
  }
}
