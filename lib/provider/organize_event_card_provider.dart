import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class OrganizeEventCardProvider extends BaseProvider{
  MMYEngine? mmyEngine;
//  UserDetail userDetail = locator<UserDetail>();
  List<Event> eventLists = [];

  Future getUserEvents(BuildContext context, {List<String>? filters}) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =
    await mmyEngine!.getUserEvents(filters: filters).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      setState(ViewState.Idle);
      eventLists = value;
    }
  }
}