import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class RejectedInvitesProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
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
      value.sort((a, b) {
        return a.displayName.toString().toLowerCase().compareTo(b.displayName.toString().toLowerCase());
      });
      _rejectedContactList = value;
    } else {
      setState(ViewState.Idle);
    }
    notifyListeners();
  }

  setRejectedInvitesValue(Contact rejectContact){
    userDetail.firstName = rejectContact.firstName;
    userDetail.lastName = rejectContact.lastName;
    userDetail.email = rejectContact.email;
    userDetail.profileUrl = rejectContact.photoURL;
    userDetail.phone = rejectContact.phoneNumber;
    userDetail.address = rejectContact.addresses['Home'];
  }

// firstName: provider.rejectedContactList[index].displayName,
// email: provider.rejectedContactList[index].email,
// profileUrl: provider.rejectedContactList[index].photoURL,
// phone: provider.rejectedContactList[index].phoneNumber,
// address:
//     provider.rejectedContactList[index].addresses['Home']
}
