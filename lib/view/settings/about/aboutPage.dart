import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/services/mmy/about.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: DialogHelper.appBarWithBack(scaler, context),
      body: SafeArea(
        child: Padding(
          padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text("about".tr()).boldText(ColorConstants.colorBlack,
                    scaler.getTextSize(17), TextAlign.left),
              ),
              SizedBox(height: scaler.getHeight(2.5)),
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  child: Text(getAboutText()).regularText(
                      ColorConstants.colorGray,
                      scaler.getTextSize(11),
                      TextAlign.left),
                ),
              )),
              SizedBox(height: scaler.getHeight(1)),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context, RoutesConstants.privacyPolicyAndTermsPage, arguments: false);
                },
                child: Text("terms_and_conditions".tr()).regularText(
                    ColorConstants.primaryColor,
                    scaler.getTextSize(11),
                    TextAlign.left,
                    underline: true),
              ),
              SizedBox(height: scaler.getHeight(1.2)),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context, RoutesConstants.privacyPolicyAndTermsPage, arguments: true);
                },
                child: Text("privacy_policy".tr()).regularText(
                    ColorConstants.primaryColor,
                    scaler.getTextSize(11),
                    TextAlign.left,
                    underline: true),
              ),
              SizedBox(height: scaler.getHeight(2)),
              Text("application_version".tr() + ": " + getVersion())
                  .regularText(ColorConstants.colorGray, scaler.getTextSize(11),
                      TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
