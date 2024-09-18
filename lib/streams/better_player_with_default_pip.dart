import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class BetterPlayerDefaultPip extends StatefulWidget {
  const BetterPlayerDefaultPip({super.key});

  @override
  State<BetterPlayerDefaultPip> createState() => _BetterPlayerDefaultPipState();
}

class _BetterPlayerDefaultPipState extends State<BetterPlayerDefaultPip> {
  BetterPlayerController? _betterPlayerController;
  final GlobalKey _betterPlayerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8",
      liveStream: false,
    );
    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: true,
        looping: true,
        aspectRatio: 16 / 9,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableSkips: true,
        ),
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _betterPlayerController
                    ?.enablePictureInPicture(_betterPlayerKey);
              },
              icon: const Icon(Icons.picture_in_picture))
        ],
      ),
      body: Column(
        children: [
          _betterPlayerController != null
              ? BetterPlayer(
                  controller: _betterPlayerController!,
                  key: _betterPlayerKey,
                )
              : const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
