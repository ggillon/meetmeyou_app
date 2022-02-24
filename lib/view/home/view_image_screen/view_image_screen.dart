import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/provider/view_image_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class ViewImageScreen extends StatelessWidget {
   ViewImageScreen({Key? key, required this.viewImageData}) : super(key: key);
 ViewImageData viewImageData;
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorBlack,
      body: BaseView<ViewImageProvider>(
        builder: (context, provider, _){
          return Padding(
            padding: viewImageData.image == null || viewImageData.image == "" ? scaler.getPaddingLTRB(1.0, 3.3, 1.0, 0.5) : scaler.getPaddingLTRB(3.0, 3.3, 3.0, 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close,  color: ColorConstants.primaryColor, size: 30)),
                SizedBox(height: scaler.getHeight(1.5)),
              ClipRRect(
                borderRadius: scaler.getBorderRadiusCircular(10),
                child: Container(
                  color: ColorConstants.primaryColor,
                    width: double.infinity,
                    height: viewImageData.image == null || viewImageData.image == "" ? scaler.getHeight(80.0) : scaler.getHeight(72.0),
                    child: ImageView(
                      path:  viewImageData.image == null || viewImageData.image == "" ? viewImageData.imageUrl :  viewImageData.image!.path,
                      fit: BoxFit.cover,
                    ),
                  ),
              ),
                SizedBox(height: scaler.getHeight(2)),
                viewImageData.image == null || viewImageData.image == "" ? Container() : Center(
                  child: provider.state == ViewState.Busy ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(height: scaler.getHeight(0.5)),
                      Text("sending_image".tr()).mediumText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(8),
                          TextAlign.left),
                    ],
                  ) :
                  InkWell(
                    onTap: (){
                      provider.postDiscussionMessage(context, viewImageData.image!).then((value) {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                        padding: scaler.getPaddingAll(8.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorConstants.primaryColor.withOpacity(0.3)
                        ),
                        child: Icon(Icons.send, color: ColorConstants.primaryColor, size: 32)),
                  ),
                )
              ],
            ),
          );
        },
      )
    );
  }
}

class ViewImageData{
  File? image;
  String imageUrl;
  String replyMid;

  ViewImageData({this.image, required this.imageUrl, required this.replyMid});
}
