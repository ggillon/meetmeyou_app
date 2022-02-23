import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/discussion.dart';
import 'package:meetmeyou_app/models/discussion_detail.dart';
import 'package:meetmeyou_app/models/discussion_message.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:permission_handler/permission_handler.dart';

class NewEventDiscussionProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  List<DiscussionMessage> eventDiscussionList = [];
  Discussion? eventDiscussion;
  EventDetail eventDetail = locator<EventDetail>();
  DiscussionDetail discussionDetail = locator<DiscussionDetail>();
  ScrollController scrollController = ScrollController();
  bool? isRightSwipe;
  File? image;
  Timer? clockTimer;
  bool isJump = true;
  String replyMessage = "";
  String userName = "";

  bool swipe = false;

  updateSwipe(bool val) {
    swipe = val;
    notifyListeners();
  }

  @override
  void dispose() {
    clockTimer!.cancel();
    super.dispose();
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

  bool value = true;

  updateValue(bool val) {
    value = val;
    notifyListeners();
  }

  Future getEventDiscussion(BuildContext context, bool load, {bool jump = true}) async {
    load == true ? setState(ViewState.Busy) : updateValue(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =
        await mmyEngine!.getEventDiscussion(eventDetail.eid!).catchError((e) {
      load == true ? setState(ViewState.Idle) : updateValue(false);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    if (value != null) {
      eventDiscussionList = value.messages;
      eventDiscussion = value;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          jump == true ?
          scrollController.jumpTo(scrollController.position.maxScrollExtent)
              : scrollListener();
        }
      });
      load == true ? setState(ViewState.Idle) : updateValue(false);
    }
  }

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent){
      isJump = true;
    }
    isJump ? scrollController
        .jumpTo(scrollController.position.maxScrollExtent) : Container();
  }

  bool postMessage = false;

  updatePostMessage(bool val) {
    postMessage = val;
    notifyListeners();
  }

  Future postDiscussionMessage(BuildContext context, String type, String text,
      TextEditingController controller, bool fromContactOrGroup,
      {File? photoFile, String? replyMid}) async {
    updatePostMessage(true);

    await mmyEngine!.postDiscussionMessage(fromContactOrGroup == true ? discussion!.did : eventDetail.eid!, type: type, text: text, photoFile: photoFile, replyMid: replyMid)
        .catchError((e) {
      updatePostMessage(false);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    controller.clear();
    isRightSwipe = false;
    replyMessage = "";
    fromContactOrGroup == true ? await getDiscussion(context) : await getEventDiscussion(context, false);
    updatePostMessage(false);
  }

// Leave a discussion

  bool leave = false;

  updateLeave(bool val) {
    leave = val;
    notifyListeners();
  }

  Future leaveDiscussion(BuildContext context) async {
    updateLeave(true);

    await mmyEngine!.leaveDiscussion(eventDetail.eid!).catchError((e) {
      updateLeave(false);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    updateLeave(false);
  }

  // chat in contact and group.
// start discussion bw contact and group
  Discussion? discussion;

  bool startDiscussion = false;

  updateStartDiscussion(bool val) {
    startDiscussion = val;
    notifyListeners();
  }

  Future startContactDiscussion(BuildContext context) async {
    updateStartDiscussion(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.startContactDiscussion(discussionDetail.userId.toString()).catchError((e) {
      updateStartDiscussion(false);
      DialogHelper.showMessage(context, e.message);
    });


    if (value != null) {
      discussion = value;
      await getDiscussion(context);
      updateStartDiscussion(false);
    }
  }

  // Retreive an discussion you're part of

  bool retrieveDiscussion = false;

  updateRetrieveDiscussion(bool val){
    retrieveDiscussion = true;
    notifyListeners();
  }

  Future getDiscussion(BuildContext context) async{
    updateRetrieveDiscussion(true);

    var value = await mmyEngine!.getDiscussion(discussion!.did).catchError((e) {
      updateRetrieveDiscussion(false);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      eventDiscussionList = value.messages;
      eventDiscussion = value;
      updateRetrieveDiscussion(false);
    }
  }
}
