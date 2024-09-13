// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';

class LiveStreamVideoPlayer extends StatefulWidget {
  final String streamUrl;

  const LiveStreamVideoPlayer({super.key, required this.streamUrl});

  @override
  _LiveStreamVideoPlayerState createState() => _LiveStreamVideoPlayerState();
}

class _LiveStreamVideoPlayerState extends State<LiveStreamVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool isPipDisable = true;
  // Platform channel for PiP
  static const platform = MethodChannel('com.example.app/pip');
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.streamUrl))
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _controller.play(); // Automatically start playing
      });
    platform.setMethodCallHandler(_handlePlatformCall);
  }

  // Handle platform method calls from native side
  Future<void> _handlePlatformCall(MethodCall call) async {
    if (call.method == 'onPiPExit') {
      debugPrint("PiP mode exited");
      setState(() {
        isPipDisable = true; // Re-enable AppBar after PiP exits
      });
    } else if (call.method == 'onPiPEnter') {
      setState(() {
        isPipDisable = false; // Hide AppBar when PiP enters
      });
    }
  }

  // Trigger Picture-in-Picture mode from Flutter side
  Future<void> _enterPiPMode() async {
    try {
      await platform.invokeMethod('enterPiP');
      setState(() {
        isPipDisable = false;
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to enter PiP mode: '${e.message}'");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isPipDisable
          ? AppBar(
              title: const Text('Live Stream'),
              actions: [
                // Button to manually enter PiP mode
                IconButton(
                  tooltip: "Picture-In-Picture (PIP) Mode",
                  icon: const Icon(Icons.picture_in_picture_alt),
                  onPressed: _enterPiPMode,
                ),
              ],
            )
          : null,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show a loader while initializing
            : AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(
                  _controller,
                ),
              ),
      ),
    );
  }
}
