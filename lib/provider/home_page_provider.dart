import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/helper/dynamic_links_api.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/group_detail.dart';
import 'package:meetmeyou_app/models/multiple_date_option.dart';
import 'package:meetmeyou_app/models/push_notification.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/notification/firebase_notification.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/view/dashboard/dashboardPage.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePageProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  GroupDetail groupDetail = locator<GroupDetail>();
  EventDetail eventDetail = locator<EventDetail>();
  CalendarDetail calendarDetail = locator<CalendarDetail>();
  TabController? tabController;
  int selectedIndex = 0;
  Color textColor = ColorConstants.colorWhite;
  MultipleDateOption multipleDateOption = locator<MultipleDateOption>();
  DynamicLinksApi dynamicLinksApi = locator<DynamicLinksApi>();
  EventBus eventBus = locator<EventBus>();
  FirebaseNotification firebaseNotification = locator<FirebaseNotification>();

  bool _value = false;

  bool get value => _value;

  updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  tabChangeEvent(BuildContext context) {
    tabController?.addListener(() {
      getIndexChanging(context);
      notifyListeners();
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   eventBus.destroy();
  // }

  Future<void> getUserDetail(BuildContext context) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var userProfile = await mmyEngine!.getUserProfile().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    userDetail.cid = userProfile.uid;
    userDetail.email = userProfile.email;

    setState(ViewState.Idle);
  }

  List<Event> eventLists = [];

  bool refresh = false;

  updateRefresh(bool val){
    refresh = val;
    notifyListeners();
  }

  Future getUserEvents(BuildContext context, {List<String>? filters, bool refresh = false}) async {
   refresh == true ? updateRefresh(true) : setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =
        await mmyEngine!.getUserEvents(filters: filters).catchError((e) {
          refresh == true ? updateRefresh(false) : setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      refresh == true ? updateRefresh(false) : setState(ViewState.Idle);
      eventLists = value;
      eventLists.sort((a,b) {
        return a.start.compareTo(b.start);
      });
      getMultipleDate = List<bool>.filled(eventLists.length, false);
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

  getIndexChanging(BuildContext context, {bool refresh = false}) {
    switch (tabController!.index) {
      case 0:
        getUserEvents(context, refresh: refresh);
        break;

      case 1:
        getUserEvents(context, filters: ["Attending"], refresh: refresh);
        break;

      case 2:
        getUserEvents(context, filters: ["Not Attending"], refresh: refresh);
        break;

      case 3:
        getUserEvents(context, filters: ["Invited"], refresh: refresh);
        break;

      case 4:
      getPastEvents(context, refresh: refresh);
        break;

      case 5:
        getUserEvents(context, filters: ["Not Interested"], refresh: refresh);
        break;
    }
    notifyListeners();
  }

  Future replyToEvent(BuildContext context, String eid, String response,
      {bool idle = true}) async {
    setState(ViewState.Busy);

    await mmyEngine!.replyToEvent(eid, response: response).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    getIndexChanging(context);

    idle == true ? setState(ViewState.Idle) : setState(ViewState.Busy);
  }

  setEventValuesForEdit(Event event) {
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

  Future unRespondedEvents(
      BuildContext context, DashboardProvider dashboardProvider) async {
    setState(ViewState.Busy);

    eventDetail.unRespondedEvent1 =
        await mmyEngine!.unrespondedEvents().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (eventDetail.unRespondedEvent! >
        eventDetail.unRespondedEvent1!.toInt()) {
      dashboardProvider.updateEventNotificationCount();
    }
    setState(ViewState.Idle);
  }

  Future unRespondedEventsApi(BuildContext context) async {
    setState(ViewState.Busy);
    eventDetail.unRespondedEvent =
        await mmyEngine!.unrespondedEvents().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    setState(ViewState.Idle);
  }

  deleteEvent(BuildContext context, String eid) async {
    setState(ViewState.Busy);

    await mmyEngine!.deleteEvent(eid).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    getIndexChanging(context);

    setState(ViewState.Idle);
  }

  Future answersToEventQuestionnaire(
      BuildContext context, String eid, Map answers) async {
    setState(ViewState.Busy);

    await mmyEngine!.answerEventForm(eid, answers: answers).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    await replyToEvent(context, eid, EVENT_ATTENDING, idle: false);
    setState(ViewState.Idle);
  }

  // Multi date
  List<DateOption> multipleDate = [];
  late List<bool> getMultipleDate = [];

  void updateGetMultipleDate(bool value, int index) {
    getMultipleDate[index] = value;
    notifyListeners();
  }

  Future getMultipleDateOptionsFromEvent(
      BuildContext context, String eid, int index) async {
    updateGetMultipleDate(true, index);
      mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    Navigator.of(context).pop();
    var value = await mmyEngine!.getDateOptionsFromEvent(eid).catchError((e) {
      updateGetMultipleDate(false, index);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      multipleDate = value;
      //  addMultiDateTimeValue(multipleDate);
      updateGetMultipleDate(false, index);
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

  // for chat notification badge count
  bool updatedDiscussion = false;

  updateDiscussion(bool val){
    updatedDiscussion = val;
    notifyListeners();
  }

  int? chatNotificationCount;

  Future updatedDiscussions(BuildContext context) async{
    updateDiscussion(true);

    var value = await mmyEngine!.updatedDiscussions().catchError((e){
      updateDiscussion(false);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    if(value != null){
      chatNotificationCount = value;
      updateDiscussion(false);
    }
  }

  // this is used when user sign up with apple login
  bool? checkAppleLoginFilledProfile;

  bool checkFilled = true;

  updateCheckFilled(bool val){
    checkFilled = val;
    notifyListeners();
  }

  Future checkFilledProfile(BuildContext context) async{
    updateCheckFilled(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.filledProfile().catchError((e){
      updateCheckFilled(false);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    if(value != null){
      checkAppleLoginFilledProfile = value;
      updateCheckFilled(false);
    }
  }


  // get past events
  //List<Event> pastEvents = [];
  bool pastEvent = true;

  updatePastEvent(bool val){
    pastEvent = val;
    notifyListeners();
  }

  Future getPastEvents(BuildContext context, {bool refresh = false}) async{
   refresh == true ? updatePastEvent(true) : setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getPastEvents().catchError((e){
      refresh == true ?  updatePastEvent(false) : setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    if(value != null){
      eventLists = [];
      eventLists = value;
      eventLists.sort((a,b) {
        return a.start.compareTo(b.start);
      });
      getMultipleDate = List<bool>.filled(eventLists.length, false);
      refresh == true ?  updatePastEvent(false) : setState(ViewState.Idle);
    }
  }

  // for checking whether any multi date date is selected or not.
  // bool statusMultiDate = false;
  //
  // updateStatusMultiDate(bool value) {
  //   statusMultiDate = value;
  //   notifyListeners();
  // }
  //
  // List<String> didsOfMultiDateSelected = [];
  //
  // Future listOfDateSelected(BuildContext context, String eid) async {
  //   updateStatusMultiDate(true);
  //   mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
  //
  //   var value = await mmyEngine!.listDateSelected(eid).catchError((e) {
  //     updateStatusMultiDate(false);
  //     DialogHelper.showMessage(context, e.message);
  //   });
  //
  //   if (value != null) {
  //     didsOfMultiDateSelected = value;
  //     updateStatusMultiDate(false);
  //   }
  // }

  // bool attendDateBtnColor = false;
  // String? selectedAttendDateDid;
  // String? selectedAttendDateEid;
  // int? selectedMultiDateIndex;

  // bool answerMultiDate = false;
  //
  // updateMultiDate(bool value) {
  //   answerMultiDate = value;
  //   notifyListeners();
  // }
  //
  // Future answerMultiDateOption(
  //     BuildContext context, String eid, String did) async {
  //   updateMultiDate(true);
  //   mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
  //
  //   await mmyEngine!.answerDateOption(eid, did, true).catchError((e) {
  //     updateMultiDate(false);
  //     DialogHelper.showMessage(context, e.message);
  //   });
  //
  //   updateMultiDate(false);
  // }
}
