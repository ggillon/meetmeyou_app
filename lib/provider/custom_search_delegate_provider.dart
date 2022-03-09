import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/discussion_detail.dart';
import 'package:meetmeyou_app/models/search_result.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class CustomSearchDelegateProvider extends BaseProvider{

  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  DiscussionDetail discussionDetail = locator<DiscussionDetail>();
  SearchResult? searchList;
  List<Contact> contactsList = [];

  /// Search
  Future search(BuildContext context, String searchText) async{
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
  var value =  await mmyEngine?.search(searchText).catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

  if(value != null){
    searchList = value;
    contactsList = searchList!.contacts;
    setState(ViewState.Idle);
  }

  }

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
}