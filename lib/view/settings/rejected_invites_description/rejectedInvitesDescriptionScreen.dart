import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/widgets/organizedEventsCard.dart';

class RejectedInvitesDescriptionScreen extends StatelessWidget {
   RejectedInvitesDescriptionScreen({Key? key}) : super(key: key);

  UserDetail userDetail = locator<UserDetail>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: scaler.getHeight(2.2)),
                      CommonWidgets.userDetails(scaler,
                          profilePic: userDetail.profileUrl,
                          firstName: userDetail.firstName.toString().capitalize(),
                          lastName: userDetail.lastName.toString().capitalize(),
                          email: userDetail.email),
                      SizedBox(height: scaler.getHeight(2.8)),
                      CommonWidgets.phoneNoAndAddressFun(
                          scaler,
                          ImageConstants.phone_no_icon,
                          "phone_number".tr(),
                          userDetail.phone!,
                          countryCode: true,
                          cCode: "+1"),
                      SizedBox(height: scaler.getHeight(1.8)),
                      CommonWidgets.phoneNoAndAddressFun(
                          scaler,
                          ImageConstants.address_icon,
                          "address".tr(),
                          userDetail.address!),
                      SizedBox(height: scaler.getHeight(3.5)),
                      // Text("organized_events".tr()).boldText(
                      //     ColorConstants.colorBlack,
                      //     scaler.getTextSize(10),
                      //     TextAlign.left),
                      // SizedBox(height: scaler.getHeight(1.5)),
                    ],
                  ),
                ),
                OrganizedEventsCard(showEventRespondBtn: false, showEventScreen: false),
              ],
            ),
          ),
        ));
  }
}
