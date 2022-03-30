import 'constants.dart';

const NOTIFICATION_TEXT = "Text notification";
const NOTIFICATION_PHOTO = "Photo notification";
const NOTIFICATION_EVENT_INVITE = "Event invitation";
const NOTIFICATION_EVENT_UPDATE = "Updated event";
const NOTIFICATION_EVENT_CANCEL = "Canceled event";
const NOTIFICATION_USER_INVITE = "User invitation";
const NOTIFICATION_MESSAGE_NEW = "New message";

class MMYNotification {
  MMYNotification(
      {
        required this.nid,
        required this.type,
        required this.uid,
        required this.title,
        required this.text,
        required this.photoURL,
        required this.id,
        required this.tokens,
        required this.timeStamp,
        this.other = EMPTY_MAP,
      });

  String nid;
  String type;
  String uid;
  String title;
  String text;
  String photoURL;
  String id;
  DateTime timeStamp;
  List<String> tokens;
  Map other;

  factory MMYNotification.fromMap(Map<String, dynamic> data) {
    final int timeMillisec = data['timeStamp'];

    return MMYNotification(
      nid: data['nid'],
      uid: data['uid'],
      type: data['type'],
      title: data['title'],
      text: data['text'],
      photoURL: data['photoURL'],
      id: data['id'],
      timeStamp: DateTime.fromMillisecondsSinceEpoch(timeMillisec),
      tokens: data['tokens'],
      other: data['other'],
    );
  }

  MMYNotification getFromMap(Map<String, dynamic> data) {
    final int timeMillisec = data['timeStamp'];

    return MMYNotification(
      nid: data['nid'],
      uid: data['uid'],
      type: data['type'],
      title: data['title'],
      text: data['text'],
      photoURL: data['photoURL'],
      id: data['id'],
      timeStamp: DateTime.fromMillisecondsSinceEpoch(timeMillisec),
      tokens: data['tokens'],
      other: data['other'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nid': nid,
      'uid': uid,
      'type': type,
      'title': title,
      'text': text,
      'photoURL': photoURL,
      'id': id,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'tokens': tokens,
      'other': other,
    };
  }

}