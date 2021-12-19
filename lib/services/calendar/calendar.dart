import 'package:device_calendar/device_calendar.dart' as device;
import 'package:meetmeyou_app/models/calendar_event.dart';

Future<List<CalendarEvent>> getCalendarEvents() async {
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
  return returnList;
}