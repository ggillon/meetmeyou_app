import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/discussion_detail.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class EventAttendingProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();
  UserDetail userDetail = locator<UserDetail>();
  DiscussionDetail discussionDetail = locator<DiscussionDetail>();

  bool _value = false;

  bool get value => _value;

  updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  bool _searchValue = false;

  bool get searchValue => _searchValue;

  void updateSearchValue(bool value) {
    _searchValue = value;
    notifyListeners();
  }

  List<Contact> eventAttendingLists = [];
  List<Contact> eventNotAttendingLists = [];
  List<Contact> eventInvitedLists = [];

  Future getContactsFromProfile(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    for(var element in eventDetail.attendingProfileKeys!){
      var value = await mmyEngine!
          .getContactFromProfile(element)
          .catchError((e) async {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
      if (value != null) {
        eventAttendingLists.add(value);
      }
    }
    for(var element in eventDetail.nonAttendingProfileKeys){
      var value = await mmyEngine!
          .getContactFromProfile(element)
          .catchError((e) async {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
      if (value != null) {
        eventNotAttendingLists.add(value);
      }
    }
    for(var element in eventDetail.invitedProfileKeys){
      var value = await mmyEngine!
          .getContactFromProfile(element)
          .catchError((e) async {
        setState(ViewState.Idle);
        DialogHelper.showMessage(context, e.message);
      });
      if (value != null) {
        eventInvitedLists.add(value);
      }
    }
    var value = await mmyEngine!
        .getContactFromProfile(eventDetail.organiserId.toString())
        .catchError((e) async {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (value != null) {
      eventAttendingLists.add(value);
    }
    setState(ViewState.Idle);
  }

  Future removeContactsFromEvent(BuildContext context, String CID) async {
    setState(ViewState.Busy);

    await mmyEngine!.removeContactsFromEvent(eventDetail.eid.toString(),
        CIDs: [CID]).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    eventDetail.attendingProfileKeys?.remove(CID);
    eventAttendingLists.clear();
    await getContactsFromProfile(context);

    if (eventAttendingLists.length == 0) {
      setState(ViewState.Idle);
      Navigator.of(context).pop();
    } else {
      setState(ViewState.Idle);
    }
  }

  inviteProfile(BuildContext context, Contact contact) async {
    updateValue(true);

    await mmyEngine!.inviteProfile(contact.cid).catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });
    contact.status = 'Invited contact';
    updateValue(false);
    DialogHelper.showMessage(context, "Invitation send Successfully");
  }

  setContactsValue(Contact contact, bool value) {
    userDetail.firstName = contact.firstName;
    userDetail.lastName = contact.lastName;
    userDetail.email = contact.email;
    userDetail.profileUrl = contact.photoURL;
    userDetail.phone = contact.phoneNumber;
    userDetail.countryCode = contact.countryCode;
    userDetail.address = contact.addresses['Home'];
    userDetail.checkForInvitation = value;
 //   userDetail.cid = cid;
  }

  bool allowNonAttendingOrInvited = false;
  bool getParam = false;

  updateGetParam(bool val){
    getParam = val;
    notifyListeners();
  }

  Future getEventParam(BuildContext context, String eid, String param) async{
    updateGetParam(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =  await mmyEngine!.getEventParam(eid, param: param).catchError((e) {
      updateGetParam(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      allowNonAttendingOrInvited = value;
      updateGetParam(false);
    }

  }
}
