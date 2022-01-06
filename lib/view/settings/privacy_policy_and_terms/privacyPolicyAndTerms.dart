import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/services/mmy/about.dart';

class PrivacyPolicyAndTermsPage extends StatelessWidget {
  final bool privacyPolicy;

  const PrivacyPolicyAndTermsPage({Key? key, required this.privacyPolicy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: DialogHelper.appBarWithBack(scaler, context),
      body: SafeArea(
        child: Padding(
          padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(privacyPolicy
                      ? "privacy_policy".tr()
                      : "terms_and_conditions".tr())
                  .boldText(ColorConstants.colorBlack, scaler.getTextSize(16),
                      TextAlign.left),
              SizedBox(height: scaler.getHeight(2)),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Text(privacyPolicy
                            ? getPrivacyPolicy()
                            : getTermsCondition())
                        .regularText(ColorConstants.colorGray,
                            scaler.getTextSize(10), TextAlign.left),
                  ),
                ),
              ),
              privacyPolicy
                  ? Container()
                  : SizedBox(height: scaler.getHeight(1)),
              privacyPolicy
                  ? Container()
                  : Container(
                      alignment: Alignment.center,
                      child:
                          Text("application_version".tr() + ": " + getVersion())
                              .regularText(ColorConstants.colorGray,
                                  scaler.getTextSize(10), TextAlign.center),
                    ),
              privacyPolicy
                  ? Container()
                  : SizedBox(height: scaler.getHeight(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
