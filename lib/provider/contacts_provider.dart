import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/group_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class ContactsProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  GroupDetail groupDetail = locator<GroupDetail>();
  int _toggle = 0;

  int get toggle => _toggle;

  set toggle(int value) {
    _toggle = value;
  }

  bool toggleSwitch = true;

  // confirm contact list
  List<Contact> _confirmContactList = [];

  List<Contact> get confirmContactList => _confirmContactList;

  set confirmContactList(List<Contact> value) {
    _confirmContactList = value;
  }

  // invitation contact list
  List<Contact> _invitationContactList = [];

  List<Contact> get invitationContactList => _invitationContactList;

  set invitationContactList(List<Contact> value) {
    _invitationContactList = value;
  }

  // Groups list
  List<Contact> _groupList = [];

  List<Contact> get groupList => _groupList;

  set groupList(List<Contact> value) {
    _groupList = value;
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
      confirmValue.sort((a, b) {
        return a.displayName
            .toString()
            .toLowerCase()
            .compareTo(b.displayName.toString().toLowerCase());
      });
      confirmContactList = confirmValue;

      groupDetail.createGroup = true;
      groupDetail.checkBoxCheck = false;
      groupDetail.groupPhotoUrl = null;
      groupDetail.groupConfirmContactList = [];
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

      groupDetail.createGroup = true;
      groupDetail.checkBoxCheck = false;
      groupDetail.groupPhotoUrl = null;
      groupDetail.groupConfirmContactList = [];
    } else {
      setState(ViewState.Idle);
    }
  }

  bool _value = false;

  bool get value => _value;

  void updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  setGroupValue(Contact contact){
    groupDetail.groupName = contact.displayName;
    groupDetail.about = contact.about;
    groupDetail.groupCid = contact.cid;
    groupDetail.membersLength = contact.group.length.toString();
    groupDetail.groupPhotoUrl = contact.photoURL;
    groupDetail.group = contact.group;
    groupDetail.createGroup = false;
  }

  setContactsValue(Contact contact, bool value, String cid){
    userDetail.firstName = contact.firstName;
    userDetail.lastName = contact.lastName;
    userDetail.email = contact.email;
    userDetail.profileUrl = contact.photoURL;
    userDetail.phone = contact.phoneNumber;
    userDetail.address = contact.addresses['Home'];
    userDetail.checkForInvitation = value;
    userDetail.cid = cid;
  }
}
