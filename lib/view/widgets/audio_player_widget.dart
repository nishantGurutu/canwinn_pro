// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// class AudioPlayerWidget extends StatefulWidget {
//   final String audioPath;
//   const AudioPlayerWidget({
//     super.key,
//     required this.audioPath,
//   });

//   @override
//   State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
// }

// class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
//   late AudioPlayer _audioPlayer;
//   bool _isPlaying = false;

//   Future<void> _stopAudio() async {
//     await _audioPlayer.stop();
//     setState(() {
//       _isPlaying = false;
//     });
//   }

//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     _audioPlayer.onPlayerComplete.listen((event) {
//       _restartAudio();
//     });
//     _playAudio();
//   }

//   Future<void> _playAudio() async {
//     await _audioPlayer.play(AssetSource(widget.audioPath));
//   }

//   void _restartAudio() async {
//     await _audioPlayer.seek(Duration.zero);
//     await _playAudio();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _audioPlayer.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           _isPlaying ? "Playing..." : "Stopped",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         ElevatedButton(
//           onPressed: _isPlaying ? _stopAudio : _playAudio,
//           child: Text(_isPlaying ? "Stop" : "Play"),
//         ),
//       ],
//     );
//   }
// }
