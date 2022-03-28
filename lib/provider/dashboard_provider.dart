import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/helper/dynamic_links_api.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
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

  // NOTIFICATIONS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  late final FirebaseMessaging _messaging;
  PushNotification? notificationInfo;
  int badgeCount = 0;


  void registerNotification(BuildContext context, ScreenScaler scaler) async {
    _messaging = FirebaseMessaging.instance;


    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          // dataTitle: message.data['title'],
          // dataBody: message.data['body'],
        );

        notificationInfo = notification;
        notifyListeners();


        if (notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
              Text(notificationInfo!.title!).boldText(ColorConstants.colorBlack, scaler.getTextSize(10.5), TextAlign.left),
              leading: ImageView(path: ImageConstants.small_logo_icon),
              subtitle: Text(notificationInfo!.body!).regularText(ColorConstants.colorBlack, scaler.getTextSize(10.0), TextAlign.left),
              background: ColorConstants.colorWhite,
              duration: Duration(seconds: 3),
              position: NotificationPosition.bottom
          );
        }
      });
    } else {
      print("User declined or has not accepted permission");
    }
  }


  bool notify = false;

  updateNotify(bool val){
    notify = val;
    notifyListeners();
  }

  StreamSubscription? messageNotifyEvent;

  @override
  void dispose() {
    super.dispose();
    messageNotifyEvent?.cancel();
  }

}
