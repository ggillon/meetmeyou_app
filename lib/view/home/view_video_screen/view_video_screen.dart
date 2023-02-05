import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/provider/view_video_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:video_player/video_player.dart';

class ViewVideoScreen extends StatelessWidget {
  ViewVideoScreen({Key? key, required this.viewVideoData, required this.fromChat, required this.format}) : super(key: key);

  ViewVideoData viewVideoData;
  String format;
  bool? fromChat;

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.colorWhite,
        leading: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.close,
                color: ColorConstants.primaryColor, size: 30)),
      ),
      body: BaseView<ViewVideoProvider>(
        onModelReady: (provider) {
          provider.controller = VideoPlayerController.file(viewVideoData.video!)
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              provider.updateLoadingStatus(true);
            });
          provider.controller.setLooping(true);
        },
        builder: (context, provider, _) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(height: scaler.getHeight(1.0)),
                provider.controller.value.isInitialized
                    ?
                    ClipRRect(
                        borderRadius: scaler.getBorderRadiusCircular(10),
                        child: Container(
                          color: ColorConstants.primaryColor,
                          width: double.infinity,
                          height: scaler.getHeight(72.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(provider.controller),
                              GestureDetector(
                                onTap: (){
                                  provider.controller.value.isPlaying
                                      ? provider.controller.pause()
                                      : provider.controller.play();
                                  provider.updateLoadingStatus(true);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorConstants.colorWhitishGray,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: scaler.getPaddingAll(9.0),
                                  child: provider.controller.value.isPlaying ? Icon(Icons.pause, size: 40, color: Colors.blueGrey,)
                                      : Icon(Icons.play_arrow, size: 40, color: Colors.blueGrey,),
                                ),
                              )
                            ],
                          )

                        ))
                    : Container(),
                SizedBox(height: scaler.getHeight(5.0)),
                Center(
                  child: provider.state == ViewState.Busy ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(height: scaler.getHeight(0.5)),
                      Text("sending_video".tr()).mediumText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(9),
                          TextAlign.left),
                    ],
                  ) :
                  InkWell(
                    onTap: (){
                     fromChat == true ?
                     provider.postDiscussionMessage(context, viewVideoData.video!, viewVideoData.fromContactOrGroup!,
                         viewVideoData.groupContactChatDid!, viewVideoData.fromChatScreen!, viewVideoData.fromChatScreenDid!, format).then((value) {
                        Navigator.of(context).pop(viewVideoData.fromChatScreen);
                      }) : Navigator.of(context).pop(viewVideoData.video);
                    },
                    child: Container(
                        padding: scaler.getPaddingAll(8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorConstants.primaryColor.withOpacity(0.3)
                        ),
                        child: Icon(Icons.send, color: ColorConstants.primaryColor, size: 32)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ViewVideoData{
  File? video;
  String? videoUrl;
  bool? fromContactOrGroup;
  String? groupContactChatDid;
  bool? fromChatScreen;
  String? fromChatScreenDid;

  ViewVideoData({this.video, this.videoUrl, this.fromContactOrGroup, this.groupContactChatDid, this.fromChatScreen, this.fromChatScreenDid});

}
