import 'constants.dart';

//Event Types
const EVENT_TYPE_PRIVATE = 'Private Event';
const EVENT_TYPE_PRIVATE_MD = 'Private Event MultiDates';
const EVENT_TYPE_ANNOUNCEMENT = 'Announcement';
const EVENT_TYPE_SAVE_THE_DATE = 'Save the date';
const EVENT_TYPE_UPDATED = 'Updated event';
const EVENT_TYPE_PUBLIC = 'Public event';
const EVENT_TYPE_LOCATION = 'Public Location event';

// Reply type
const EVENT_INVITED = 'Invited';
const EVENT_ORGANISER = 'Organiser';
const EVENT_ATTENDING = 'Attending';
const EVENT_NOT_ATTENDING = 'Not Attending';
const EVENT_NOT_INTERESTED = 'Not Interested';
const EVENT_CANCELED = 'Canceled';
const EVENT_DELETED = 'Canceled';
const EVENT_REPLIED = 'Replied';

// Admin Type
const EVENT_ADMIN_ORGANISER = 'Organiser';

// Invites type
const EMAIL_DONE = 'Email Done';
const EMAIL_NEW_INVITE = 'Email New';
const EMAIL_UPDATE = 'Email Update';
const EMAIL_CANCEL = 'Email Cancel';
const NONE = 'None';

const DEFAULT_EVENT_PHOTO_URL = 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/MeetMeYou.jpg?alt=media&token=6a8fc7ac-1925-4bc3-b5d0-f422473363a1';

class Event {
  Event({required this.eid, required this.organiserID, required this.organiserName, required this.admins, this.eventType='Private Event', required this.timeStamp, required this.title, required this.start, required this.end, this.location='', this.geoLocation=EMPTY_MAP, this.multipleDates=false, this.description='', this.photoURL=DEFAULT_EVENT_PHOTO_URL, this.invitedContacts=EMPTY_MAP, this.status='', this.website='', this.formText='', this.form=EMPTY_MAP, this.params=EMPTY_MAP, this.invites=EMPTY_MAP});
  String eid;
  String title;
  String eventType;
  DateTime timeStamp;
  String organiserID;
  String organiserName;
  Map admins;
  DateTime start;
  DateTime end;
  String location;
  Map geoLocation;
  bool multipleDates;
  String description;
  String photoURL;
  Map invitedContacts;
  String status;
  String formText;
  Map form;
  Map params;
  Map invites;
  String website;

  double get durationInHours => end.difference(start).inMinutes.toDouble()/60;


  factory Event.fromMap(Map<String, dynamic> data) {

    final int timeStampMillisec = data['timeStamp'] ?? DateTime.now();
    final int startMillisec = data['start'] ?? timeStampMillisec;
    final int endMillisec = data['end'] ?? timeStampMillisec;

    final String eid= data['eid'];
    final String organiserID= data['organiserID'];
    final String organiserName= data['organiserName'] ?? data['organiserID'];
    final Map admins = data['admins'] ?? EMPTY_MAP;
    final String title = data['title'] ?? 'Untitled Event';
    final String eventType = data['eventType'] ?? PRIVATE_EVENT;
    final DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(timeStampMillisec);
    final DateTime start = DateTime.fromMillisecondsSinceEpoch(startMillisec);
    final DateTime end = DateTime.fromMillisecondsSinceEpoch(endMillisec);
    final bool multipleDates = data['multipleDates'] ?? false;
    final String location = data['location'] ?? '';
    final Map geoLocation = data['geoLocation'] ?? EMPTY_MAP;
    final String description = data['description'] ?? '';
    final String photoURL = data['photoURL'] ?? DEFAULT_EVENT_PHOTO_URL;
    final String status = data['status'] ?? '';
    final Map invitedContacts = data['invitedContacts'] ?? EMPTY_MAP;
    final String formText = data['formText'] ?? '';
    final Map form = data['form'] ?? EMPTY_MAP;
    final Map params = data['params'] ?? EMPTY_MAP;
    final Map invites = data['invites'] ?? EMPTY_MAP;
    final String website = data['website'] ?? '';

    return Event(eid: eid, organiserID: organiserID, organiserName: organiserName, admins: admins, eventType: eventType, timeStamp: timeStamp, title: title, start: start, end: end, multipleDates: multipleDates, location: location, geoLocation: geoLocation, description: description, photoURL: photoURL, status: status, invitedContacts: invitedContacts, formText: formText, form: form, params: params, invites: invites, website: website);
  }

  Event getFromMap(Map<String, dynamic> data) {

    final int timeStampMillisec = data['timeStamp'] ?? DateTime.now();
    final int startMillisec = data['start'] ?? timeStampMillisec;
    final int endMillisec = data['end'] ?? timeStampMillisec;

    final String eid= data['eid'];
    final String organiserID= data['organiserID'];
    final String organiserName= data['organiserName'] ?? data['organiserID'];
    final Map admins = data['admins'] ?? EMPTY_MAP;
    final String title = data['title'] ?? 'Untitled Event';
    final String eventType = data['eventType'] ?? PRIVATE_EVENT;
    final DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(timeStampMillisec);
    final DateTime start = DateTime.fromMillisecondsSinceEpoch(startMillisec);
    final DateTime end = DateTime.fromMillisecondsSinceEpoch(endMillisec);
    final bool multipleDates = data['multipleDates'] ?? false;
    final String location = data['location'] ?? '';
    final Map geoLocation = data['geoLocation'] ?? EMPTY_MAP;
    final String description = data['description'] ?? '';
    final String photoURL = data['photoURL'] ?? DEFAULT_EVENT_PHOTO_URL;
    final String status = data['status'] ?? '';
    final Map invitedContacts = data['invitedContacts'] ?? EMPTY_MAP;
    final String formText = data['formText'] ?? '';
    final Map form = data['form'] ?? EMPTY_MAP;
    final Map params = data['params'] ?? EMPTY_MAP;
    final String website = data['website'] ?? '';

    return Event(eid: eid, organiserID: organiserID, organiserName: organiserName, admins: admins, eventType: eventType, timeStamp: timeStamp, title: title, start: start, end: end, multipleDates: multipleDates, location: location, geoLocation: geoLocation, description: description, photoURL: photoURL, status: status, invitedContacts: invitedContacts, formText: formText, form: form, params: params, invites: invites, website: website);
  }

  Map<String, dynamic> toMap() {
    return {
      'eid': eid,
      'eventType': eventType,
      'organiserID': organiserID,
      'organiserName': organiserName,
      'admins': admins,
      'title': title,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'location': location,
      'geoLocation': geoLocation,
      'multipleDates': multipleDates,
      'description': description,
      'photoURL': photoURL,
      'status': status,
      'invitedContacts': invitedContacts,
      'formText': formText,
      'form': form,
      'params': params,
      'invites': invites,
      'website': website,
    };
  }
}


//OLD CONSTANTS
const PRIVATE_EVENT = 'Private Event';
const PRIVATE_EVENT_MD = 'Private Event MultiDates';
const ANNOUNCEMENT = 'Announcement';
const SAVE_THE_DATE = 'Save the date';
const UPDATED_EVENT = 'Updated event';

// Reply type
const INVITED = 'Invited';
const ORGANISER = 'Organiser';
const ATTENDING = 'Attending';
const NOT_ATTENDING = 'Not Attending';
const NOT_INTERESTED = 'Not Interested';
const CANCELED = 'Canceled';
const REPLIED = 'Replied';