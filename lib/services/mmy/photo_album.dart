import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/photo.dart';
import 'package:meetmeyou_app/models/photo_album.dart';
import 'package:meetmeyou_app/services/mmy/idgen.dart';
import '../../models/event.dart';

import '../database/database.dart';


Future<MMYPhotoAlbum> createEventAlbum(User currentUser, String eid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  Event event = await db.getEvent(eid);
  MMYPhotoAlbum album = MMYPhotoAlbum(aid: idGenerator(), adminId: event.organiserID, title: event.title, description: event.description, timeStamp: DateTime.now());
  return album;
}

Future<MMYPhotoAlbum> getAlbum(User currentUser, String aid) async {
  final db = FirestoreDB(uid: currentUser.uid);
  return db.getPhotoAlbum(aid);
}

Future<void> postPhoto(User currentUser, String aid, String photoURL) async {
  final db = FirestoreDB(uid: currentUser.uid);
  MMYPhoto photo = MMYPhoto(pid: idGenerator(), aid: aid, ownerId: currentUser.uid, title: '', description: '', photoURL: photoURL, timeStamp: DateTime.now());
  await db.setPhoto(photo);
}

Future<void> deletePhoto(User currentUser, String aid, String pid) async {
  FirestoreDB(uid: currentUser.uid).deletePhoto(aid, pid);
}
