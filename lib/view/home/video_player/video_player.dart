import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({Key? key, required this.videoUrl}) : super(key: key);
  final String videoUrl;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {

  late VideoPlayerController videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    initializePlayer();
    super.initState();
  }

  Future<void> initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);

    await videoPlayerController.initialize();

    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        fullScreenByDefault: true
    );

    videoPlayerController.addListener(() {
      setState(() {});
    });

  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorBlack,
      appBar: AppBar(
        backgroundColor: ColorConstants.colorWhite,
        leading: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back,
                color: ColorConstants.primaryColor, size: 30)),
      ),
      body:  Center(
        child: (_chewieController != null &&
            _chewieController!.videoPlayerController.value.isInitialized)
            ? Chewie(
          controller: _chewieController!,
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading'),
          ],
        ),
      ),
    );
  }
}

