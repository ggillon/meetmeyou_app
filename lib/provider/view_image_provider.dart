import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/discussion_message.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class ViewImageProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();

  Future postDiscussionMessage(BuildContext context, File photoFile, {bool? fromContactOrGroup,}) async {

    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine!.postDiscussionMessage(
        eventDetail.eid!, type: PHOTO_MESSAGE, text: "", photoFile: photoFile)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    setState(ViewState.Idle);
  }
}