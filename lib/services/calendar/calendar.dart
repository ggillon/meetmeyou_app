import 'package:device_calendar/device_calendar.dart' as device;
import 'package:meetmeyou_app/models/calendar_event.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/services/database/database.dart';

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

void updateEvent(Event event) async {
  
}

Future<List<CalendarEvent>> getCalendarEvents(String uid) async {
  List<CalendarEvent> returnList = [];
  device.DeviceCalendarPlugin plugin = device.DeviceCalendarPlugin();
  final calendarsResult = await plugin.retrieveCalendars();
  if(calendarsResult.isSuccess && calendarsResult.data != null) {
    final calendars = calendarsResult.data!.toList();
    for(device.Calendar cal in calendars) {
      device.RetrieveEventsParams retrieveEventsParams = device.RetrieveEventsParams(startDate: DateTime.now(), endDate: (DateTime.now().add(Duration(days: 365))));
      final result = await plugin.retrieveEvents(cal.id, retrieveEventsParams);
      if (result.isSuccess && result.data != null) {
        final events = result.data!.toList();
        for(device.Event e in events){
          CalendarEvent entry = CalendarEvent(
            title: e.title ?? 'Untitled Event',
            start: DateTime.fromMicrosecondsSinceEpoch(e.start!.millisecondsSinceEpoch),
            end: DateTime.fromMillisecondsSinceEpoch(e.end!.millisecondsSinceEpoch),
            meetMeYou: (cal!.name == 'MeetMeYou'),
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