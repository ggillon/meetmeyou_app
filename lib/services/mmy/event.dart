import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/date_option.dart';
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
  /*if(event.organiserID != currentUser.uid)
    throw('Error trying to create an event with wrong ID');*/
  //print(event.organiserID);
  await FirestoreDB(uid: currentUser.uid).setEvent(event);
  return event;
}

Future<Event> updateEvent(User currentUser, String? eid, {String? title, String? location, String? description, String? photoURL, DateTime? start, DateTime? end, String? formText, Map? form,}) async {

  Event? event;

  if (eid != null)
    event = await FirestoreDB(uid: currentUser.uid).getEvent(eid);
  else
    event = createLocalEvent(await getUserProfile(currentUser));

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
  final db = FirestoreDB(uid: currentUser.uid);
  Event event = await db.getEvent(eid);
  event.invitedContacts.addAll(invitations);
  if(event.multipleDates) {
    final eventDates = await db.getAllDateOptions(eid);
    for(DateOption date in eventDates) {
      date.invitedContacts.addAll(invitations);
      await db.setDateOption(eid, date);
    }
  }
  await db.setEvent(event);
  return event;
}

Future<Event> removeInvitations(User currentUser, String eid, List<String> CIDs) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Event event = await db.getEvent(eid);
  for(String CID in CIDs) {
    event.invitedContacts.remove(CID);
    if(event.multipleDates) {
      final eventDates = await db.getAllDateOptions(eid);
      for(DateOption date in eventDates) {
        date.invitedContacts.remove(CID);
        await db.setDateOption(eid, date);
      }
    }
  }
  await FirestoreDB(uid: currentUser.uid).setEvent(event);
  return event;
}

Map<String, dynamic> Invitations({String? CID, List<String>? CIDs, required String inviteStatus}){
  Map<String, dynamic> newList = <String, dynamic>{};
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

Future<List<Event>> getUserEvents(User currentUser,{List<String>? filters}) async {
  List<Event> eventList = [];
  if(filters == null)
    filters = [EVENT_ORGANISER, EVENT_INVITED, EVENT_ATTENDING, EVENT_NOT_ATTENDING, EVENT_CANCELED];
  for (Event event in await FirestoreDB(uid: currentUser.uid).getUserEvents(currentUser.uid)) {
    if(filters.contains(event.invitedContacts[currentUser.uid]) && event.start.isAfter(DateTime.now().subtract(Duration(hours: 24))))
      eventList.add(event);
  }
  return eventList;
}

Future<Event> getEvent(User currentUser, String eid) async {
  return await FirestoreDB(uid: currentUser.uid).getEvent(eid);
}

Future<void> deleteEvent(User currentUser, String eid) async {
  await FirestoreDB(uid: currentUser.uid).deleteEvent(eid);
}

Future<Event> cancelEvent(User currentUser, String eid) async {
  Event event = await FirestoreDB(uid: currentUser.uid).getEvent(eid);
  if(event.organiserID == currentUser.uid) {
    event.invitedContacts.forEach((key, value) {event.invitedContacts[key] = EVENT_CANCELED;});
  } else {
    throw('Error: user not organiser');
  }
  await FirestoreDB(uid: currentUser.uid).setEvent(event);
  return event;
}