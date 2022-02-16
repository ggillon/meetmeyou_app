import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart' as phone;

class InviteFriendsProvider extends BaseProvider {
  MMYEngine? mmyEngine;

  List<Contact> _contactList = [];

  set contactList(List<Contact> value) {
    _contactList = value;
  }

  List<Contact> get contactList => _contactList;

  List<Contact> checkedContactList = [];

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

  //String errorMsg = "Please allow contacts access";

  Future<void> getPhoneContacts(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value = await mmyEngine!.getPhoneContacts().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "Error! while fetching contacts.");
    });
    if (await Permission.contacts.request().isDenied) {
      setState(ViewState.Idle);
      return CommonWidgets.errorDialog(context, 'allow_contact_access'.tr());
    } else if (await Permission.contacts.request().isPermanentlyDenied) {
      setState(ViewState.Idle);
      return CommonWidgets.errorDialog(
          context,
          'enable_contact_access_permission'.tr());
    } else if (value != null) {
      setState(ViewState.Idle);
      value.sort((a, b) {
        return a.displayName
            .toString()
            .toLowerCase()
            .compareTo(b.displayName.toString().toLowerCase());
      });
      contactList = value;
      isChecked = List<bool>.filled(contactList.length, false);
    } else {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "Error! while fetching contacts.");
    }
  }


  Future onTapInviteBtn(BuildContext context) async {
    updateValue(true);
    await mmyEngine!.invitePhoneContacts(checkedContactList).catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });
    updateValue(false);
    Navigator.of(context).pop();
    DialogHelper.showMessage(context, "Invited Successfully");

  }
}
