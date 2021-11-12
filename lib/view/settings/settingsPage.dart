import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: scaler.getPaddingLTRB(1.5, 3, 1.5, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                shadowColor: ColorConstants.colorWhite,
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: scaler.getBorderRadiusCircular(10)),
                child: CustomShape(
                  child: userDetails(scaler, context),
                  bgColor: ColorConstants.colorWhite,
                  radius: scaler.getBorderRadiusCircular(10),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              SizedBox(height: scaler.getHeight(2.5)),
              settingsPageCard(scaler, context, ImageConstants.person_icon,
                  "invite_friends".tr(), true),
              SizedBox(height: scaler.getHeight(1)),
              settingsPageCard(scaler, context, ImageConstants.archive_icon,
                  "history".tr(), true),
              SizedBox(height: scaler.getHeight(1)),
              settingsPageCard(scaler, context, ImageConstants.about_icon,
                  "about".tr(), false),
              Expanded(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: logoutBtn(scaler, context)),
              ),
              SizedBox(height: scaler.getHeight(2.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget userDetails(ScreenScaler scaler, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutesConstants.myAccountScreen);
      },
      child: Padding(
        padding: scaler.getPaddingAll(10.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorConstants.primaryColor,
                  ),
                  color: ColorConstants.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              width: scaler.getWidth(20),
              height: scaler.getWidth(20),
            ),
            SizedBox(width: scaler.getWidth(2.5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Darrell Steward").boldText(ColorConstants.colorBlack,
                      scaler.getTextSize(11), TextAlign.left,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: scaler.getHeight(0.2)),
                  Text("DarrellSteward@example.com").regularText(
                      ColorConstants.colorGray,
                      scaler.getTextSize(9.5),
                      TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)
                ],
              ),
            ),
            moveIcon(ImageConstants.arrow_icon)
          ],
        ),
      ),
    );
  }

  Widget moveIcon(String icon) {
    return SvgPicture.asset(icon);
  }

  Widget settingsPageCard(
      ScreenScaler scaler, BuildContext context, icon, String txt, bool val) {
    return Card(
      shadowColor: ColorConstants.colorWhite,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(10)),
      child: CustomShape(
        child: Padding(
          padding: scaler.getPaddingAll(10.0),
          child: Row(
            children: [
              ImageView(path: icon),
              SizedBox(width: scaler.getWidth(2.5)),
              Text(txt).mediumText(ColorConstants.colorBlack,
                  scaler.getTextSize(9.5), TextAlign.left),
              val
                  ? Expanded(
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: moveIcon(ImageConstants.small_arrow_icon)))
                  : Container()
            ],
          ),
        ),
        bgColor: ColorConstants.colorWhite,
        radius: scaler.getBorderRadiusCircular(10),
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  Widget logoutBtn(
    ScreenScaler scaler,
    BuildContext context,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: CustomShape(
        child: Center(
          child: Text("logout".tr()).mediumText(ColorConstants.colorWhite,
              scaler.getTextSize(10), TextAlign.center),
        ),
        bgColor: ColorConstants.primaryColor,
        radius: scaler.getBorderRadiusCircular(10),
        width: MediaQuery.of(context).size.width,
        height: scaler.getHeight(5),
      ),
    );
  }
}
