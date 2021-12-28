import 'package:meetmeyou_app/models/constants.dart';

class EventChatMessage {
  EventChatMessage(
      {required this.eid, required this.uid, required this.mid, required this.timeCreated, required this.timeEdited, required this.text, this.level = 0, this.replyMid = '', this.likes = EMPTY_MAP, this.attachments = EMPTY_MAP});

  String eid;
  String uid;
  String mid;
  DateTime timeCreated;
  DateTime timeEdited;
  String text;
  int level;
  String replyMid;
  Map likes;
  Map attachments;

  factory EventChatMessage.fromMap(Map<String, dynamic> data) {
    final int timeCreatedMillisec = data['timeCreated'];
    final int timeEditedMillisec = data['timeEdited'];

    final String eid = data['eid'];
    final String mid = data['mid'];
    final String uid = data['uid'];
    final DateTime timeCreated = DateTime.fromMillisecondsSinceEpoch(
        timeCreatedMillisec);
    final DateTime timeEdited = DateTime.fromMillisecondsSinceEpoch(
        timeEditedMillisec);
    final String text = data['text'];
    final int level = data['level'];
    final String replyMid = data['replyMid'];
    final Map likes = data['likes'];
    final Map attachments = data['attachments'];

    return EventChatMessage(eid: eid,
        mid: mid,
        uid: uid,
        timeCreated: timeCreated,
        timeEdited: timeEdited,
        text: text,
        level: level,
        replyMid: replyMid,
        likes: likes,
        attachments: attachments,
    );
  }

  EventChatMessage getFromMap(Map<String, dynamic> data) {
    final int timeCreatedMillisec = data['timeCreated'];
    final int timeEditedMillisec = data['timeEdited'];

    final String eid = data['eid'];
    final String mid = data['mid'];
    final String uid = data['uid'];
    final DateTime timeCreated = DateTime.fromMillisecondsSinceEpoch(
        timeCreatedMillisec);
    final DateTime timeEdited = DateTime.fromMillisecondsSinceEpoch(
        timeEditedMillisec);
    final String text = data['text'];
    final int level = data['level'];
    final String replyMid = data['replyMid'];
    final Map likes = data['likes'];
    final Map attachments = data['attachments'];

    return EventChatMessage(eid: eid,
        mid: mid,
        uid: uid,
        timeCreated: timeCreated,
        timeEdited: timeEdited,
        text: text,
        level: level,
        replyMid: replyMid,
        likes: likes,
        attachments: attachments,);
  }

  Map<String, dynamic> toMap() {
    return {
      'eid': eid,
      'mid': mid,
      'uid': uid,
      'timeCreated': timeCreated.millisecondsSinceEpoch,
      'timeEdited': timeEdited.millisecondsSinceEpoch,
      'text': text,
      'level': level,
      'replyMid': replyMid,
      'likes': likes,
      'attachments': attachments,
    };
  }
}