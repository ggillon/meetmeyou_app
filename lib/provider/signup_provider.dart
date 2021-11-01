import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/enum/viewstate.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/services/mmy/profile.dart';

class SignUpProvider extends BaseProvider{
  File? image;
  AuthBase _auth = locator<AuthBase>();
  String countryCode="+1";


  Future<void> authRegister(BuildContext context,String? email,String? password,String? firstName,String? lastName,String? countryCode,String? phone,String? address) async {
    setState(ViewState.Busy);
    var user=await _auth.createEmailUser(email!, password!).catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    if(user!=null){
      var displayName=firstName!+" "+lastName!;
      createProfile(user,displayName:displayName,firstName: firstName,lastName: lastName,email: email,countryCode: countryCode,phoneNumber: phone,homeAddress: address);
      setState(ViewState.Idle);
    }
  }

  Future getImage(BuildContext context, int type) async {
    final picker = ImagePicker();
    // type : 1 for camera in and 2 for gallery
    Navigator.of(context).pop();
    if (type == 1) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      image = File(pickedFile!.path);
      notifyListeners();
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      image = File(pickedFile!.path);
      notifyListeners();
    }
  }
}