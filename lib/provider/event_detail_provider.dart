import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class EventDetailProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();
  UserDetail userDetail = locator<UserDetail>();
  int eventAttendingLength = 0;
  List<String> eventAttendingKeysList = [];

  bool _value = false;

  bool get value => _value;

  updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  eventGoingLength() {
    List<String> keysList = [];
    for (var key in eventDetail.eventMapData!.keys) {
      keysList.add(key);
    }
    List<String> valuesList = [];

    for (var value in eventDetail.eventMapData!.values) {
      valuesList.add(value);
    }

    for (int i = 0; i < keysList.length; i++) {
      if (valuesList[i] == "Attending") {
        eventAttendingLength = eventAttendingLength + 1;
        eventAttendingKeysList.add(keysList[i]);
      }
    }
    return eventAttendingLength;
  }

  List<String> eventAttendingPhotoUrlLists = [];

  Future getUsersProfileUrl(BuildContext context) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    for (var key in eventDetail.eventMapData!.keys) {
      var value = await mmyEngine!
          .getUserProfile(user: false, uid: key)
          .catchError((e) {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
      eventAttendingPhotoUrlLists.add(value.photoURL);
    }
    // print(eventAttendingLists);
    setState(ViewState.Idle);
  }

  bool _replyEventValue = false;

  bool get replyEventValue => _replyEventValue;

  updateReplyEventValue(bool value) {
    _replyEventValue = value;
    notifyListeners();
  }

  Future replyToEvent(BuildContext context, String eid, String response) async {
    updateValue(true);
    // mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine!.replyToEvent(eid, response: response).catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });

    updateValue(false);
    Navigator.of(context).pop();
  }
}
