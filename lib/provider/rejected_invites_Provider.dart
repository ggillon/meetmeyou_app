import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class RejectedInvitesProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  List<Contact> _rejectedContactList = [];

  List<Contact> get rejectedContactList => _rejectedContactList;

  set rejectedContactList(List<Contact> value) {
    _rejectedContactList = value;
  }

  bool _value = false;

  bool get value => _value;

  void updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  getRejectedInvitesList(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value =
        await mmyEngine!.getContacts(rejectedContacts: true).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (value != null) {
      setState(ViewState.Idle);
      _rejectedContactList = value;
    } else {
      setState(ViewState.Idle);
    }
    notifyListeners();
  }

  List<Contact> sortRejectedContactList() {
    rejectedContactList.sort();
    return rejectedContactList;
  }
}
