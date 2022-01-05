import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/event_chat_message.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/services/database/database.dart';


String midGenerator() {
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

Future<List<EventChatMessage>> getEventChatMessages(User currentUser, String eid,) async {
  List<EventChatMessage> messagesList = await FirestoreDB(uid: currentUser.uid).getMessages(eid);
  messagesList.sort((a,b) => (a.timeCreated.microsecondsSinceEpoch - b.timeCreated.microsecondsSinceEpoch));
  return messagesList;
}

Future<EventChatMessage> postEventChatMessages(User currentUser, String eid, String text,) async {
  Profile profile = (await FirestoreDB(uid: currentUser.uid).getProfile(currentUser.uid))!;
  EventChatMessage message = EventChatMessage(eid: eid, uid: currentUser.uid, mid: midGenerator(),
      displayName: profile.displayName,
      photoURL: profile.photoURL,
      timeCreated: DateTime.now(), timeEdited: DateTime.now(), text: text);
  await FirestoreDB(uid: currentUser.uid).setMessage(eid, message);
  return message;
}