import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/my_account_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/widgets/organizedEventsCard.dart';

class MyAccountScreen extends StatelessWidget {
  MyAccountScreen({Key? key}) : super(key: key);
  MyAccountProvider? provider;
  UserDetail userDetail = locator<UserDetail>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context, showEdit: true,
            editClick: () {
          Navigator.pushNamed(context, RoutesConstants.editProfileScreen)
              .then((value) {
            this.provider!.updateLoadingStatus(true);
            this.provider!.getUserDetail();
          });
        }),
        body: BaseView<MyAccountProvider>(onModelReady: (provider) {
          this.provider = provider;
          provider.getUserDetail();
          this.provider!.updateLoadingStatus(true);
        }, builder: (context, provider, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("my_account".tr()).boldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(16),
                          TextAlign.left),
                      SizedBox(height: scaler.getHeight(2)),
                      CommonWidgets.userDetails(scaler,
                          profilePic: provider.userProfilePic,
                          firstName: provider.firstName.toString(),
                          lastName: provider.lastName.toString(),
                          email: provider.email),
                      SizedBox(height: scaler.getHeight(3)),
                      CommonWidgets.phoneNoAndAddressFun(
                          scaler,
                          ImageConstants.phone_no_icon,
                          "phone_number".tr(),
                          provider.phoneNumber!,
                          countryCode: true,
                          cCode: provider.countryCode),
                      SizedBox(height: scaler.getHeight(1.5)),
                      CommonWidgets.phoneNoAndAddressFun(
                          scaler,
                          ImageConstants.address_icon,
                          "address".tr(),
                          provider.address!),
                      SizedBox(height: scaler.getHeight(3)),
                      Text("organized_events".tr()).boldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(10),
                          TextAlign.left),
                      SizedBox(height: scaler.getHeight(1.5)),
                    ],
                  ),
                ),
                OrganizedEventsCard(
                  showEventRespondBtn: true,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
