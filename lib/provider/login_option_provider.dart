import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/widgets/introduction_widget.dart';

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
    await auth.signInWithFacebook().catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value=await mmyEngine!.isNew();
    setState(ViewState.Idle);
    if(value){
      Navigator.pushNamed(context, RoutesConstants.signUpPage,arguments: StringConstants.social);
    }else{
      Navigator.of(context)
          .pushNamedAndRemoveUntil(
          RoutesConstants.homePage,
              (route) => false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    setState(ViewState.Busy);
    await auth.signInWithGoogle().catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value=await mmyEngine!.isNew();
    var userProfile=await mmyEngine!.getUserProfile();
    userDetail.email=userProfile.email;
    userDetail.firstName=userProfile.firstName;
    userDetail.lastName=userProfile.lastName;
    userDetail.profileUrl=userProfile.photoURL;
    Navigator.pushNamed(context, RoutesConstants.signUpPage,arguments: StringConstants.social);
    setState(ViewState.Idle);
    /*if(value){
      Navigator.pushNamed(context, RoutesConstants.signUpPage);
    }else{
      Navigator.of(context)
          .pushNamedAndRemoveUntil(
          RoutesConstants.homePage,
              (route) => false);
    }*/
  }
}
