import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Widget video looping tanpa suara, dipakai sebagai elemen dekoratif
/// di area kosong background (tidak menggantikan corak/logo yang sudah ada).
class VideoBackground extends StatefulWidget {
  final double height;
  final double borderRadius;

  const VideoBackground({
    super.key,
    this.height = 220,
    this.borderRadius = 20,
  });

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late VideoPlayerController _controller;
  bool _siap = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/background.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _siap = true);
        _controller.setLooping(true);
        _controller.setVolume(0); // tanpa suara
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_siap) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child:
              CircularProgressIndicator(color: Colors.white70, strokeWidth: 2),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}
