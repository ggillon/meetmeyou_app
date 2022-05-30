import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/services/database/database.dart';
import 'package:meetmeyou_app/services/mmy/profile.dart';
import 'idgen.dart';

Event createLocalAnnouncement(Profile organiser) {
  DateTime now = DateTime.now();

  return Event(
    title: '',
    eid: idGenerator(),
    eventType: EVENT_TYPE_ANNOUNCEMENT,
    timeStamp: now,
    organiserID: organiser.uid,
    organiserName: organiser.displayName,
    admins: {organiser.uid: EVENT_ADMIN_ORGANISER },
    invitedContacts: { '${organiser.uid}': 'Organiser' },
    start: now.add(Duration(days: 100,)),
    end: now.add(Duration(days:100, hours: 3)),
  );
}

Future<Event> updateAnnouncement(User currentUser, String? eid, {String? title, String? location, String? description, String? photoURL, DateTime? start, DateTime? end, String? website, String? formText, Map? form, String? eventType}) async {

  Event? event;

  if (eid != null)
    event = await FirestoreDB(uid: currentUser.uid).getEvent(eid);
  else
    event = createLocalAnnouncement(await getUserProfile(currentUser));

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
    ..eventType = eventType ?? EVENT_TYPE_ANNOUNCEMENT;

  event.params['announcementLocation'] = (event.location != '')  ? true : false;
  event.params['announcementWebsite'] = (event.website != '')  ? true : false;
  event.params['announcementDate'] = (event.start.difference(event.timeStamp) != Duration(days: 100))  ? true : false;

  await FirestoreDB(uid: currentUser.uid).setEvent(event);
  return event;
}