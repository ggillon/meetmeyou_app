import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/announcement_detail.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class PublicationVisibilityProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  TabController? tabController;
  AnnouncementDetail announcementDetail = locator<AnnouncementDetail>();
  int toggle = 0;
  bool isManuallyList = false;

  late List<bool> value = [];

  void updateCheckValue(bool val, int index) {
    value[index] = val;
    notifyListeners();
  }

  tabChangeEvent(BuildContext context) {
    tabController?.addListener(() {
      if(tabController!.index == 0){
        contactsKeys.addAll(announcementDetail.contactCIDs);
        isManuallyList = false;
      } else if(tabController!.index == 1){
        isManuallyList = false;
      } else if(tabController!.index == 2){
        isManuallyList = true;
      }

      notifyListeners();
    });
  }

  // confirm contact list
  List<Contact> confirmContactList = [];

  // favourite contact list
  List<Contact> favouriteContactList = [];

  // Groups list
  List<Contact> groupList = [];

  getConfirmedContactsList(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var confirmValue =
    await mmyEngine!.getContacts(confirmedContacts: true).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (confirmValue != null) {
      setState(ViewState.Idle);
      confirmValue.sort((a, b) {
        return a.displayName
            .toString()
            .toLowerCase()
            .compareTo(b.displayName.toString().toLowerCase());
      });
      confirmContactList = confirmValue;
      value = List<bool>.filled(confirmContactList.length, false);
      favouriteContactList = [];
      for (var element in confirmContactList) {
        if (element.isFavourite == true) {
          favouriteContactList.add(element);
        }
      }
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
      value = List<bool>.filled(groupList.length, false);
    } else {
      setState(ViewState.Idle);
    }
  }

  bool contactCheckIsSelected(Contact contact) {
    var value = announcementDetail.contactCIDs.any((element) =>
    element == contact.cid);
    return value;
  }

  bool groupCheckIsSelected(int index) {
    var value = announcementDetail.groupIndexList.any((element) =>
    element == index.toString());
    return value;
  }

  List<String> contactsKeys = [];

  groupCheck(Contact contact, int index) {
    List<String> groupKeysList = [];
    for (var key in contact.group.keys) {
      groupKeysList.add(key);
    }
    contactsKeys.sort((a, b) {
      return a
          .toString()
          .toLowerCase()
          .compareTo(b.toString().toLowerCase());
    });

    groupKeysList.sort((a, b) {
      return a
          .toString()
          .toLowerCase()
          .compareTo(b.toString().toLowerCase());
    });

    if (groupKeysList.isNotEmpty) {
      for (int i = 0; i < groupKeysList.length; i++) {
        if (contactsKeys.contains(groupKeysList[i])) {
          return true;
        } else {
          var value = announcementDetail.groupIndexList
              .any((element) => element == index.toString());
          return value;
        }
      }
    } else {
      var value = announcementDetail.groupIndexList
          .any((element) => element == index.toString());
      return value;
    }
  }

  /// these function are used to invite contact
  inviteContactToEvent(BuildContext context, String CID, int index) async {
    updateCheckValue(true, index);

    await mmyEngine!.inviteContactsToEvent(announcementDetail.announcementId.toString(),
        CIDs: [CID]).catchError((e) {
      updateCheckValue(false, index);
      DialogHelper.showMessage(context, e.message);
    });
    announcementDetail.contactCIDs.add(CID);
    updateCheckValue(false, index);
  }

  removeContactFromEvent(BuildContext context, String CID, int ind) async {
    updateCheckValue(true, ind);

    await mmyEngine!.removeContactsFromEvent(announcementDetail.announcementId.toString(),
        CIDs: [CID]).catchError((e) {
      updateCheckValue(false, ind);
      DialogHelper.showMessage(context, e.message);
    });

    var index = announcementDetail.contactCIDs.indexWhere((element) => element == CID);
    announcementDetail.contactCIDs.removeAt(index);
    updateCheckValue(false, ind);
  }
  /// ~~~~~~~~~~~~~


  /// these function are used to invite group.
  Future inviteGroupToEvent(BuildContext context, List<String> CIDs, int index,
      Contact groupContact) async {
    updateCheckValue(true, index);
    List<String> keysList = [];
    addContactToGroupCidList(index, groupContact);
    if (announcementDetail.checkGroupList.isNotEmpty) {
      for (int i = 0; i < announcementDetail.checkGroupList.length; i++) {
        for (var key in announcementDetail.checkGroupList[i].group.keys) {
          keysList.add(key);
        }
      }
    }

    await mmyEngine!
        .inviteContactsToEvent(announcementDetail.announcementId.toString(),
        CIDs: keysList.toSet().toList())
        .catchError((e) {
      updateCheckValue(false, index);
      DialogHelper.showMessage(context, e.message);
    });

    updateCheckValue(false, index);
  }

  Future removeGroupFromEvent(BuildContext context, List<String> CIDs,
      int index, Contact groupContact) async {
    updateCheckValue(true, index);
    List<String> keysList = [];
    removeContactFromGroupCidList(index, groupContact);
    if (announcementDetail.checkGroupList.isNotEmpty) {
      for (int i = 0; i < announcementDetail.checkGroupList.length; i++) {
        for (var key in announcementDetail.checkGroupList[i].group.keys) {
          keysList.add(key);
        }
      }
    }

    for (int i = 0; i < CIDs.length; i++) {
      contactsKeys.remove(CIDs[i]);
    }
    await mmyEngine!
        .removeContactsFromEvent(announcementDetail.announcementId.toString(),
        CIDs: keysList.toSet().toList())
        .catchError((e) {
      updateCheckValue(false, index);
      DialogHelper.showMessage(context, e.message);
    });

    updateCheckValue(false, index);
  }

  addContactToGroupCidList(int index, Contact groupContact) {
    announcementDetail.groupIndexList.add(index.toString());
    announcementDetail.checkGroupList.add(groupContact);
    notifyListeners();
  }

  removeContactFromGroupCidList(int ind, Contact groupContact) {
    var index = announcementDetail.groupIndexList.indexWhere((element) =>
    element == ind.toString());
    if (index == -1) {
      announcementDetail.groupIndexList.remove(ind);
    } else {
      announcementDetail.groupIndexList.removeAt(index);
    }

    announcementDetail.checkGroupList.remove(groupContact);

    notifyListeners();
  }

  /// Event invite all contacts

  bool inviteContacts = false;

  updateInviteContacts(bool val){
    inviteContacts = val;
    notifyListeners();
  }

  Future inviteAllContacts(BuildContext context, String eid) async{
    updateInviteContacts(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =
        await mmyEngine!.inviteAllContacts(eid).catchError((e) {
          updateInviteContacts(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      updateInviteContacts(false);
      Navigator.of(context).pop();
    }
  }

  /// Event invite all favourite contacts

  Future inviteAllFavourites(BuildContext context, String eid)async{
    updateInviteContacts(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =
    await mmyEngine!.inviteAllFavourites(eid).catchError((e) {
      updateInviteContacts(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      updateInviteContacts(false);
      Navigator.of(context).pop();
    }
  }
}