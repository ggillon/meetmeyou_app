import 'package:meetmeyou_app/models/photo.dart';

import 'constants.dart';

class MMYPhotoAlbum {
  MMYPhotoAlbum(
      {
        required this.aid,
        required this.adminId,
        required this.title,
        required this.description,
        required this.timeStamp,
        this.other = EMPTY_MAP,
      });

  String aid;
  String adminId;
  String title;
  String description;
  DateTime timeStamp;
  List<MMYPhoto> photos=[];
  Map other;

  factory MMYPhotoAlbum.fromMap(Map<String, dynamic> data) {
    final int timeMillisec = data['timeStamp'];

    return MMYPhotoAlbum(
      aid: data['aid'],
      adminId: data['adminId'],
      title: data['title'],
      description: data['description'],
      timeStamp: DateTime.fromMillisecondsSinceEpoch(timeMillisec),
      other: data['other'],
    );
  }

  MMYPhotoAlbum getFromMap(Map<String, dynamic> data) {
    final int timeMillisec = data['timeStamp'];

    return MMYPhotoAlbum(
      aid: data['aid'],
      adminId: data['adminId'],
      title: data['title'],
      description: data['description'],
      timeStamp: DateTime.fromMillisecondsSinceEpoch(timeMillisec),
      other: data['other'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'aid': aid,
      'adminId': adminId,
      'title': title,
      'description': description,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'other': other,
    };
  }

}