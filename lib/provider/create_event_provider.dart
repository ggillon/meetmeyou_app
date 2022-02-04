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
  DateTime startDate = DateTime.now().add(Duration(days: 7));
  TimeOfDay startTime = TimeOfDay(hour: 19, minute: 0);
  DateTime endDate = DateTime.now().add(Duration(days: 7));
  TimeOfDay endTime = TimeOfDay(hour: 19, minute: 0).addHour(3);
  bool isSwitched = false;
  bool fromInviteScreen = false;
  bool addMultipleDate = false;
  bool removeMultiDate = false;
  int? selectedIndex;
  bool addEndDate = false;

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
            initialDate: checkOrEndStartDate ? startDate : endDate,
            // : dateCheck
            //     ? endDate
            //     : DateTime(startDate.year, startDate.month, startDate.day),
            firstDate: checkOrEndStartDate
                ? DateTime.now().add(Duration(days: 7))
                : startDate,
            // : dateCheck
            //     ? endDate
            //     : DateTime(startDate.year, startDate.month, startDate.day),
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
    // TimeOfDay eveningTime = TimeOfDay(hour: 19, minute: 0);

    // if(eveningTime.period == DayPeriod.pm){
    //   if(startTimeHour > eveningTime.hour){
    //     startTime = eveningTime;
    //     DialogHelper.showMessage(
    //         context, "Sorry! event can't be created after 7:00 PM.");
    //   } else if(startTimeHour == eveningTime.hour){
    //     if(startTime.minute > eveningTime.minute){
    //       startTime = eveningTime;
    //       DialogHelper.showMessage(
    //           context, "Sorry! event can't be created after 7:00 PM.");
    //     }
    //   }
    // }

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
      Navigator.of(context).pop("cancelled");
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
    multipleDateOption.invitedContacts.clear();
    multipleDateOption.eventAttendingPhotoUrlLists.clear();
    multipleDateOption.eventAttendingKeysList.clear();
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

  Future getMultipleDateOptionsFromEvent(BuildContext context, String eid,
      {bool multiDateList = true}) async {
    updateGetMultipleDate(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getDateOptionsFromEvent(eid).catchError((e) {
      updateGetMultipleDate(false);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      multipleDate = value;
      multiDateList == true ? addMultipleDate = true : addMultipleDate = false;
      multiDateList == true ? await addMultiDateTimeValue(context, multipleDate) : clearMultiDateOption();
      updateGetMultipleDate(false);
    }
  }

  addMultiDateTimeValue(
      BuildContext context, List<DateOption> multipleDate) async {
    for (int i = 0; i < multipleDate.length; i++) {
      multipleDateOption.startDate.add(multipleDate[i].start);
      multipleDateOption.endDate.add(multipleDate[i].end);
      multipleDateOption.startTime
          .add(TimeOfDay.fromDateTime(multipleDate[i].start));
      multipleDateOption.endTime
          .add(TimeOfDay.fromDateTime(multipleDate[i].end));
      multipleDateOption.invitedContacts.add(multipleDate[i].invitedContacts);
    }
  }

  bool finalDate = false;

  void updateFinalDate(bool value) {
    finalDate = value;
    notifyListeners();
  }

  Future selectFinalDate(BuildContext context, String did) async {
    updateFinalDate(true);
    Navigator.of(context).pop();
    var value = await mmyEngine!
        .selectFinalDate(eventDetail.eid.toString(), did)
        .catchError((e) {
      updateFinalDate(false);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      eventDetail.event = value;
      addMultipleDate = false;
      startDate = value.start;
      endDate = value.end;
      startTime = TimeOfDay.fromDateTime(value.start);
      endTime = TimeOfDay.fromDateTime(value.end);
      updateFinalDate(false);
      getMultipleDateOptionsFromEvent(context, eventDetail.eid.toString(),
          multiDateList: false);
    }
  }

  List<String> eventAttendingPhotoUrlLists = [];

  bool imageAndKeys = false;

  updateImageAndKeys(bool val) {
    imageAndKeys = val;
    notifyListeners();
  }

  imageUrlAndAttendingKeysList(BuildContext context) async {
    updateImageAndKeys(true);
    multipleDateOption.eventAttendingPhotoUrlLists.clear();
    multipleDateOption.eventAttendingKeysList.clear();
    for (int i = 0; i < multipleDateOption.invitedContacts.length; i++) {
      List<String> eventAttendingKeysList = [];
      List<String> attendingImages = [];

      List<String> keysList = [];

      for (var key in multipleDate[i].invitedContacts.keys) {
        keysList.add(key);
      }

      List<String> valuesList = [];

      for (var value in multipleDate[i].invitedContacts.values) {
        valuesList.add(value);
      }

      for (int i = 0; i < keysList.length; i++) {
        if (valuesList[i] == "Attending") {
          eventAttendingKeysList.add(keysList[i]);
          await getUsersProfileUrl(context, keysList[i]);
        }
        attendingImages.addAll(eventAttendingPhotoUrlLists);
        eventAttendingPhotoUrlLists.clear();
      }
      multipleDateOption.eventAttendingPhotoUrlLists.add(attendingImages);
      multipleDateOption.eventAttendingKeysList.add(eventAttendingKeysList);
    }
    // print(multipleDateOption.eventAttendingPhotoUrlLists);
    // print(multipleDateOption.eventAttendingKeysList);
    updateImageAndKeys(false);
  }

  Future getUsersProfileUrl(BuildContext context, String key) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value =
        await mmyEngine!.getUserProfile(user: false, uid: key).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    eventAttendingPhotoUrlLists.add(value.photoURL);

    setState(ViewState.Idle);
  }

  //Future<void> removeDateFromEvent(String eid, String did);

  bool removeMDate = false;

  updateDate(bool val) {
    removeMDate = val;
    notifyListeners();
  }

  Future removeDateFromEvent(
      BuildContext context, String eid, String did) async {
    updateDate(true);

    await mmyEngine?.removeDateFromEvent(eid, did).catchError((e) {
      updateDate(false);
      DialogHelper.showMessage(context, e.message);
    });

    updateDate(false);
  }
}
