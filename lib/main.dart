import 'dart:async';

import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';

/// Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// [MediaKit.ensureInitialized] must be called before using the library.
  MediaKit.ensureInitialized();
  // Check internet connection with singleton (no custom values allowed)

  runApp(
    const MaterialApp(
      home: MyScreen(),
    ),
  );
}

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  State<MyScreen> createState() => MyScreenState();
}

class MyScreenState extends State<MyScreen> {
  late final player = Player();

  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    player.open(
      Media(
          'rtsp://admin:123asdfg@185.190.23.227:555/cam/realmonitor?channel=1&subtype=0'),
      play: true,
    );
    setState(() {

    });
  }

  @override
  void dispose() {
    player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Use [Video] widget to display the output.
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 9.0 / 16.0,
          // Use [Video] widget to display video output.
          child: Video(controller: controller),
        ),
      ),
    );
  }
}
