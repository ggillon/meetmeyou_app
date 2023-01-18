import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/services/database/database.dart';
import 'package:meetmeyou_app/services/mmy/profile.dart';

import 'idgen.dart';

Event createLocalEvent(Profile organiser) {
  return Event(
    title: '',
    eid: idGenerator(),
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

Future<Event> updateEvent(User currentUser, String? eid, {String? title, String? location, String? description, String? photoURL, DateTime? start, DateTime? end, String? website, String? formText, Map? form, String? eventType}) async {

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
    ..form = form ?? event.form
    ..website = website ?? event.website
    ..eventType = eventType ?? EVENT_TYPE_PRIVATE;


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

const SELECTOR_PRIVATE_EVENTS = "Private Event";
const SELECTOR_ANNOUNCEMENT = "Announcement";

// need to clean it up
Future<List<Event>> getUserEvents(User currentUser, {List<String>? selector, List<String>? filters}) async {
  List<Event> eventList = [];

  if(selector == null) selector = [SELECTOR_PRIVATE_EVENTS, SELECTOR_ANNOUNCEMENT];
  if(filters == null) filters = [EVENT_ORGANISER, EVENT_INVITED, EVENT_ATTENDING, EVENT_NOT_ATTENDING, EVENT_CANCELED];

  for (Event event in await FirestoreDB(uid: currentUser.uid).getUserEvents(currentUser.uid)) {
    if(filters.contains(event.invitedContacts[currentUser.uid])
        && selector.contains(event.eventType)
        && event.start.isAfter(DateTime.now().subtract(Duration(hours: 24)))
    )
      eventList.add(event);
  }
  if(filters.contains(EVENT_NOT_INTERESTED)) {
    for (Event event in await FirestoreDB(uid: currentUser.uid).getUserEvents(currentUser.uid)) {
      if(filters.contains(event.invitedContacts[currentUser.uid]))
        eventList.add(event);
    }
  }
  return eventList;
}

Future<List<Event>> getContactEvents(User currentUser, String cid, {List<String>? selector, List<String>? filters}) async {
  List<Event> eventList = [];

  if(selector == null) selector = [SELECTOR_PRIVATE_EVENTS, SELECTOR_ANNOUNCEMENT];
  if(filters == null) filters = [EVENT_ORGANISER, EVENT_INVITED, EVENT_ATTENDING, EVENT_NOT_ATTENDING, EVENT_CANCELED];

  for (Event event in await FirestoreDB(uid: currentUser.uid).getUserEvents(cid)) {
    if(filters.contains(event.invitedContacts[cid])
        && selector.contains(event.eventType)
        && event.start.isAfter(DateTime.now().subtract(Duration(hours: 24)))
    )
      eventList.add(event);
  }
  if(filters.contains(EVENT_NOT_INTERESTED)) {
    for (Event event in await FirestoreDB(uid: currentUser.uid).getUserEvents(cid)) {
      if(filters.contains(event.invitedContacts[cid]))
        eventList.add(event);
    }
  }
  return eventList;
}

Future<List<Event>> getPastEvents(User currentUser,) async {
  List<Event> eventList = [];
  for (Event event in await FirestoreDB(uid: currentUser.uid).getUserEvents(currentUser.uid)) {
    if(event.start.isBefore(DateTime.now().subtract(Duration(hours: 24)))
        && event.invitedContacts[currentUser.uid] != EVENT_NOT_INTERESTED)
      eventList.add(event);
  }
  return eventList;
}


Future<Event> getEvent(User currentUser, String eid) async {

  final event = await FirestoreDB(uid: currentUser.uid).getEvent(eid);
  try { // TODO: Clean up at some point
    final organiser = await FirestoreDB(uid: currentUser.uid).getProfile(event.organiserID);
    event.organiserName = organiser!.displayName;
    FirestoreDB(uid: currentUser.uid).setEvent(event);
  } catch(e) {print(e);}
  return event;
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

Future<Event> setParam(User currentUser, String eid, String param, dynamic value) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Event event = await db.getEvent(eid);
  event.params[param] = value;
  db.setEvent(event);
  return event;
}

Future<dynamic> getParam(User currentUser, String eid, String param,) async {
  return (await FirestoreDB(uid: currentUser.uid).getEvent(eid)).params[param];
}