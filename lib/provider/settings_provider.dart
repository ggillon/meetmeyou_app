import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class SettingsProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  CalendarDetail calendarDetail = locator<CalendarDetail>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void updateLoadingStatus(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getUserDetail(BuildContext context) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var userProfile = await mmyEngine!.getUserProfile().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });


    userDetail.firstName = userProfile.firstName;
    userDetail.lastName = userProfile.lastName;
    userDetail.email = userProfile.email;
    userDetail.phone = userProfile.phoneNumber;
    userDetail.countryCode = userProfile.countryCode;

    userDetail.address = '';
    if(userProfile.addresses != null)
      if(userProfile.addresses.containsKey('Home'))
        userDetail.address = userProfile.addresses['Home'];

    userDetail.profileUrl = userProfile.photoURL;

    setState(ViewState.Idle);
  }

  Future getCalendarParams(BuildContext context) async {
    updateLoadingStatus(true);
  //  mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    final response = await mmyEngine!.getCalendarParams().catchError((e) {
      updateLoadingStatus(false);
      DialogHelper.showMessage(context, e.message);
    });
    if (response != null) {
      calendarDetail.calendarSync = response['calendar_sync'];
      calendarDetail.calendarDisplay = response['calendar_display'];
    }
    updateLoadingStatus(false);
  }
}
