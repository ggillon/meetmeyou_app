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

import '../models/event.dart';

class AnnouncementProvider extends BaseProvider{

  MMYEngine? mmyEngine;
  AnnouncementDetail announcementDetail = locator<AnnouncementDetail>();
  EventDetail eventDetail = locator<EventDetail>();
  File? image;
  DateTime startDate = DateTime.now().add(Duration(days: 7));
  TimeOfDay startTime = TimeOfDay(hour: 19, minute: 0);
  DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 3, DateTime.now().day + 7);
  TimeOfDay endTime = TimeOfDay(hour: 19, minute: 0);
  bool addDateAndTime = false;
  bool addLocation = false;
  bool photoGallerySwitch = false;
  bool discussionSwitch = false;
  bool askInfoSwitch = false;

  // to be used when creating publication
  List<String> questionsList = [];

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
        initialDate: endDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      //for rebuilding the ui
      endDate = pickedDate;
      notifyListeners();
    });
  }

  Future<Null> selectTimeDialog(
      BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (pickedTime == null) {
      return;
    }
    endTime = pickedTime;

    notifyListeners();
  }

  /// For creating an announcement

  Future createAnnouncement(BuildContext context, String title, String location, String description, DateTime startDateTime, DateTime endDateTime) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.createAnnouncement(title: title, description: description, photoURL: announcementDetail.announcementPhotoUrl ?? DEFAULT_EVENT_PHOTO_URL,
        location: location, start: startDateTime, end: endDateTime).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (value != null) {
      value.form = <String, dynamic>{};
      announcementDetail.announcementId = value.eid;
      eventDetail.eid = value.eid;

      if(image != null){
        announcementDetail.announcementPhotoUrl =  await storeFile(image!, path: StoragePath.eventPhoto(value.eid)).catchError((e) {
          setState(ViewState.Idle);
          DialogHelper.showMessage(context, e.message);
        });
        image = null;
        if(!announcementDetail.editAnnouncement){
          if(askInfoSwitch){
            if(questionsList.isNotEmpty){
              for(int i = 0 ; i < questionsList.length; i++){
                await addQuestionToEvent(context, value, (i+1), questionsList[i]);
              }
            }
          }
          if(discussionSwitch){
            await setEventParam(context, value.eid, "discussion", discussionSwitch);
          }
          if(photoGallerySwitch){
            await createEventAlbum(context, value.eid, photoGallerySwitch);
          }
        }
        await updateAnnouncement(context, title, location, description, startDateTime, endDateTime);
      } else{
        announcementDetail.announcementPhotoUrl = value.photoURL;
        if(!announcementDetail.editAnnouncement){
          if(askInfoSwitch){
            if(questionsList.isNotEmpty){
              for(int i = 0 ; i < questionsList.length; i++){
                await addQuestionToEvent(context, value, (i+1), questionsList[i]);
              }
            }
          }
          if(discussionSwitch){
            await setEventParam(context, value.eid, "discussion", discussionSwitch);
          }
          if(photoGallerySwitch){
            await createEventAlbum(context, value.eid, photoGallerySwitch);
          }
        }
        setState(ViewState.Idle);
      }

      Navigator.pushNamed(context, RoutesConstants.publicationVisibility).then((value) {
        hideKeyboard(context);
        Navigator.of(context).pop();
      });
    } else{
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error_message".tr());
    }
  }

/// for update an announcement
  Future updateAnnouncement(BuildContext context, String title, String location,
      String description, DateTime startDateTime, DateTime endDateTime) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    if(image != null){
      announcementDetail.announcementPhotoUrl =  await storeFile(image!, path: StoragePath.eventPhoto(announcementDetail.announcementId.toString())).catchError((e) {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
    }
    var value = await mmyEngine!
        . updateAnnouncement(announcementDetail.announcementId.toString(), title: title, location: location, description: description,
        photoURL: announcementDetail.announcementPhotoUrl, start: startDateTime, end: endDateTime)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
    });
    if (value != null) {
      setState(ViewState.Idle);
      announcementDetail.announcementPhotoUrl = value.photoURL;
      announcementDetail.announcementTitle = value.title;
      announcementDetail.announcementStartDateAndTime = value.start;
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

      // these variables are used for set value in common screen event detail
      eventDetail.photoUrlEvent = value.photoURL;
      eventDetail.eventName = value.title;
      eventDetail.startDateAndTime = value.start;
      eventDetail.eventLocation = value.location;
      eventDetail.eventDescription = value.description;
      eventDetail.event = value;

      Navigator.of(context).pop();
    }else{
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error_message".tr());
    }
  }

  /// for cancel an announcement
  Future cancelAnnouncement(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.cancelEvent(announcementDetail.announcementId.toString())
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

  /// add questions to announcement
  bool addQuestion = false;

  void updateAddQuestionStatus(bool value) {
    addQuestion = value;
    notifyListeners();
  }

  Future addQuestionToEvent(
      BuildContext context, Event event, int queNo, String queText) async {
    updateAddQuestionStatus(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!
        .addQuestionToEvent(event, questionNum: queNo, text: queText)
        .catchError((e) {
      updateAddQuestionStatus(false);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      updateAddQuestionStatus(false);
    }
  }

  /// Create an album for announcement

  bool album = false;

  updateAlbum(bool val){
    album = val;
    notifyListeners();
  }

  Future createEventAlbum(BuildContext context, String eid, bool switchValue) async{
    updateAlbum(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =  await mmyEngine!.createEventAlbum(eid).catchError((e) {
      updateAlbum(false);
      DialogHelper.showMessage(context, e.message);
    });

    await setEventParam(context, eid, "photoAlbum", switchValue);

    if(value != null){
      updateAlbum(false);
    }

  }

  /// Get announcement parameter
  // this fun is used to check toggle switch whether on or off.
  bool getParam = false;

  updateGetParam(bool val){
    getParam = val;
    notifyListeners();
  }

  Future getEventParam(BuildContext context, String eid, String param, bool discussionSwitch) async{
    updateGetParam(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =  await mmyEngine!.getEventParam(eid, param: param).catchError((e) {
      updateGetParam(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      if(discussionSwitch){
        this.discussionSwitch = value;
      } else{
        photoGallerySwitch = value;
      }
      updateGetParam(false);
    }

  }

  /// Set announcement parameter
// this fun is used to set toggle switch on or off.

  bool setParam = false;

  updateSetParam(bool val){
    setParam = val;
    notifyListeners();
  }

  Future setEventParam(BuildContext context, String eid, String param, dynamic switchValue) async{
    updateSetParam(true);

    var value =  await mmyEngine!.setEventParam(eid, param: param, value: switchValue).catchError((e) {
      updateSetParam(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      updateSetParam(false);
    }

  }
}