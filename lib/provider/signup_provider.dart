import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/helper/shared_pref.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/services/mmy/profile.dart';
import 'package:meetmeyou_app/view/dashboard/dashboardPage.dart';
import 'package:permission_handler/permission_handler.dart';

class SignUpProvider extends BaseProvider {
  UserDetail userDetail = locator<UserDetail>();
  File? image;
  String countryCode = "+1";
  String phone = "";
  MMYEngine? mmyEngine;

  void sendOtpToMail(String email) {
    auth.generateOTP(email);
  }

  Future<bool> permissionCheck() async {
    var status = await Permission.storage.status;
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      if (release.contains(".")) {
        release = release.substring(0, 1);
      }
      if (int.parse(release) > 10) {
        status = await Permission.manageExternalStorage.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      Permission.storage.request();
      return false;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      return false;
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

  Future<void> updateProfile(
      BuildContext context,
      String firstName,
      String lastName,
      String email,
      String countryCode,
      String phone,
      String address) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    await mmyEngine!.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
        countryCode: phone == "" ? null : userDetail.countryCode,
        phoneNumber: phone,
        homeAddress: address,
        parameters: <String, dynamic>{'New': false}).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });
    setState(ViewState.Idle);
    moveToNextScreen(context);
  }

  void moveToNextScreen(BuildContext context) {
    SharedPref.prefs?.setBool(SharedPref.IS_USER_LOGIN, true);
    Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesConstants.dashboardPage, (route) => false, arguments: DashboardPage(isFromLogin: true));
  }
}
