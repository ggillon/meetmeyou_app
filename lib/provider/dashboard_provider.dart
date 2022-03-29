import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/helper/dynamic_links_api.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/group_detail.dart';
import 'package:meetmeyou_app/models/push_notification.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/notification/firebase_notification.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:overlay_support/overlay_support.dart';

class DashboardProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  GroupDetail groupDetail = locator<GroupDetail>();
  EventDetail eventDetail = locator<EventDetail>();
  CalendarDetail calendarDetail = locator<CalendarDetail>();
  DynamicLinksApi dynamicLinksApi = locator<DynamicLinksApi>();
  EventBus eventBus = locator<EventBus>();
  FirebaseNotification firebaseNotification = locator<FirebaseNotification>();
  int _selectedIndex = 0;

  var unRespondedInvite = 0;
  var unRespondedEvent = 0;

  set selectedIndex(int value) {
    _selectedIndex = value;
  }

  int get selectedIndex => _selectedIndex;

  void onItemTapped(int index) {
    _selectedIndex = index;
    // unRespondedInvites(context);
    // unRespondedEvents(context);

    notifyListeners();
  }

  Future unRespondedInvites(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    unRespondedInvite = await mmyEngine!.unrespondedInvites().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    userDetail.unRespondedInvites = unRespondedInvite;
    setState(ViewState.Idle);
  }

  Future unRespondedEvents(BuildContext context) async {
    setState(ViewState.Busy);
    unRespondedEvent = await mmyEngine!.unrespondedEvents().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    eventDetail.unRespondedEvent = unRespondedEvent;
    eventDetail.unRespondedEvent1 = unRespondedEvent;
    setState(ViewState.Idle);
  }

   updateEventNotificationCount(){
      unRespondedEvent--;
      notifyListeners();
  }

  updateInvitesNotificationCount(){
    unRespondedInvite--;
    notifyListeners();
  }

}
