import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/group_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateEditGroupProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  GroupDetail groupDetail = locator<GroupDetail>();
  String? imageUrl;
  File? image;

  bool groupCreated = false;
  bool update = false;

  // String? groupCid;

  Future<bool> permissionCheck() async {
    var status = await Permission.storage.status;
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      if (release.contains(".")) {
        release = release.substring(0, 1);
      }
      if (int.parse(release) > 10) {
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

  Future createNewGroupContact(BuildContext context, String groupName,
      {String? groupImg, String? about}) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!
        .newGroupContact(groupName,
            photoURL: groupImg ??
                "https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media",
            about: about ?? "")
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    print("value is ${value}");
    groupDetail.groupCid = value.cid;
    // groupCid = value.cid;

    setState(ViewState.Idle);
    groupCreated = true;
    update = true;
    //enable = false;
    // Navigator.of(context).pop();
    DialogHelper.showMessage(context, "Group created successfully");
  }

  Future updateGroupContact(BuildContext context, String groupCid,
      {String? groupName, String? groupImg, String? about}) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!
        .updateGroupContact(groupCid,
            displayName: groupName,
            // photoURL: groupImg ??
            //     "https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media",
            about: about ?? "")
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      setState(ViewState.Idle);

      groupDetail.groupName = value.displayName;
      groupDetail.about = value.about;
      groupDetail.membersLength = value.group.length.toString();

      Navigator.of(context).pop();
    }
  }

  // Future updateGroupImage(BuildContext context, String groupName,
  //     {String? groupImg, String? about}) async {
  //   setState(ViewState.Busy);
  //   if (image != null) {
  //     await mmyEngine!.updateGroupPicture(image!).catchError((e) {
  //       setState(ViewState.Idle);
  //       DialogHelper.showMessage(context, e.message);
  //     });
  //
  //     createNewGroupContact(context, groupName, about: about);
  //   } else {
  //     createNewGroupContact(context, groupName, about: about);
  //   }
  // }
}
