import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/models/event.dart' as eventModel;

class ChooseEventProvider extends BaseProvider {
  MMYEngine? mmyEngine;
 // UserDetail userDetail = locator<UserDetail>();
  CalendarDetail calendarDetail = locator<CalendarDetail>();
  EventDetail eventDetail = locator<EventDetail>();
 // eventModel.Event? event;
  // bool eventValue = false;
  //
  // void updateEventValue(bool value) {
  //   eventValue = value;
  //   notifyListeners();
  // }
  //
  // Future getEvent(BuildContext context, String eid) async {
  //   updateEventValue(true);
  //   mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
  //
  //   var value = await mmyEngine!.getEvent(eid).catchError((e) {
  //     updateEventValue(false);
  //     DialogHelper.showMessage(context, e.message);
  //   });
  //
  //   if (value != null) {
  //     event = value;
  //     updateEventValue(false);
  //     eventDetail.eventBtnStatus = CommonEventFunction.getEventBtnStatus(
  //         event!, userDetail.cid.toString());
  //     eventDetail.textColor = CommonEventFunction.getEventBtnColorStatus(
  //         event!, userDetail.cid.toString());
  //     eventDetail.btnBGColor = CommonEventFunction.getEventBtnColorStatus(
  //         event!, userDetail.cid.toString(),
  //         textColor: false);
  //     eventDetail.eventMapData = event!.invitedContacts;
  //     setEventValuesForEdit(event!);
  //     Navigator.pushNamed(context, RoutesConstants.eventDetailScreen,
  //         arguments: event).then((value) {
  //           Navigator.of(context).pop();
  //     });
  //   } else {
  //     DialogHelper.showMessage(context, "ERROR! something wrong.");
  //   }
  // }
  //
  // setEventValuesForEdit(eventModel.Event event) {
  //   eventDetail.editEvent = true;
  //   eventDetail.eid = event.eid;
  //   eventDetail.photoUrlEvent = event.photoURL;
  //   eventDetail.eventName = event.title;
  //   eventDetail.startDateAndTime = event.start;
  //   eventDetail.endDateAndTime = event.end;
  //   eventDetail.eventLocation = event.location;
  //   eventDetail.eventDescription = event.description;
  //   eventDetail.event = event;
  //   List<String> valuesList = [];
  //   for (var value in event.invitedContacts.values) {
  //     valuesList.add(value);
  //   }
  //   List<String> keysList = [];
  //   for (var key in event.invitedContacts.keys) {
  //     keysList.add(key);
  //   }
  //   List<String> contactsKeys = [];
  //   for (int i = 0; i < keysList.length; i++) {
  //     if (valuesList[i] != "Organiser") {
  //       contactsKeys.add(keysList[i]);
  //     }
  //   }
  //
  //   eventDetail.contactCIDs = contactsKeys;
  // }
}
