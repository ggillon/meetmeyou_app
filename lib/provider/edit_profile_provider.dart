import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  String? imageUrl;
  File? image;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void updateLoadingStatus(bool value) {
    _isLoading = value;
    notifyListeners();
  }

// This function is used to get user details in edit profile screen.
  // so that we can show user details in multiple text fields.

  Future<void> setUserDetail(
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      TextEditingController emailController,
      TextEditingController phoneNoController,
      TextEditingController addressController) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var userProfile = await mmyEngine!.getUserProfile();
    firstNameController.text = userProfile.firstName ?? "";
    lastNameController.text = userProfile.lastName ?? "";
    emailController.text = userProfile.email ?? "";
    phoneNoController.text = userProfile.phoneNumber ?? "";
    imageUrl = userProfile.photoURL ?? "";
    addressController.text = userProfile.addresses!['Home'];

    setState(ViewState.Idle);
    notifyListeners();
  }

  Future<bool> permissionCheck() async {
    var status = await Permission.storage.status;
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
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

  // This Function is used to update user details.
  Future<void> updateUserDetails(BuildContext context, String firstName,
      String lastName, String email, String phoneNumber, String address) async {
    mmyEngine!
        .updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      homeAddress: address,
    )
        .catchError((e) {
      updateLoadingStatus(false);
      DialogHelper.showMessage(context, e.message);
    });
    updateLoadingStatus(false);
    DialogHelper.showMessage(context, "profile_updated_successfully".tr());
    //Navigator.pop(context);
  }

  Future<void> updateUserProfilePicture(BuildContext context, String firstName,
      String lastName, String email, String phoneNumber, String address) async {
    updateLoadingStatus(true);
    if (image != null) {
      await mmyEngine!.updateProfilePicture(image!);
      updateUserDetails(
          context, firstName, lastName, email, phoneNumber, address);
    } else {
      updateUserDetails(
          context, firstName, lastName, email, phoneNumber, address);
    }
  }
}