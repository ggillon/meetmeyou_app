import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomDialog extends StatelessWidget {
  final VoidCallback galleryClick;
  final VoidCallback cameraClick;
  final VoidCallback cancelClick;
  VoidCallback? videoClick;
  bool? videoSelection;

  CustomDialog(
      {required this.galleryClick, required this.cameraClick, required this.cancelClick, this.videoClick, this.videoSelection});

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler=new ScreenScaler()..init(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: CustomShape(
        bgColor: Colors.white,
        radius: scaler.getBorderRadiusCircularLR(16, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Ink(
              decoration: BoxDecoration(
                  color: ColorConstants.primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: scaler.getBorderRadiusCircularLR(16, 16, 0, 0)),
              child: Padding(
                padding: scaler.getPaddingAll(10),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "choose_from".tr(),
                    ).mediumText(ColorConstants.colorWhite, scaler.getTextSize(12), TextAlign.center)),
              ),
            ),
            GestureDetector(
              onTap: galleryClick,
              child: Padding(
                padding: scaler.getPaddingAll(8),
                child: Text(videoSelection == true ? "photo_gallery".tr() : "phone_gallery".tr()).regularText(ColorConstants.primaryColor, scaler.getTextSize(12),TextAlign.center),
              ),
            ),
            videoSelection == true ?   Divider(
              height: 1.0,
              color: Colors.black,
            ) : Container(),
            videoSelection == true ?  GestureDetector(
              onTap: videoClick,
              child: Padding(
                padding: scaler.getPaddingAll(8),
                child: Text("video_gallery".tr()).regularText(ColorConstants.primaryColor, scaler.getTextSize(12),TextAlign.center),
              ),
            ) : Container(),
            Divider(
              height: 1.0,
              color: Colors.black,
            ),
            GestureDetector(
              onTap: cameraClick,
              child: Padding(
                padding: scaler.getPaddingAll(8),
                child: Text("camera".tr()).regularText(ColorConstants.primaryColor, scaler.getTextSize(12),TextAlign.center),
              ),
            ),
            Divider(
              height: 1.0,
              color: Colors.black,
            ),
            GestureDetector(
              onTap: cancelClick,
              child: Padding(
                padding: scaler.getPaddingAll(8),
                child: Text("cancel".tr()).regularText(ColorConstants.colorRed, scaler.getTextSize(12),TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

