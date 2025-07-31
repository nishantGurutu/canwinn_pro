import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class VoiceRecorderButton extends StatefulWidget {
  /// This will return the recorded audio file (use it to upload)
  final Function(File recordedAudioFile) onRecordingComplete;

  /// Optional: show/hide icon size or colors
  final double iconSize;
  final Color micColor;
  final Color stopColor;

  const VoiceRecorderButton({
    super.key,
    required this.onRecordingComplete,
    this.iconSize = 28,
    this.micColor = Colors.grey,
    this.stopColor = Colors.red,
  });

  @override
  State<VoiceRecorderButton> createState() => _VoiceRecorderButtonState();
}

class _VoiceRecorderButtonState extends State<VoiceRecorderButton> {
  late final AudioRecorder _audioRecorder;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxBool isRecording = false.obs;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
  }

  Future<void> _toggleRecording() async {
    if (isRecording.value) {
      final path = await _audioRecorder.stop();
      isRecording.value = false;

      if (path != null && await File(path).exists()) {
        final recordedFile = File(path);
        widget.onRecordingComplete(recordedFile);
        _recordedFilePath = path;

        // Optional: play the audio
        await _audioPlayer.play(DeviceFileSource(path));
      } else {
        debugPrint("❌ Recorded file not found at path: $path");
      }
    } else {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        debugPrint("❌ Microphone permission not granted.");
        return;
      }

      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: filePath,
      );

      _recordedFilePath = filePath;
      isRecording.value = true;
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: _toggleRecording,
          child: Icon(
            isRecording.value ? Icons.stop_circle : Icons.mic,
            size: widget.iconSize,
            color: isRecording.value ? widget.stopColor : widget.micColor,
          ),
        ));
  }
}
