import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/photo.dart';
import 'package:meetmeyou_app/provider/event_gallery_image_view_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' show get;

class EventGalleryImageView extends StatelessWidget {
  EventGalleryImageView({Key? key, required this.mmyPhoto}) : super(key: key);
 MMYPhoto mmyPhoto;

 EventGalleryImageViewProvider provider = EventGalleryImageViewProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorConstants.colorWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorConstants.colorNewGray,
        automaticallyImplyLeading: false,
        leading: Center(child: Row(
          children: [
            SizedBox(width: scaler.getWidth(3.0)),
            GestureDetector(
              onTap: (){
                Navigator.of(_scaffoldKey.currentContext!).pop();
              },
                child: Icon(Icons.arrow_back_ios, color: Colors.blue))
          ],
        )),
        actions: [
          Row(
            children: [
              GestureDetector(
                  onTap: (){
                    // GallerySaver.saveImage(mmyPhoto.photoURL).then((value) {
                    //   DialogHelper.showMessage(context, "image_saved".tr());
                    // });
                    _save(context, mmyPhoto.photoURL, mmyPhoto.pid);
                  },
                  child: Icon(Icons.save_alt, color: Colors.blue,)),
              SizedBox(width: scaler.getWidth(5.0)),
              GestureDetector(
                onTap: (){
                  shareImage();
                },
                  child: Icon(Icons.share, color: Colors.blue,)),
              SizedBox(width: scaler.getWidth(5.0)),
            (provider.auth.currentUser!.uid == mmyPhoto.ownerId || provider.auth.currentUser!.uid == provider.eventDetail.albumAdminId) ? GestureDetector(
                onTap: (){
                  DialogHelper.showDialogWithTwoButtons(
                      context,
                      "delete_photo".tr(),
                      "sure_to_delete_photo".tr(), positiveButtonPress: () async {
                    Navigator.of(_scaffoldKey.currentContext!).pop();
                    await provider.deletePhoto(_scaffoldKey.currentContext!, mmyPhoto.aid, mmyPhoto.pid);
                  });
                },
                  child: Icon(Icons.delete_outline, color: Colors.blue,)) : Container(),
              (provider.auth.currentUser!.uid == mmyPhoto.ownerId || provider.auth.currentUser!.uid == provider.eventDetail.albumAdminId) ?  SizedBox(width: scaler.getWidth(3.0)) : Container(),
            ],
          )
        ],
      ),
      body: BaseView<EventGalleryImageViewProvider>(
        onModelReady: (provider){
          this.provider = provider;
        },
        builder: (context, provider, _){
          return ClipRRect(
            borderRadius: scaler.getBorderRadiusCircular(10),
            child: Container(
                color: ColorConstants.primaryColor,
                width: double.infinity,
                height: scaler.getHeight(90.0),
                child: PhotoView(imageProvider: NetworkImage(mmyPhoto.photoURL))
            ),
          );
        },
      ),
    );
  }


  void shareImage() async {
    final Directory temp = await getApplicationDocumentsDirectory();
    final File imageFile = File('${temp.path}/${mmyPhoto.pid}.png');
    if (imageFile.existsSync()) {
     // print('file already exist');
      await imageFile.readAsBytes();
      Share.shareFiles([imageFile.path]);
    } else{
      final response = await get(Uri.parse(mmyPhoto.photoURL));
      var bytes = await response.bodyBytes;
      imageFile.writeAsBytes(bytes);
      Share.shareFiles([imageFile.path]);
    }
  }

  // Future<File> _fileFromImageUrl() async {
  //   final response = await get(Uri.parse(mmyPhoto.photoURL));
  //
  //   final Directory documentDirectory = await getApplicationDocumentsDirectory();
  //
  //   final File file = File('${documentDirectory.path}/${mmyPhoto.pid}.png');
  //
  //   file.writeAsBytesSync(response.bodyBytes);
  //
  //   return file;
  // }

  _save(BuildContext context, String photoUrl, String name) async {
    var response = await Dio().get(photoUrl,
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: name);
    DialogHelper.showMessage(context, "image_saved".tr());
   // print(result);
  }

}
