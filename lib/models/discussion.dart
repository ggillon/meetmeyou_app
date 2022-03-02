import 'package:meetmeyou_app/models/discussion_message.dart';

import 'constants.dart';

const EVENT_DISCUSSION = "Event discussion";
const USER_DISCUSSION = "Chat discussion";

const MESSAGES_READ = "Messages read";
const MESSAGES_UNREAD = "Messages unread";
const MESSAGES_IGNORE = "Messages ignore";

class Discussion {
  Discussion(
      {
        required this.did,
        required this.type,
        required this.adminUid,
        required this.adminDisplayName,
        required this.title,
        required this.photoURL,
        required this.participants,
        required this.timeStamp,
        this.params = EMPTY_MAP,
        this.messages,
        this.unread = false,
      });

  String did;
  String type;
  String adminUid;
  String adminDisplayName;
  String title;
  String photoURL;
  Map<String, dynamic> participants;
  DateTime timeStamp;
  Map params;
  Stream<List<DiscussionMessage>>? messages;
  bool unread;

  factory Discussion.fromMap(Map<String, dynamic> data) {
    return Discussion(
      did: data['did'],
      type: data['type'],
      adminUid: data['adminUid'],
      adminDisplayName: data['adminDisplayName'],
      title: data['title'],
      photoURL: data['photoURL'],
      participants: data['participants'],
      timeStamp: DateTime.fromMillisecondsSinceEpoch(data['timeStamp']),
      params: data['params'],
      // messages is stored
      // unread is a ui flag
    );
  }

  Discussion getFromMap(Map<String, dynamic> data) {
    return Discussion(
      did: data['did'],
      type: data['type'],
      adminUid: data['adminUid'],
      adminDisplayName: data['adminDisplayName'],
      title: data['title'],
      photoURL: data['photoURL'],
      participants: data['participants'],
      timeStamp: DateTime.fromMillisecondsSinceEpoch(data['timeStamp']),
      params: data['params'],
      // messages is stored
      // unread is a ui flag
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'did': did,
      'type': type,
      'adminUid': adminUid,
      'adminDisplayName': adminDisplayName,
      'title': title,
      'photoURL': photoURL,
      'participants': participants,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'params': params,
      // messages - stored
      // unread is a ui flag
    };
  }



}