
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/discussion.dart';
import 'package:meetmeyou_app/models/discussion_message.dart';

import '../../models/profile.dart';
import '../../models/event.dart';
import '../database/database.dart';

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

Future<Discussion> createDiscussion(User currentUser, String title, {String? eid, Map<String, dynamic>? invited}) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Profile admin;
  Event? event;
  if (eid == null) {
    admin = (await db.getProfile(currentUser.uid))!;
  } else {
    event = await db.getEvent(eid);
    admin = (await db.getProfile(event.organiserID))!;
  }
  Map<String, dynamic> participants = { admin.uid: MESSAGES_READ };

  if(invited != null) {
    participants.addAll(invited);
  }

  return Discussion(
    did: eid ?? idGenerator(),
    type: (eid==null) ? EVENT_DISCUSSION : USER_DISCUSSION,
    title: title,
    adminUid: admin.uid,
    adminDisplayName: admin.displayName,
    photoURL: (eid==null) ? admin.photoURL : event!.photoURL,
    participants: participants,
    timeStamp: DateTime.now(),
  );
}

Future<Discussion> getDiscussion(User currentUser, String did) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  discussion.messages = await db.getDiscussionMessages(did);
  return discussion;
}

Future<void> postMessage(User currentUser, String did, String type, String text, String URL) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Profile profile = (await db.getProfile(currentUser.uid))!;
  DiscussionMessage message = DiscussionMessage(did: did, mid: idGenerator(),
      type: type,
      contactUid: profile.uid, contactDisplayName: profile.displayName, contactPhotoURL: profile.photoURL,
      text: text,
      attachmentURL: URL,
      createdTimeStamp: DateTime.now(), editedTimeStamp: DateTime.now());
  db.setDiscussionMessage(message);
}

Future<List<Discussion>> getUserDiscussions(User currentUser) async {
  final db = FirestoreDB(uid: currentUser.uid);
  List<Discussion> discussions = [];
  for(Discussion discussion in await db.getUserDiscussions(currentUser.uid)) {
    if(discussion.participants[currentUser.uid] == MESSAGES_UNREAD) {
      discussion.unread = true;
      discussions.add(discussion);
    }
    if(discussion.participants[currentUser.uid] == MESSAGES_READ) {
      discussions.add(discussion);
    }
  }
  return discussions;
}

Future<void> removeUserFromDiscussion(User currentUser, String did) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  discussion.participants.remove(currentUser.uid);
  db.setDiscussion(discussion);
}

Future<void> inviteUserToDiscussion(User currentUser, String uid, String did) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  discussion.participants.remove(currentUser.uid);
  db.setDiscussion(discussion);
}