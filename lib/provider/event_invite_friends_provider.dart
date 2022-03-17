import 'package:collection/src/list_extensions.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/view/home/event_discussion_screen/new_event_discussion_screen.dart';

class EventInviteFriendsProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();
  int toggle = 0;

  late List<bool> value = [];

  void updateCheckValue(bool val, int index) {
    value[index] = val;
    notifyListeners();
  }

  bool _groupInviteValue = false;

  bool get groupInviteValue => _groupInviteValue;

  void updateGroupValue(bool value) {
    _groupInviteValue = value;
    notifyListeners();
  }

  bool _toggleValue = false;

  bool get toggleValue => _toggleValue;

  void updateToggleValue(bool value) {
    _toggleValue = value;
    notifyListeners();
  }

  bool _searchValue = false;

  bool get searchValue => _searchValue;

  void updateSearchValue(bool value) {
    _searchValue = value;
    notifyListeners();
  }

  // confirm contact list
  List<Contact> _confirmContactList = [];

  List<Contact> get confirmContactList => _confirmContactList;

  set confirmContactList(List<Contact> value) {
    _confirmContactList = value;
  }

  // Groups list
  List<Contact> _groupList = [];

  List<Contact> get groupList => _groupList;

  set groupList(List<Contact> value) {
    _groupList = value;
  }

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
      addRemoveUser = List<bool>.filled(confirmContactList.length, false);
      addContactToGroupDiscussion = List<bool>.filled(confirmContactList.length, false);
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
      addRemoveUser = List<bool>.filled(groupList.length, false);
      addContactGroupToGroupDiscussion = List<bool>.filled(groupList.length, false);
    } else {
      setState(ViewState.Idle);
    }
  }

  // for event invite friends

  bool contactCheckIsSelected(Contact contact) {
    var value = eventDetail.contactCIDs.any((element) => element == contact.cid);
    return value;
  }

  bool groupCheckIsSelected(int index) {
    var value = eventDetail.groupIndexList.any((element) => element == index.toString());
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

    if(groupKeysList.isNotEmpty){
      for(int i = 0 ; i< groupKeysList.length ; i++){
        if (contactsKeys.contains(groupKeysList[i])) {
          return true;
        } else {
          var value = eventDetail.groupIndexList
              .any((element) => element == index.toString());
          return value;
        }
      }
    } else{
      var value = eventDetail.groupIndexList
          .any((element) => element == index.toString());
      return value;
    }


    // if (contactsKeys.equals(groupKeysList)) {
    //   return true;
    // } else {
    //   var value = eventDetail.groupIndexList
    //       .any((element) => element == index.toString());
    //   return value;
    // }
  }

  // Future inviteContactsToEvent(BuildContext context, List<String> CIDs) async {
  //   updateInviteValue(true);
  //
  //   mmyEngine!.inviteContactsToEvent(eventDetail.eid.toString(),
  //       CIDs: CIDs).catchError((e) {
  //     updateInviteValue(false);
  //     DialogHelper.showMessage(context, e.message);
  //   });
  //
  //   updateInviteValue(false);
  // }

  // these function are used to invite contact
  inviteContactToEvent(BuildContext context, String CID, int index) async {
    updateCheckValue(true, index);

    await mmyEngine!.inviteContactsToEvent(eventDetail.eid.toString(),
        CIDs: [CID]).catchError((e) {
      updateCheckValue(false, index);
      DialogHelper.showMessage(context, e.message);
    });
    eventDetail.contactCIDs.add(CID);
    updateCheckValue(false, index);
  }

  removeContactFromEvent(BuildContext context, String CID, int ind) async {
    updateCheckValue(true, ind);

    await mmyEngine!.removeContactsFromEvent(eventDetail.eid.toString(),
        CIDs: [CID]).catchError((e) {
      updateCheckValue(false, ind);
      DialogHelper.showMessage(context, e.message);
    });

    var index = eventDetail.contactCIDs.indexWhere((element) => element == CID);
    eventDetail.contactCIDs.removeAt(index);
    updateCheckValue(false, ind);
  }

  // addContactToContactCIDList(Contact contact) {
  //   //   eventInviteFriendsList?.add(contact);
  //   eventDetail.contactCIDs.add(contact.cid);
  //   notifyListeners();
  // }
  //
  // removeContactFromContactCIDList(Contact contact) {
  //   var index = eventDetail.contactCIDs.indexWhere((element) => element == contact.cid);
  //   //  eventInviteFriendsList?.removeAt(index!);
  //   eventDetail.contactCIDs.removeAt(index);
  //   notifyListeners();
  // }

  // these function are used to invite group.
  Future inviteGroupToEvent(BuildContext context, List<String> CIDs, int index,
      Contact groupContact) async {
    updateCheckValue(true, index);
    List<String> keysList = [];
    addContactToGroupCidList(index, groupContact);
    if (eventDetail.checkGroupList.isNotEmpty) {
      for (int i = 0; i < eventDetail.checkGroupList.length; i++) {
        for (var key in eventDetail.checkGroupList[i].group.keys) {
          keysList.add(key);
        }
      }
    }

   // eventDetail.contactCIDs.addAll(keysList.toSet().toList());
    await mmyEngine!
        .inviteContactsToEvent(eventDetail.eid.toString(),
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
    if (eventDetail.checkGroupList.isNotEmpty) {
      for (int i = 0; i < eventDetail.checkGroupList.length; i++) {
        for (var key in eventDetail.checkGroupList[i].group.keys) {
          keysList.add(key);
        }
      }
    }
    // eventDetail.contactCIDs = [];
   // contactsKeys = [];
    for(int i =0 ; i <  CIDs.length ; i++){
      contactsKeys.remove(CIDs[i]);
    }
    await mmyEngine!
        .removeContactsFromEvent(eventDetail.eid.toString(),
            CIDs: keysList.toSet().toList())
        .catchError((e) {
      updateCheckValue(false, index);
      DialogHelper.showMessage(context, e.message);
    });

    updateCheckValue(false, index);
  }

  addContactToGroupCidList(int index, Contact groupContact) {
    eventDetail.groupIndexList.add(index.toString());
    eventDetail.checkGroupList.add(groupContact);
    notifyListeners();
  }

  removeContactFromGroupCidList(int ind, Contact groupContact) {
    var index = eventDetail.groupIndexList.indexWhere((element) => element == ind.toString());
    if (index == -1) {
      eventDetail.groupIndexList.remove(ind);
    } else {
      eventDetail.groupIndexList.removeAt(index);
    }

    eventDetail.checkGroupList.remove(groupContact);

    notifyListeners();
  }

  Future<bool> checkIsGroupInvited(
      BuildContext context, Contact contact) async {
    updateGroupValue(true);
    var value = await mmyEngine!
        .isGroupInvited(eventDetail.eid.toString(), contact.cid)
        .catchError((e) {
      updateGroupValue(false);
      DialogHelper.showMessage(context, e.message);
    });
    updateGroupValue(false);
    return value;
  }


  // Add user to discussion

  late List<bool> addRemoveUser = [];

  updateAddRemoveUser(bool val, int index){
    addRemoveUser[index] = val;
    notifyListeners();
  }
  Future addContactToDiscussion(BuildContext context, String did, int index , {required String cid}) async{
    updateAddRemoveUser(true, index);

    await mmyEngine!.addContactToDiscussion(did, cid: cid).catchError((e){
      updateAddRemoveUser(false, index);
      DialogHelper.showMessage(context, e.message);
    });
    eventDetail.contactCIDs.add(cid);
    updateAddRemoveUser(false, index);
  }

  // Remove user from discussion

  Future removeContactFromDiscussion(BuildContext context, String did, int index , {required String cid}) async{
    updateAddRemoveUser(true, index);

    await mmyEngine!.removeContactFromDiscussion(did, cid: cid).catchError((e){
      updateAddRemoveUser(false, index);
      DialogHelper.showMessage(context, e.message);
    });

    var i = eventDetail.contactCIDs.indexWhere((element) => element == cid);
    eventDetail.contactCIDs.removeAt(i);

    updateAddRemoveUser(false, index);
  }


  // create a group of users for discussion.

  List<String> userKeysToInviteInGroup = [];

  late List<bool> addContactToGroupDiscussion = [];

   updateAddContactToGroupValue(bool val, int index) {
    addContactToGroupDiscussion[index] = val;
    notifyListeners();
  }

  late List<bool> addContactGroupToGroupDiscussion = [];

  updateAddContactGroupToGroupValue(bool val, int index) {
    addContactGroupToGroupDiscussion[index] = val;
    notifyListeners();
  }

  bool startGroup = false;

  updateStartGroup(bool val){
    startGroup = val;
    notifyListeners();
  }

  Future startGroupDiscussion(BuildContext context, List<String> CIDs) async{
    updateStartGroup(true);

  var value =   await mmyEngine?.startGroupDiscussion(CIDs).catchError((e){
      updateStartGroup(false);
      DialogHelper.showMessage(context, e.message);
    });

  if(value != null){
    updateStartGroup(false);
    Navigator.pushNamed(context, RoutesConstants.newEventDiscussionScreen, arguments: NewEventDiscussionScreen(fromContactOrGroup: false, fromChatScreen: true, chatDid: value.did)).then((value){
      Navigator.of(context).pop();
    });

  }

  }
}
