import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/contact_description_provider.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/organizedEventsCard.dart';
import 'package:provider/provider.dart';

class ContactDescriptionScreen extends StatelessWidget {
  ContactDescriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);

    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context),
        body: BaseView<ContactDescriptionProvider>(
            builder: (builder, provider, _) {
              return LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Padding(
                            padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: scaler.getHeight(2)),
                                CommonWidgets.userDetails(scaler,
                                    profilePic: provider.userDetail.profileUrl,
                                    firstName: provider.userDetail.firstName
                                        .toString()
                                        .capitalize(),
                                    lastName: provider.userDetail.lastName
                                        .toString()
                                        .capitalize(),
                                    email: provider.userDetail.email,
                                    actionOnEmail: provider.userDetail.checkForInvitation!
                                        ? () {}
                                        : () {
                                      provider.sendingMails(context);
                                    }),
                                SizedBox(height: scaler.getHeight(2.5)),
                                GestureDetector(
                                  onTap: () {
                                    provider.userDetail.checkForInvitation!
                                        ? Container()
                                        // : CommonWidgets.bottomSheet(
                                        // context,
                                        // scaler,
                                        // bottomDesign(context, scaler,
                                        //     callClick: () {
                                        //       provider.makePhoneCall(context);
                                        //     }, smsClick: () {
                                        //       provider.sendingSMS(context);
                                        //     }, whatsAppClick: () {
                                        //       provider.openingWhatsApp(context);
                                        //     }));
                                    : bottomDesign(context, scaler,
                                        callClick: () {
                                          provider.makePhoneCall(context);
                                        }, smsClick: () {
                                          provider.sendingSMS(context);
                                        }, whatsAppClick: () {
                                          provider.openingWhatsApp(context);
                                        });
                                  },
                                  child: CommonWidgets.phoneNoAndAddressFun(
                                      scaler,
                                      ImageConstants.phone_no_icon,
                                      "phone_number".tr(),
                                      provider.userDetail.phone ?? "",
                                      countryCode: true,
                                      cCode: provider.userDetail.countryCode),
                                ),
                                SizedBox(height: scaler.getHeight(1.5)),
                                CommonWidgets.phoneNoAndAddressFun(
                                    scaler,
                                    ImageConstants.address_icon,
                                    "address".tr(),
                                    provider.userDetail.address ?? ""),
                                SizedBox(height: scaler.getHeight(3)),
                                // Text("organized_events".tr()).boldText(
                                //     ColorConstants.colorBlack,
                                //     scaler.getTextSize(10),
                                //     TextAlign.left),
                                // SizedBox(height: scaler.getHeight(1.5)),
                              ],
                            ),
                          ),
                          OrganizedEventsCard(showEventRespondBtn: false, showEventScreen: true),
                          provider.userDetail.checkForInvitation!
                              ? provider.state == ViewState.Busy
                              ? Expanded(
                              child: Container(
                                  padding: scaler.getPaddingLTRB(
                                      0.0, 0.0, 0.0, 1.0),
                                  alignment: Alignment.bottomCenter,
                                  child: CircularProgressIndicator()))
                              : Expanded(
                            child: CommonWidgets.expandedRowButton(
                                context,
                                scaler,
                                "reject_invite".tr(),
                                "accept_invite".tr(),
                                btn1: false, onTapBtn1: () {
                              provider.acceptOrRejectInvitation(context,
                                  provider.userDetail.cid!, false, "Reject");
                            }, onTapBtn2: () {
                              provider.acceptOrRejectInvitation(context,
                                  provider.userDetail.cid!, true, "Accept");
                            }),
                          )
                              : Container(),
                          SizedBox(height: scaler.getHeight(1.5))
                        ],
                      ),
                    ),
                  ),
                );
              });
            }));
  }

   bottomDesign(BuildContext context, ScreenScaler scaler,
      {required VoidCallback callClick,
      required VoidCallback smsClick,
      required VoidCallback whatsAppClick}) {
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
                    SizedBox(height: scaler.getHeight(2)),
                    GestureDetector(
                      onTap: callClick,
                      child: Text("call".tr()).regularText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(11),
                          TextAlign.center),
                    ),
                    SizedBox(height: scaler.getHeight(0.9)),
                    Divider(),
                    SizedBox(height: scaler.getHeight(0.9)),
                    GestureDetector(
                      onTap: smsClick,
                      child: Text("sms".tr()).regularText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(11),
                          TextAlign.center),
                    ),
                    SizedBox(height: scaler.getHeight(0.9)),
                    Divider(),
                    SizedBox(height: scaler.getHeight(0.9)),
                    GestureDetector(
                      onTap: whatsAppClick,
                      child: Text("whats_app".tr()).regularText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(11),
                          TextAlign.center),
                    ),
                    SizedBox(height: scaler.getHeight(2)),
                  ],
                ),
                GestureDetector(
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
    // return Column(
    //   children: [
    //     Card(
    //       color: ColorConstants.colorWhite.withOpacity(0.7),
    //       shape:
    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    //       child: Column(
    //         children: [
    //           SizedBox(height: scaler.getHeight(1.5)),
    //           GestureDetector(
    //             onTap: callClick,
    //             child: Text("call".tr()).regularText(
    //                 ColorConstants.primaryColor,
    //                 scaler.getTextSize(11),
    //                 TextAlign.center),
    //           ),
    //           SizedBox(height: scaler.getHeight(0.9)),
    //           Divider(),
    //           SizedBox(height: scaler.getHeight(0.9)),
    //           GestureDetector(
    //             onTap: smsClick,
    //             child: Text("sms".tr()).regularText(ColorConstants.primaryColor,
    //                 scaler.getTextSize(11), TextAlign.center),
    //           ),
    //           SizedBox(height: scaler.getHeight(0.9)),
    //           Divider(),
    //           SizedBox(height: scaler.getHeight(0.9)),
    //           GestureDetector(
    //             onTap: whatsAppClick,
    //             child: Text("whats_app".tr()).regularText(
    //                 ColorConstants.primaryColor,
    //                 scaler.getTextSize(11),
    //                 TextAlign.center),
    //           ),
    //           SizedBox(height: scaler.getHeight(1.5)),
    //         ],
    //       ),
    //     ),
    //     CommonWidgets.cancelBtn(scaler, context, 5.0),
    //     SizedBox(height: scaler.getHeight(1)),
    //   ],
    // );
  }
}
