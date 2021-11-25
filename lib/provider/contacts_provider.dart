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
  }

  List<Contact> sortContactList() {
    confirmContactList.sort();
    return confirmContactList;
  }

}
