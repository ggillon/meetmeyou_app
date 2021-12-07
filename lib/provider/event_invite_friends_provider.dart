import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class EventInviteFriendsProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();
  int toggle = 0;

  bool _value = false;

  bool get value => _value;

  void updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  // confirm contact list
  List<Contact> _confirmContactList = [];

  List<Contact> get confirmContactList => _confirmContactList;

  set confirmContactList(List<Contact> value) {
    _confirmContactList = value;
  }

  // Groups list
  List<Contact> _groupList = [];

  List<Contact> get groupList => _groupList;

  set groupList(List<Contact> value) {
    _groupList = value;
  }

  getConfirmedContactsList(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var confirmValue =
        await mmyEngine!.getContacts(confirmedContacts: true).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (confirmValue != null) {
      setState(ViewState.Idle);
      confirmValue.sort((a, b) {
        return a.displayName
            .toString()
            .toLowerCase()
            .compareTo(b.displayName.toString().toLowerCase());
      });
      confirmContactList = confirmValue;
    } else {
      setState(ViewState.Idle);
    }
  }

  getGroupList(BuildContext context) async {
    setState(ViewState.Busy);

    var groupValue = await mmyEngine!.getContacts(groups: true).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (groupValue != null) {
      setState(ViewState.Idle);
      groupValue.sort((a, b) {
        return a.displayName
            .toString()
            .toLowerCase()
            .compareTo(b.displayName.toString().toLowerCase());
      });

      groupList = groupValue;

      isGroupChecked = List<bool>.filled(groupList.length, false);
    } else {
      setState(ViewState.Idle);
    }
  }

  // for event invite friends
//  List<Contact>? eventInviteFriendsList = [];
  List<String>? contactCIDs = [];

  bool checkIsSelected(Contact contact) {
    var value = contactCIDs?.any((element) => element == contact.cid);
    return value!;
  }

  Future inviteContactsToEvent(BuildContext context, List<String>? CIDs) async {
    updateValue(true);

    mmyEngine!.inviteContactsToEvent(eventDetail.eid.toString(),
        CIDs: CIDs ?? []).catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });

    updateValue(false);
    Navigator.of(context).pop();
  }

  Future removeContactsFromEvent(BuildContext context, List<String> CIDs) async {
    updateValue(true);

    mmyEngine!.removeContactsFromEvent(eventDetail.eid.toString(),
        CIDs: []).catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });

    updateValue(false);
  }

  addContactToContactCIDList(Contact contact) {
    //   eventInviteFriendsList?.add(contact);
    contactCIDs?.add(contact.cid);
    notifyListeners();
  }

  removeContactFromContactCIDList(Contact contact) {
    var index = contactCIDs?.indexWhere((element) => element == contact.cid);
    //  eventInviteFriendsList?.removeAt(index!);
    contactCIDs?.removeAt(index!);
    notifyListeners();
  }

  late List<bool> _isGroupChecked;

  List<bool> get isGroupChecked => _isGroupChecked;

  set isGroupChecked(List<bool> value) {
    _isGroupChecked = value;
  }

  setGroupCheckBoxValue(bool value, int index) {
    _isGroupChecked[index] = value;
    notifyListeners();
  }
}
