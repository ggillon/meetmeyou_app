import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_answer.dart';
import 'package:meetmeyou_app/models/event_chat_message.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/services/database/database.dart';
import 'package:meetmeyou_app/services/mmy/profile.dart';

import '../email/email.dart';

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

Future<List<EventAnswer>> getAnswersEventForm(User currentUser, String eid, ) async {
  FirestoreDB db = FirestoreDB(uid: currentUser.uid);
  return db.getAnswers(eid);
}

Future<EventAnswer> getAnswerEventForm(User currentUser, String eid, String uid) async {
  List<EventAnswer> answers = await getAnswersEventForm(currentUser, eid);
  for(EventAnswer answer in answers) {
    if (answer.uid == uid)
      return answer;
  }
  return answers.first;
}

Future<List<EventAnswer>> emailEventAnswers(eid, User currentUser,) async {
  FirestoreDB db = FirestoreDB(uid: currentUser.uid);
  List<EventAnswer> answers = await db.getAnswers(eid);
  Event event = await db.getEvent(eid);
  String body = '';
  for(EventAnswer answer in answers) {
    body = body + 'Answer from ${answer.displayName}: ${answer.answers.toString()} \n ';
  }
  sendEmail(
    emails: [currentUser.email!],
    subject: 'Answer to Event: ${event.title}',
    message: body,
  );
  return answers;
}