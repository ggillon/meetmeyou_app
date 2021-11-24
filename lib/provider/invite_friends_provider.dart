import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:permission_handler/permission_handler.dart';

class InviteFriendsProvider extends BaseProvider {
  MMYEngine? mmyEngine;

  List<Contact> _contactList = [];

  set contactList(List<Contact> value) {
    _contactList = value;
  }

  List<Contact> get contactList => _contactList;

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
      DialogHelper.showMessage(context, e.message);
    });
    if (await Permission.contacts.request().isDenied) {
      setState(ViewState.Idle);
      return errorDialog(context, 'Please allow contacts access');
    } else if (await Permission.contacts.request().isPermanentlyDenied) {
      setState(ViewState.Idle);
      return errorDialog(
          context,
          'Please enable contacts access '
          'permission in system settings');
    } else if (value.isNotEmpty) {
      setState(ViewState.Idle);
      contactList = value;
      isChecked = List<bool>.filled(contactList.length, false);
    } else {
      setState(ViewState.Idle);
    }
    notifyListeners();
  }

  List<Contact> sortContactList() {
    contactList.sort();
    return contactList;
  }

  errorDialog(BuildContext context, String content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('Permissions error'),
              content: Text(content),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }
}
