import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerStream extends StatefulWidget {
  final String streamId;
  const YoutubePlayerStream({super.key, required this.streamId});

  @override
  State<YoutubePlayerStream> createState() => _YoutubePlayerStreamState();
}

class _YoutubePlayerStreamState extends State<YoutubePlayerStream> {
  late YoutubePlayerController youtubePlayerController;

  @override
  void initState() {
    youtubePlayerController = YoutubePlayerController.fromVideoId(
      videoId: widget.streamId,
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: YoutubePlayerScaffold(
            controller: youtubePlayerController,
            aspectRatio: 16 / 10,
            builder: (context, player) {
              return Container(
                height: double.infinity,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      player,
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Money Heist | Series Trailer | Netflix',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
