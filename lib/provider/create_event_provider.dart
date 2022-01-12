import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/common_used.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/multiple_date_option.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateEventProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();
  UserDetail userDetail = locator<UserDetail>();
  MultipleDateOption multipleDateOption = locator<MultipleDateOption>();

  File? image;

  //String? imageUrl;
  DateTime startDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime endDate = DateTime.now();
  TimeOfDay endTime = TimeOfDay.now().addHour(3);
  bool isSwitched = false;
  bool fromInviteScreen = false;
  bool addMultipleDate = false;
  int? selectedIndex;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void updateLoadingStatus(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool question = false;

  void updateQuestionStatus(bool value) {
    question = value;
    notifyListeners();
  }

  bool multipleDateUi = false;

  void updateMultipleDateUiStatus(bool value) {
    multipleDateUi = value;
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

  bool dateCheck = false;

  //Method for showing the date picker
  void pickDateDialog(BuildContext context, bool checkOrEndStartDate) {
    showDatePicker(
            context: context,
            initialDate: checkOrEndStartDate
                ? DateTime.now()
                : dateCheck
                    ? endDate
                    : DateTime(startDate.year, startDate.month, startDate.day),
            firstDate: checkOrEndStartDate
                ? DateTime.now()
                : dateCheck
                    ? endDate
                    : DateTime(startDate.year, startDate.month, startDate.day),
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
          notifyListeners();
          return;
        }
        startTimeFun();
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
      startTimeFun();
      //dateTimeFormat(startDate, startTime);
    } else {
      endTime = pickedTime;
      endTimeFun(context);
    }

    notifyListeners();
  }

  startTimeFun() {
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
        dateCheck = true;
      }
    } else {
      // endDate = startDate;
      // dateCheck = false;
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
      // else if (startTime.isCompareTo(endTime) == 1) {
      //   DialogHelper.showMessage(context,
      //       "Select correct time.");
      // }
    }
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
            start: addMultipleDate == true ? null : startDateTime,
            end: addMultipleDate == true ? null : endDateTime,
            startDateOptions: addMultipleDate == true
                ? multipleDateOption.startDateTime
                : null,
            endDateOptions:
                addMultipleDate == true ? multipleDateOption.endDateTime : null)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (value != null) {
      setState(ViewState.Idle);
      eventDetail.eid = value.eid;
      photoFile = null;
      eventDetail.eventPhotoUrl = value.photoURL;

      clearMultiDateOption();
      //   DialogHelper.showMessage(context, "Event created Successfully");
      Navigator.pushNamed(context, RoutesConstants.eventInviteFriendsScreen)
          .then((value) {
        // fromInviteScreen = true;
        // updateLoadingStatus(true);
        hideKeyboard(context);
        Navigator.of(context).pop();
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
            photoFile: eventDetail.eventPhotoUrl == "" ? image ?? null : null,
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
      clearMultiDateOption();
      // DialogHelper.showMessage(context, "Event updated Successfully");
      Navigator.of(context).pop();
    }
  }

  Future cancelEvent(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!
        .cancelEvent(eventDetail.eid.toString())
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (value != null) {
      setState(ViewState.Idle);
      eventDetail.eventBtnStatus = CommonEventFunction.getEventBtnStatus(
          value, userDetail.cid.toString());
      eventDetail.btnBGColor = CommonEventFunction.getEventBtnColorStatus(
          value, userDetail.cid.toString(),
          textColor: false);
      eventDetail.textColor = CommonEventFunction.getEventBtnColorStatus(
          value, userDetail.cid.toString());
      clearMultiDateOption();
      Navigator.of(context).pop();
    }
  }

  clearMultiDateOption() {
    // clear multi date and time lists
    multipleDateOption.startDate.clear();
    multipleDateOption.endDate.clear();
    multipleDateOption.startTime.clear();
    multipleDateOption.endTime.clear();
    multipleDateOption.startDateTime.clear();
    multipleDateOption.endDateTime.clear();
  }

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

  List<DateOption> multipleDate = [];
  bool getMultipleDate = false;

  void updateGetMultipleDate(bool value) {
    getMultipleDate = value;
    notifyListeners();
  }

  Future getMultipleDateOptionsFromEvent(
      BuildContext context, String eid, {bool multiDateList = true}) async {
    updateGetMultipleDate(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getDateOptionsFromEvent(eid).catchError((e) {
      updateGetMultipleDate(false);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      multipleDate = value;
      multiDateList == true ?  addMultipleDate = true : addMultipleDate = false;
      multiDateList == true ? addMultiDateTimeValue(multipleDate): clearMultiDateOption();
      updateGetMultipleDate(false);
    }
  }

addMultiDateTimeValue(List<DateOption> multipleDate){
  for (int i = 0; i < multipleDate.length; i++) {
    multipleDateOption.startDate.add(multipleDate[i].start);
    multipleDateOption.endDate.add(multipleDate[i].end);
    multipleDateOption.startTime
        .add(TimeOfDay.fromDateTime(multipleDate[i].start));
    multipleDateOption.endTime
        .add(TimeOfDay.fromDateTime(multipleDate[i].end));
  }
}

  bool finalDate = false;

  void updateFinalDate(bool value) {
    finalDate = value;
    notifyListeners();
  }

  Future selectFinalDate(BuildContext context, String did) async{
    updateFinalDate(true);

  var value =  await mmyEngine!.selectFinalDate(eventDetail.eid.toString(), did).catchError((e) {
      updateFinalDate(false);
      DialogHelper.showMessage(context, e.message);
    });

  if(value != null){
    updateFinalDate(false);
    eventDetail.event = value;
    addMultipleDate = false;
    Navigator.of(context).pop();
    getMultipleDateOptionsFromEvent(context, eventDetail.eid.toString(), multiDateList: false);
  }
  }

// getEventBtnStatus(Event event) {
//   List<String> keysList = [];
//   for (var key in event.invitedContacts.keys) {
//     keysList.add(key);
//   }
//   List<String> valuesList = [];
//   for (var value in event.invitedContacts.values) {
//     valuesList.add(value);
//   }
//   for (int i = 0; i < keysList.length; i++) {
//     if (keysList[i] == userDetail.cid) {
//       if (valuesList[i] == "Invited") {
//         return "respond";
//       } else if (valuesList[i] == "Organiser") {
//         return "edit";
//       } else if (valuesList[i] == "Attending") {
//         return "going";
//       } else if (valuesList[i] == "Not Attending") {
//         return "not_going";
//       } else if (valuesList[i] == "Not Interested") {
//         return "hidden";
//       } else if (valuesList[i] == "Canceled") {
//         return "cancelled";
//       }
//     }
//   }
// }
//
// getEventBtnColorStatus(Event event, {bool textColor = true}) {
//   List<String> keysList = [];
//   for (var key in event.invitedContacts.keys) {
//     keysList.add(key);
//   }
//   List<String> valuesList = [];
//   for (var value in event.invitedContacts.values) {
//     valuesList.add(value);
//   }
//   for (int i = 0; i < keysList.length; i++) {
//     if (keysList[i] == userDetail.cid) {
//       if (valuesList[i] == "Invited") {
//         return textColor
//             ? ColorConstants.colorWhite
//             : ColorConstants.primaryColor;
//       } else if (valuesList[i] == "Organiser") {
//         return textColor
//             ? ColorConstants.colorWhite
//             : ColorConstants.primaryColor;
//       } else if (valuesList[i] == "Attending") {
//         return textColor
//             ? ColorConstants.primaryColor
//             : ColorConstants.primaryColor.withOpacity(0.2);
//       } else if (valuesList[i] == "Not Attending") {
//         return textColor
//             ? ColorConstants.primaryColor
//             : ColorConstants.primaryColor.withOpacity(0.2);
//       } else if (valuesList[i] == "Not Interested") {
//         return textColor
//             ? ColorConstants.primaryColor
//             : ColorConstants.primaryColor.withOpacity(0.2);
//       } else if (valuesList[i] == "Canceled") {
//         return textColor
//             ? ColorConstants.primaryColor
//             : ColorConstants.primaryColor.withOpacity(0.2);
//       }
//     }
//   }
// }
}
