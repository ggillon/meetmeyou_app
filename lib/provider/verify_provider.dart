import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/services/mmy/profile.dart';

class VerifyProvider extends BaseProvider {
  bool _correctOtp = true;

  bool get correctOtp => _correctOtp;

  MMYEngine? mmyEngine;

  UserDetail? userDetail;

  void updateOtpStatus(bool value) {
    _correctOtp = value;
    notifyListeners();
  }

  bool verifyOtp(String otp) {
    var value = auth.emailCheckCode(userDetail!.email!, otp);
    updateOtpStatus(value);
    return value;
  }

  Future<void> authRegister(BuildContext context) async {
    setState(ViewState.Busy);
    var user = await auth
        .createEmailUser(userDetail!.email!, userDetail!.password!)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if (user != null) {
      var displayName = userDetail!.firstName! + " " + userDetail!.lastName!;
      await createProfile(user,
          displayName: displayName,
          firstName: userDetail!.firstName,
          lastName: userDetail!.lastName,
          email: userDetail!.email,
          countryCode: userDetail!.phone==null||userDetail!.phone==""?null:userDetail!.countryCode,
          phoneNumber: userDetail!.phone,
          homeAddress: userDetail!.address);
      if (userDetail!.profileFile != null) {
        updateProfilePic(context);
      } else {
        setState(ViewState.Idle);
        moveToNextScreen(context);
      }
    }
  }

  Future<void> updateProfilePic(BuildContext context) async {
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    await mmyEngine!
        .updateProfilePicture(userDetail!.profileFile!)
        .catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    moveToNextScreen(context);
  }
  void moveToNextScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(RoutesConstants.homePage, (route) => false);
  }
}
