import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/provider/event_gallery_image_view_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' show get;

class VideoPlayer extends StatefulWidget {
  VideoPlayer({Key? key, required this.videoUrl, required this.fromDiscussion, this.aid, this.pid, this.ownerId}) : super(key: key);
  final String videoUrl;
  final bool fromDiscussion;
  String? pid;
  String? aid;
  String? ownerId;

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

  EventGalleryImageViewProvider provider = EventGalleryImageViewProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return BaseView<EventGalleryImageViewProvider>(
      builder: (context, provider, _){
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: ColorConstants.colorBlack,
          appBar: widget.fromDiscussion == true ?  AppBar(
            backgroundColor: ColorConstants.colorWhite,
            leading: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back,
                    color: ColorConstants.primaryColor, size: 30)),
          ) : AppBar(
            centerTitle: true,
            backgroundColor: ColorConstants.colorNewGray,
            automaticallyImplyLeading: false,
            leading: Center(child: Row(
              children: [
                SizedBox(width: scaler.getWidth(5.0)),
                GestureDetector(
                    onTap: (){
                      Navigator.of(_scaffoldKey.currentContext!).pop();
                    },
                    child: Icon(Icons.arrow_back_ios, color: Colors.blue))
              ],
            )),
            actions: [
              Row(
                children: [
                  GestureDetector(
                      onTap: (){
                        GallerySaver.saveVideo(widget.videoUrl).then((value) {
                          DialogHelper.showMessage(context, "video_saved".tr());
                        });
                      },
                      child: Icon(Icons.save_alt, color: Colors.blue,)),
                  SizedBox(width: scaler.getWidth(3.0)),
                  GestureDetector(
                      onTap: (){
                        shareVideo();
                      },
                      child: Icon(Icons.share, color: Colors.blue,)),
                  SizedBox(width: scaler.getWidth(3.0)),
                  (provider.auth.currentUser!.uid == widget.ownerId || provider.auth.currentUser!.uid == provider.eventDetail.albumAdminId) ? GestureDetector(
                      onTap: (){
                        DialogHelper.showDialogWithTwoButtons(
                            context,
                            "delete_video".tr(),
                            "are_you_sure_to_delete_video".tr(), positiveButtonPress: () async {
                          Navigator.of(_scaffoldKey.currentContext!).pop();
                          await provider.deletePhoto(_scaffoldKey.currentContext!, widget.aid!, widget.pid!);
                        });
                      },
                      child: Icon(Icons.delete_outline, color: Colors.blue,)) : Container(),
                  (provider.auth.currentUser!.uid == widget.ownerId || provider.auth.currentUser!.uid == provider.eventDetail.albumAdminId) ?  SizedBox(width: scaler.getWidth(3.0)) : Container(),
                ],
              )
            ],
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
      },
    );
  }

  void shareVideo() async {
    final Directory temp = await getApplicationDocumentsDirectory();
    final File videoFile = File('${temp.path}/${widget.pid}.mp4');
    if (videoFile.existsSync()) {
      // print('file already exist');
      await videoFile.readAsBytes();
      Share.shareFiles([videoFile.path]);
    } else{
      final response = await get(Uri.parse(widget.videoUrl));
      var bytes = await response.bodyBytes;
      videoFile.writeAsBytes(bytes);
      Share.shareFiles([videoFile.path]);
    }
  }


}

