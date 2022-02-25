import 'constants.dart';

const NOTIFICATION_TEXT = "Text notification";
const NOTIFICATION_PHOTO = "Photo notification";

class MMYNotification {
  MMYNotification(
      {
        required this.nid,
        required this.type,
        required this.uid,
        required this.title,
        required this.text,
        required this.photoURL,
        required this.tokens,
        this.other = EMPTY_MAP,
      });

  String nid;
  String type;
  String uid;
  String title;
  String text;
  String photoURL;
  List<String> tokens;
  Map other;

  factory MMYNotification.fromMap(Map<String, dynamic> data) {
    return MMYNotification(
      nid: data['nid'],
      uid: data['uid'],
      type: data['type'],
      title: data['title'],
      text: data['text'],
      photoURL: data['photoURL'],
      tokens: data['tokens'],
      other: data['other'],
    );
  }

  MMYNotification getFromMap(Map<String, dynamic> data) {
    return MMYNotification(
      nid: data['nid'],
      uid: data['uid'],
      type: data['type'],
      title: data['title'],
      text: data['text'],
      photoURL: data['photoURL'],
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
      'tokens': tokens,
      'other': other,
    };
  }

}