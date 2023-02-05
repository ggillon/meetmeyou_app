import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/discussion_detail.dart';
import 'package:meetmeyou_app/models/group_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class GroupDescriptionProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  GroupDetail groupDetail = locator<GroupDetail>();
  UserDetail userDetail = locator<UserDetail>();
  DiscussionDetail discussionDetail = locator<DiscussionDetail>();
  bool favouriteSwitch = false;

  // confirm contact list
  List<Contact> _groupContactList = [];

  List<Contact> get groupContactList => _groupContactList;

  set groupContactList(List<Contact> value) {
    _groupContactList = value;
  }

  List<String> keysList = [];

  getGroupContactsList(BuildContext context, Map groupData) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var confirmValue =
        await mmyEngine!.getContacts(confirmedContacts: true).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (confirmValue != null) {
      setState(ViewState.Idle);

      for (var key in groupData.keys) {
        keysList.add(key);
      }
      ;
      for (int i = 0; i < keysList.length; i++) {
        var groupContactList1 = confirmValue.where((element) {
          return element.cid == keysList[i];
        }).toList();
        groupContactList.addAll(groupContactList1.toList());
      }

      groupDetail.groupConfirmContactList = groupContactList;

      groupContactList.sort((a, b) {
        return a.displayName
            .toString()
            .toLowerCase()
            .compareTo(b.displayName.toString().toLowerCase());
      });
    } else {
      setState(ViewState.Idle);
    }
  }


  String? groupName;
  String? about;
  List<Contact>? groupConfirmContactList = [];
  String? groupPhotoUrl;
  String? membersLength;

   getGroupDetail() {
    groupName = groupDetail.groupName ?? "";
    about = groupDetail.about ?? "";
    membersLength = groupDetail.membersLength ?? "";
    groupPhotoUrl = groupDetail.groupPhotoUrl ?? "";

    notifyListeners();
  }

  bool favourite = false;

  updateFavouriteStatus(bool val){
    favourite = val;
    notifyListeners();
  }

  Future addGroupToFavourite(BuildContext context, String contactId) async{
    updateFavouriteStatus(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine!.addToFavourites(contactId).catchError((e){
      updateFavouriteStatus(false);
      DialogHelper.showMessage(context, e.message);
    });

    updateFavouriteStatus(false);

  }
}
