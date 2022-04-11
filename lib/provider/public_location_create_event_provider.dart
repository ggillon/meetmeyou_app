import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/creator_mode.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:permission_handler/permission_handler.dart';

class PublicLocationCreateEventProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  CreatorMode creatorMode = locator<CreatorMode>();
  EventDetail eventDetail = locator<EventDetail>();
  File? image;

  DateTime startDate = DateTime.now().add(Duration(days: 7));
  TimeOfDay startTime = TimeOfDay(hour: 19, minute: 0);
  DateTime endDate = DateTime.now().add(Duration(days: 7));
  TimeOfDay endTime = TimeOfDay(hour: 19, minute: 0).addHour(3);
  bool addEndDate = false;
  bool addLocationDate = false;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void updateLoadingStatus(bool value) {
    _isLoading = value;
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
          source: ImageSource.camera, imageQuality: 90, maxHeight: 1440);
      image = File(pickedFile!.path);
      if (image != null) {
        eventDetail.eventPhotoUrl = "";
      }
      notifyListeners();
    } else {
      final pickedFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 90, maxHeight: 1440);
      image = File(pickedFile!.path);
      if (image != null) {
        eventDetail.eventPhotoUrl = "";
      }
      notifyListeners();
    }
  }


  //Method for showing the date picker
  void pickDateDialog(BuildContext context, bool checkOrEndStartDate) {
    showDatePicker(
        context: context,
        initialDate: checkOrEndStartDate ? startDate : endDate,
        firstDate: checkOrEndStartDate
            ? DateTime.now()
            : startDate,
        lastDate: DateTime(2100))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      //for rebuilding the ui
      if (checkOrEndStartDate == true) {
        startDate = pickedDate;
        if (startDate.isAfter(endDate)) {
          endDate = startDate;
          startTimeFun(context);
          notifyListeners();
          return;
        }
        startTimeFun(context);
      } else {
        endDate = pickedDate;
        endTimeFun(context);
      }
      notifyListeners();
    });
  }

  Future<Null> selectTimeDialog(
      BuildContext context, bool checkOrEndStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: checkOrEndStartTime ? startTime : endTime,
    );
    if (pickedTime == null) {
      return;
    }
    if (checkOrEndStartTime == true) {
      startTime = pickedTime;
      startTimeFun(context);
      //dateTimeFormat(startDate, startTime);
    } else {
      endTime = pickedTime;
      endTimeFun(context);
    }

    notifyListeners();
  }

  startTimeFun(BuildContext context) {
    // start time
    int startTimeHour = startTime.hour;
    int endTimeHour = endTime.hour;
    if (startTime.hour >= 21) {
      if (startDate
          .toString()
          .substring(0, 11)
          .compareTo(endDate.toString().substring(0, 11)) ==
          0) {
        endDate = startDate.add(Duration(days: 1));
        endTime = startTime.addHour(3);
        // dateCheck = true;
      } else {
        if ((endDate.day.toInt() - startDate.day.toInt()) == 1) {
          endTime = startTime.addHour(3);
        }
      }
    }

    if (startDate
        .toString()
        .substring(0, 11)
        .compareTo(endDate.toString().substring(0, 11)) ==
        0) {
      if (startTimeHour > endTimeHour) {
        endTime = startTime.addHour(3);
      } else if (startTimeHour == endTimeHour) {
        if (startTime.minute <= endTime.minute ||
            startTime.minute >= endTime.minute) {
          endTime = startTime.addHour(3);
        }
      } else if ((endTimeHour.toInt() - startTimeHour.toInt()) < 3) {
        endTime = startTime.addHour(3);
      } else if ((endTimeHour.toInt() - startTimeHour.toInt()) == 3) {
        if (startTime.minute > endTime.minute) {
          endTime = startTime.addHour(3);
        }
      }
    }
  }

  endTimeFun(BuildContext context) {
    // for end time
    int startTimeHour = startTime.hour;
    int endTimeHour = endTime.hour;
    if (startTime.hour >= 21) {
      if (startDate
          .toString()
          .substring(0, 11)
          .compareTo(endDate.toString().substring(0, 11)) ==
          0) {
        endDate = startDate.add(Duration(days: 1));
        endTime = startTime.addHour(3);
        DialogHelper.showMessage(
            context, "End time should 3 hours greater than Start time.");
        // dateCheck = true;
      } else {
        if ((endDate.day.toInt() - startDate.day.toInt()) == 1) {
          endTime = startTime.addHour(3);
          DialogHelper.showMessage(
              context, "End time should 3 hours greater than Start time.");
        }
      }
    }

    if (startDate
        .toString()
        .substring(0, 11)
        .compareTo(endDate.toString().substring(0, 11)) ==
        0) {
      if (endTimeHour < startTimeHour + 3) {
        endTime = startTime.addHour(3);
        DialogHelper.showMessage(
            context, "End time should 3 hours greater than Start time.");
      } else if (endTimeHour == startTimeHour + 3) {
        if (endTime.minute < startTime.minute) {
          endTime = startTime.addHour(3);
          DialogHelper.showMessage(
              context, "End time should 3 hours greater than Start time.");
        }
      }
    }
  }

  Future createPublicEvent(BuildContext context, String title, String location, String description, DateTime start, {File? image, String? website, DateTime? end}) async{
    setState(ViewState.Busy);

    var value = await creatorMode.mmyCreator!.createPublicEvent(title: title, location: location, description: description, start: start, photoFile: image, website: website, end: end).catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
    });

    if(value != null){
      image = null;
      setState(ViewState.Idle);
      Navigator.of(context).pop();
    }
  }

  Future updatePublicEvent(BuildContext context, String eid, String title, String location, String description, DateTime start, {File? image, String? website, DateTime? end, String? photoURL}) async{
    setState(ViewState.Busy);

    var value = await creatorMode.mmyCreator!.updatePublicEvent(eid, title: title, location: location, description: description, start: start, photoFile: image, website: website, end: end, photoURL: photoURL).catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
    });

    if(value != null){
      image = null;
      setState(ViewState.Idle);
      Navigator.of(context).pop();
    }
  }

  Future cancelEvent(BuildContext context, String eid) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.cancelEvent(eid).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (value != null) {
      setState(ViewState.Idle);
      Navigator.of(context).pop();
    }
  }


    Future createLocationEvent(BuildContext context, String title, String location, String description, {File? photoFile, String? website, DateTime? start, DateTime? end}) async{
      setState(ViewState.Busy);

    var value = await creatorMode.mmyCreator!.createLocationEvent(title: title, location: location, description: description, photoFile: photoFile, website: website, start: start, end: end).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      image = null;
      setState(ViewState.Idle);
      Navigator.of(context).pop();
    }
    }

  Future updateLocationEvent(BuildContext context, String eid, String title, String location, String description, DateTime start, {File? image, String? website, DateTime? end, String? photoURL}) async{
    setState(ViewState.Busy);

    var value = await creatorMode.mmyCreator!.updateLocationEvent(eid, title: title, location: location, description: description, start: start, photoFile: image, website: website, end: end, photoURL: photoURL).catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
    });

    if(value != null){
      image = null;
      setState(ViewState.Idle);
      Navigator.of(context).pop();
    }
  }
  }