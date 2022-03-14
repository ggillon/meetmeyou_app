
import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/provider/group_image_view_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class GroupImageView extends StatelessWidget {
   GroupImageView({Key? key, required this.groupImageData}) : super(key: key);
   GroupImageData groupImageData;
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
        backgroundColor: ColorConstants.colorBlack,
        body: BaseView<GroupImageViewProvider>(
          builder: (context, provider, _){
            return Padding(
              padding: scaler.getPaddingLTRB(3.0, 3.3, 3.0, 0.5),
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
                    borderRadius: scaler.getBorderRadiusCircular(100),
                    child: Container(
                      color: ColorConstants.primaryColor,
                      width: double.infinity,
                      height: scaler.getHeight(40.0),
                      child: ImageView(
                        path: groupImageData.groupImage.path,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: scaler.getHeight(5.0)),
                provider.state == ViewState.Busy ? Center(child: CircularProgressIndicator()) : GestureDetector(
                    onTap: (){
                      if(groupImageData.groupImage != null){
                        provider.updateDiscussionPhoto(context, groupImageData.did, groupImageData.fromChatScreen, photo: groupImageData.groupImage);
                      }
                    },
                      child: CommonWidgets.commonBtn(scaler, context, "update_photo".tr(), ColorConstants.primaryColor, ColorConstants.colorWhite))
                ],
              ),
            );
          },
        )
    );
  }
}

class GroupImageData{
  File groupImage;
  String did;
  bool fromChatScreen;

  GroupImageData({required this.groupImage, required this.did, required this.fromChatScreen});
}
