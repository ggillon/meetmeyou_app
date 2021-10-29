import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image/image.dart' as imageLib;

Future<String> storeFile(File file, {required String path}) async {
  await FirebaseStorage.instance.ref(path).putFile(file);
  return FirebaseStorage.instance.ref(path).getDownloadURL();
}

Future<String> storeProfilePicture(File file, {required String uid}) async {
  final path = 'profile_pictures/${uid}.png';
  imageLib.Image image = imageLib.decodeImage(file.readAsBytesSync())!;
  imageLib.Image profilePicture = imageLib.copyResize(image, height: 720);
  File profilePic = await File('${uid}.png').writeAsBytes(imageLib.encodePng(profilePicture));
  await FirebaseStorage.instance.ref(path).putFile(profilePic);
  return FirebaseStorage.instance.ref(path).getDownloadURL();
}

Future<String> storeEventPicture(File file, {required String eid}) async {
  final path = 'event_pictures/${eid}.png';
  imageLib.Image image = imageLib.decodeImage(file.readAsBytesSync())!;
  imageLib.Image eventPicture = imageLib.copyResize(image, height: 1440);
  File profilePic = await File('${eid}.png').writeAsBytes(imageLib.encodePng(eventPicture));
  await FirebaseStorage.instance.ref(path).putFile(profilePic);
  return FirebaseStorage.instance.ref(path).getDownloadURL();
}