import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_straming/streams/live_streaming_better_player.dart';
import 'package:live_straming/streams/live_streaming_chewie.dart';
import 'package:live_straming/streams/live_streaming_video_player.dart';
import 'package:live_straming/streams/youtube_player.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  ).then(
    (value) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Live Streams Players',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen()
        //home: HomeScreen(),
        );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> streamPlayers = [
    const LiveStreamVideoPlayer(
      streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
    ),
    const LiveStreamPChewie(
      streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
    ),
    const BetterPlayerExample(
        streamUrl: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8"),
    const YoutubePlayerStream(
      streamId: "_InqQJRqGW4",
    ),
    // const YouTubePlayerExample(),
  ];

  final List<String> streamPlayerNames = [
    "Video Player",
    "Chewie Player",
    "Better Player",
    "Youtube Player IFrame",
    // "Youtube Player Flutter"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Streams Example'),
      ),
      body: ListView.separated(
        itemCount: streamPlayers.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // On tap, navigate to the corresponding widget
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => streamPlayers[index],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(streamPlayerNames[index]),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 0),
      ),
    );
  }
}
