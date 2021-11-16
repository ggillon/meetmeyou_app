import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
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
                      userDetails(scaler, provider),
                      SizedBox(height: scaler.getHeight(3)),
                      phoneNoAndAddressFun(scaler, ImageConstants.phone_no_icon,
                          "phone_number".tr(), provider.phoneNumber!),
                      SizedBox(height: scaler.getHeight(1.5)),
                      phoneNoAndAddressFun(scaler, ImageConstants.address_icon,
                          "address".tr(), provider.address!),
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
                  showAttendBtn: true,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget userDetails(ScreenScaler scaler, MyAccountProvider provider) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: scaler.getBorderRadiusCircular(10.0),
          child: ImageView(
            path: provider.userProfilePic,
            width: scaler.getWidth(22),
            height: scaler.getWidth(22),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: scaler.getWidth(2.5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(provider.firstName.toString() +
                      " " +
                      provider.lastName.toString())
                  .boldText(ColorConstants.colorBlack, scaler.getTextSize(12),
                      TextAlign.left,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: scaler.getHeight(0.5)),
              Text(provider.email!).mediumText(ColorConstants.colorBlack,
                  scaler.getTextSize(10), TextAlign.left,
                  maxLines: 1, overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
      ],
    );
  }

  Widget phoneNoAndAddressFun(
      ScreenScaler scaler, String icon, String field, String value) {
    return Row(
      children: [
        SvgPicture.asset(icon),
        SizedBox(width: scaler.getWidth(4)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field).boldText(ColorConstants.colorBlack,
                  scaler.getTextSize(9.5), TextAlign.left),
              SizedBox(height: scaler.getHeight(0.3)),
              Text(value).regularText(ColorConstants.colorGray,
                  scaler.getTextSize(9.5), TextAlign.left,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        )
      ],
    );
  }
}
