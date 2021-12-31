class CalendarEvent{
  CalendarEvent({required this.title, required this.start, required this.end, required this.meetMeYou, this.eid, this.eventStatus, required this.description});
  String title;
  DateTime start;
  DateTime end;
  bool meetMeYou;
  String? eid;
  String? eventStatus;
  String description;
}