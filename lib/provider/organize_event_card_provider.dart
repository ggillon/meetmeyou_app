import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/multiple_date_option.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/provider/home_page_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class OrganizeEventCardProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  EventDetail eventDetail = locator<EventDetail>();
  CalendarDetail calendarDetail = locator<CalendarDetail>();
  DashboardProvider dashboardProvider = locator<DashboardProvider>();
  HomePageProvider homePageProvider = locator<HomePageProvider>();
  List<Event> eventLists = [];
  MultipleDateOption multipleDateOption = locator<MultipleDateOption>();

  Future getUserEvents(BuildContext context, {List<String>? filters}) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =
    await mmyEngine!.getUserEvents(filters: filters).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      setState(ViewState.Idle);
      eventLists = value;
      eventDetail.eventListLength = eventLists.length;
      getMultipleDate = List<bool>.filled(eventLists.length, false);
    }
  }

  Future replyToEvent(BuildContext context, String eid, String response, {bool idle = true}) async {
    setState(ViewState.Busy);

    await mmyEngine!.replyToEvent(eid, response: response).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    getUserEvents(context);
    unRespondedEventsApi(context);

    idle == true ?  setState(ViewState.Idle) : setState(ViewState.Busy);
  }

  Future deleteEvent(BuildContext context, String eid) async {
    setState(ViewState.Busy);

    await mmyEngine!.deleteEvent(eid).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    getUserEvents(context);

    setState(ViewState.Idle);
  }

  Future answersToEventQuestionnaire(BuildContext context, String eid, Map answers) async{
    setState(ViewState.Busy);

    await mmyEngine!.answerEventForm(eid, answers: answers).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    await replyToEvent(context, eid, EVENT_ATTENDING, idle: false);
    setState(ViewState.Idle);
  }

  Future unRespondedEventsApi(BuildContext context) async {
    setState(ViewState.Busy);
    eventDetail.unRespondedEvent1 = await mmyEngine!.unrespondedEvents().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

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