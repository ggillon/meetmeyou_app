import 'package:device_calendar/device_calendar.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/calendar_event.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:meetmeyou_app/models/event.dart' as eventModel;

class CalendarProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  CalendarDetail calendarDetail = locator<CalendarDetail>();
  EventDetail eventDetail = locator<EventDetail>();
  List<CalendarEvent> deviceCalendarEvent = [];

//  eventModel.Event? event;
  bool calendar = true;

  bool iconValue = false;

  void updateIconValue(bool value) {
    iconValue = value;
    notifyListeners();
  }

  List<CalendarEvent> calendarEventDevice = [];
  List<CalendarEvent> calendarEventMeetMeYou = [];
  List<CalendarEvent> calendarEvent = [];

  Future getCalendarEvents(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getCalendarEvents(context).catchError((e) {
      setState(ViewState.Idle);
      //  DialogHelper.showMessage(context, "enable_calendar_permission".tr());
      CommonWidgets.errorDialog(context, "enable_calendar_permission".tr());
    });
    if (value != null) {
      deviceCalendarEvent = value;
      deviceCalendarEvent.sort((a, b) {
        return a.start.compareTo(b.start);
      });
      setState(ViewState.Idle);
    } else {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "enable_calendar_permission".tr());
    }
  }

  bool val = false;

  updateValue(bool value) {
    val = value;
    notifyListeners();
  }

  Future unRespondedEventsApi(BuildContext context) async {
    updateValue(true);
    eventDetail.unRespondedEvent1 =
        await mmyEngine!.unrespondedEvents().catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });

    updateValue(false);
  }

// bool eventValue = false;
//
// void updateEventValue(bool value) {
//   eventValue = value;
//   notifyListeners();
// }
//
// Future getEvent(BuildContext context, String eid) async {
//   updateEventValue(true);
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
//     // Navigator.pushNamed(context, RoutesConstants.eventDetailScreen,
//     //         arguments: event)
//     //     .then((value) {
//     //   deviceCalendarEvent = [];
//     //   getCalendarEvents(context);
//     // });
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
