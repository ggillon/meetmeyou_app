import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/services/database/database.dart';
import 'event.dart' as eventLib;

String didGenerator() {
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

Future<String> addDateToEvent(User currentUser, String eid, DateTime start, DateTime end) async {
  Event event = await FirestoreDB(uid: currentUser.uid).getEvent(eid);
  if(event.multipleDates == false) {
    event.multipleDates = true;
    await FirestoreDB(uid: currentUser.uid).setEvent(event);
  }
  String did = didGenerator();
  final date = DateOption(eid: event.eid, did: did, start: start, end: end, description: event.description, invitedContacts: event.invitedContacts);
  await FirestoreDB(uid: currentUser.uid).setDateOption(event.eid, date);
  return did;
}

Future<void> removeDateFromEvent(User currentUser, String eid, String did) async {
  await FirestoreDB(uid: currentUser.uid).deleteDateOption(eid, did);
}


Future<List<DateOption>> getDateOptionsFromEvent(User currentUser, String eid,) async {
  List<DateOption> dateList = await FirestoreDB(uid: currentUser.uid).getAllDateOptions(eid);
  dateList = sortDateOptions(dateList);
  return dateList;
}

Future<Event> selectFinalDate(User currentUser, String eid, String did) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Event event = await db.getEvent(eid);
  DateOption date = await db.getDateOption(eid, did);
  event.start = date.start;
  event.end = date.end;
  event.invitedContacts = date.invitedContacts;
  event.multipleDates = false;
  await db.setEvent(event);
  return event;
}

Future<void> answerDateOption(User currentUser, String eid, String did, bool attend) async {
  final db = FirestoreDB(uid: currentUser.uid);
  DateOption date = await db.getDateOption(eid, did);
  date.invitedContacts[currentUser.uid] = attend ? EVENT_ATTENDING : EVENT_NOT_ATTENDING;
  db.setDateOption(eid, date);
}

Future<bool> dateOptionStatus(User currentUser, String eid, String did) async {
  final db = FirestoreDB(uid: currentUser.uid);
  DateOption date = await db.getDateOption(eid, did);
  return (date.invitedContacts[currentUser.uid] == EVENT_ATTENDING);
}

Future<List<String>> listDateSelected(User currentUser, String eid,) async {
  List<String> results = [];
  final db = FirestoreDB(uid: currentUser.uid);
  final dates = await db.getAllDateOptions(eid);
  for (DateOption date in dates) {
    if(date.invitedContacts.containsKey(currentUser.uid)) {
      if(date.invitedContacts[currentUser.uid] == EVENT_ATTENDING) results.add(date.did);
    }
  }
  return results;
}

Future<void> invitedMultipleDates(User currentUser, String eid, String uid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  final dateList = await db.getAllDateOptions(eid);
  for(DateOption date in dateList) {
    date.invitedContacts.addAll({uid: EVENT_INVITED});
    await db.setDateOption(eid, date);
  }
}

Future<void> removeMultipleDates(User currentUser, String eid, String uid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Event event = await db.getEvent(eid);
  final dateList = await db.getAllDateOptions(eid);
  for(DateOption date in dateList) {
    date.invitedContacts.remove(uid);
    await db.setDateOption(eid, date);
  }
}

List<DateOption> sortDateOptions(List<DateOption> dateList) {
  dateList.sort((a,b) => (a.start.isAfter(b.start)) ? 1 : -1 );
  return dateList;
}

