import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';

class EventGalleryImageView extends StatelessWidget {
  const EventGalleryImageView({Key? key}) : super(key: key);

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
            Text("edit".tr()).mediumText(Colors.blue, scaler.getTextSize(10.5), TextAlign.center)
          ],
        )),
        actions: [
          GestureDetector(
            onTap: (){},
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.blue,),
                SizedBox(width: scaler.getWidth(3.0)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
