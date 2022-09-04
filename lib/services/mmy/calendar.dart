

import 'package:firebase_auth/firebase_auth.dart';

import '../../models/mmy_calendar.dart';
import '../calendar/calendar.dart';
import '../database/database.dart';

/// Syncs the calendar between
void syncCalendars(User currentUser) async {
  List<MMYCalendar> calendars = [];
  final db = FirestoreDB(uid: currentUser.uid);

  // get all device Calendars
  List<MMYCalendar> deviceCalendars = await getDeviceCalendars(currentUser.uid);

  // generate the MMY calendars

  // store the calendars in the backend
  calendars.map((calendar) => db.setCalendar(calendar));

  // write/update the MMY calenders to device

}