import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/discussion.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class ChatScreenProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  List<Discussion> userDiscussion = [];

  Future getUserDiscussion(BuildContext context) async{
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value = await mmyEngine!.getUserDiscussions().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    if(value != null){
      userDiscussion = value;
      setState(ViewState.Idle);
    }
  }
}