import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/common_used.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateEventProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();

  File? image;

  //String? imageUrl;
  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime endDate = DateTime.now();
  TimeOfDay endTime = TimeOfDay.now();
  bool isSwitched = false;
  bool fromInviteScreen = false;

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
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      image = File(pickedFile!.path);
      if (image != null) {
        eventDetail.eventPhotoUrl = "";
      }
      notifyListeners();
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
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
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime.now(),
            //what will be the previous supported year in picker
            lastDate: DateTime(
                2100)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      //for rebuilding the ui
      if (checkOrEndStartDate) {
        startDate = pickedDate;
      } else {
        endDate = pickedDate;
      }

      notifyListeners();
    });
  }

  Future<Null> selectTimeDialog(
      BuildContext context, bool checkOrEndStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (pickedTime == null) {
      return;
    }
    if (checkOrEndStartTime) {
      startTime = pickedTime;
      dateTimeFormat(startDate, startTime);
    } else {
      endTime = pickedTime;
    }

    notifyListeners();
  }

  Future createEvent(BuildContext context, String title, String location,
      String description, DateTime startDateTime, DateTime endDateTime,
      {String? photoURL, File? photoFile}) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!
        .createEvent(
            title: title,
            location: location,
            description: description,
            photoFile: photoFile ?? null,
            photoURL: photoURL ?? "",
            start: startDateTime,
            end: endDateTime)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (value != null) {
      setState(ViewState.Idle);
      eventDetail.eid = value.eid;
      photoFile = null;
      eventDetail.eventPhotoUrl = value.photoURL;
      //   DialogHelper.showMessage(context, "Event created Successfully");
      Navigator.pushNamed(context, RoutesConstants.eventInviteFriendsScreen)
          .then((value) {
        fromInviteScreen = true;
        updateLoadingStatus(true);
        hideKeyboard(context);
      });
    }
  }

  Future updateEvent(BuildContext context, String title, String location,
      String description, DateTime startDateTime, DateTime endDateTime,
      {String? photoURL, File? photoFile}) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value = await mmyEngine!
        .updateEvent(eventDetail.eid.toString(),
            title: title,
            location: location,
            description: description,
            photoURL: eventDetail.eventPhotoUrl ?? "",
            photoFile:
                eventDetail.eventPhotoUrl == null ? photoFile ?? null : null,
            start: startDateTime,
            end: endDateTime)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (value != null) {
      setState(ViewState.Idle);
      eventDetail.photoUrlEvent = value.photoURL;
      eventDetail.eventName = value.title;
      eventDetail.startDateAndTime = value.start;
      eventDetail.endDateAndTime = value.end;
      eventDetail.eventLocation = value.location;
      eventDetail.eventDescription = value.description;
      // DialogHelper.showMessage(context, "Event updated Successfully");
      Navigator.of(context).pop();
    }
  }

  dateTimeFormat(DateTime date, TimeOfDay time) {
    String dateTimeString =
        date.toString().substring(0, 11) + DateTimeHelper.timeConversion(time);
    DateTime tempDate =
        new DateFormat("yyyy-MM-dd hh:mm").parse(dateTimeString);
    // print(dateTimeString);
    // print(tempDate);
    return tempDate;
  }


}
