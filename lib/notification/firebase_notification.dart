import 'dart:convert';

import 'package:easy_localization/src/public_ext.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contactInvitationNotificationEvent.dart';
import 'package:meetmeyou_app/models/messageNotificationEvent.dart';
import 'package:meetmeyou_app/models/userEventsNotificationEvent.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/view/dashboard/dashboardPage.dart';
import 'package:provider/provider.dart';

class FirebaseNotification {
  BuildContext? context;
  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
  EventBus eventBus = locator<EventBus>();
  String? title;

  Future<void> configureFireBase(BuildContext context) async {
    this.context = context;

    await Firebase.initializeApp();
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        if(value.notification!.title == StringConstants.newEvent ||value.notification!.title == StringConstants.eventModified || value.notification!.title == StringConstants.eventCancelled){
          eventBus.fire(UserEventsNotificationEvent(eventId: value.data["id"]));
          return;
        } else if(value.notification!.title == StringConstants.newMessage){
          eventBus.fire(MessageNotificationEvent(chatId: value.data["id"]));
          return;
        } else if(value.notification!.title == StringConstants.newInvitation){
          eventBus.fire(ContactInvitationNotificationEvent(contactId: value.data["id"]));
          return;
        } else{
          DialogHelper.showMessage(context, "sorry_notification_data_changed".tr());
        }
      }
    });

    flutterNotification(context);
    channel = const AndroidNotificationChannel(
      '91512', // id
      '91512', // title
      description: 'This channel is used for important notifications.',
      // description
      importance: Importance.max,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("notification data is ${message.data}");
      if(message.data['id'] != null){
        title = message.notification?.title;
      }
    //  var image;
      // if (message.data.containsKey("imageURL")) {
      //   var imageUrl = message.data["imageURL"];
      //   image = await _downloadAndSaveFile(imageUrl, 'attachment_img.jpg');
      // }
      RemoteNotification? notification = message.notification;
      var androidNotificationDetail = AndroidNotificationDetails(
          "91512", "91512",
          channelDescription: "This is for testing purpose",
          importance: Importance.max,
          priority: Priority.high,
        //  largeIcon: image != null ? FilePathAndroidBitmap(image) : null
      );

      var iosNotificationDetail = new IOSNotificationDetails(
          // attachments:
          // image != null ? [IOSNotificationAttachment(image)] : null
      );
      var notificationDetail = new NotificationDetails(
          android: androidNotificationDetail, iOS: iosNotificationDetail);
      _flutterLocalNotificationsPlugin?.show(
        0, notification?.title, notification?.body, notificationDetail,
          payload: json.encode(message.data)
      );
    });
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        print("notification data is ${message.data}");

        if(message.notification!.title == StringConstants.newEvent ||message.notification!.title == StringConstants.eventModified || message.notification!.title == StringConstants.eventCancelled){
          eventBus.fire(UserEventsNotificationEvent(eventId: message.data["id"]));
          return;
        } else if(message.notification!.title == StringConstants.newMessage){
          eventBus.fire(MessageNotificationEvent(chatId: message.data["id"]));
          return;
        } else if(message.notification!.title == StringConstants.newInvitation){
          eventBus.fire(ContactInvitationNotificationEvent(contactId: message.data["id"]));
          return;
        } else{
          DialogHelper.showMessage(context, "sorry_notification_data_changed".tr());
        }

      });
    } else {
      print('User declined or has not accepted permission');
    }

  }

  void flutterNotification(BuildContext context) {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    _flutterLocalNotificationsPlugin?.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void onSelectNotification(String? payload) {
    print("notification click ${payload}");
    if (payload != null) {
      var dataMap = json.decode(payload);
      var id = dataMap["id"];
       intentToNextScreen(id);
      if(title == StringConstants.newEvent || title == StringConstants.eventModified || title == StringConstants.eventCancelled){
        eventBus.fire(UserEventsNotificationEvent(eventId: id));
        return;
      }else if(title == StringConstants.newMessage){
        eventBus.fire(MessageNotificationEvent(chatId: id));
        return;
      } else if(title == StringConstants.newInvitation){
        eventBus.fire(ContactInvitationNotificationEvent(contactId: id));
        return;
      }

    }
  }

  intentToNextScreen(String id) {
    Navigator.of(context!).pushNamedAndRemoveUntil(
        RoutesConstants.dashboardPage, (route) => false, arguments: DashboardPage(isFromLogin: false));
  }

}
