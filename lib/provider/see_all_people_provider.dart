import 'package:flutter/material.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/discussion_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class SeeAllPeopleProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  DiscussionDetail discussionDetail = locator<DiscussionDetail>();

  setContactsValue(Contact contact) {
    userDetail.firstName = contact.firstName;
    userDetail.lastName = contact.lastName;
    userDetail.email = contact.email;
    userDetail.profileUrl = contact.photoURL;
    userDetail.phone = contact.phoneNumber;
    userDetail.countryCode = contact.countryCode;
    userDetail.address = contact.addresses['Home'];
    userDetail.checkForInvitation = false;
  }

  bool _value = false;

  bool get value => _value;

  updateValue(bool value) {
    _value = value;
    notifyListeners();
  }


  inviteProfile(BuildContext context, Contact contact) async {
    updateValue(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine!.inviteProfile(contact.cid).catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });
    contact.status = 'Invited contact';
    updateValue(false);
    DialogHelper.showMessage(context, "Invitation send Successfully");
  }
}