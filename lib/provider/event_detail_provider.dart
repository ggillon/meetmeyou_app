import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/helper/dynamic_links_api.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/announcement_detail.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/discussion_detail.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
  DynamicLinksApi dynamicLinksApi = locator<DynamicLinksApi>();
  DiscussionDetail discussionDetail = locator<DiscussionDetail>();
  AnnouncementDetail announcementDetail = locator<AnnouncementDetail>();

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

  bool mayBeEventDeleted = false;

  Future getEvent(BuildContext context, String eid) async {
    updateEventValue(true);

    getUsersProfileUrl(context);

    var value = await mmyEngine!.getEvent(eid).catchError((e) {
      updateEventValue(false);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    if (value != null) {
      event = value;
      eventDetail.eventBtnStatus = (event!.eventType == EVENT_TYPE_PRIVATE
          ? CommonEventFunction.getEventBtnStatus(
          event!, auth.currentUser!.uid)
          : CommonEventFunction.getAnnouncementBtnStatus(
          event!, auth.currentUser!.uid));
      eventDetail.textColor = CommonEventFunction.getEventBtnColorStatus(
          event!, auth.currentUser!.uid);
      eventDetail.btnBGColor = CommonEventFunction.getEventBtnColorStatus(
          event!, auth.currentUser!.uid,
          textColor: false);
      eventDetail.eventMapData = event!.invitedContacts;
      eventDetail.organiserId = event!.organiserID;
      eventDetail.organiserName = event!.organiserName;
      eventGoingLength();
      getOrganiserProfileUrl(context, eventDetail.organiserId!);
      getUsersProfileUrl(context);
      setEventValuesForEdit(event!);
      await getEventParam(context, eventDetail.eid.toString(), "discussion", false);
      await getEventParam(context, eventDetail.eid.toString(), "photoAlbum", true);
      eventDetail.organiserId == auth.currentUser?.uid ? Container() : getOrganiserContact(context);

        eventDetail.event = event!;
        eventDetail.event?.multipleDates == true
            ? getMultipleDateOptionsFromEvent(
            context, eventDetail.eid!,
            onBtnClick: false)
            : Container();
        eventDetail.event?.multipleDates == true
            ? listOfDateSelected(context, eventDetail.eid!).then((value) {
        })
            : Container();
        if(calendarDetail.fromDeepLink == true){
          eventDetail.eventBtnStatus = "respond";
          eventDetail.btnBGColor = ColorConstants.primaryColor;
          eventDetail.textColor = ColorConstants.colorWhite;
        }
    updateEventValue(false);
    } else {
      updateEventValue(false);
      mayBeEventDeleted = true;
      DialogHelper.showMessage(context, "error_message".tr());
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
    setContactKeys(event);
  }

  setContactKeys(eventModel.Event event){
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
    multipleDateOption.endDate.clear();
    multipleDateOption.startTime.clear();
    multipleDateOption.endTime.clear();
    multipleDateOption.startDateTime.clear();
    multipleDateOption.endDateTime.clear();
    multipleDateOption.invitedContacts.clear();
    multipleDateOption.eventAttendingPhotoUrlLists.clear();
    multipleDateOption.eventAttendingKeysList.clear();
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

  List<String> didsOfMultiDateSelected = [];

  Future listOfDateSelected(BuildContext context, String eid) async {
    updateStatusMultiDate(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.listDateSelected(eid).catchError((e) {
      updateStatusMultiDate(false);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      didsOfMultiDateSelected = value;
      updateStatusMultiDate(false);
    }
  }


  bool deepLink = false;

  updateDeepLink(bool val){
    deepLink = val;
    notifyListeners();
  }

  Future inviteUrl(BuildContext context, var eid) async {
    updateDeepLink(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine!.inviteURL(eid).catchError((e) {
      updateDeepLink(false);
    });

    updateDeepLink(false);
  }

  //  Future<void> openMap(BuildContext context, double latitude, double longitude) async {
  //   String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  //   if (await canLaunch(googleUrl)) {
  //     await launch(googleUrl);
  //   } else {
  //     DialogHelper.showMessage(context, "could_not_open_map".tr());
  //   }
  // }

  launchMap(BuildContext context, lat, lng) async {
    if (Platform.isAndroid) {
      var url = "https://www.google.com/maps/search/?api=1&query=${lat},${lng}";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        DialogHelper.showMessage(context, "could_not_open_map".tr());
      }
    } else {
      var urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      //  url = "comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving";
      if (await canLaunch(urlAppleMaps)) {
        await launch(urlAppleMaps);
      } else {
        DialogHelper.showMessage(context, "could_not_open_map".tr());
      }
    }
  }

  // for organiser card
  Contact? organiserContact;
  bool contact = false;

  updateGetContact(bool val){
    contact = val;
    notifyListeners();
  }

  Future getOrganiserContact(BuildContext context) async{
    updateGetContact(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
  var value =  await mmyEngine!.getContactFromProfile(eventDetail.organiserId.toString()).catchError((e){
      updateGetContact(false);
      DialogHelper.showMessage(context, "Organiser fetching error!");
    });

  if(value != null){
    organiserContact = value;
    updateGetContact(false);
  } else{
    DialogHelper.showMessage(context, "Organiser fetching error!");
  }

  }

  setContactsValue() {
    userDetail.firstName = organiserContact?.firstName;
    userDetail.lastName = organiserContact?.lastName;
    userDetail.email = organiserContact?.email;
    userDetail.profileUrl = organiserContact?.photoURL;
    userDetail.phone = organiserContact?.phoneNumber;
    userDetail.countryCode = organiserContact?.countryCode;
    userDetail.address = organiserContact?.addresses['Home'];
    userDetail.checkForInvitation = false;
   // userDetail.cid = cid;
  }

  /// Get event parameter
  // this fun is used to check photo gallery or discussion switch whether on or off.
  bool photoGalleryEnable = false;
  bool discussionEnable = false;
  bool getParam = false;

  updateGetParam(bool val){
    getParam = val;
    notifyListeners();
  }

  Future getEventParam(BuildContext context, String eid, String param, bool photoGallery) async{
    updateGetParam(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =  await mmyEngine!.getEventParam(eid, param: param).catchError((e) {
      updateGetParam(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      if(photoGallery){
        photoGalleryEnable = value;
      } else{
        discussionEnable = value;
      }
      updateGetParam(false);
    }

  }


  setEventValuesForAnnouncementEdit(Event event) {
    announcementDetail.editAnnouncement = true;
    announcementDetail.announcementId = event.eid;
    announcementDetail.announcementPhotoUrl = event.photoURL;
    announcementDetail.announcementTitle = event.title;
    announcementDetail.announcementStartDateAndTime = event.start;
    announcementDetail.announcementLocation = event.location;
    announcementDetail.announcementDescription = event.description;
}
}
