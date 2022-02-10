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
      final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 90, maxHeight: 720);
      image = File(pickedFile!.path);
      notifyListeners();
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90, maxHeight: 720);
      image = File(pickedFile!.path);
      notifyListeners();
    }
  }

  Future createNewGroupContact(BuildContext context, String groupName,
      {String? groupImg, String? about, File? photoFile}) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!
        .newGroupContact(groupName, about: about ?? "")
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      groupDetail.groupCid = value.cid;
      groupCreated = true;
      update = true;
     await updateGroupContact(context, value.cid,
          groupName: groupName, about: about, photoFile: image, back: false);
       image = null;
      DialogHelper.showMessage(context, "Group created successfully");
    }
    //groupDetail.groupPhotoUrl = value.photoURL;
  }

  Future updateGroupContact(BuildContext context, String groupCid,
      {String? groupName,
      String? groupImg,
      String? about,
      File? photoFile, bool back = true,}) async {
    if(back){
      setState(ViewState.Busy);
    }
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!
        .updateGroupContact(groupCid,
            displayName: groupName,
            about: about ?? "",
            photoFile: back ? image : photoFile,
            photoURL: groupDetail.groupPhotoUrl)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      setState(ViewState.Idle);
      groupDetail.groupName = value.displayName;
      groupDetail.about = value.about;
      groupDetail.groupPhotoUrl = value.photoURL;
      groupDetail.membersLength = value.group.length.toString();
      back ? Navigator.of(context).pop() : Container();
    }
  }

  //Future<void> deleteContact(String cid);
  bool groupDelete = false;

  updateGroup(bool val){
    groupDelete = val;
    notifyListeners();
  }

  Future deleteGroup(BuildContext context) async{
    Navigator.of(context).pop();
    updateGroup(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    mmyEngine!.deleteContact(groupDetail.groupCid.toString()).catchError((e) {
      updateGroup(false);
      DialogHelper.showMessage(context, e.message);
    });

    Navigator.of(context).pop(true);
    updateGroup(false);
  }
}
