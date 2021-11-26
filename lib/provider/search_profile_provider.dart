import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class SearchProfileProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  bool searchValue = false;

  List<Contact> _searchContactList = [];

  set searchContactList(List<Contact> value) {
    _searchContactList = value;
  }

  List<Contact> get searchContactList => _searchContactList;

  bool _value = false;

  bool get value => _value;

  void updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  getSearchContacts(BuildContext context, String searchText) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value = await mmyEngine!.searchProfiles(searchText).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      setState(ViewState.Idle);
      searchContactList = value;
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
}
