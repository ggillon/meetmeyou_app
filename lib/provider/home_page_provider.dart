import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class HomePageProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  EventDetail eventDetail = locator<EventDetail>();
  TabController? tabController;
  int selectedIndex = 0;
  Color textColor = ColorConstants.colorWhite;

  bool _value = false;

  bool get value => _value;

  updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  tabChangeEvent(BuildContext context) {
    tabController?.addListener(() {
   //   selectedIndex = tabController!.index;
     // setState(ViewState.Busy);
      getIndexChanging(context);
    //  setState(ViewState.Idle);
      notifyListeners();
    });
  }


  Future<void> getUserDetail(BuildContext context) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var userProfile = await mmyEngine!.getUserProfile().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    userDetail.cid = userProfile.uid;
   // userDetail.profileUrl = userProfile.photoURL;

    setState(ViewState.Idle);
  }

  List<Event> eventLists = [];

  Future getUserEvents(BuildContext context, {List<String>? filters}) async {
    setState(ViewState.Busy);
    //mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =
        await mmyEngine!.getUserEvents(filters: filters).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      setState(ViewState.Idle);
      // for (int i = 0; i < value.length; i++) {
      //   getEventBtnStatus(value[i]);
      // }
      eventLists = value;
    }
  }

  getEventBtnStatus(Event event) {
    List<String> keysList = [];
    for (var key in event.invitedContacts.keys) {
      keysList.add(key);
    }
    List<String> valuesList = [];
    for (var value in event.invitedContacts.values) {
      valuesList.add(value);
    }
    for (int i = 0; i < keysList.length; i++) {
      if (keysList[i] == userDetail.cid) {
        if (valuesList[i] == "Invited") {
          return "respond";

        } else if (valuesList[i] == "Organiser") {
          return "edit";

        } else if (valuesList[i] == "Attending") {
          return "going";

        } else if (valuesList[i] == "Not Attending") {
          return "not_going";

        } else if (valuesList[i] == "Not Interested") {
          return "hidden";

        } else if (valuesList[i] == "Canceled") {
          return "cancelled";

        }
      }
    }
  }


  getEventBtnColorStatus(Event event, {bool textColor = true}) {
    List<String> keysList = [];
    for (var key in event.invitedContacts.keys) {
      keysList.add(key);
    }
    List<String> valuesList = [];
    for (var value in event.invitedContacts.values) {
      valuesList.add(value);
    }
    for (int i = 0; i < keysList.length; i++) {
      if (keysList[i] == userDetail.cid) {
        if (valuesList[i] == "Invited") {
          return textColor ? ColorConstants.colorWhite : ColorConstants.primaryColor;

        } else if (valuesList[i] == "Organiser") {
          return textColor ? ColorConstants.colorWhite : ColorConstants.primaryColor;

        } else if (valuesList[i] == "Attending") {
          return textColor ? ColorConstants.primaryColor : ColorConstants.primaryColor.withOpacity(0.2);

        } else if (valuesList[i] == "Not Attending") {
          return textColor ? ColorConstants.primaryColor : ColorConstants.primaryColor.withOpacity(0.2);

        } else if (valuesList[i] == "Not Interested") {
          return textColor ? ColorConstants.primaryColor : ColorConstants.primaryColor.withOpacity(0.2);

        } else if (valuesList[i] == "Canceled") {
          return textColor ? ColorConstants.primaryColor : ColorConstants.primaryColor.withOpacity(0.2);

        }
      }
    }
  }

  getIndexChanging(BuildContext context) {
    switch (tabController!.index) {
      case 0:
        getUserEvents(context);
        break;

      case 1:
        getUserEvents(context, filters: ["Attending"]);
        break;

      case 2:
        getUserEvents(context, filters: ["Not Attending"]);
        break;

      case 3:
        getUserEvents(context, filters: ["Invited"]);
        break;

      case 4:
        getUserEvents(context, filters: ["Not Interested"]);
        break;
    }
    notifyListeners();
  }


  Future replyToEvent(BuildContext context, String eid, String response) async{
    setState(ViewState.Busy);

    await mmyEngine!.replyToEvent(eid, response: response).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

   getIndexChanging(context);

    setState(ViewState.Idle);
  }

}
