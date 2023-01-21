import 'package:firebase_auth/firebase_auth.dart';

import '../../models/mmy_calendar.dart';
import '../calendar/calendar.dart';
import '../database/database.dart';
import 'event.dart' as eventLib;
import '../../models/event.dart';

bool calendar_access = false;

/// Syncs the calendar between
Future<void> syncCalendars(User currentUser) async {

  final events = await eventLib.getUserEvents(currentUser);

  if(calendar_access == false) {
    //print("SYNC CALENDAR");
    calendar_access = true;
    try {
      await generateMMYCalendar(events, currentUser.uid);
      calendar_access = false;
    } catch(e) {calendar_access = false;}
  }
}