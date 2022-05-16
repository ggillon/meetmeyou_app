import 'constants.dart';

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
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'other': other,
    };
  }

}