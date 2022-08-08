import 'dart:io';

import 'package:device_calendar/device_calendar.dart' as device;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/models/calendar_event.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/mmy_calendar.dart';
import 'package:meetmeyou_app/services/database/database.dart';
import 'package:timezone/timezone.dart';

Future<bool> checkCalendar() async {
  bool result=false;
  device.DeviceCalendarPlugin plugin = device.DeviceCalendarPlugin();
  final calendarsResult = await plugin.retrieveCalendars();
  calendarsResult.data!.forEach((element) {
    if (element.name == "MeetMeYou") {
      result = true;
    }
  });
  return result;
}

Future<String?> createCalendar() async {
  device.DeviceCalendarPlugin plugin = device.DeviceCalendarPlugin();
  if(!(await checkCalendar())) {
    final result = await plugin.createCalendar('MeetMeYou');
    if (!result.isSuccess) {
      throw('Error in creating calendar');
    } else {
      return result.data!;
    }
  } else {
    return getCaldendarID();
  }
}

Future<String?> getCaldendarID() async {
  String result='';
  device.DeviceCalendarPlugin plugin = device.DeviceCalendarPlugin();
  final calendarsResult = await plugin.retrieveCalendars();
  calendarsResult.data!.forEach((element) {
    if (element.name == "MeetMeYou") {
      result = element.id!;
    }
  });
  if (result != '') {
    return result;
  } else {
    return await createCalendar();
  }
}

void updateCalendarEvent(Event event) async {
  Location _location = TZDateTime.local(2000).location;
  String? deviceCalID = await getCaldendarID();
  if(deviceCalID == null) return null;
  device.Event deviceEvent = device.Event(deviceCalID);

  deviceEvent.eventId = event.eid;
  deviceEvent.title = event.title;
  deviceEvent.start = TZDateTime.fromMillisecondsSinceEpoch(_location, event.start.millisecondsSinceEpoch);
  deviceEvent.end = TZDateTime.fromMillisecondsSinceEpoch(_location, event.end.millisecondsSinceEpoch);
  deviceEvent.location = event.location;
  deviceEvent.description = event.description;

  device.DeviceCalendarPlugin plugin = device.DeviceCalendarPlugin();
  final result = await plugin.createOrUpdateEvent(deviceEvent);
}

Future<void> storeCalendar(BuildContext context, String uid, Database db) async {
  final entries = await getCalendarEvents(context, uid);
  MMYCalendar serverCalendar = MMYCalendar(uid: uid, name: uid, timeStamp: DateTime.now());
  for(CalendarEvent entry in entries) {
    serverCalendar.addEvent(entry.title, entry.start, entry.end);
  }
  await db.setCalendar(serverCalendar);
}


// Future<List<CalendarEvent>> getCalendarEvents1(String uid, {bool display=true}) async {
//   List<CalendarEvent> returnList = [];
//   device.DeviceCalendarPlugin plugin = device.DeviceCalendarPlugin();
//   final calendarsResult = await plugin.retrieveCalendars();
//   if(display==null) display=true;
//   if(calendarsResult.isSuccess && calendarsResult.data != null && display) {
//     final calendars = calendarsResult.data!.toList();
//     for(device.Calendar cal in calendars) {
//       device.RetrieveEventsParams retrieveEventsParams = device.RetrieveEventsParams(startDate: DateTime.now(), endDate: (DateTime.now().add(Duration(days: 365))));
//       final result = await plugin.retrieveEvents(cal.id, retrieveEventsParams);
//       if (result.isSuccess && result.data != null) {
//         final events = result.data!.toList();
//         for(device.Event e in events){
//           CalendarEvent entry = CalendarEvent(
//             title: e.title ?? 'Untitled Event',
//             start: DateTime.fromMillisecondsSinceEpoch(e.start!.millisecondsSinceEpoch),
//             end: DateTime.fromMillisecondsSinceEpoch(e.end!.millisecondsSinceEpoch),
//             meetMeYou: (cal!.name == 'MeetMeYou'),
//             description: e.description ?? '',
//           );
//           returnList.add(entry);
//         }
//       }
//     }
//   }
//   // Code for MeetMeYou Events (to be adapted)
//   List<Event> events = await FirestoreDB(uid: uid).getUserEvents(uid);
//   for (Event e in events) {
//     CalendarEvent entry = CalendarEvent(
//         title: e.title,
//         start: e.start,
//         end: e.end,
//         meetMeYou: true,
//         eid: e.eid,
//         eventStatus: e.invitedContacts[uid],
//         description: e.description);
//     returnList.add(entry);
//   }
//   return returnList;
// }

Future<List<CalendarEvent>> getCalendarEvents(BuildContext context,String uid, {bool display = true}) async {
  List<CalendarEvent> returnList = [];
  var calendarsResult;
  device.DeviceCalendarPlugin plugin = device.DeviceCalendarPlugin();
  calendarsResult = await plugin.retrieveCalendars();
  var permissionsGranted;
  if (Platform.isIOS) {
    permissionsGranted = await plugin.hasPermissions();
    if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
      permissionsGranted = await plugin.requestPermissions();
      calendarsResult = await plugin.retrieveCalendars();
      if (!permissionsGranted.isSuccess || !permissionsGranted.loading!) {
        CommonWidgets.errorDialog(context, "enable_calendar_permission".tr());
      }
    }
  }
  if((calendarsResult.isSuccess || permissionsGranted.isSuccess) && (calendarsResult.data != null) && display) {
    // final calendarsResult = await plugin.retrieveCalendars();
//  if(calendarsResult.isSuccess && calendarsResult.data != null && display) {
    final calendars = calendarsResult.data!.toList();
    for(device.Calendar cal in calendars) {
      device.RetrieveEventsParams retrieveEventsParams = device.RetrieveEventsParams(startDate: DateTime.now(), endDate: (DateTime.now().add(Duration(days: 365))));
      final result = await plugin.retrieveEvents(cal.id, retrieveEventsParams);
      if (result.isSuccess && result.data != null) {
        final events = result.data!.toList();
        for(device.Event e in events){
          CalendarEvent entry = CalendarEvent(
            title: e.title ?? 'Untitled Event',
            start: DateTime.fromMillisecondsSinceEpoch(e.start!.millisecondsSinceEpoch),
            end: DateTime.fromMillisecondsSinceEpoch(e.end!.millisecondsSinceEpoch),
            meetMeYou: (cal.name == 'MeetMeYou'),
            description: e.description ?? '',
          );
          returnList.add(entry);
        }
      }
    }
  }
  // Code for MeetMeYou Events (to be adapted)
  List<Event> events = await FirestoreDB(uid: uid).getUserEvents(uid);
  for (Event e in events) {
    CalendarEvent entry = CalendarEvent(
        title: e.title,
        start: e.start,
        end: e.end,
        meetMeYou: true,
        eid: e.eid,
        eventStatus: e.invitedContacts[uid],
        description: e.description);
    returnList.add(entry);
  }
  return returnList;
}
