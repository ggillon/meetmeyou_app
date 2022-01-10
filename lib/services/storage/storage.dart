import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image/image.dart' as imageLib;
import 'package:meetmeyou_app/constants/string_constants.dart';

Future<String> storeFile(File file, {required String path}) async {
  await FirebaseStorage.instance.ref(path).putFile(file);
  return FirebaseStorage.instance.ref(path).getDownloadURL();
}

Future<String> storeProfilePicture(File file, {required String uid}) async {
  final path = 'profile_pictures/${uid}.png';
  // imageLib.Image image = imageLib.decodeImage(file.readAsBytesSync())!;
  // imageLib.Image profilePicture = imageLib.copyResize(image, height: 720);
  // final profileFile = File(await getFilePath(uid));
  // File profilePic=await profileFile.writeAsBytes(imageLib.encodePng(profilePicture));
  // File profilePic = await File('${uid}.png').writeAsBytes(imageLib.encodePng(profilePicture));
  await FirebaseStorage.instance.ref(path).putFile(file);
  return FirebaseStorage.instance.ref(path).getDownloadURL();
}

Future<String> storeEventPicture(File file, {required String eid}) async {
  final path = 'event_pictures/${eid}.png';
  // imageLib.Image image = imageLib.decodeImage(file.readAsBytesSync())!;
  // imageLib.Image eventPicture = imageLib.copyResize(image, height: 1440);
  // final profileFile = File(await getFilePath(eid));
  // var profilePic = profileFile..writeAsBytesSync(imageLib.encodePng(eventPicture));
  // File profilePic = await File('${eid}.png').writeAsBytes(imageLib.encodePng(eventPicture));
  await FirebaseStorage.instance.ref(path).putFile(file);
  return FirebaseStorage.instance.ref(path).getDownloadURL();
}

Future<String> storeGroupPicture(File file, {required String eid}) async {
  final path = 'group_pictures/${eid}.png';
  imageLib.Image image = imageLib.decodeImage(file.readAsBytesSync())!;
  imageLib.Image groupPicture = imageLib.copyResize(image, height: 720);
  final profileFile = File(await getFilePath(eid));
  File profilePic =
  await profileFile.writeAsBytes(imageLib.encodePng(groupPicture));
//  File profilePic = await File('${eid}.png').writeAsBytes(imageLib.encodePng(groupPicture));
  await FirebaseStorage.instance.ref(path).putFile(profilePic);
  return FirebaseStorage.instance.ref(path).getDownloadURL();
}

Future<String> getFilePath(String uid)async {
  final folderName = StringConstants.appName.toLowerCase();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  //final directory = Directory("storage/emulated/0/$folderName");
  final directory = Directory("${appDocDir.path}/$folderName");
  if ((await directory.exists())) {
  } else {
    directory.create();
  }
  String filePath = '${directory.path}/${uid}.png';
  return filePath;
}