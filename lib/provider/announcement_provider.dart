import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/announcement_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';

class AnnouncementProvider extends BaseProvider{

  AnnouncementDetail announcementDetail = locator<AnnouncementDetail>();
  File? image;
  DateTime startDate = DateTime.now().add(Duration(days: 7));
  TimeOfDay startTime = TimeOfDay(hour: 19, minute: 0);
  bool addDateAndTime = false;
  bool addLocation = false;
  bool photoGallerySwitch = false;
  bool discussionSwitch = false;
  bool askInfoSwitch = false;

  bool loading = false;
  updateLoadingStatus(bool val){
    loading = val;
    notifyListeners();
  }

  Future getImage(BuildContext context, int type) async {
    final picker = ImagePicker();
    // type : 1 for camera in and 2 for gallery
    Navigator.of(context).pop();
    if (type == 1) {
      final pickedFile = await picker.pickImage(
          source: ImageSource.camera, imageQuality: 85, maxHeight: 1440);
      // image = File(pickedFile!.path);
      // if (image != null) {
      //   announcementDetail.announcementPhotoUrl = "";
      // }
      if (pickedFile != null) {
        announcementDetail.announcementPhotoUrl = "";
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          notifyListeners();
        });
      }
      notifyListeners();
    } else {
      final pickedFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 85, maxHeight: 1440);
      // image = File(pickedFile!.path);
      // if (image != null) {
      //   announcementDetail.announcementPhotoUrl = "";
      // }

      if (pickedFile != null) {
        announcementDetail.announcementPhotoUrl = "";
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          notifyListeners();
        });
      }
      notifyListeners();
    }
  }


  //Method for showing the date picker
  void pickDateDialog(BuildContext context) {
    showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      //for rebuilding the ui
      startDate = pickedDate;
      notifyListeners();
    });
  }

  Future<Null> selectTimeDialog(
      BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (pickedTime == null) {
      return;
    }
    startTime = pickedTime;

    notifyListeners();
  }

}