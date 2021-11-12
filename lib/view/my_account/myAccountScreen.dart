import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/widgets/organizedEventsCard.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context, showEdit: true,
            editClick: () {
          Navigator.pushNamed(context, RoutesConstants.editProfileScreen);
        }),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("my_account".tr()).boldText(ColorConstants.colorBlack,
                        scaler.getTextSize(16), TextAlign.left),
                    SizedBox(height: scaler.getHeight(2)),
                    userDetails(scaler),
                    SizedBox(height: scaler.getHeight(3)),
                    phoneNoAndAddressFun(scaler, ImageConstants.phone_no_icon,
                        "phone_number".tr(), "+1 58 478 95 8"),
                    SizedBox(height: scaler.getHeight(1.5)),
                    phoneNoAndAddressFun(scaler, ImageConstants.address_icon,
                        "address".tr(), "Madison Square Garden"),
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
        ),
      ),
    );
  }

  Widget userDetails(ScreenScaler scaler) {
    return Row(
      children: [
        // Container(
        //   decoration: BoxDecoration(
        //       border: Border.all(
        //         color: ColorConstants.primaryColor,
        //       ),
        //       color: ColorConstants.primaryColor,
        //       borderRadius: BorderRadius.all(Radius.circular(12))),
        //   width: scaler.getWidth(20),
        //   height: scaler.getWidth(20),
        // ),
        ImageView(path: ImageConstants.dummy_profile),
        SizedBox(width: scaler.getWidth(2.5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Jared Dudley").boldText(ColorConstants.colorBlack,
                  scaler.getTextSize(12), TextAlign.left,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: scaler.getHeight(0.5)),
              Text("randomemail@random.com").mediumText(
                  ColorConstants.colorBlack,
                  scaler.getTextSize(10),
                  TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)
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
