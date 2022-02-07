import 'package:meetmeyou_app/models/calendar_event.dart';

class CalendarDetail{
  bool? calendarSync;
  bool? calendarDisplay;
  List<CalendarEvent>? calendarEventList = [];
  bool? fromCalendarPage = true;
  bool fromDeepLink = false;

  CalendarDetail({this.calendarSync, this.calendarDisplay, this.calendarEventList, this.fromCalendarPage});
}