
import 'idgen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/discussion.dart';
import 'package:meetmeyou_app/models/discussion_message.dart';
import 'package:meetmeyou_app/services/storage/storage.dart';

import 'profile.dart' as profileLib;
import 'contact.dart' as contactLib;
import 'event.dart' as eventLib;

import '../../models/contact.dart';
import '../../models/profile.dart';
import '../../models/event.dart';
import '../database/database.dart';

const DEFAULT_PHOTO = "https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media";


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

Future<Discussion> createDiscussion(User currentUser, {required String adminUid, String? did, required String type, String? title, String? photoURL, Map<String, dynamic>? invited}) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Map<String, dynamic> participants = { adminUid: MESSAGES_READ };
  if(invited != null) {
    participants.addAll(invited);
  }

  Discussion discussion = Discussion(
    did: did ?? idGenerator(),
    type: type,
    title: title ?? '',
    adminUid: adminUid,
    adminDisplayName: '',
    photoURL: photoURL ?? DEFAULT_PHOTO,
    participants: participants,
    timeStamp: DateTime.now().toUtc(),
  );

  await db.setDiscussion(discussion);
  return discussion;
}

Future<Discussion> startEventDiscussion(User currentUser, {required eid}) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Event event = await db.getEvent(eid);
  List<String> CIDs = [];
  for(String cid in event.invites.keys) CIDs.add(cid);
  Discussion discussion = await createDiscussion(currentUser,
    adminUid: event.organiserID,
    did: eid,
    type: DISCUSSION_TYPE_EVENT,
    title: event.title,
    photoURL: event.photoURL,
    invited: Invitations(CIDs: CIDs),
  );
  return discussion;
}

Future<Discussion> startContactDiscussion(User currentUser, {required cid}) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Contact contact = await db.getContact(currentUser.uid, cid);
  List<String> CIDs = [];
  if(contact.status == CONTACT_GROUP) {
    for(String cid in contact.group.keys) CIDs.add(cid);
  } else {
    CIDs.add(cid);
  }
  // Check if discussion exists
  Discussion? existingDiscussion = await findDiscussion(currentUser, (CIDs + [currentUser.uid]));
  if(existingDiscussion != null) return existingDiscussion;

  // Else create it
  Discussion discussion = await createDiscussion(currentUser,
    adminUid: currentUser.uid,
    did: cid,
    type: (contact.status == CONTACT_GROUP) ? DISCUSSION_TYPE_GROUP : DISCUSSION_TYPE_PRIVATE,
    invited: Invitations(CIDs: CIDs),
  );
  return discussion;
}

Future<Discussion> startGroupDiscussion(User currentUser, {required CIDs}) async {
  final db = FirestoreDB(uid: currentUser.uid);
  List<String> _CIDs = [];
  List<Contact> contacts = [];
  for(String cid in CIDs) contacts.add(await db.getContact(currentUser.uid, cid));
  for(Contact contact in contacts) {
    if(contact.status == CONTACT_GROUP) {
      for(String c in contact.group.keys) _CIDs.add(c);
    } else {
      _CIDs.add(contact.cid);
    }
  }

  // Check if discussion exists
  Discussion? existingDiscussion = await findDiscussion(currentUser, (_CIDs + [currentUser.uid]));
  if(existingDiscussion != null) return existingDiscussion;

  // Else create it
  Discussion discussion = await createDiscussion(currentUser,
    adminUid: currentUser.uid,
    type: (_CIDs.length > 1) ? DISCUSSION_TYPE_GROUP : DISCUSSION_TYPE_PRIVATE,
    invited: Invitations(CIDs: _CIDs),
  );
  return discussion;
}


Future<Discussion> getDiscussion(User currentUser, String did) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  discussion.participants[currentUser.uid] = MESSAGES_READ;

  // Adapt discussion to user
  discussion.unread = false; // Discussion opened
  discussion.isOrganiser = (currentUser.uid == discussion.adminUid);

  // If discussion is private or group adapt the title & photo
  if (discussion.type == DISCUSSION_TYPE_PRIVATE || discussion.type == DISCUSSION_TYPE_GROUP) {
    discussion.photoURL = await getDiscussionPhotoURL(currentUser, discussion);
    discussion.title = await getDiscussionTitle(currentUser, discussion);
    if (discussion.participants.keys.length > 2) discussion.type = DISCUSSION_TYPE_GROUP;
  }

  // Add the messages
  discussion.messages = db.getDiscussionMessagesStream(did);

  db.setDiscussion(discussion);
  return discussion;
}

