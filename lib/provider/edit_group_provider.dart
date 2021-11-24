import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EditGroupProvider extends BaseProvider {
  String? imageUrl;
  File? image;

  Future<bool> permissionCheck() async {
    var status = await Permission.storage.status;
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      if (release.contains(".")) {
        release = release.substring(0, 1);
      } else if (int.parse(release) > 10) {
        status = await Permission.manageExternalStorage.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      Permission.storage.request();
      return false;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  Future getImage(BuildContext context, int type) async {
    final picker = ImagePicker();
    // type : 1 for camera in and 2 for gallery
    Navigator.of(context).pop();
    if (type == 1) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      image = File(pickedFile!.path);
      notifyListeners();
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      image = File(pickedFile!.path);
      notifyListeners();
    }
  }
}
