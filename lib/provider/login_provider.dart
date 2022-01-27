import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/helper/shared_pref.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class LoginProvider extends BaseProvider {
  Future<void> login(
      BuildContext context, String? email, String? password) async {
    setState(ViewState.Busy);
    var user = await auth.signInEmailUser(email!, password!).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (user != null) {
      setState(ViewState.Idle);
      SharedPref.prefs?.setBool(SharedPref.IS_USER_LOGIN, true);
      Navigator.of(context).pushNamedAndRemoveUntil(
          RoutesConstants.dashboardPage, (route) => false, arguments: true);
    }
  }
}