Future<String> getDiscussionTitle(User currentUser, Discussion discussion) async {
  final db = FirestoreDB(uid: currentUser.uid);
  String result = discussion.title;
  if(discussion.params.containsKey('set_title')) { // Title has been set use it
    if(discussion.params['set_title']) return result;
  }
  if(discussion.participants.length == 2) { // it's a 2 people conversation - return other person's name
    if(currentUser.uid != discussion.adminUid) return (await db.getProfile(discussion.adminUid))!.displayName; // when created it's the one used
    for (String key in discussion.participants.keys) {
      if (key != currentUser.uid) return (await db.getProfile(key))!.displayName; // Use the other persons name
    }
  } else { // it's a multiple discussion title return other users name
    result = '';
    for(String key in discussion.participants.keys) {
      if(key != currentUser.uid) {
        Profile profile = (await db.getProfile(key))!;
        if(result != '') {
          result = result + ', ' + profile.displayName;
        } else {
          result = profile.displayName;
        }
      }
    }
  }
  return result;
}

Future<String> getDiscussionPhotoURL(User currentUser, Discussion discussion) async {
  final db = FirestoreDB(uid: currentUser.uid);
  String result = discussion.photoURL;
  if(discussion.params.containsKey('set_photo')) { // Photo has been set use it
    if(discussion.params['set_photo']) return result;
  }
  if(discussion.participants.length == 2) { // it's a 2 people conversation - show other person's photo
    if(currentUser.uid != discussion.adminUid) return (await db.getProfile(discussion.adminUid))!.photoURL; // when created it's the one used
    for (String key in discussion.participants.keys) {
      if (key != currentUser.uid) result = (await db.getProfile(key))!.photoURL; // Use the other persons photo
    }
  } else {
    return result;
  }
  return DEFAULT_PHOTO;
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
      createdTimeStamp: DateTime.now().toUtc(), editedTimeStamp: DateTime.now().toUtc());

  Discussion discussion = await db.getDiscussion(did);
  for(String uid in discussion.participants.keys) {
    discussion.participants[uid] = MESSAGES_UNREAD;
  }
  discussion.participants[currentUser.uid] = MESSAGES_READ;
  discussion.timeStamp = DateTime.now().toUtc();
  await db.setDiscussion(discussion);
  await db.setDiscussionMessage(message);
}

Future<Discussion> updateDiscussion(User currentUser, String did, {String? title, String? photoURL}) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  if(title != null) {
    discussion.title = title;
    discussion.params['set_photo'] = true;
  }
  if(photoURL != null) {
    discussion.photoURL = photoURL;
    discussion.params['set_photo'] = true;
  }
  db.setDiscussion(discussion);
  return discussion;
}

Future<Discussion?> updateLinkedDiscussion(User currentUser, String id, {String? title, String? photoURL}) async {
  Discussion? discussion;
  try {
    discussion = await updateDiscussion(currentUser, id, title: title, photoURL: photoURL);
  } catch (e) {}
  return discussion;
}

Future<List<Discussion>> getUserDiscussions(User currentUser) async {
  final db = FirestoreDB(uid: currentUser.uid);
  List<Discussion> discussions = await db.getUserDiscussions(currentUser.uid);
  List<Discussion> results = [];
  for(Discussion discussion in discussions) {
    if(discussion.participants[currentUser.uid] == MESSAGES_UNREAD) {
      discussion.unread = true;
      if(discussion.type==DISCUSSION_TYPE_PRIVATE && discussion.participants.keys.length>2)
        discussion.type = DISCUSSION_TYPE_GROUP;
      discussion.isOrganiser = (currentUser.uid == discussion.adminUid);
      if (discussion.type != EVENT_DISCUSSION) {
        discussion.photoURL = await getDiscussionPhotoURL(currentUser, discussion);
        discussion.title = await getDiscussionTitle(currentUser, discussion);
      }
      if(discussion.participants.length != 1) results.add(discussion);
    }
    if(discussion.participants[currentUser.uid] != MESSAGES_UNREAD) {
      discussion.unread = false;
      if(discussion.type==DISCUSSION_TYPE_PRIVATE && discussion.participants.keys.length>2)
        discussion.type = DISCUSSION_TYPE_GROUP;
      discussion.isOrganiser = (currentUser.uid == discussion.adminUid);
      if (discussion.type != EVENT_DISCUSSION) {
        discussion.photoURL = await getDiscussionPhotoURL(currentUser, discussion);
        discussion.title = await getDiscussionTitle(currentUser, discussion);
      }
      if(discussion.participants.length != 1) results.add(discussion);
    }
  }
  results.sort((a,b)=> a.timeStamp.microsecondsSinceEpoch.compareTo(b.timeStamp.microsecondsSinceEpoch));
  results = results.reversed.toList();
  return results;
}

Future<void> removeUserFromDiscussion(User currentUser, String did, String uid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  discussion.participants.remove(uid);
  if(discussion.participants.length == 2) {
    discussion.type = DISCUSSION_TYPE_PRIVATE;
  }
  await db.setDiscussion(discussion);
}

