class CalendarEvent{
  CalendarEvent(
      {required this.title,
        required this.start,
        required this.end,
        required this.meetMeYou,
        this.eid,
        required this.location,
        this.eventStatus,
        required this.description
      });
  String title;
  DateTime start;
  DateTime end;
  bool meetMeYou;
  String? eid;
  String? eventStatus;
  String location;
  List<CalendarAttendee> attendees = [];
  String description;

  addAttendee(String name, String email, bool isOrganiser) {
    attendees.add(CalendarAttendee(name: name, email: email, isOrganiser: isOrganiser));
  }
}

class CalendarAttendee{
  CalendarAttendee(
      {required this.name,
        required this.email,
        required this.isOrganiser,
  });
  String name;
  String email;
  bool isOrganiser;
}