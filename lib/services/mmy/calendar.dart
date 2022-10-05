import 'package:firebase_auth/firebase_auth.dart';

import '../../models/mmy_calendar.dart';
import '../calendar/calendar.dart';
import '../database/database.dart';
import 'event.dart' as eventLib;
import '../../models/event.dart';

/// Syncs the calendar between
Future<void> syncCalendars(User currentUser) async {
  List<MMYCalendar> calendars = [];
  final db = FirestoreDB(uid: currentUser.uid);
  final events = await eventLib.getUserEvents(currentUser);

  for(Event event in events) {
    final status = event.invitedContacts[currentUser.uid];

  }
  //print("SYNC CALENDAR");

  await generateMMYCalendar(events, currentUser.uid);

  // get all device Calendars
  //List<MMYCalendar> deviceCalendars = await getDeviceCalendars(currentUser.uid);



  // generate the MMY calendars

  // store the calendars in the backend
  /*for(int i = 0; i < deviceCalendars.length; i++) {
    print(deviceCalendars[i].name);
    print(deviceCalendars[i].events);
    db.setCalendar(deviceCalendars[i]);
  }*/


  //print("SYNC CALENDAR - DONE");

  // write/update the MMY calenders to device

}