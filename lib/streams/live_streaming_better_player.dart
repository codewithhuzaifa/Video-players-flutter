// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/services.dart'; // For platform channels

class BetterPlayerExample extends StatefulWidget {
  final String streamUrl;
  final bool isLive;
  const BetterPlayerExample(
      {required this.streamUrl, super.key, required this.isLive});
  @override
  _BetterPlayerExampleState createState() => _BetterPlayerExampleState();
}

class _BetterPlayerExampleState extends State<BetterPlayerExample> {
  BetterPlayerController? _betterPlayerController;
  bool isPipDisable = true;
  // Platform channel for PiP
  static const platform = MethodChannel('com.example.app/pip');
  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.streamUrl,
      liveStream: widget.isLive,
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
    // Listen for PiP exit from platform side
    platform.setMethodCallHandler(_handlePlatformCall);
    // Notify native side that the BetterPlayerExample screen is active
    _notifyScreenActive(true);
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
      print("Failed to enter PiP mode: '${e.message}'");
    }
  }

  // Notify native side when the screen is active or not
  Future<void> _notifyScreenActive(bool isActive) async {
    try {
      await platform.invokeMethod(isActive ? 'screenActive' : 'screenInactive');
    } on PlatformException catch (e) {
      print("Failed to notify screen state: '${e.message}'");
    }
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    _notifyScreenActive(false); // Notify native side when screen is disposed
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
                  icon: const Icon(Icons.picture_in_picture),
                  onPressed: _enterPiPMode,
                ),
              ],
            )
          : null,
      body: Column(
        children: [
          _betterPlayerController != null
              ? BetterPlayer(controller: _betterPlayerController!)
              : const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
