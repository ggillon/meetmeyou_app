import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/event_gallery_image_view_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

class EventGalleryImageView extends StatelessWidget {
  EventGalleryImageView({Key? key, required this.photoUrl}) : super(key: key);
  String photoUrl;

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
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
                Navigator.of(context).pop();
              },
                child: Icon(Icons.arrow_back_ios, color: Colors.blue))
          ],
        )),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: (){
                //  Share.shareFiles(photoUrl);
                },
                  child: Icon(Icons.share, color: Colors.blue,)),
              SizedBox(width: scaler.getWidth(3.0)),
              GestureDetector(
                onTap: (){
                  DialogHelper.showDialogWithTwoButtons(
                      context,
                      "delete_photo".tr(),
                      "sure_to_delete_photo".tr());
                },
                  child: Icon(Icons.delete_outline, color: Colors.blue,)),
              SizedBox(width: scaler.getWidth(3.0)),
            ],
          )
        ],
      ),
      body: BaseView<EventGalleryImageViewProvider>(
        builder: (context, provider, _){
          return ClipRRect(
            borderRadius: scaler.getBorderRadiusCircular(10),
            child: Container(
                color: ColorConstants.primaryColor,
                width: double.infinity,
                height: scaler.getHeight(90.0),
                child: PhotoView(imageProvider: NetworkImage (photoUrl))
            ),
          );
        },
      ),
    );
  }
}
