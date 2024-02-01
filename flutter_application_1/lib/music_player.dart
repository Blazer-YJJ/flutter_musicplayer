import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final String audioUrl = "audio/12Mornings.mp3";
  late AudioPlayer _audioPlayer;
  late Duration _duration;
  late Duration _position;

  void playerInit() {
    // _audioPlayer = AudioPlayer();
    // // 设定特定源
    // _audioPlayer.setSourceAsset(audioUrl);
    _audioPlayer = AudioPlayer()..setSourceAsset(audioUrl);
    _duration = Duration();
    _position = Duration();

    _audioPlayer.onDurationChanged.listen((Duration d) {
      _duration = d;
      setState(() {});
    });

    // 播放进度长度改变
    _audioPlayer.onPositionChanged.listen((Duration p) {
      _position = p;
      setState(() {});
    });

    // 播放完毕
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _position = _duration; 
      });
    });
  }

  void playOrPause() {
    if(_audioPlayer.state == PlayerState.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
    setState(() {});
  }

  // 转换时间
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)} : $twoDigitMinutes : $twoDigitSeconds";
  }

  // 写入
  @override
  void initState() {
    playerInit();
    super.initState();
  }

  // 释放
  @override
  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 曲目信息
            Image.asset('assets/images/record-3203939_1280.jpg', height: 200, width: double.infinity),
            const SizedBox(height: 40),
            const Text("12 Mornings", style: TextStyle(fontSize: 24, color: Colors.red)),
            const SizedBox(height: 10),
            const Text("EASY LISTENING", style: TextStyle(fontSize: 14, color: Colors.black38)),
            
            // 控制功能
            Slider(
              onChanged: (value) async {
                await _audioPlayer.seek(Duration(seconds: value.toInt()));
                setState(() {});
              },
              value: _position.inSeconds.toDouble(),
              min: 0,
              max: _duration.inSeconds.toDouble(),
              inactiveColor: Colors.grey,
              activeColor: Colors.red,
            ),
            Text('${formatDuration(_position)} / ${formatDuration(_duration)}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _audioPlayer.seek(Duration(seconds: _position.inSeconds - 10));
                    setState(() {});
                  }, 
                  icon: const Icon(Icons.fast_rewind), 
                  iconSize: 40
                ),
                IconButton(
                  onPressed: playOrPause, 
                  icon: Icon(_audioPlayer.state == PlayerState.playing ? Icons.pause : Icons.play_arrow), 
                  iconSize: 50
                ),
                IconButton(
                  onPressed: () {
                    _audioPlayer.seek(Duration(seconds: _position.inSeconds + 10));
                    setState(() {});
                  }, 
                  icon: const Icon(Icons.fast_forward), 
                  iconSize: 40
                )
              ],
            ),
          ],
        )
      ),
    );
  }
}

