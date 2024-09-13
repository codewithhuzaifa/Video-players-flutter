// ignore_for_file: library_private_types_in_public_api

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class LiveStreamPChewie extends StatefulWidget {
  final String streamUrl;
  const LiveStreamPChewie({super.key, required this.streamUrl});
  @override
  _LiveStreamPChewieState createState() => _LiveStreamPChewieState();
}

class _LiveStreamPChewieState extends State<LiveStreamPChewie> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool isPipDisable = true;
  // Platform channel for PiP
  static const platform = MethodChannel('com.example.app/pip');
  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.streamUrl),
    )..initialize().then(
        (value) {
          _chewieController = ChewieController(
            allowFullScreen: false,
            videoPlayerController: _videoPlayerController!,
            autoPlay: true,
            looping: true,
          );
          setState(() {});
        },
      );
    platform.setMethodCallHandler(_handlePlatformCall);
  }

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
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isPipDisable
          ? AppBar(
              title: const Text('chewie Player'),
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
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(

                controller: _chewieController!,
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
