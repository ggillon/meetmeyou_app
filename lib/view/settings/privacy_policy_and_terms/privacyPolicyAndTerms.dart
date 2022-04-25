import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/helper/shared_pref.dart';
import 'package:meetmeyou_app/provider/privacy_policy_provider.dart';
import 'package:meetmeyou_app/services/mmy/about.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:url_launcher/url_launcher.dart';

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
        body: BaseView<PrivacyPolicyProvider>(
          builder: (context, provider, _) {
            return SafeArea(
              child: Padding(
                padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0),
                child: privacyPolicy
                    ?  provider.state == ViewState.Busy ? Center(
                  child: CircularProgressIndicator(),
                ) : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("privacy_policy".tr()).boldText(
                                ColorConstants.colorBlack,
                                scaler.getTextSize(16),
                                TextAlign.left),
                            SizedBox(height: scaler.getHeight(2)),
                            Container(
                              child: Text(getPrivacyPolicy()).regularText(
                                  ColorConstants.colorGray,
                                  scaler.getTextSize(10),
                                  TextAlign.left),
                            ),
                            SizedBox(height: scaler.getHeight(1.5)),
                            GestureDetector(
                              onTap: () {
                                _launchDataPolicyURL(context);
                              },
                              child: Text("our_detailed_data_policy".tr())
                                  .boldText(ColorConstants.primaryColor,
                                      scaler.getTextSize(9.5), TextAlign.left),
                            ),
                            SizedBox(height: scaler.getHeight(1.0)),
                            GestureDetector(
                              onTap: () {
                                DialogHelper.showDialogWithTwoButtons(context,
                                    "delete_user".tr(), "all_data_delete".tr(),
                                    positiveButtonPress: () {
                                  provider
                                      .deleteUser(context)
                                      .then((value) async {
                                    provider.auth.signOut();
                                    provider.userDetail.userType = null;
                                    provider.userDetail.profileUrl = null;
                                    SharedPref.clearSharePref();
                                    provider.calendarDetail.fromDeepLink ==
                                        false;
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            RoutesConstants.loginOptions,
                                            (route) => false);
                                  });
                                });
                              },
                              child: Text(
                                      "delete_all_the_data_linked_to_your_account"
                                          .tr())
                                  .boldText(ColorConstants.primaryColor,
                                      scaler.getTextSize(9.5), TextAlign.left),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("terms_and_conditions".tr()).boldText(
                              ColorConstants.colorBlack,
                              scaler.getTextSize(16),
                              TextAlign.left),
                          SizedBox(height: scaler.getHeight(2)),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                child: Text(getTermsCondition()).regularText(
                                    ColorConstants.colorGray,
                                    scaler.getTextSize(10),
                                    TextAlign.left),
                              ),
                            ),
                          ),
                          SizedBox(height: scaler.getHeight(1)),
                          Container(
                            alignment: Alignment.center,
                            child: Text("application_version".tr() +
                                    ": " +
                                    getVersion())
                                .regularText(ColorConstants.colorGray,
                                    scaler.getTextSize(10), TextAlign.center),
                          ),
                          SizedBox(height: scaler.getHeight(0.5)),
                        ],
                      ),
              ),
            );
          },
        ));
  }

  _launchDataPolicyURL(BuildContext context) async {
    const url =
        'https://www.termsfeed.com/live/1775afca-122b-4296-8fa8-75733a5f3d84';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      DialogHelper.showMessage(context, 'Could not launch $url');
    }
  }
}
