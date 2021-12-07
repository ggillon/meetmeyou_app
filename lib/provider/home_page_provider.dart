import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class HomePageProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  TabController? tabController;
  int selectedIndex = 0;
  Color textColor = ColorConstants.colorWhite;

  bool _value = false;

  bool get value => _value;

  updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  tabChangeEvent() {
    tabController?.addListener(() {
      selectedIndex = tabController!.index;
      notifyListeners();
    });
  }

  List<Event> eventLists = [];

  Future getUserEvents(BuildContext context, {List<String>? filters}) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getUserEvents(filters: filters).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      setState(ViewState.Idle);
      eventLists = value;
    }
  }

  getIndexChanging(BuildContext context){
      switch(tabController!.index){
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


  checkEventButtonStatus(){
  //  if()
  }
}
