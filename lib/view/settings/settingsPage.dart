import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/helper/shared_pref.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/provider/settings_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/services/mmy/notification.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/widgets/shimmer/userProfileCardShimmer.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);
  SettingsProvider? provider;
  AuthBase auth = locator<AuthBase>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        body: BaseView<SettingsProvider>(
          onModelReady: (provider) {
            this.provider = provider;
            provider.getUserDetail(context);
            provider.getCalendarParams(context);
            provider.getUserParameterForEvent(context, PARAM_NOTIFY_EVENT);
            provider.getUserParameterForMessages(context, PARAM_NOTIFY_DISCUSSION);
            provider.getUserParameterForInvitation(context, PARAM_NOTIFY_INVITATION);
          },
          builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Padding(
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
                        child: userDetails(scaler, context, provider),
                        bgColor: ColorConstants.colorWhite,
                        radius: scaler.getBorderRadiusCircular(10),
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    SizedBox(height: scaler.getHeight(2.5)),
                    Column(
                      children: [
                        CommonWidgets.settingsPageCard(
                            scaler,
                            context,
                            ImageConstants.person_icon,
                            "search_contact_book".tr(),
                            true, onTapCard: () {
                          Navigator.pushNamed(
                              context, RoutesConstants.inviteFriendsScreen);
                        }),
                        SizedBox(height: scaler.getHeight(1)),
                        CommonWidgets.settingsPageCard(
                            scaler,
                            context,
                            ImageConstants.person_icon,
                            "rejected_invites".tr(),
                            true, onTapCard: () {
                          Navigator.pushNamed(
                              context, RoutesConstants.rejectedInvitesScreen);
                        }, isIcon: false),
                        SizedBox(height: scaler.getHeight(1)),
                        CommonWidgets.settingsPageCard(
                            scaler,
                            context,
                            ImageConstants.archive_icon,
                            "history".tr(),
                            true, onTapCard: () {
                          Navigator.pushNamed(
                              context, RoutesConstants.historyScreen);
                        }),
                        SizedBox(height: scaler.getHeight(1)),
                        CommonWidgets.settingsPageCard(
                            scaler,
                            context,
                            ImageConstants.calendar_icon,
                            "calender_settings".tr(),
                            true, onTapCard: () {
                          Navigator.pushNamed(
                              context, RoutesConstants.calendarSettingsScreen);
                        }),
                        SizedBox(height: scaler.getHeight(1)),
                        CommonWidgets.settingsPageCard(
                            scaler,
                            context,
                            ImageConstants.speaker_icon,
                            "notification_settings".tr(),
                            true, onTapCard: () {
                          Navigator.pushNamed(
                              context, RoutesConstants.notificationSettings);
                        }),
                        SizedBox(height: scaler.getHeight(1)),
                        CommonWidgets.settingsPageCard(
                            scaler,
                            context,
                            ImageConstants.about_icon,
                            "about".tr(),
                            false, onTapCard: () {
                          Navigator.pushNamed(
                              context, RoutesConstants.aboutPage);
                        }),
                        SizedBox(height: scaler.getHeight(1.5)),
                        DialogHelper.btnWidget(scaler, context, "logout".tr(),
                            ColorConstants.primaryColor, funOnTap: () async {
                          auth.signOut();
                          provider.userDetail.profileUrl = null;
                          SharedPref.clearSharePref();
                          provider.calendarDetail.fromDeepLink == false;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              RoutesConstants.loginOptions, (route) => false);
                        }),
                        DialogHelper.btnWidget(scaler, context, "switch_mode".tr(),
                            ColorConstants.colorBlackDown, funOnTap: () {
                          switchModeBottomSheet(context, scaler);
                            }),
                        DialogHelper.btnWidget(
                            scaler,
                            context,
                            "delete_user".tr(),
                            ColorConstants.colorRed, funOnTap: () {
                          DialogHelper.showDialogWithTwoButtons(
                              context,
                              "delete_user".tr(),
                              "sure_to_delete_user".tr());
                        }),
                      ],
                    ),
                    SizedBox(height: scaler.getHeight(1)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget userDetails(
      ScreenScaler scaler, BuildContext context, SettingsProvider provider) {
    return provider.state == ViewState.Busy
        ? UserProfileCardShimmer()
        : InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutesConstants.myAccountScreen)
                  .then((value) {
                this.provider!.updateLoadingStatus(true);
                this.provider!.getUserDetail(context);
              });
            },
            child: Padding(
              padding: scaler.getPaddingAll(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: scaler.getWidth(22),
                        height: scaler.getWidth(22),
                        child: ClipRRect(
                          borderRadius: scaler.getBorderRadiusCircular(10.0),
                          child: ImageView(
                            path: provider.userDetail.profileUrl,
                            width: scaler.getWidth(22),
                            height: scaler.getWidth(22),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: scaler.getWidth(2.5)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(provider.userDetail.firstName.toString() +
                                    " " +
                                    provider.userDetail.lastName.toString())
                                .boldText(ColorConstants.colorBlack,
                                    scaler.getTextSize(11), TextAlign.left,
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                            SizedBox(height: scaler.getHeight(0.2)),
                            Text(provider.userDetail.email.toString()).regularText(
                                ColorConstants.colorGray,
                                scaler.getTextSize(9.5),
                                TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      ImageView(path: ImageConstants.arrow_icon)
                    ],
                  ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     Text(provider.auth.currentUser!.uid.toString()).regularText(
                         Colors.grey[300] ?? ColorConstants.colorGray,
                         scaler.getTextSize(9.5),
                         TextAlign.left,
                         maxLines: 1,
                         overflow: TextOverflow.ellipsis),
                     SizedBox(width: scaler.getWidth(2.5))
                   ],
                 )
                ],
              ),
            ),
          );
  }

  switchModeBottomSheet(BuildContext context, ScreenScaler scaler){
    return showModalBottomSheet(
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircularLR(25.0, 25.0, 0.0, 0.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: scaler.getHeight(0.5)),
                Container(
                  decoration: BoxDecoration(
                      color: ColorConstants.colorMediumGray,
                      borderRadius: scaler.getBorderRadiusCircular(10.0)),
                  height: scaler.getHeight(0.4),
                  width: scaler.getWidth(12),
                ),
                Column(
                  children: [
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                       // onTap: going,
                        child: Column(
                          children: [
                            SizedBox(height: scaler.getHeight(2)),
                            Container(
                              width: double.infinity,
                              child: Text("normal_usage".tr()).regularText(
                                  ColorConstants.primaryColor,
                                  scaler.getTextSize(11),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.9)),
                          ],
                        )
                    ),
                    Divider(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                     // onTap: notGoing,
                      child: Column(
                        children: [
                          SizedBox(height: scaler.getHeight(0.9)),
                          Container(
                            width: double.infinity,
                            child: Text("creator_mode".tr()).regularText(
                                ColorConstants.primaryColor,
                                scaler.getTextSize(11),
                                TextAlign.center),
                          ),
                          SizedBox(height: scaler.getHeight(0.9)),
                        ],
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                    //  onTap: hide,
                      child: Column(
                        children: [
                          SizedBox(height: scaler.getHeight(0.9)),
                          Container(
                            width: double.infinity,
                            child: Text("admin_mode".tr()).regularText(
                                ColorConstants.primaryColor,
                                scaler.getTextSize(11),
                                TextAlign.center),
                          ),
                          SizedBox(height: scaler.getHeight(2)),
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Text("cancel".tr()).semiBoldText(
                        ColorConstants.colorRed,
                        scaler.getTextSize(11),
                        TextAlign.center),
                  ),
                ),
                SizedBox(height: scaler.getHeight(0.5)),
              ],
            ),
          );
        });
  }
}
