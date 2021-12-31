import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_answer.dart';
import 'package:meetmeyou_app/models/event_chat_message.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/services/database/database.dart';
import 'package:meetmeyou_app/services/mmy/profile.dart';

Future<EventAnswer> answerEventForm(String eid, User currentUser, Map answers) async {
  FirestoreDB db = FirestoreDB(uid: currentUser.uid);
  Profile profile = (await db.getProfile(currentUser.uid))!;
  Event event = await db.getEvent(eid);
  EventAnswer answer = EventAnswer(eid: event.eid,
      uid: profile.uid, displayName: profile.displayName, email: profile.email,
      attend: event.invitedContacts[profile.uid],
      fields: event.form, answers: answers,
      timeStamp: DateTime.now());
  await db.setAnswer(eid, profile.uid, answer);
  return answer;
}

Future<List<EventAnswer>> emailEventAnswers(eid, User currentUser,) async {
  return await FirestoreDB(uid: currentUser.uid).getAnswers(eid);
  //TODO: write code to build email
}