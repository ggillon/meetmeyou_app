import 'idgen.dart';

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


Future<void> setToken(User currentUser) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Profile? profile = await db.getProfile(currentUser.uid);
  profile!.parameters['token'] = await FirebaseMessaging.instance.getToken();
  await db.setProfile(profile);
}

Future<List<MMYNotification>> getUserNotifications(User currentUser) async {
  final db = FirestoreDB(uid: currentUser.uid);
  return db.getUserNotifications(currentUser.uid);
}

Future<void> notifyEventInvite(User currentUser, String eid, String uid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  String token = await db.getUserToken(uid);
  Event event = await db.getEvent(eid);
  if(token != '' && uid!=currentUser.uid) {
    MMYNotification notification = MMYNotification(
        nid: idGenerator(),
        type: NOTIFICATION_EVENT_INVITE,
        uid: uid,
        title: 'New Event',
        text: 'You have been invited to a new event (${event.title}) by ${event.organiserName}',
        photoURL: '${event.photoURL}',
        id: eid,
        timeStamp: DateTime.now(),
        tokens: [token]);
    await db.setNotification(notification);
  }
}

Future<void> notifyEventModified(User currentUser, String eid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Event event = await db.getEvent(eid);

  for(String uid in event.invitedContacts.keys) {
    String token = await db.getUserToken(uid);
    if(token != '' && uid!=currentUser.uid ) {
      MMYNotification notification = MMYNotification(
          nid: idGenerator(),
          type: NOTIFICATION_EVENT_UPDATE,
          uid: uid,
          title: 'Event modified',
          text: 'Event (${event.title}) by ${event
              .organiserName} has been modified',
          photoURL: '${event.photoURL}',
          id: eid,
          timeStamp: DateTime.now(),
          tokens: [token]);
      await db.setNotification(notification);
    }
  }
}

Future<void> notifyEventCanceled(User currentUser, String eid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Event event = await db.getEvent(eid);
  for(String uid in event.invitedContacts.keys) {
    String token = await db.getUserToken(uid);
    if (token != '' && uid!=currentUser.uid ) {
      MMYNotification notification = MMYNotification(
          nid: idGenerator(),
          type: NOTIFICATION_EVENT_CANCEL,
          uid: uid,
          title: 'Event canceled',
          text: 'Event (${event.title}) by ${event
              .organiserName} has been canceled',
          photoURL: '${event.photoURL}',
          id: eid,
          timeStamp: DateTime.now(),
          tokens: [token]);
      await db.setNotification(notification);
    }
  }
}

Future<void> notifyContactInvite(User currentUser, String uid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  String token = await db.getUserToken(uid);
  Profile profile = (await db.getProfile(currentUser.uid))!;
  if(token != '' && uid!=currentUser.uid) {
    MMYNotification notification = MMYNotification(
        nid: idGenerator(),
        type: NOTIFICATION_USER_INVITE,
        uid: uid,
        title: 'New contact invitation',
        text: 'You have received contact invitation by ${profile.displayName}',
        photoURL: '${profile.photoURL}',
        id: profile.uid,
        timeStamp: DateTime.now(),
        tokens: [token]);
    await db.setNotification(notification);
  }
}

Future<void> notifyDiscussionMessage(User currentUser, String did,) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  for(String uid in discussion.participants.keys) {
    String token = await db.getUserToken(uid);
    if (token != '' && uid!=currentUser.uid) {
      MMYNotification notification = MMYNotification(
          nid: idGenerator(),
          type: NOTIFICATION_MESSAGE_NEW,
          uid: uid,
          title: 'New message',
          text: 'You have received a new message',
          photoURL: '${discussion.photoURL}',
          id: did,
          timeStamp: DateTime.now(),
          tokens: [token]);
      await db.setNotification(notification);
    }
  }
}