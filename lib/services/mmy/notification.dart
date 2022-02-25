import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meetmeyou_app/models/mmy_notification.dart';

import '../../models/discussion.dart';
import '../../models/profile.dart';
import '../database/database.dart';
import 'package:meetmeyou_app/models/event.dart';

const PARAM_NOTIFY_EVENT = 'notify_event';
const PARAM_NOTIFY_INVITATION = 'notify_invitation';
const PARAM_NOTIFY_DISCUSSION = 'notify_discussion';

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
        title: 'New Event',
        text: 'You have been invited to a new event (${event.title}) by ${event.organiserName}',
        photoURL: '${event.photoURL}',
        tokens: [token]);
    await db.setNotification(notification);
  }
}

Future<void> notifyEventModified(User currentUser, String eid, String uid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  String token = await db.getUserToken(uid);
  Event event = await db.getEvent(eid);
  if(token != '') {
    MMYNotification notification = MMYNotification(
        nid: idGenerator(),
        type: NOTIFICATION_TEXT,
        uid: currentUser.uid,
        title: 'Event modified',
        text: 'Event (${event.title}) by ${event.organiserName} has been modified',
        photoURL: '${event.photoURL}',
        tokens: [token]);
    await db.setNotification(notification);
  }
}

Future<void> notifyEventCanceled(User currentUser, String eid, String uid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  String token = await db.getUserToken(uid);
  Event event = await db.getEvent(eid);
  if(token != '') {
    MMYNotification notification = MMYNotification(
        nid: idGenerator(),
        type: NOTIFICATION_TEXT,
        uid: currentUser.uid,
        title: 'Event canceled',
        text: 'Event (${event.title}) by ${event.organiserName} has been canceled',
        photoURL: '${event.photoURL}',
        tokens: [token]);
    await db.setNotification(notification);
  }
}

Future<void> notifyContactInvite(User currentUser, String uid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  String token = await db.getUserToken(uid);
  Profile profile = (await db.getProfile(currentUser.uid))!;
  if(token != '') {
    MMYNotification notification = MMYNotification(
        nid: idGenerator(),
        type: NOTIFICATION_TEXT,
        uid: currentUser.uid,
        title: 'New contact invitation',
        text: 'You have received contact invitation by ${profile.displayName}',
        photoURL: '${profile.photoURL}',
        tokens: [token]);
    await db.setNotification(notification);
  }
}

Future<void> notifyDiscussionMessage(User currentUser, String did, String uid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  String token = await db.getUserToken(uid);
  Discussion discussion = await db.getDiscussion(did);
  if(token != '') {
    MMYNotification notification = MMYNotification(
        nid: idGenerator(),
        type: NOTIFICATION_TEXT,
        uid: currentUser.uid,
        title: 'New message',
        text: 'You have received a new message',
        photoURL: '${discussion.photoURL}',
        tokens: [token]);
    await db.setNotification(notification);
  }
}