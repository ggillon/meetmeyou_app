import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/discussion.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:permission_handler/permission_handler.dart';

class NewEventDiscussionProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  List<Discussion> eventChatList = [];
  EventDetail eventDetail = locator<EventDetail>();
  bool? isRightSwipe;
  File? image;

  bool swipe = false;

  updateSwipe(bool val) {
    swipe = val;
    notifyListeners();
  }

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
      final pickedFile = await picker.pickImage(
          source: ImageSource.camera, imageQuality: 90, maxHeight: 720);
      image = File(pickedFile!.path);
      notifyListeners();
    } else {
      final pickedFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 90, maxHeight: 720);
      //  image = File(pickedFile!.path);
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
        return;
      }
      notifyListeners();
    }
  }

//  Future<void> postDiscussionMessage(String did, {String type=TEXT_MESSAGE, String? text, File? photoFile,});

  Future getEventDiscussion(BuildContext context, String eid) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine?.getEventDiscussion(eid).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    if (value != null) {
      eventChatList = value as List<Discussion>;
      setState(ViewState.Idle);
    }
  }

  bool postMessage = false;

  updatePostMessage(bool val) {
    postMessage = val;
    notifyListeners();
  }

  Future postDiscussionMessage(
      BuildContext context, String eid, String type, String text,
      {File? photoFile}) async {
    updatePostMessage(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine!
        .postDiscussionMessage(eventDetail.eid!,
            type: type, text: text, photoFile: photoFile)
        .catchError((e) {
      updatePostMessage(false);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    updatePostMessage(false);
  }
}
