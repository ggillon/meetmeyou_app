import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:permission_handler/permission_handler.dart';

class EventGalleryPageProvider extends BaseProvider{

  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();
  File? image;


  Future getImage(BuildContext context, int type) async {
    final picker = ImagePicker();
    // type : 1 for camera in and 2 for gallery
    Navigator.of(context).pop();
    if (type == 1) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 90, maxHeight: 720);
      if (pickedFile != null) {
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          notifyListeners();
        });
        //  image = File(pickedFile.path);
      }
      notifyListeners();
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
      //  image = File(pickedFile!.path);
      if (pickedFile != null) {
        //  image = File(pickedFile.path);
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
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

  /// Get photo Album
  bool getAlbum = false;

  updateGetAlbum(bool val){
    getAlbum = val;
    notifyListeners();
  }

  Future getPhotoAlbum(BuildContext context, String aid) async{
    updateGetAlbum(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getPhotoAlbum(aid).catchError((e) {
      updateGetAlbum(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      updateGetAlbum(false);
    }

  }

  /// Post photo
  Future postPhoto(BuildContext context, String aid, String photoURL) async{
    setState(ViewState.Busy);

    await mmyEngine!.postPhoto(aid, photoURL).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    setState(ViewState.Idle);
}
}