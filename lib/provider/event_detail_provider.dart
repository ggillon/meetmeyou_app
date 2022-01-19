import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/multiple_date_option.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/models/event.dart' as eventModel;
import 'package:meetmeyou_app/services/storage/templates.dart';

class EventDetailProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();
  UserDetail userDetail = locator<UserDetail>();
  CalendarDetail calendarDetail = locator<CalendarDetail>();
  DashboardProvider dashboardProvider = locator<DashboardProvider>();
  int eventAttendingLength = 0;
  List<String> eventAttendingKeysList = [];
  String? organiserKey;
  MultipleDateOption multipleDateOption = locator<MultipleDateOption>();

  bool backValue = false;

  updateBackValue(bool value) {
    backValue = value;
    notifyListeners();
  }

  bool _value = false;

  bool get value => _value;

  updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  eventGoingLength() {
    List<String> keysList = [];
    for (var key in eventDetail.eventMapData!.keys) {
      keysList.add(key);
    }
    List<String> valuesList = [];

    for (var value in eventDetail.eventMapData!.values) {
      valuesList.add(value);
    }

    for (int i = 0; i < keysList.length; i++) {
      if (valuesList[i] == "Attending") {
        eventAttendingLength = eventAttendingLength + 1;
        eventAttendingKeysList.add(keysList[i]);
      } else if (valuesList[i] == "Organiser") {
        organiserKey = keysList[i];
      }
    }
    return eventAttendingLength;
  }

  List<String> eventAttendingPhotoUrlLists = [];

  Future getUsersProfileUrl(BuildContext context) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    for (var key in eventAttendingKeysList) {
      var value = await mmyEngine!
          .getUserProfile(user: false, uid: key)
          .catchError((e) {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
      eventAttendingPhotoUrlLists.add(value.photoURL);
    }
    // print(eventAttendingLists);
    setState(ViewState.Idle);
  }

  Future getOrganiserProfileUrl(
      BuildContext context, String organiserUid) async {
    setState(ViewState.Busy);

    var value = await mmyEngine!
        .getUserProfile(user: false, uid: organiserUid)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    userDetail.profileUrl = value.photoURL;
    setState(ViewState.Idle);
  }

  Future replyToEvent(BuildContext context, String eid, String response,
      {bool idle = true}) async {
    updateValue(true);
    // mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine!.replyToEvent(eid, response: response).catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });

    idle == true ? updateValue(false) : updateValue(true);
    idle == true ? Navigator.of(context).pop() : Container();
  }

  imageStackLength(int length) {
    switch (length) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 3;
      case 4:
        return 4;
      case 5:
        return 5;
      case 6:
        return 6;
      default:
        return length <= 6 ? length : 6;
    }
  }

  deleteEvent(BuildContext context, String eid) async {
    setState(ViewState.Busy);

    await mmyEngine!.deleteEvent(eid).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    setState(ViewState.Idle);
    Navigator.of(context).pop();
  }

  // This function are used when we comes from calendar.
  eventModel.Event? event;

  bool eventValue = false;

  void updateEventValue(bool value) {
    eventValue = value;
    notifyListeners();
  }

  Future getEvent(BuildContext context, String eid) async {
    updateEventValue(true);

    getUsersProfileUrl(context);

    var value = await mmyEngine!.getEvent(eid).catchError((e) {
      updateEventValue(false);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      event = value;
      updateEventValue(false);
      eventDetail.eventBtnStatus = CommonEventFunction.getEventBtnStatus(
          event!, userDetail.cid.toString());
      eventDetail.textColor = CommonEventFunction.getEventBtnColorStatus(
          event!, userDetail.cid.toString());
      eventDetail.btnBGColor = CommonEventFunction.getEventBtnColorStatus(
          event!, userDetail.cid.toString(),
          textColor: false);
      eventDetail.eventMapData = event!.invitedContacts;
      eventDetail.organiserId = event!.organiserID;
      eventDetail.organiserName = event!.organiserName;
      eventGoingLength();
      getOrganiserProfileUrl(context, eventDetail.organiserId!);
      getUsersProfileUrl(context);
      setEventValuesForEdit(event!);
    } else {
      updateEventValue(false);
      DialogHelper.showMessage(context, "ERROR! something wrong.");
    }
  }

  setEventValuesForEdit(eventModel.Event event) {
    eventDetail.editEvent = true;
    eventDetail.eid = event.eid;
    eventDetail.photoUrlEvent = event.photoURL;
    eventDetail.eventName = event.title;
    eventDetail.startDateAndTime = event.start;
    eventDetail.endDateAndTime = event.end;
    eventDetail.eventLocation = event.location;
    eventDetail.eventDescription = event.description;
    eventDetail.event = event;
    List<String> valuesList = [];
    for (var value in event.invitedContacts.values) {
      valuesList.add(value);
    }
    List<String> keysList = [];
    for (var key in event.invitedContacts.keys) {
      keysList.add(key);
    }
    List<String> contactsKeys = [];
    for (int i = 0; i < keysList.length; i++) {
      if (valuesList[i] != "Organiser") {
        contactsKeys.add(keysList[i]);
      }
    }

    eventDetail.contactCIDs = contactsKeys;
  }

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  Future answersToEventQuestionnaire(
      BuildContext context, String eid, Map answers) async {
    updateValue(true);

    await mmyEngine!.answerEventForm(eid, answers: answers).catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });

    await replyToEvent(context, eid, EVENT_ATTENDING, idle: false);
    updateValue(false);
    Navigator.of(context).pop();
  }

  // Multi date~~~~~~~~~~~~~~~

  List<DateOption> multipleDate = [];
  bool getMultipleDate = false;

  void updateGetMultipleDate(bool value) {
    getMultipleDate = value;
    notifyListeners();
  }

  Future getMultipleDateOptionsFromEvent(BuildContext context, String eid,
      {bool onBtnClick = true}) async {
    onBtnClick ? updateGetMultipleDate(true) : updateStatusMultiDate(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    onBtnClick ? Navigator.of(context).pop() : Container();
    var value = await mmyEngine!.getDateOptionsFromEvent(eid).catchError((e) {
      onBtnClick ? updateGetMultipleDate(false) : updateStatusMultiDate(false);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      multipleDate = value;
      //  addMultiDateTimeValue(multipleDate);
      onBtnClick ? updateGetMultipleDate(false) : updateStatusMultiDate(false);
    }
  }

  clearMultiDateOption() {
    // clear multi date and time lists
    multipleDateOption.startDate.clear();
    //   multipleDateOption.endDate.clear();
    multipleDateOption.startTime.clear();
    multipleDateOption.endTime.clear();
    multipleDateOption.startDateTime.clear();
    multipleDateOption.endDateTime.clear();
  }

  bool attendDateBtnColor = false;
  String? selectedAttendDateDid;
  String? selectedAttendDateEid;
  int? selectedMultiDateIndex;

  bool answerMultiDate = false;

  updateMultiDate(bool value) {
    answerMultiDate = value;
    notifyListeners();
  }

  Future answerMultiDateOption(
      BuildContext context, String eid, String did, bool attend) async {
    updateMultiDate(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine!.answerDateOption(eid, did, attend).catchError((e) {
      updateMultiDate(false);
      DialogHelper.showMessage(context, e.message);
    });

    updateMultiDate(false);
  }

  bool statusMultiDate = false;

  updateStatusMultiDate(bool value) {
    statusMultiDate = value;
    notifyListeners();
  }

  Future dateOptionStatus(BuildContext context, String eid, String did) async {
    updateStatusMultiDate(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.dateOptionStatus(eid, did).catchError((e) {
      updateStatusMultiDate(false);
      DialogHelper.showMessage(context, e.message);
    });

    print(value);

    updateStatusMultiDate(false);
  }

  List<String> eidsOfMultiDateSelected = [];

  Future listOfDateSelected(BuildContext context, String eid) async {
    updateStatusMultiDate(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.listDateSelected(eid).catchError((e) {
      updateStatusMultiDate(false);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      eidsOfMultiDateSelected = value;
      updateStatusMultiDate(false);
    }
  }
}
