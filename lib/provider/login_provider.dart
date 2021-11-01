import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/viewstate.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';

class LoginProvider extends BaseProvider{
  AuthBase _auth = locator<AuthBase>();
  Future<void> login(BuildContext context,String? email,String? password) async {
    setState(ViewState.Busy);
    await _auth.signInEmailUser(email!, password!).catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    setState(ViewState.Idle);
   /* if(user!=null){
      var displayName=firstName!+" "+lastName!;
      createProfile(user,displayName:displayName,firstName: firstName,lastName: lastName,email: email,countryCode: countryCode,phoneNumber: phone,homeAddress: address);
      setState(ViewState.Idle);
    }*/
  }
}