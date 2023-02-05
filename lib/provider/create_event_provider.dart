import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/common_used.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/helper/deep_linking.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/multiple_date_option.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/services/storage/storage.dart';
import 'package:meetmeyou_app/view/add_event/event_invite_friends_screen/eventInviteFriendsScreen.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateEventProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();
  UserDetail userDetail = locator<UserDetail>();
  MultipleDateOption multipleDateOption = locator<MultipleDateOption>();
  DashboardProvider dashboardProvider = locator<DashboardProvider>();
  EventBus eventBus = locator<EventBus>();

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
  bool photoGallerySwitch = false;
  bool allowNonAttendingAndInvited = false;

  // this list is used at time of event creation for sending questions in add question api.
  List<String> questionsList = [];

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
      updatingStatus(true);
      final pickedFile = await picker.pickImage(
          source: ImageSource.camera, imageQuality: 50, maxHeight: 1440);
      updatingStatus(false);
     // image = File(pickedFile!.path);
      if (image != null) {
        eventDetail.eventPhotoUrl = DEFAULT_EVENT_PHOTO_URL;
      }
      if (pickedFile != null) {
        eventDetail.eventPhotoUrl = DEFAULT_EVENT_PHOTO_URL;
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          notifyListeners();
        });
      }
      notifyListeners();
    } else {
      updatingStatus(true);
      final pickedFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50, maxHeight: 1440);
      updatingStatus(false);
     // image = File(pickedFile!.path);
      if (image != null) {
        eventDetail.eventPhotoUrl = DEFAULT_EVENT_PHOTO_URL;
      }

      if (pickedFile != null) {
        // final bytes =  File(pickedFile.path).readAsBytesSync().lengthInBytes;
        // final kb = bytes / 1024;
        // final mb = kb / 1024;
        // print(mb);
        eventDetail.eventPhotoUrl = DEFAULT_EVENT_PHOTO_URL;
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          notifyListeners();
        });
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
                ? DateTime.now()
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
        int startDateBeforeDiff = 0;
        int startDateAfterDiff = 0;
        if(startDate.isAfter(pickedDate)){
          startDateBeforeDiff = startDate.difference(pickedDate).inDays;
          endDate = endDate.subtract(Duration(days: startDateBeforeDiff));
        } else if(pickedDate.isAfter(startDate)){
          startDateAfterDiff = pickedDate.difference(startDate).inDays;
          endDate = endDate.add(Duration(days: startDateAfterDiff));
        }
        // print(startDateBeforeDiff);
        // print(startDateAfterDiff);
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
      /// maintain time length
      int startTimeHourDiff = 0;
      int startTimeMinDiff = 0;  if (startDate
          .toString()
          .substring(0, 11)
          .compareTo(endDate.toString().substring(0, 11)) ==
          0) {
        if(pickedTime.hour < startTime.hour){
          startTimeHourDiff = startTime.hour - pickedTime.hour;
          int hour = endTime.hour - startTimeHourDiff;
          startTimeFun(context);
          endTime = endTime.replacing(hour: hour, minute: endTime.minute);
          // endTime = endTime.addHour(-startTimeHourDiff);
          if(pickedTime.minute < startTime.minute){
            startTimeMinDiff = startTime.minute - pickedTime.minute;
            int min = endTime.minute - startTimeMinDiff;
            endTime = endTime.replacing(hour: endTime.hour, minute: min);
          }
        } else if(pickedTime.hour == startTime.hour){
          if(pickedTime.minute < startTime.minute){
            startTimeMinDiff = startTime.minute - pickedTime.minute;
            int min = endTime.minute - startTimeMinDiff;
            endTime = endTime.replacing(hour: endTime.hour, minute: min);
          }
        }

        if(pickedTime.hour > startTime.hour){
          startTimeHourDiff = pickedTime.hour - startTime.hour;
          int hour = endTime.hour + startTimeHourDiff;

          if(hour >= 24){
            startTimeFun(context);
          } else{
            endTime = endTime.replacing(hour: hour, minute: endTime.minute);
          }

          // endTime = endTime.addHour(-startTimeHourDiff);
          if(pickedTime.minute > startTime.minute){
            startTimeMinDiff = pickedTime.minute - startTime.minute;
            int min = endTime.minute + startTimeMinDiff;
            endTime = endTime.replacing(hour: endTime.hour, minute: min);
          }
        } else if(pickedTime.hour == startTime.hour){
          if(pickedTime.minute > startTime.minute){
            startTimeMinDiff = pickedTime.minute - startTime.minute;
            int min = endTime.minute + startTimeMinDiff;
            endTime = endTime.replacing(hour: endTime.hour, minute: min);
          }
        }
      }

      // print(startTimeHourDiff);
      // print(startTimeMinDiff);
      // int beforeStartTime = 0;
      // int afterStartTime = 0;
      // if((startTime.hour == 0 ? 24 : startTime.hour) > (pickedTime.hour == 0 ? 24 : pickedTime.hour)){
      //
      //   // if(endTime.hour == 0){
      //   //   endTime = endTime.addHour(12);
      //   //   endTime = endTime.addHour(beforeStartTime);
      //   // } else{
      //   //   endTime = endTime.addHour(beforeStartTime);
      //   // }
      //   if(pickedTime.hour == 0 || startTime.hour == 0){
      //     endTime = endTime.addHour(-startTime.hour);
      //   } else{
      //     beforeStartTime = ((startTime.hour) - (pickedTime.hour));
      //     if((endTime.hour + beforeStartTime) > 24){
      //       endTime = endTime.addHour(-beforeStartTime);
      //     } else{
      //       endTime = endTime.addHour(beforeStartTime);
      //     }
      //
      //   }
      //
      // } else{
      //   if(pickedTime.hour == 0){
      //     endTime = endTime.addHour(-startTime.hour);
      //   } else{
      //     afterStartTime = ((pickedTime.hour) - (startTime.hour));
      //     endTime = endTime.addHour(afterStartTime);
      //   }
      //
      //
      // }
      // // print(beforeStartTime);
      // // print(afterStartTime);
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
    // if (startTime.hour >= 21) {
    //   if (startDate.toString().substring(0, 11)
    //       .compareTo(endDate.toString().substring(0, 11)) ==
    //       0) {
    //     endDate = startDate.add(Duration(days: 1));
    //     endTime = startTime.addHour(3);
    //     DialogHelper.showMessage(
    //         context, "End time should 3 hours greater than Start time.");
    //     // dateCheck = true;
    //   } else {
    //     if ((endDate.day.toInt() - startDate.day.toInt()) == 1) {
    //       endTime = startTime.addHour(3);
    //       DialogHelper.showMessage(
    //           context, "End time should 3 hours greater than Start time.");
    //     }
    //   }
    // }

    if (startDate.toString().substring(0, 11)
            .compareTo(endDate.toString().substring(0, 11)) ==
        0) {
      if (endTimeHour < startTimeHour) {
        endTime = startTime.addHour(3);
        DialogHelper.showMessage(
            context, "end_time_cannot_before_start_time".tr());
      } else if (endTimeHour == startTimeHour) {
        if (endTime.minute < startTime.minute) {
          endTime = startTime.addHour(3);
          DialogHelper.showMessage(
              context, "end_time_cannot_before_start_time".tr());
        } else if(endTime.minute == startTime.minute){
          endTime = startTime.addHour(3);
          DialogHelper.showMessage(
              context, "end_time_cannot_same_start_time".tr());
        }
      }

      // if (endTimeHour < startTimeHour + 3) {
      //   endTime = startTime.addHour(3);
      //   DialogHelper.showMessage(
      //       context, "End time should 3 hours greater than Start time.");
      // } else if (endTimeHour == startTimeHour + 3) {
      //   if (endTime.minute < startTime.minute) {
      //     endTime = startTime.addHour(3);
      //     DialogHelper.showMessage(
      //         context, "End time should 3 hours greater than Start time.");
      //   }
      // }
      // else if (startTime.isCompareTo(endTime) == 1) {
      //   DialogHelper.showMessage(context,
      //       "Select correct time.");
      // }
    }
  }

  Future createEvent(BuildContext context, String title, String location,
      String description, DateTime startDateTime, DateTime endDateTime,
      {String? photoURL, File? photoFile}) async {
    hideKeyboard(context);
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!
        .createEvent(
            title: title,
            location: (location == "" || location == null) ? "not_specified".tr() : location,
            description: description,
           // photoFile: photoFile ?? null,
            photoURL: (photoURL == "" || photoURL == null) ? DEFAULT_EVENT_PHOTO_URL : photoURL,
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
    //  setState(ViewState.Idle);
      value.form = <String, dynamic>{};
      eventDetail.eid = value.eid;

      /// for creating photo gallery
      if(photoGallerySwitch){
        await createEventAlbum(context, value.eid, photoGallerySwitch);
      }

     // photoFile = null;
      if(image != null){
        eventDetail.eventPhotoUrl =  await storeFile(image!, path: StoragePath.eventPhoto(value.eid)).catchError((e) {
          setState(ViewState.Idle);
          DialogHelper.showMessage(context, e.message);
        });
        if(eventDetail.editEvent != true){
          if(questionsList.isNotEmpty){
            for(int i = 0; i < questionsList.length; i++){
              await addQuestionToEvent(context, value, (i+1), questionsList[i]);
            }
          }
        }
        await updateEvent(context, title, location, description, startDateTime, endDateTime, photoURL: eventDetail.eventPhotoUrl, isCreateEvent: true);

        if(!eventDetail.isFromContactOrGroupDescription){
          Navigator.pushNamed(context, RoutesConstants.eventInviteFriendsScreen, arguments: EventInviteFriendsScreen(fromDiscussion: false, discussionId: "", fromChatDiscussion: false))
              .then((value) {
            Navigator.of(context).pop();
            // this is done because home screen not refreshes on pop when user choose or click a photo.
            eventBus.fire(InviteEventFromLink(true));
          });
        } else{
          await inviteContactToEvent(context, eventDetail.contactIdsForEventCreation);
      }
        setState(ViewState.Idle);
      } else{
        eventDetail.eventPhotoUrl = value.photoURL;
        clearMultiDateOption();

          if(eventDetail.editEvent != true){
            if(questionsList.isNotEmpty){
              for(int i = 0; i < questionsList.length; i++){
              await addQuestionToEvent(context, value, (i+1), questionsList[i]);
              }
            }
          }

          if(!eventDetail.isFromContactOrGroupDescription){
            Navigator.pushNamed(context, RoutesConstants.eventInviteFriendsScreen, arguments: EventInviteFriendsScreen(fromDiscussion: false, discussionId: "", fromChatDiscussion: false))
                .then((value) {
              // fromInviteScreen = true;
              // updateLoadingStatus(true);
              Navigator.of(context).pop();
            });
          } else{
           await inviteContactToEvent(context, eventDetail.contactIdsForEventCreation);
          }

        setState(ViewState.Idle);
      }
    //  eventDetail.eventPhotoUrl = value.photoURL;


    }else{
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error_message".tr());
    }
  }

  Future updateEvent(BuildContext context, String title, String location,
      String description, DateTime startDateTime, DateTime endDateTime,
      {String? photoURL, File? photoFile, bool isCreateEvent = false}) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    if(image != null){
      eventDetail.eventPhotoUrl =  await storeFile(image!, path: StoragePath.eventPhoto(eventDetail.eid.toString())).catchError((e) {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
    }
    var value = await mmyEngine!
        .updateEvent(eventDetail.eid.toString(),
            title: title,
            location: (location == "" || location == null) ? "not_specified".tr() : location,
            description: description,
            photoURL: eventDetail.eventPhotoUrl ?? DEFAULT_EVENT_PHOTO_URL,
         //   photoFile: eventDetail.eventPhotoUrl == "" ? image ?? null : null,
            start: startDateTime,
            end: endDateTime)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.toString());
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

     isCreateEvent ? Container() : Navigator.of(context).pop();
    } else{
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error_message".tr());
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

    var value = await mmyEngine!.addQuestionToEvent(event, questionNum: queNo, text: queText)
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

    await mmyEngine!.removeDateFromEvent(eid, did).catchError((e) {
      updateDate(false);
      DialogHelper.showMessage(context, e.message);
    });

    updateDate(false);
  }

  /// Create an album for event

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

  /// Get event parameter
  // this fun is used to check photo gallery switch whether on or off.
  bool getParam = false;

  updateGetParam(bool val){
    getParam = val;
    notifyListeners();
  }

  Future getEventParam(BuildContext context, String eid, String param, {bool photoGallery = true}) async{
    updateGetParam(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =  await mmyEngine!.getEventParam(eid, param: param).catchError((e) {
      updateGetParam(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      if(photoGallery){
        photoGallerySwitch = value;
      } else{
        allowNonAttendingAndInvited = value;
      }
      updateGetParam(false);
    }

  }

  /// Set event parameter
// this fun is used to set photo gallery switch on or off.

  bool setParam = false;

  updateSetParam(bool val){
    setParam = val;
    notifyListeners();
  }

  Future setEventParam(BuildContext context, String eid, String param, bool switchValue) async{
    updateSetParam(true);

    var value =  await mmyEngine!.setEventParam(eid, param: param, value: switchValue).catchError((e) {
      updateSetParam(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      updateSetParam(false);
    }

  }


  /// this function is used when we are creating event with contact or group.
  inviteContactToEvent(BuildContext context, List<String> CID) async {
   setState(ViewState.Busy);

    await mmyEngine!.inviteContactsToEvent(eventDetail.eid.toString(),
        CIDs: CID.length > 1 ? CID : [CID[0]]).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

   Navigator.of(context).pop();

   setState(ViewState.Idle);
  }
}
