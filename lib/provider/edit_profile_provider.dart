import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/services/storage/storage.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  EventDetail eventDetail = locator<EventDetail>();
  String? imageUrl;
  File? image;
  String? countryCode;

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
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    firstNameController.text = userDetail.firstName ?? "";
    lastNameController.text = userDetail.lastName ?? "";
    emailController.text = userDetail.email ?? "";
    phoneNoController.text = userDetail.phone ?? "";
    countryCode = userDetail.countryCode ?? "";
    imageUrl = userDetail.profileUrl ?? "";
    addressController.text = userDetail.address ?? "";

    notifyListeners();
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
      final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 85, maxHeight: 720);
      if (pickedFile != null) {
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          var decodedImage = await decodeImageFromList(image!.readAsBytesSync());
          final bytes = image!.readAsBytesSync().lengthInBytes;
          final kb = bytes / 1024;
          final mb = kb / 1024;
          print(kb);
          print(mb);
          print(decodedImage.width);
          print(decodedImage.height);
          notifyListeners();
        });
      //  image = File(pickedFile.path);
      }
      notifyListeners();
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    //  image = File(pickedFile!.path);
      if (pickedFile != null) {
      //  image = File(pickedFile.path);
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          var decodedImage = await decodeImageFromList(image!.readAsBytesSync());
          final bytes = image!.readAsBytesSync().lengthInBytes;
          final kb = bytes / 1024;
          final mb = kb / 1024;
          print(kb);
          print(mb);
          print(decodedImage.width);
          print(decodedImage.height);
          notifyListeners();
        });

        notifyListeners();
      } else {
        print('No image selected.');
        return;
      }
      notifyListeners();
    }
  }

  // This Function is used to update user details.
  Future<void> updateUserDetails(
      BuildContext context,
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String countryCode,
      String address, String photoUrl) async {
    var value = await mmyEngine!
        .updateProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      homeAddress: address,
      photoUrl: photoUrl
    )
        .catchError((e) {
      updateLoadingStatus(false);
      DialogHelper.showMessage(context, e.message);
    });
    if (value != null) {
      updateLoadingStatus(false);
      userDetail.firstName = value.firstName;
      userDetail.lastName = value.lastName;
      userDetail.email = value.email;
      userDetail.phone = value.phoneNumber;
      userDetail.countryCode = value.countryCode;
      userDetail.address = value.addresses['Home'];
      userDetail.profileUrl = value.photoURL;
      Navigator.of(context).pop();
      DialogHelper.showMessage(context, "profile_updated_successfully".tr());
    }
  }

  Future<void> updateUserProfilePicture(
      BuildContext context,
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String countryCode,
      String address) async {
    updateLoadingStatus(true);
    if (image != null) {
      // await mmyEngine!.updateProfilePicture(image!).catchError((e) {
      //   updateLoadingStatus(false);
      //   DialogHelper.showMessage(context, e.message);
      // });
     var profilePhotoUrl =  await storeFile(image!, path: StoragePath.profilePhoto(auth.currentUser!.uid.toString())).catchError((e) {
       updateLoadingStatus(false);
       DialogHelper.showMessage(context, e.message);
     });
      updateUserDetails(context, firstName, lastName, email, phoneNumber, countryCode, address, profilePhotoUrl);
    } else {
      updateUserDetails(context, firstName, lastName, email, phoneNumber, countryCode, address, userDetail.profileUrl!);
    }
  }
}
