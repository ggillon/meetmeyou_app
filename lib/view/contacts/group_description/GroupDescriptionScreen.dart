import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';

class GroupDescriptionScreen extends StatelessWidget {
  const GroupDescriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context,
            showEdit: true, editClick: () {
          Navigator.pushNamed(context, RoutesConstants.createEditGroupScreen);
            }),
        body: Padding(
          padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonWidgets.userDetails(scaler,
                  profilePic: ImageConstants.dummy_profile,
                  firstName: "group_name".tr(),
                  lastName: "",
                  email: "description".tr()),
              SizedBox(height: scaler.getHeight(1.5)),
              // Text("contacts_in_groups".tr()).boldText(
              //     ColorConstants.colorBlack,
              //     scaler.getTextSize(10),
              //     TextAlign.left),
              // SizedBox(height: scaler.getHeight(1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
