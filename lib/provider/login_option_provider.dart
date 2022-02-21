import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/helper/shared_pref.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/widgets/introduction_widget.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginOptionProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();

  bool _moreOption = false;

  bool get moreOption => _moreOption;

  void updateMoreOptions(bool value) {
    _moreOption = value;
    notifyListeners();
  }

  Future<void> signInWithFb(BuildContext context) async {
    setState(ViewState.Busy);
    var user = await auth.signInWithFacebook().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showDialogWithOneButton(context, "error".tr(), e.message);
    });
    if (user != null) {
      setState(ViewState.Busy);
      mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
      var value = await mmyEngine!.isNew();
      if (value) {
        var userProfile = await mmyEngine!.createUserProfile();
        userDetail.email = userProfile.email;
        userDetail.firstName = userProfile.firstName;
        userDetail.lastName = userProfile.lastName;
        userDetail.profileUrl = userProfile.photoURL;
        setState(ViewState.Idle);
        Navigator.pushNamed(context, RoutesConstants.signUpPage,
            arguments: StringConstants.social);
      } else {
        setState(ViewState.Idle);
        SharedPref.prefs?.setBool(SharedPref.IS_USER_LOGIN, true);
        Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesConstants.dashboardPage, (route) => false, arguments: true);
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    setState(ViewState.Busy);
    var user = await auth.signInWithGoogle().catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showDialogWithOneButton(context, "error".tr(), e.message,
          barrierDismissible: false);
    });
    if (user != null) {
      setState(ViewState.Busy);
      mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
      var value = await mmyEngine!.isNew();
      if (value) {
        var userProfile = await mmyEngine!.createUserProfile();
        userDetail.email = userProfile.email;
        userDetail.firstName = userProfile.firstName;
        userDetail.lastName = userProfile.lastName;
        userDetail.profileUrl = userProfile.photoURL;
        setState(ViewState.Idle);
        Navigator.pushNamed(context, RoutesConstants.signUpPage,
            arguments: StringConstants.social);
      } else {
        setState(ViewState.Idle);
        SharedPref.prefs?.setBool(SharedPref.IS_USER_LOGIN, true);
        Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesConstants.dashboardPage, (route) => false, arguments: true);
      }
    }
  }

  // Future<void> signInWithApple(BuildContext context) async {
  //   initiateSignInWithApple(context);
  //   var user = await auth.signInWithApple().catchError((e) {
  //     setState(ViewState.Idle);
  //     DialogHelper.showDialogWithOneButton(context, "error".tr(), e.message);
  //   });
  //   if (user != null) {
  //     setState(ViewState.Busy);
  //     mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
  //     var value = await mmyEngine!.isNew();
  //     if (value) {
  //       var userProfile = await mmyEngine!.createUserProfile();
  //       userDetail.email = userProfile.email;
  //       userDetail.firstName = userProfile.firstName;
  //       userDetail.lastName = userProfile.lastName;
  //       userDetail.profileUrl = userProfile.photoURL;
  //       setState(ViewState.Idle);
  //       Navigator.pushNamed(context, RoutesConstants.signUpPage,
  //           arguments: StringConstants.social);
  //     } else {
  //       setState(ViewState.Idle);
  //       SharedPref.prefs?.setBool(SharedPref.IS_USER_LOGIN, true);
  //       Navigator.of(context).pushNamedAndRemoveUntil(
  //           RoutesConstants.dashboardPage, (route) => false, arguments: true);
  //     }
  //   }
  // }
  //
  // void initiateSignInWithApple(BuildContext context) async {
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //         scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //         ]);
  //     }catch (error) {
  //     print("error with apple sign in");
  //   }
  // }

}
