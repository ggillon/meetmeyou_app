import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class CalendarSettingsProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  CalendarDetail calendarDetail = locator<CalendarDetail>();
  // bool _isLoading = false;
  //
  // bool get isLoading => _isLoading;
  //
  // void updateLoadingStatus(bool value) {
  //   _isLoading = value;
  //   notifyListeners();
  // }

  Future setCalendarParams(
      BuildContext context, bool sync, bool display) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine!
        .setCalendarParams(sync: sync, display: display)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    setState(ViewState.Idle);
  }
}

