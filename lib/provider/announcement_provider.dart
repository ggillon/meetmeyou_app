import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/common_used.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/announcement_detail.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/services/storage/storage.dart';
import 'package:meetmeyou_app/view/add_event/event_invite_friends_screen/eventInviteFriendsScreen.dart';

class AnnouncementProvider extends BaseProvider{

  MMYEngine? mmyEngine;
  AnnouncementDetail announcementDetail = locator<AnnouncementDetail>();
  EventDetail eventDetail = locator<EventDetail>();
  File? image;
  DateTime startDate = DateTime.now().add(Duration(days: 7));
  TimeOfDay startTime = TimeOfDay(hour: 19, minute: 0);
  bool addDateAndTime = false;
  bool addLocation = false;
  bool photoGallerySwitch = false;
  bool discussionSwitch = false;
  bool askInfoSwitch = false;

  bool loading = false;
  updateLoadingStatus(bool val){
    loading = val;
    notifyListeners();
  }

  Future getImage(BuildContext context, int type) async {
    final picker = ImagePicker();
    // type : 1 for camera in and 2 for gallery
    Navigator.of(context).pop();
    if (type == 1) {
      final pickedFile = await picker.pickImage(
          source: ImageSource.camera, imageQuality: 85, maxHeight: 1440);
      // image = File(pickedFile!.path);
      // if (image != null) {
      //   announcementDetail.announcementPhotoUrl = "";
      // }
      if (pickedFile != null) {
        announcementDetail.announcementPhotoUrl = "";
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          notifyListeners();
        });
      }
      notifyListeners();
    } else {
      final pickedFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 85, maxHeight: 1440);
      // image = File(pickedFile!.path);
      // if (image != null) {
      //   announcementDetail.announcementPhotoUrl = "";
      // }

      if (pickedFile != null) {
        announcementDetail.announcementPhotoUrl = "";
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          notifyListeners();
        });
      }
      notifyListeners();
    }
  }


  //Method for showing the date picker
  void pickDateDialog(BuildContext context) {
    showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      //for rebuilding the ui
      startDate = pickedDate;
      notifyListeners();
    });
  }

  Future<Null> selectTimeDialog(
      BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (pickedTime == null) {
      return;
    }
    startTime = pickedTime;

    notifyListeners();
  }


  Future createAnnouncement(BuildContext context, String title, String location, String description, DateTime startDateTime) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.createAnnouncement(title: title, description: description, photoURL:  announcementDetail.announcementPhotoUrl ?? "", location: location, start: startDateTime).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (value != null) {
      announcementDetail.announcementId = value.eid;
      eventDetail.eid = value.eid;

      if(image != null){
        announcementDetail.announcementPhotoUrl =  await storeFile(image!, path: StoragePath.eventPhoto(value.eid)).catchError((e) {
          setState(ViewState.Idle);
          DialogHelper.showMessage(context, e.message);
        });
        image = null;
        await updateAnnouncement(context, title, location, description, startDateTime);
      } else{
        setState(ViewState.Idle);
        announcementDetail.announcementPhotoUrl = value.photoURL;
      }

      Navigator.pushNamed(context, RoutesConstants.eventInviteFriendsScreen, arguments: EventInviteFriendsScreen(fromDiscussion: false, discussionId: "", fromChatDiscussion: false))
          .then((value) {
        hideKeyboard(context);
        Navigator.of(context).pop();
      });
    } else{
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error_message".tr());
    }
  }


  Future updateAnnouncement(BuildContext context, String title, String location,
      String description, DateTime startDateTime) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    if(image != null){
      announcementDetail.announcementPhotoUrl =  await storeFile(image!, path: StoragePath.eventPhoto(announcementDetail.announcementId.toString())).catchError((e) {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
    }
    var value = await mmyEngine!
        . updateAnnouncement(announcementDetail.announcementId.toString(), title: title, location: location, description: description, photoURL: announcementDetail.announcementPhotoUrl, start: startDateTime)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
    });
    if (value != null) {
      setState(ViewState.Idle);
      announcementDetail.announcementPhotoUrl = value.photoURL;
      announcementDetail.announcementTitle = value.title;
      announcementDetail.announcementStartDateAndTine = value.start;
      announcementDetail.announcementLocation = value.location;
      announcementDetail.announcementDescription = value.description;
      List<String> valuesList = [];
      for (var value in value.invitedContacts.values) {
        valuesList.add(value);
      }
      List<String> keysList = [];
      for (var key in value.invitedContacts.keys) {
        keysList.add(key);
      }
      List<String> contactsKeys = [];
      for (int i = 0; i < keysList.length; i++) {
        if (valuesList[i] != "Organiser") {
          contactsKeys.add(keysList[i]);
        }
      }

      eventDetail.contactCIDs = contactsKeys;

      Navigator.of(context).pop();
    }else{
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error_message".tr());
    }
  }

  Future cancelAnnouncement(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!
        .cancelEvent(announcementDetail.announcementId.toString())
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (value != null) {
      setState(ViewState.Idle);
      eventDetail.eventBtnStatus = CommonEventFunction.getEventBtnStatus(
          value, auth.currentUser!.uid.toString());
      eventDetail.btnBGColor = CommonEventFunction.getEventBtnColorStatus(
          value, auth.currentUser!.uid.toString(),
          textColor: false);
      eventDetail.textColor = CommonEventFunction.getEventBtnColorStatus(
          value, auth.currentUser!.uid.toString());

      Navigator.of(context).pop("cancelled");
    }
  }
}