import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';

class FirebaseNotification {
  BuildContext? context;
  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;


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
        intentToNextScreen();
      }
    });
    // await FirebaseMessaging.instance.subscribeToTopic(AppConfig.newsTopic);
    // await FirebaseMessaging.instance
    //     .subscribeToTopic(AppConfig.promotionsTopic);
    // await FirebaseMessaging.instance
    //     .subscribeToTopic(AppConfig.notificationsTopic);
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
      // if (message.data["notificationType"] == "ORDER") {
      //   print("order notification");
      //   eventBus.fire(json.encode(message.data));
      // }
      var image;
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
          largeIcon: image != null ? FilePathAndroidBitmap(image) : null);

      var iosNotificationDetail = new IOSNotificationDetails(
          attachments:
          image != null ? [IOSNotificationAttachment(image)] : null);
      var notificationDetail = new NotificationDetails(
          android: androidNotificationDetail, iOS: iosNotificationDetail);
      _flutterLocalNotificationsPlugin?.show(
        0, notification?.title, notification?.body, notificationDetail,
        //  payload: json.encode(message.data)
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      intentToNextScreen();
    });
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
    // if (payload != null) {
    //   var dataMap = json.decode(payload);
    //   var notificationType = dataMap["notificationType"];
    //   if (notificationType != "ORDER") {
    //     intentToNextScreen();
    //   }
    // }
  }

  intentToNextScreen() {

  }

// _downloadAndSaveFile(String url, String fileName) async {
//   var directory = await getApplicationDocumentsDirectory();
//   var filePath = '${directory.path}/$fileName';
//   var response = await http.get(Uri.parse(url));
//   var file = File(filePath);
//   var raf = file.openSync(mode: FileMode.write);
//   raf.writeFromSync(response.bodyBytes);
//   await raf.close();
//   return filePath;
// }
}
