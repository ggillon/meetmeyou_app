import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/discussion_message.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/services/storage/storage.dart';
import 'package:video_player/video_player.dart';

class ViewVideoProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();
  String videoUrl = "";

  late VideoPlayerController controller;

  Future postDiscussionMessage(BuildContext context, File videoFile, bool fromContactOrGroup, String contactGroupDid, bool fromChatScreen, String fromChatScreenDid, String format) async {

    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    if(videoFile != null){
      videoUrl =  await storeFile(videoFile, path: StoragePath.discussionChatGalleryVideo(fromChatScreen == true ? fromChatScreenDid : (fromContactOrGroup == true ? contactGroupDid :  eventDetail.eid!),
          auth.currentUser!.uid.toString(), format)).catchError((e) {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
    }
    await mmyEngine!.postDiscussionMessage(fromChatScreen == true ? fromChatScreenDid : (fromContactOrGroup == true ? contactGroupDid :  eventDetail.eid!), type: VIDEO_MESSAGE, text: "", photoURL: videoUrl)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    setState(ViewState.Idle);
  }

  @override
  void dispose() {
  controller.dispose();
    super.dispose();
  }
}