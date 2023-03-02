import 'package:flutter/cupertino.dart';
import 'package:madoapp/configs/theme_config.dart';
import 'package:video_player/video_player.dart';

class VideoLoader extends StatefulWidget {
  final double? imgSize;
  final String url;
  final double borderRadius;

  const VideoLoader({
    Key? key,
    required this.url,
    this.borderRadius = 8.0,
    this.imgSize,
  }) : super(key: key);

  @override
  State<VideoLoader> createState() => _VideoLoaderState();
}

class _VideoLoaderState extends State<VideoLoader> {
  late VideoPlayerController videoPlayerController;

  void initialize(String videoUrl) {
    videoPlayerController = VideoPlayerController.network(videoUrl);

    videoPlayerController.addListener(() {
      setState(() {});
    });
    videoPlayerController.initialize().then((value) {
      // notifyListeners();
      videoPlayerController.play();
      setState(() {});
    });
    videoPlayerController.setLooping(true);
    videoPlayerController.setVolume(0.0);
  }

  @override
  void initState() {
    initialize(widget.url);
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        color: ThemeConfig.kBgGrey,
        width: widget.imgSize,
        height: widget.imgSize,
        child: VideoPlayer(videoPlayerController),
      ),
    );
  }
}
