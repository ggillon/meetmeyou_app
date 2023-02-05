import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/services/storage/storage.dart';

class GroupImageViewProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  String photoUrl = "";

  Future updateDiscussionPhoto(BuildContext context, String did, bool fromChatScreen,
      {String? title, File? photo}) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    if(photo != null){
      photoUrl =  await storeFile(photo, path: StoragePath.discussionPhoto(did)).catchError((e) {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
    }
    var value = await mmyEngine?.updateDiscussion(did, photoURL: photoUrl).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      Navigator.of(context).pop();
      setState(ViewState.Idle);
    }
  }

}