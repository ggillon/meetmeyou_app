import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meetmeyou_app/models/mmy_notification.dart';

import '../../models/profile.dart';
import '../database/database.dart';
import 'package:meetmeyou_app/models/event.dart';

String idGenerator() {
  final charList = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String eid = '';

  for(int i=0; i<4; i++) {
    int randomNumber = Random().nextInt(52);
    eid = eid + charList.substring(randomNumber, randomNumber+1);
  }
  eid = eid + '-';
  for(int i=0; i<4; i++) {
    int randomNumber = Random().nextInt(52);
    eid = eid + charList.substring(randomNumber, randomNumber+1);
  }
  return eid;
}

Future<void> setToken(User currentUser) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Profile? profile = await db.getProfile(currentUser.uid);
  profile!.parameters['token'] = await FirebaseMessaging.instance.getToken();
  await db.setProfile(profile);
}

Future<void> notifyEventInvite(User currentUser, String eid, String uid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  String token = await db.getUserToken(uid);
  Event event = await db.getEvent(eid);
  if(token != '') {
    MMYNotification notification = MMYNotification(
        nid: idGenerator(),
        type: NOTIFICATION_TEXT,
        uid: currentUser.uid,
        text: 'You have been invited to a new event (${event.title}) by ${event.organiserName}',
        photoURL: '',
        tokens: [token]);
    await db.setNotification(notification);
  }
}