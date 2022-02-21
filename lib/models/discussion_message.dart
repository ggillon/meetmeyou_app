import 'constants.dart';

const TEXT_MESSAGE = "Text message";
const PHOTO_MESSAGE = "Photo message";
const FILE_MESSAGE = "Photo message";

class DiscussionMessage {
  DiscussionMessage(
      {
        required this.did,
        required this.mid,
        required this.type,
        required this.contactUid,
        required this.contactDisplayName,
        required this.contactPhotoURL,
        required this.text,
        required this.attachmentURL,
        this.isReply = false,
        this.level = 0,
        this.replyMid = '',
        required this.createdTimeStamp,
        required this.editedTimeStamp,
        this.params = EMPTY_MAP,
      });

  String did;
  String mid;
  String type;
  String contactUid;
  String contactDisplayName;
  String contactPhotoURL;
  String text;
  String attachmentURL;
  bool isReply;
  int level;
  String replyMid;
  DateTime createdTimeStamp;
  DateTime editedTimeStamp;
  Map params;

  factory DiscussionMessage.fromMap(Map<String, dynamic> data) {
    return DiscussionMessage(
      did: data['did'],
      mid: data['mid'],
      type: data['type'],
      contactUid: data['contactUid'],
      contactDisplayName: data['ccontactDisplayName'],
      contactPhotoURL: data['concontactPhotoURL'],
      text: data['text'],
      attachmentURL: data['aattachmentURL'],
      isReply: data['isReplay'],
      level: data['level'],
      replyMid: data['replyMid'],
      createdTimeStamp: DateTime.fromMillisecondsSinceEpoch(data['createdTimeStamp']),
      editedTimeStamp: DateTime.fromMillisecondsSinceEpoch(data['editedTimeStamp']),
      params: data['params'],
    );
  }

  DiscussionMessage getFromMap(Map<String, dynamic> data) {
    return DiscussionMessage(
      did: data['did'],
      mid: data['mid'],
      type: data['type'],
      contactUid: data['contactUid'],
      contactDisplayName: data['ccontactDisplayName'],
      contactPhotoURL: data['concontactPhotoURL'],
      text: data['text'],
      attachmentURL: data['aattachmentURL'],
      isReply: data['isReplay'],
      level: data['level'],
      replyMid: data['replyMid'],
      createdTimeStamp: DateTime.fromMillisecondsSinceEpoch(data['createdTimeStamp']),
      editedTimeStamp: DateTime.fromMillisecondsSinceEpoch(data['editedTimeStamp']),
      params: data['params'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'did': did,
      'mid': mid,
      'type': type,
      'contactUid': contactUid,
      'contactDisplayName': contactDisplayName,
      'contactPhotoURL': contactPhotoURL,
      'text': text,
      'atatchmentURL': attachmentURL,
      'isReply': isReply,
      'level': level,
      'replyMid': replyMid,
      'createdTimeStamp': createdTimeStamp.millisecondsSinceEpoch,
      'editTimeStamp': editedTimeStamp.millisecondsSinceEpoch,
      'params': params,
      // messages - stored
    };
  }

}