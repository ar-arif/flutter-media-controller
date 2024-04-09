import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(const TVControllerApp());

class TVControllerApp extends StatelessWidget {
  const TVControllerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TVControllerScreen(), // Ensuring const is used here
    );
  }
}

class TVControllerScreen extends StatefulWidget {
  const TVControllerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TVControllerScreenState createState() => _TVControllerScreenState();
}

class _TVControllerScreenState extends State<TVControllerScreen> {
  late WebSocketChannel channel; // Corrected type
  bool isPlaying = false;
  bool isFullScreen = false;
  bool isSubtitleOn = false;
  bool isAudioOn = false;

  @override
  void initState() {
    super.initState();
    channel = kIsWeb
        ? WebSocketChannel.connect(
            Uri.parse('ws://192.168.10.199:8000')) // For web
        : WebSocketChannel.connect(
            Uri.parse('ws://192.168.10.199:8000')); // For non-web
  }

  void sendKey(String key) {
    channel.sink.add(key);
  }

  void logAction(String action) {
    if (kDebugMode) {
      print('Action: $action');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Controller'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.fast_rewind),
                    iconSize: 40,
                    onPressed: () {
                      sendKey('rewind');
                      logAction('Rewind button clicked');
                    },
                  ),
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    iconSize: 40,
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                        sendKey(isPlaying ? 'pause' : 'play');
                        logAction(isPlaying
                            ? 'Pause button clicked'
                            : 'Play button clicked');
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.fast_forward),
                    iconSize: 40,
                    onPressed: () {
                      sendKey('fast_forward');
                      logAction('Fast forward button clicked');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.volume_down),
                    iconSize: 40,
                    onPressed: () {
                      sendKey('volume_down');
                      logAction('Volume down button clicked');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    iconSize: 40,
                    onPressed: () {
                      sendKey('volume_up');
                      logAction('Volume up button clicked');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.fullscreen),
                    iconSize: 40,
                    onPressed: () {
                      setState(() {
                        sendKey('fullscreen');
                        logAction('Fullscreen button clicked');
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.closed_caption),
                    iconSize: 40,
                    onPressed: () {
                      setState(() {
                        sendKey('subtitle');
                        logAction('Subtitle button clicked');
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_off),
                    iconSize: 40,
                    onPressed: () {
                      setState(() {
                        sendKey('audio');
                        logAction('Audio button clicked');
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close(); // Properly close the WebSocket connection
    super.dispose();
  }
}
