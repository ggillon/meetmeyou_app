import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class GroupContactsProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  List<String> _checklist = [];

  List<String> get checklist => _checklist;

  bool _value = false;

  bool get value => _value;

  void updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  late List<bool> _isChecked;

  List<bool> get isChecked => _isChecked;

  set isChecked(List<bool> value) {
    _isChecked = value;
  }

  setCheckBoxValue(bool value, int index) {
    _isChecked[index] = value;
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
      isChecked = List<bool>.filled(confirmContactList.length, false);
    } else {
      setState(ViewState.Idle);
    }
  }

  addContactsToGroup(
      BuildContext context, String groupCID, String contactCId) async {
    updateValue(true);

    await mmyEngine!
        .addContactsToGroup(groupCID, contactCID: contactCId)
        .catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });
    updateValue(false);
  }

  removeContactsFromGroup(
      BuildContext context, String groupCID, String contactCId) async {
    updateValue(true);

    await mmyEngine!
        .removeContactsFromGroup(groupCID, contactCID: contactCId)
        .catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });
    updateValue(false);
  }
}
