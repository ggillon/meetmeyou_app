import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class ContactsProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  List<Contact> _confirmContactList = [];

  List<Contact> get confirmContactList => _confirmContactList;

  set confirmContactList(List<Contact> value) {
    _confirmContactList = value;
  }

  List<Contact> _invitationContactList = [];

  List<Contact> get invitationContactList => _invitationContactList;

  set invitationContactList(List<Contact> value) {
    _invitationContactList = value;
  }

  bool _value = false;

  bool get value => _value;

  void updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  getConfirmedContactsAndInvitationsList(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var invitationValue =
        await mmyEngine!.getContacts(invitations: true).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    var confirmValue =
        await mmyEngine!.getContacts(confirmedContacts: true).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (invitationValue != null && confirmValue != null) {
      setState(ViewState.Idle);
      invitationContactList = invitationValue;
      confirmContactList = confirmValue;
    } else {
      setState(ViewState.Idle);
    }
    notifyListeners();
  }

  List<Contact> sortContactList() {
    confirmContactList.sort();
    return confirmContactList;
  }

  List<String> _myContactListName = [
    'jenny wilson',
    'Robert fox',
    'Elenor pena',
    "Bessie cooper",
    "Danny bill",
    "sachin kalra",
    "Rohit kumar",
    "Bhavneet",
    "Pardeep",
    "Sahil",
    "Chetan",
    "Tarun",
    "Sagar",
    "Kanwar Sharma",
    "Mohit",
    "Divesh",
    "Lucky",
    "Sandeep",
    "vikas",
    "Annie",
    "shivam",
    "justin"
  ];

  List<String> get myContactListName => _myContactListName;

  List<String> sortList() {
    _myContactListName = _myContactListName
        .map((_myContactListName) => _myContactListName.toLowerCase())
        .toList();
    _myContactListName.sort();
    return _myContactListName;
  }
}
