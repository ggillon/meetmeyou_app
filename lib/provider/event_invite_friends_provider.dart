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

  bool _toggleValue = false;

  bool get toggleValue => _toggleValue;

  void updateToggleValue(bool value) {
    _toggleValue = value;
    notifyListeners();
  }

  bool _searchValue = false;

  bool get searchValue => _searchValue;

  void updateSearchValue(bool value) {
    _searchValue = value;
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

      //isGroupChecked = List<bool>.filled(groupList.length, false);
    } else {
      setState(ViewState.Idle);
    }
  }

  // for event invite friends
//  List<Contact>? eventInviteFriendsList = [];
  List<String>? contactCIDs = [];
  List<String> groupIndexList = [];
  List<Contact> checkGroupList = [];
 // List<String> groupCidList = [];

  bool contactCheckIsSelected(Contact contact) {
    var value = contactCIDs?.any((element) => element == contact.cid);
    return value!;
  }

  bool groupCheckIsSelected(Contact groupData, int index) {
    // List<String> keysList = [];
    // for (var key in groupData.group.keys) {
    //   keysList.add(key);
    // }
    // bool? val;
    // for (int i = 0; i < keysList.length; i++) {
    //   var value = groupCidList.any((element) => element == keysList[i]);
    //   val = value;
    // }
    //
    // return val!;
    var value = groupIndexList.any((element) => element == index.toString());
    return value;
  }

  Future inviteContactsToEvent(BuildContext context, List<String>? CIDs) async {
    updateValue(true);

    mmyEngine!
        .inviteContactsToEvent(eventDetail.eid.toString(), CIDs: CIDs ?? [])
        .catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });

    updateValue(false);
    Navigator.of(context).pop();
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

  addContactToGroupCidList(List<String> keysList, int index, Contact groupContact) {
    groupIndexList.add(index.toString());
    checkGroupList.add(groupContact);
  //  groupCidList.addAll(keysList);
    notifyListeners();
  }

  removeContactFromGroupCidList(List<String> keysList, int ind, Contact groupContact) {
    var index =
        groupIndexList.indexWhere((element) => element == ind.toString());
    groupIndexList.removeAt(index);
    checkGroupList.remove(groupContact);
  //  groupCidList.remove(keysList);
    notifyListeners();
  }

// late List<bool> _isGroupChecked;
//
// List<bool> get isGroupChecked => _isGroupChecked;
//
// set isGroupChecked(List<bool> value) {
//   _isGroupChecked = value;
// }
//
// setGroupCheckBoxValue(bool value, int index) {
//   _isGroupChecked[index] = value;
//   notifyListeners();
// }
}
