import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/discussion_detail.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/search_result.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/provider/home_page_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class CustomSearchDelegateProvider extends BaseProvider{

  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  DiscussionDetail discussionDetail = locator<DiscussionDetail>();
  HomePageProvider homePageProvider = locator<HomePageProvider>();
  EventDetail eventDetail = locator<EventDetail>();
  CalendarDetail calendarDetail = locator<CalendarDetail>();
  SearchResult? searchList;
  List<Contact> contactsList = [];
  List<Event> eventLists = [];

  /// Search
  Future search(BuildContext context, String searchText) async{
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
  var value =  await mmyEngine?.search(searchText).catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

  if(value != null){
    searchList = value;
    contactsList = searchList!.contacts;
    eventLists = searchList!.events;
    getMultipleDate = List<bool>.filled(eventLists.length, false);
    setState(ViewState.Idle);
  }

  }

  setContactsValue(Contact contact) {
    userDetail.firstName = contact.firstName;
    userDetail.lastName = contact.lastName;
    userDetail.email = contact.email;
    userDetail.profileUrl = contact.photoURL;
    userDetail.phone = contact.phoneNumber;
    userDetail.countryCode = contact.countryCode;
    userDetail.address = contact.addresses['Home'];
    userDetail.checkForInvitation = false;
  }

  Future replyToEvent(BuildContext context, String eid, String response, {bool idle = true}) async {
    setState(ViewState.Busy);

    await mmyEngine!.replyToEvent(eid, response: response).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

  //  getUserEvents(context);
    Navigator.of(context).pop();
    unRespondedEventsApi(context);

    idle == true ?  setState(ViewState.Idle) : setState(ViewState.Busy);
  }

  Future deleteEvent(BuildContext context, String eid) async {
    setState(ViewState.Busy);

    await mmyEngine!.deleteEvent(eid).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    Navigator.of(context).pop();

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

  late List<bool> getMultipleDate = [];

  void updateGetMultipleDate(bool value, int index) {
    getMultipleDate[index] = value;
    notifyListeners();
  }

}