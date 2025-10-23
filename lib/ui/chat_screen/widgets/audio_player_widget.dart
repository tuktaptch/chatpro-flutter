import 'package:audioplayers/audioplayers.dart';
import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/utilities/alert/alert.dart';
import 'package:chat_pro/utilities/alert/toast_item.dart';
import 'package:chat_pro/utilities/global_method.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.color,
    required this.viewOnly,
  });

  final String audioUrl;
  final Color color;
  final bool viewOnly;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;
  bool audioReady = false;

  @override
  void initState() {
    super.initState();

    // listen to changes in player state
    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
        if (event == PlayerState.completed) {
          position = Duration.zero;
        }
      });
    });

    // listen to changes in player position
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    // listen to changes in player duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
        audioReady = newDuration.inSeconds > 0;
      });
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  // void seekToPosition(double seconds) async {
  //   final newPosition = Duration(seconds: seconds.toInt());
  //   await audioPlayer.seek(newPosition);
  //   if (!isPlaying) await audioPlayer.resume();
  // }
  void seekToPosition(double seconds, BuildContext context) async {
    if (!audioReady) {
      showSnackBar(context, 'Audio not ready yet', Type.warning);
      return;
    }
    final newPosition = Duration(seconds: seconds.toInt());
    try {
      await audioPlayer.seek(newPosition).timeout(Duration(seconds: 10));
      if (!isPlaying) await audioPlayer.resume();
    } catch (e) {
      print('Error seeking audio: $e');
      Alert.show('Error seeking audio: $e', type: ToastType.failed);
    }
  }

  @override
  Widget build(BuildContext context) {
    // กำหนด maxSlider ให้ปลอดภัย
    final maxSlider = duration.inSeconds > 0
        ? duration.inSeconds.toDouble()
        : 1.0;
    final sliderValue = position.inSeconds.toDouble().clamp(0.0, maxSlider);

    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: CColors.pureWhite,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: CColors.lightPink,
            child: IconButton(
              onPressed: widget.viewOnly
                  ? null
                  : () async {
                      if (!isPlaying) {
                        await audioPlayer.play(UrlSource(widget.audioUrl));
                      } else {
                        await audioPlayer.pause();
                      }
                    },
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: CColors.darkGray,
              ),
            ),
          ),
        ),
        Expanded(
          child: Slider.adaptive(
            min: 0.0,
            max: maxSlider,
            value: sliderValue,
            onChanged: (double newValue) =>
                widget.viewOnly ? null : seekToPosition(newValue, context),
          ),
        ),
        Text(
          formatTime(duration - position),
          style: CTypography.small.copyWith(color: widget.color),
        ),
      ],
    );
  }
}
