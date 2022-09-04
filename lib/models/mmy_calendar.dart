

const MMY_CALENDAR_PERMISSION_FULL = "Full";
const MMY_CALENDAR_PERMISSION_PARTIAL = "Partial";
const MMY_CALENDAR_PERMISSION_NONE = "None";

class MMYCalendar {
  String uid;
  String calID;
  String name;
  DateTime timeStamp;

  List<Map<String, dynamic>> events;
  Map<String, String> permissions;
  Map<String, dynamic> params;

  MMYCalendar({required this.uid, required this.calID, required this.name, required this.timeStamp,
    this.events = const[], this.permissions = const <String, String>{}, this.params = const <String, dynamic>{} });

  factory MMYCalendar.fromMap(Map<String, dynamic> data) {
    return MMYCalendar(
        uid: data['uid'],
        calID: data['calID'],
        name: data['name'],
        timeStamp: DateTime.now(),
        events: data['events'],
        permissions: data['permissions'],
        params: data['params'],
    );
  }

  MMYCalendar getFromMap(Map<String, dynamic> data) {
    return MMYCalendar(
      uid: data['uid'],
      calID: data['calID'],
      name: data['name'],
      timeStamp: DateTime.now(),
      events: data['events'],
      permissions: data['permissions'],
      params: data['params'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'calID': calID,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'events': events,
      'permissions': permissions,
      'params': params,
    };
  }
  
  void addEvent(String title, DateTime start, DateTime end) {events.add({'title': title, 'start': start, 'end': end});}
  void setParam(String name, dynamic value) {params.addAll({name: value});}
  void setAccess(String uid, {String access=MMY_CALENDAR_PERMISSION_FULL}) {permissions.addAll({uid:access});}
}