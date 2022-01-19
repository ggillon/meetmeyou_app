import 'constants.dart';
import 'event.dart';

class DateOption {
  DateOption({required this.eid, required this.did, required this.start, required this.end, required this.description, this.location='', this.geoLocation=EMPTY_MAP, this.invitedContacts=EMPTY_MAP});
  String eid;
  String did;
  DateTime start;
  DateTime end;
  String description;
  String location;
  Map geoLocation;
  Map invitedContacts;

  double get durationInHours => end.difference(start).inMinutes.toDouble()/60;


  factory DateOption.fromMap(Map<String, dynamic> data) {

    final int startMillisec = data['start'];
    final int endMillisec = data['end'];

    final String eid= data['eid'];
    final String did= data['did'];
    final DateTime start = DateTime.fromMillisecondsSinceEpoch(startMillisec);
    final DateTime end = DateTime.fromMillisecondsSinceEpoch(endMillisec);
    final String location = data['location'] ?? '';
    final Map geoLocation = data['geoLocation'] ?? EMPTY_MAP;
    final String description = data['description'] ?? '';
    final Map invitedContacts = data['invitedContacts'] ?? EMPTY_MAP;

    return DateOption(eid: eid, did: did,  start: start, end: end, location: location, geoLocation: geoLocation, description: description, invitedContacts: invitedContacts,);
  }

  DateOption getFromMap(Map<String, dynamic> data) {

    final int startMillisec = data['start'];
    final int endMillisec = data['end'];

    final String eid= data['eid'];
    final String did= data['did'];
    final DateTime start = DateTime.fromMillisecondsSinceEpoch(startMillisec);
    final DateTime end = DateTime.fromMillisecondsSinceEpoch(endMillisec);
    final String location = data['location'] ?? '';
    final Map geoLocation = data['geoLocation'] ?? EMPTY_MAP;
    final String description = data['description'] ?? '';
    final Map invitedContacts = data['invitedContacts'] ?? EMPTY_MAP;

    return DateOption(eid: eid, did: did,  start: start, end: end, location: location, geoLocation: geoLocation, description: description, invitedContacts: invitedContacts,);
  }

  Map<String, dynamic> toMap() {
    return {
      'eid': eid,
      'did': did,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'location': location,
      'geoLocation': geoLocation,
      'description': description,
      'invitedContacts': invitedContacts,
    };
  }
}