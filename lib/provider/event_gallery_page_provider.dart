import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/photo.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/services/storage/storage.dart';
import 'package:meetmeyou_app/view/home/view_video_screen/view_video_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class EventGalleryPageProvider extends BaseProvider{

  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();
  File? image;
  File? video;
  List<MMYPhoto> mmyPhotoList = [];
  List<dynamic> galleryImagesUrl = [];
  List<PhotoGallery> photoGalleryData = [];


  Future getImage(BuildContext context, int type, Widget postBtn) async {
    final picker = ImagePicker();
    // type : 1 for camera in , 2 for gallery and 3 for video.
    Navigator.of(context).pop();
    if (type == 1) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 90, maxHeight: 720);
      if (pickedFile != null) {
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          if(image != null){
            setState(ViewState.Busy);
            var photoUrl = await storeFile(image!, path: StoragePath.eventPhotoGallery(eventDetail.eid.toString()));
            await postPhoto(context, eventDetail.eid.toString(), photoUrl, postBtn);
          }
          notifyListeners();
        });
        //  image = File(pickedFile.path);
      }
      notifyListeners();
    } else if(type == 2) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
      //  image = File(pickedFile!.path);
      if (pickedFile != null) {
        //  image = File(pickedFile.path);
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          if(image != null){
            setState(ViewState.Busy);
          var photoUrl =  await storeFile(image!, path: StoragePath.eventPhotoGallery(eventDetail.eid.toString()));
          await postPhoto(context, eventDetail.eid.toString(), photoUrl, postBtn);
          }
          notifyListeners();
        });
        notifyListeners();
      } else {
        print('No image selected.');
        return;
      }
      notifyListeners();
    } else{
      final pickedFile = await picker.pickVideo(
          source: ImageSource.gallery);
      if(pickedFile != null){
        video = File(pickedFile.path);
        var fileName = (video!.path.split('/').last);
        var format = fileName.split(".").last;
        int sizeInBytes = await video!.length();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if(sizeInMb <= 25){
          Navigator.pushNamed(context, RoutesConstants.viewVideoScreen, arguments: ViewVideoScreen(viewVideoData: ViewVideoData(video: video), fromChat: false,
            format: format,)).then((dynamic value) async{
            video = value;
            if(video != null){
              setState(ViewState.Busy);
              var videoUrl =  await storeFile(video!, path: StoragePath.eventPhotoGalleryVideo(eventDetail.eid.toString(), format));
              await postPhoto(context, eventDetail.eid.toString(), videoUrl, postBtn, type: PHOTO_TYPE_VIDEO);
              video = null;
            }
            notifyListeners();
          });
        } else{
          DialogHelper.showMessage(context, "video_size".tr());
        }

      } else{
        DialogHelper.showMessage(context, "no_video_selected".tr());
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

  Future getPhotoAlbum(BuildContext context, String aid, {bool postPhoto = false, Widget? postBtn}) async{
   postPhoto ? setState(ViewState.Busy) :  updateGetAlbum(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getPhotoAlbum(aid).catchError((e) {
      postPhoto ? setState(ViewState.Idle) : updateGetAlbum(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      image = null;
      eventDetail.albumAdminId = value.adminId;
      mmyPhotoList = value.photos;
      galleryImagesUrl = [];
      photoGalleryData = [];
      for(int i = 0; i < mmyPhotoList.length; i++){
        if(mmyPhotoList[i].type == PHOTO_TYPE_VIDEO){
          mmyPhotoList[i].videoPlayerController = VideoPlayerController.network(mmyPhotoList[i].photoURL)
            ..initialize().then((_) {
              notifyListeners();
            });
          photoGalleryData.add(PhotoGallery(aid: mmyPhotoList[i].aid, pid : mmyPhotoList[i].pid, ownerId: mmyPhotoList[i].ownerId,
              photoUrl: mmyPhotoList[i].photoURL, type: mmyPhotoList[i].type, videoPlayerController: mmyPhotoList[i].videoPlayerController));
        } else{
          galleryImagesUrl.add(mmyPhotoList[i].photoURL);
          photoGalleryData.add(PhotoGallery(aid: mmyPhotoList[i].aid, pid : mmyPhotoList[i].pid, ownerId: mmyPhotoList[i].ownerId,
              photoUrl: mmyPhotoList[i].photoURL, type: mmyPhotoList[i].type, videoPlayerController: mmyPhotoList[i].videoPlayerController));
        }

      }
     galleryImagesUrl.insert(galleryImagesUrl.length, postBtn);
      photoGalleryData.insert(photoGalleryData.length, PhotoGallery(btn: postBtn));


      postPhoto ? setState(ViewState.Busy) : updateGetAlbum(false);
    }

  }

  /// Post photo
  Future postPhoto(BuildContext context, String aid, String photoURL, Widget postBtn,
      {String? type}) async{
    setState(ViewState.Busy);

    await mmyEngine!.postPhoto(aid, photoURL, type: type ?? PHOTO_TYPE_PHOTO).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

     await getPhotoAlbum(context, aid, postPhoto: true, postBtn: postBtn);

    setState(ViewState.Idle);
}
}

class PhotoGallery{
  String? pid;
  String? aid;
  String? ownerId;
  String? photoUrl;
  String? type;
  VideoPlayerController? videoPlayerController;
  Widget? btn;

  PhotoGallery({this.aid, this.pid, this.ownerId, this.photoUrl, this.type, this.videoPlayerController, this.btn});
}
