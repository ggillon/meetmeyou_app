import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/event_chat_message.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class EventDiscussionProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();
  UserDetail userDetail = locator<UserDetail>();
  List<EventChatMessage> eventChatList = [];
  List<Contact> eventAttendingLists = [];
  ScrollController scrollController = ScrollController();
  Timer? clockTimer;
  bool isJump = true;

  bool _value = false;

  bool get value => _value;

  updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  @override
  void dispose() {
    clockTimer!.cancel();
    super.dispose();
  }

  Future getEventChatMessages(BuildContext context, {bool load = true, bool jump = true}) async {
   load ?  setState(ViewState.Busy) :  updateValue(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value =
        await mmyEngine!.getEventChatMessages(eventDetail.eid!).catchError((e) {
          jump ?  setState(ViewState.Idle) :  updateValue(false);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    if (value != null) {
      load ?  setState(ViewState.Idle) :  updateValue(false);
      eventChatList = value;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          jump ? scrollController
              .jumpTo(scrollController.position.maxScrollExtent) :
         // scrollController.position.pixels.toInt() <= scrollController.position.maxScrollExtent.toInt() ?
         // // scrollController.position.userScrollDirection == ScrollDirection.
         //  scrollController
         //      .jumpTo(scrollController.position.maxScrollExtent)
         //      :
         //  Container();
         // _scrollListener();
         //  scrollController.offset <= scrollController.position.maxScrollExtent ? (isJump == true ? scrollController
         //      .jumpTo(scrollController.position.maxScrollExtent) : Container()) : isJump = false;
          _scrollListener();
      }});
     }else {
      load ?  setState(ViewState.Idle) :  updateValue(false);
      DialogHelper.showMessage(context, "error_message".tr());
    }
  }

  _scrollListener() {
        if (scrollController.offset >= scrollController.position.maxScrollExtent){
          isJump = true;
        }
        isJump ? scrollController
            .jumpTo(scrollController.position.maxScrollExtent) : Container();
      }

  Future postEventChatMessage(BuildContext context, String text,
      TextEditingController controller) async {
    updateValue(true);

    await mmyEngine!
        .postEventChatMessage(eventDetail.eid!, text: text)
        .catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, "error_message".tr());
    });

   // eventChatList.clear();
    controller.clear();
    await getEventChatMessages(context, load: false);
    updateValue(false);
  }
  
}
