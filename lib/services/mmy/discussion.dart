
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/discussion.dart';
import 'package:meetmeyou_app/models/discussion_message.dart';

import 'profile.dart' as profileLib;
import 'contact.dart' as contactLib;

import '../../models/contact.dart';
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

Map<String, dynamic> Invitations({String? CID, List<String>? CIDs,}){
  Map<String, dynamic> newList = <String, dynamic>{};
  if(CID != null) {
    newList.addAll({CID: MESSAGES_UNREAD});
    return newList;
  }
  if(CIDs != null) {
    for(String CID in CIDs)
      newList.addAll({CID: MESSAGES_UNREAD});
    return newList;
  }
  return newList;
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

  Discussion discussion = Discussion(
    did: eid ?? idGenerator(),
    type: (eid==null) ? EVENT_DISCUSSION : USER_DISCUSSION,
    title: title,
    adminUid: admin.uid,
    adminDisplayName: admin.displayName,
    photoURL: (eid==null) ? admin.photoURL : event!.photoURL,
    participants: participants,
    timeStamp: DateTime.now(),
  );
  await db.setDiscussion(discussion);
  return discussion;
}

Future<Discussion> getDiscussion(User currentUser, String did) async {
  final db = FirestoreDB(uid: currentUser.uid);
  List<DiscussionMessage> messages = [];
  Discussion discussion = await db.getDiscussion(did);
  messages = await db.getDiscussionMessages(did);
  messages.sort((a,b) => (a.createdTimeStamp.microsecondsSinceEpoch - b.createdTimeStamp.microsecondsSinceEpoch));
  discussion.messages = messages;
  discussion.unread = false;
  discussion.participants[currentUser.uid] = MESSAGES_READ;
  await db.setDiscussion(discussion);
  return discussion;
}

Future<void> postMessage(User currentUser, String did, String type, String text, String? URL, String? replyMid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Profile profile = (await db.getProfile(currentUser.uid))!;
  DiscussionMessage message = DiscussionMessage(did: did, mid: idGenerator(),
      type: type,
      contactUid: profile.uid, contactDisplayName: profile.displayName, contactPhotoURL: profile.photoURL,
      text: text,
      attachmentURL: URL ?? '',
      replyMid: replyMid ?? '',
      isReply: (replyMid==null) ? false:true,
      level: (replyMid==null) ? 0:1,
      createdTimeStamp: DateTime.now(), editedTimeStamp: DateTime.now());

  Discussion discussion = await db.getDiscussion(did);
  for(String uid in discussion.participants.keys) {
    discussion.participants[uid] = MESSAGES_UNREAD;
  }
  discussion.participants[currentUser] = MESSAGES_READ;
  await db.setDiscussion(discussion);
  await db.setDiscussionMessage(message);
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
      discussion.unread = false;
      discussions.add(discussion);
    }
  }
  return discussions;
}

Future<void> removeUserFromDiscussion(User currentUser, String did, String uid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  discussion.participants.remove(uid);
  await db.setDiscussion(discussion);
}

Future<void> inviteUserToDiscussion(User currentUser, String uid, String did) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  discussion.participants.addAll({uid: MESSAGES_UNREAD});
  await db.setDiscussion(discussion);
}

Future<Discussion> changeTitleOfDiscussion(User currentUser, String did, String title) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  discussion.title = title;
  await db.setDiscussion(discussion);
  return discussion;
}

Future<Discussion?> findDiscussion(User currentUser, List<String> UIDs) async {
  Discussion? result = null;
  List<Discussion> userDiscussions = await getUserDiscussions(currentUser);
  for(Discussion discussion in userDiscussions) {
    if(discussion.adminUid == currentUser.uid) {
      bool test1 = true;
      bool test2 = true;
      for(String uid in UIDs) {
        if(!discussion.participants.containsKey(uid)) test1 = false;
      }
      for(String uid in discussion.participants.keys) {
        if(!UIDs.contains(uid)) test2 = false;
      }
      if(test1 && test2) return discussion;
    }
  }
  return result;
}

Future<Discussion> startContactDiscussion(User currentUser, String cid) async {
  String title = (await profileLib.getUserProfile(currentUser)).displayName;
  Contact contact = await contactLib.getContact(currentUser, cid: cid);
  title = title + ',' + contact.displayName;
  if(contact.status == CONTACT_GROUP) {
    List<String> CIDs = [];
    for(String cid in contact.group.keys) CIDs.add(cid);

    Discussion? existingDiscussion = await findDiscussion(currentUser, (CIDs + [currentUser.uid]));
    if(existingDiscussion != null) return existingDiscussion;

    return await createDiscussion(currentUser, title,invited: Invitations(CIDs: CIDs));
  }
  else {
    Discussion? existingDiscussion = await findDiscussion(currentUser, [currentUser.uid, cid]);
    if(existingDiscussion != null) return existingDiscussion;
    return await createDiscussion(currentUser, title, invited: Invitations(CIDs: [cid]));
  }
}