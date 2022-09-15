import 'constants.dart';

const PHOTO_TYPE_PHOTO = "Photo";
const PHOTO_TYPE_VIDEO = "Video";

class MMYPhoto {
  MMYPhoto(
      {
        required this.pid,
        required this.aid,
        required this.ownerId,
        required this.title,
        required this.description,
        this.folder = '',
        required this.photoURL,
        required this.timeStamp,
        this.type = PHOTO_TYPE_PHOTO,
        this.other = EMPTY_MAP,
      });

  String pid;
  String aid;
  String ownerId;
  String title;
  String description;
  String folder;
  String photoURL;
  DateTime timeStamp;
  String type;
  Map other;

  factory MMYPhoto.fromMap(Map<String, dynamic> data) {
    final int timeMillisec = data['timeStamp'];

    return MMYPhoto(
      pid: data['pid'],
      aid: data['aid'],
      ownerId: data['ownerId'],
      title: data['title'],
      description: data['description'],
      folder: data['folder'],
      photoURL: data['photoURL'],
      type: data['type'],
      timeStamp: DateTime.fromMillisecondsSinceEpoch(timeMillisec),
      other: data['other'],
    );
  }

  MMYPhoto getFromMap(Map<String, dynamic> data) {
    final int timeMillisec = data['timeStamp'];

    return MMYPhoto(
      pid: data['pid'],
      aid: data['aid'],
      ownerId: data['ownerId'],
      title: data['title'],
      description: data['description'],
      folder: data['folder'],
      photoURL: data['photoURL'],
      type: data['type'],
      timeStamp: DateTime.fromMillisecondsSinceEpoch(timeMillisec),
      other: data['other'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pid': pid,
      'aid': aid,
      'ownerId': ownerId,
      'title': title,
      'description': description,
      'folder': folder,
      'photoURL': photoURL,
      'type': type,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'other': other,
    };
  }

}