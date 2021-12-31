import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/group_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class GroupContactsProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  GroupDetail groupDetail = locator<GroupDetail>();
  List<String> _checklist = [];

  List<String> get checklist => _checklist;

  late List<bool> _value = [];

  List<bool> get value => _value;

  set value(List<bool> value) {
    _value = value;
  }

  void updateValue(bool value, int index) {
    _value[index] = value;
    notifyListeners();
  }

  // confirm contact list
  List<Contact> _confirmContactList = [];

  List<Contact> get confirmContactList => _confirmContactList;

  set confirmContactList(List<Contact> value) {
    _confirmContactList = value;
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
      value = List<bool>.filled(confirmContactList.length, false);
    } else {
      setState(ViewState.Idle);
    }
  }

  addContactsToGroup(
      BuildContext context, String groupCID, Contact contact, int index) async {
    updateValue(true, index);
    await mmyEngine!
        .addContactsToGroup(groupCID, contactCID: contact.cid)
        .catchError((e) {
      updateValue(false, index);
      DialogHelper.showMessage(context, e.message);
    });
    groupDetail.groupConfirmContactList?.add((contact));
    groupDetail.groupConfirmContactList?.sort((a, b) {
      return a.displayName
          .toString()
          .toLowerCase()
          .compareTo(b.displayName.toString().toLowerCase());
    });
    groupDetail.membersLength =
        groupDetail.groupConfirmContactList?.length.toString();
    updateValue(false, index);
    notifyListeners();
  }

  removeContactsFromGroup(BuildContext context, String groupCID,
      Contact contact, int currentIndex) async {
    updateValue(true, currentIndex);
    await mmyEngine!
        .removeContactsFromGroup(groupCID, contactCID: contact.cid)
        .catchError((e) {
      updateValue(false, currentIndex);
      DialogHelper.showMessage(context, e.message);
    });
    var index = groupDetail.groupConfirmContactList
        ?.indexWhere((element) => element.cid == contact.cid);
    groupDetail.groupConfirmContactList?.removeAt(index!);
    groupDetail.groupConfirmContactList?.sort((a, b) {
      return a.displayName
          .toString()
          .toLowerCase()
          .compareTo(b.displayName.toString().toLowerCase());
    });
    groupDetail.membersLength =
        groupDetail.groupConfirmContactList?.length.toString();
    updateValue(false, currentIndex);
    notifyListeners();
  }

  bool checkIsSelected(Contact contact) {
    var value = groupDetail.groupConfirmContactList
        ?.any((element) => element.cid == contact.cid);
    return value!;
  }
}