Future<void> inviteUserToDiscussion(User currentUser, String uid, String did) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  Contact contact = await db.getContact(currentUser.uid, uid);
  if(contact.status==CONTACT_GROUP) {
    List<String> CIDs = [];
    for(String cid in contact.group.keys) CIDs.add(cid);
    discussion.participants.addAll(Invitations(CIDs: CIDs));
  } else {
    discussion.participants.addAll({uid: MESSAGES_UNREAD});
  }
  if(discussion.participants.length>2) discussion.type = DISCUSSION_TYPE_GROUP;
  await db.setDiscussion(discussion);
}

Future<Discussion?> findDiscussion(User currentUser, List<String> UIDs) async {
  Discussion? result = null;
  List<Discussion> userDiscussions = await getUserDiscussions(currentUser);
  for(Discussion discussion in userDiscussions) {
    if(discussion.type == DISCUSSION_TYPE_GROUP || discussion.type == DISCUSSION_TYPE_PRIVATE) { // Adapt later
      bool test1 = true;
      bool test2 = true;
      for(String uid in UIDs) {
        if(!discussion.participants.containsKey(uid)) {
          test1 = false;
        }
      }
      for(String uid in discussion.participants.keys) {
        if(!UIDs.contains(uid)) {
          test2 = false;
        }
      }
      if(test1 && test2) return discussion;
    }
  }
  return result;
}


/*Future<Discussion> createDiscussion(User currentUser, {required String adminUid, required String title, Map<String, dynamic>? invited}) async {
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

  bool group = false;
  if(invited != null) {
    participants.addAll(invited);
    group = invited.length>1;
  }

  Discussion discussion = Discussion(
    did: eid ?? idGenerator(),
    type: (eid!=null) ? DISCUSSION_TYPE_EVENT : (group ? DISCUSSION_TYPE_GROUP : DISCUSSION_TYPE_PRIVATE),
    title: title,
    adminUid: admin.uid,
    adminDisplayName: admin.displayName,
    photoURL: (eid==null) ? admin.photoURL : event!.photoURL,
    participants: participants,
    timeStamp: DateTime.now().toUtc(),
  );
  await db.setDiscussion(discussion);
  return discussion;
}



Future<Discussion> getEventDiscussion(User currentUser, String eid) async {
  Discussion discussion;
  try{
    discussion = await getDiscussion(currentUser, eid);
  } catch(e) {
    discussion = await createDiscussion(currentUser, (await eventLib.getEvent(currentUser, eid)).title, eid: eid);
  }
}
*/






/*Future<Discussion> setDiscussionTitle(User currentUser, String did, String title) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  discussion.title = title;
  await db.setDiscussion(discussion);
  return discussion;
}

Future<Discussion> setDiscussionPhoto(User currentUser, String did, String photoURL) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  discussion.photoURL = photoURL;
  await db.setDiscussion(discussion);
  return discussion;
}


Future<Discussion> changeTitleOfDiscussion(User currentUser, String did, String title) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  discussion.title = title;
  discussion.params['set_title'] = true;
  await db.setDiscussion(discussion);
  return discussion;
}

Future<Discussion> changePictureOfDiscussion(User currentUser, String did, String photoURL) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Discussion discussion = await db.getDiscussion(did);
  discussion.photoURL = photoURL;
  discussion.params['set_photo'] = true;
  await db.setDiscussion(discussion);
  return discussion;
}

Future<Discussion> startGroupDiscussion(User currentUser, List<String> CIDs) async {
  String title = (await profileLib.getUserProfile(currentUser)).displayName;
  for(String cid in CIDs) {
    Contact contact = await contactLib.getContact(currentUser, cid: cid);
    title = title + ', ' + contact.displayName;
    if (contact.status == CONTACT_GROUP) {
      CIDs.remove(contact.cid);
      for(String key in contact.group.keys) CIDs.add(key);
    }
  }
  Discussion? existingDiscussion = await findDiscussion(
      currentUser, (CIDs + [currentUser.uid]));
  if (existingDiscussion != null) return existingDiscussion;
  return await createDiscussion(
      currentUser, title, invited: Invitations(CIDs: CIDs));
}

Future<Discussion> startContactDiscussion(User currentUser, String cid) async {
  String title = (await profileLib.getUserProfile(currentUser)).displayName;
  Contact contact = await contactLib.getContact(currentUser, cid: cid);
  title = title + ', ' + contact.displayName;
  if(contact.status == CONTACT_GROUP) {
    List<String> CIDs = [];
    for(String cid in contact.group.keys) CIDs.add(cid);
    title = contact.displayName;
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

*/





