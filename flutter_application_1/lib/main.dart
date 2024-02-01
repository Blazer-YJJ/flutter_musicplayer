import 'package:flutter/material.dart';
import 'package:flutter_application_1/music_player.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light
        // brightness: Brightness.dark // 暗模式
      ),
      home: const Scaffold(
        body: MusicPlayer(),
      )
    );
  }
}