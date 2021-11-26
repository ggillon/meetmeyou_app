import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/services/database/database.dart';
import 'package:meetmeyou_app/services/mmy/profile.dart';

String eidGenerator() {
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

Event createLocalEvent(Profile organiser) {
  return Event(
    title: '',
    eid: eidGenerator(),
    timeStamp: DateTime.now(),
    organiserID: organiser.uid,
    organiserName: organiser.displayName,
    admins: {organiser.uid: EVENT_ADMIN_ORGANISER },
    invitedContacts: { '${organiser.uid}': 'Organiser' },
    start: DateTime.now(),
    end: DateTime.now().add(Duration(hours: 3)),
  );
}

Future<Event> createEvent(User currentUser, Event event) async {
  await FirestoreDB(uid: currentUser.uid).setEvent(event);
  return event;
}

Future<Event> updateEvent(User currentUser, String eid, {String? title, String? location, String? description, String? photoURL, DateTime? start, DateTime? end, String? formText, Map? form}) async {
  Event event = await FirestoreDB(uid: currentUser.uid).getEvent(eid);

  event
  ..title = title ?? event.title
  ..location = location ?? event.location
  ..description = description ?? event.description
  ..photoURL = photoURL ?? event.photoURL
  ..start = start ?? event.start
  ..end = end ?? event.end
  ..formText = formText ?? event.formText
  ..form = form ?? event.form;

  await FirestoreDB(uid: currentUser.uid).setEvent(event);
  return event;
}

Future<Event> updateInvitations(User currentUser, String eid, Map invitations) async {
  Event event = await FirestoreDB(uid: currentUser.uid).getEvent(eid);
  event.invitedContacts.addAll(invitations);
  await FirestoreDB(uid: currentUser.uid).setEvent(event);
  return event;
}

Future<Event> removeInvitations(User currentUser, String eid, List<String> CIDs) async {
  Event event = await FirestoreDB(uid: currentUser.uid).getEvent(eid);
  for(String CID in CIDs)
    event.invitedContacts.remove(CID);
  await FirestoreDB(uid: currentUser.uid).setEvent(event);
  return event;
}

Map Invitations({String? CID, List<String>? CIDs, required String inviteStatus}){
  Map newList = Map();
  if(CID != null) {
    newList.addAll({CID: inviteStatus});
    return newList;
  }
  if(CIDs != null) {
    for(String CID in CIDs)
      newList.addAll({CID: inviteStatus});
    return newList;
  }
  return newList;
}

Future<List<Event>> getUserEvents(User currentUser) async {
  return await FirestoreDB(uid: currentUser.uid).getUserEvents(currentUser.uid);
}

Future<Event> getEvent(User currentUser, String eid) async {
  return await FirestoreDB(uid: currentUser.uid).getEvent(eid);
}

Future<void> deleteEvent(User currentUser, String eid) async {
  await FirestoreDB(uid: currentUser.uid).deleteEvent(eid);
}