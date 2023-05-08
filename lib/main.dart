import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:media_kit/media_kit.dart';

/// Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';

/// Provides [VideoController] & [Video] etc.
Future<void> execute(
  InternetConnectionChecker internetConnectionChecker,
) async {
  // Simple check to see if we have Internet
  // ignore: avoid_print
  print('''The statement 'this machine is connected to the Internet' is: ''');
  final bool isConnected = await InternetConnectionChecker().hasConnection;
  // ignore: avoid_print
  print(
    isConnected.toString(),
  );
  // returns a bool

  // We can also get an enum instead of a bool
  // ignore: avoid_print
  print('**************************************');

  print(
    'Current status: ${await InternetConnectionChecker().connectionStatus}',
  );
  print('**************************************');

  // Prints either InternetConnectionStatus.connected
  // or InternetConnectionStatus.disconnected

  // actively listen for status updates
  final StreamSubscription<InternetConnectionStatus> listener =
      InternetConnectionChecker().onStatusChange.listen(
    (InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          // ignore: avoid_print
          print(
              '******************* Data connection is available. *******************');
          print(
              '******************* Data connection is available. *******************');
          print(
              '******************* Data connection is available. *******************');

          break;
        case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
          print(
              '******************* You are disconnected from the internet. *******************');
          print(
              '******************* You are disconnected from the internet. *******************');
          print(
              '******************* You are disconnected from the internet. *******************');

          break;
      }
    },
  );

  // close listener after 30 seconds, so the program doesn't run forever
  await Future<void>.delayed(const Duration(seconds: 30));
  await listener.cancel();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// [MediaKit.ensureInitialized] must be called before using the library.
  MediaKit.ensureInitialized();
  // Check internet connection with singleton (no custom values allowed)
   execute(InternetConnectionChecker());

  // Create customized instance which can be registered via dependency injection
  final InternetConnectionChecker customInstance =
  InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 1),
    checkInterval: const Duration(seconds: 1),
  );

  // Check internet connection with created instance
   execute(customInstance);

 /*  */
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
  /// Create a [Player].
  final Player player = Player();

  /// Store reference to the [VideoController].
  VideoController? controller;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      /// Create a [VideoController] to show video output of the [Player].
      controller = await VideoController.create(player);

      /// Play any media source.
      //  await player.open(Media('https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4'));
      // await player.open(Media('http://158.58.130.148/mjpg/video.mjpg'));
      // await player.open(Media('rtsp://freja.hiof.no:1935/rtplive/definst/hessdalen03.stream'));
       await player.open(Media('rtsp://admin:123asdfg@185.190.23.227:555/cam/realmonitor?channel=1&subtype=0'));
      setState(() {});
      print('******************* its runnig *******************');
      print('******************* its runnig *******************');
    });
  }

  @override
  void dispose() {
    Future.microtask(() async {
      /// Release allocated resources back to the system.
      await controller?.dispose();
      await player.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Use [Video] widget to display the output.
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Video(
            /// Pass the [controller].
            controller: controller,
            width: double.infinity,
            height: 400,
          ),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              player.play();
            },
            child: Text('playOrPause'),
          )
        ],
      ),
    );
  }
}
