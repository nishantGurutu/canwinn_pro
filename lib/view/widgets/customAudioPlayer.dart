import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomAudioPlayer extends StatefulWidget {
  final String audioUrl;
  final String chatId;

  const CustomAudioPlayer({
    super.key,
    required this.audioUrl,
    required this.chatId,
  });

  @override
  State<CustomAudioPlayer> createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final RxString selectedId = ''.obs;
  static final RxBool isPlaying = false.obs;
  static final Rx<Duration> duration = Duration.zero.obs;
  static final Rx<Duration> position = Duration.zero.obs;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((d) => duration.value = d);
    _audioPlayer.onPositionChanged.listen((p) => position.value = p);
    _audioPlayer.onPlayerComplete.listen((_) {
      isPlaying.value = false;
      selectedId.value = '';
      position.value = Duration.zero;
    });
  }

  Future<void> togglePlayPause() async {
    if (selectedId.value == widget.chatId && isPlaying.value) {
      await _audioPlayer.pause();
      isPlaying.value = false;
    } else {
      await _audioPlayer.stop();
      selectedId.value = widget.chatId;
      await _audioPlayer.play(UrlSource(widget.audioUrl));
      isPlaying.value = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final isCurrent = selectedId.value == widget.chatId;

        return Container(
          width: 150.w,
          // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: togglePlayPause,
                child: Icon(
                  isCurrent && isPlaying.value
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  size: 28.sp,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isCurrent ? "${position.value.inSeconds}s" : "0s",
                style: const TextStyle(fontSize: 12),
              ),
              Expanded(
                child: Slider(
                  min: 0,
                  max: isCurrent
                      ? duration.value.inMilliseconds
                          .toDouble()
                          .clamp(1.0, double.infinity)
                      : 1.0,
                  value: isCurrent
                      ? position.value.inMilliseconds
                          .toDouble()
                          .clamp(0.0, duration.value.inMilliseconds.toDouble())
                      : 0.0,
                  onChanged: isCurrent
                      ? (value) async {
                          final newPos = Duration(milliseconds: value.toInt());
                          await _audioPlayer.seek(newPos);
                        }
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
