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
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/organizedEventsCard.dart';

class ContactDescriptionScreen extends StatelessWidget {
  ContactDescriptionScreen({Key? key}) : super(key: key);

  UserDetail userDetail = locator<UserDetail>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
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
                                  profilePic: userDetail.profileUrl,
                                  firstName: userDetail.firstName
                                      .toString()
                                      .capitalize(),
                                  lastName: userDetail.lastName
                                      .toString()
                                      .capitalize(),
                                  email: userDetail.email,
                                  actionOnEmail: userDetail.checkForInvitation!
                                      ? () {}
                                      : () {
                                          provider.sendingMails(context);
                                        }),
                              SizedBox(height: scaler.getHeight(2.5)),
                              GestureDetector(
                                onTap: () {
                                  userDetail.checkForInvitation!
                                      ? Container()
                                      : CommonWidgets.bottomSheet(
                                          context,
                                          scaler,
                                          bottomDesign(context, scaler,
                                              callClick: () {
                                            provider.makePhoneCall(context);
                                          }, smsClick: () {
                                            provider.sendingSMS(context);
                                          }, whatsAppClick: () {
                                            provider.openingWhatsApp(context);
                                          }));
                                },
                                child: CommonWidgets.phoneNoAndAddressFun(
                                    scaler,
                                    ImageConstants.phone_no_icon,
                                    "phone_number".tr(),
                                    userDetail.phone ?? "",
                                    countryCode: true,
                                    cCode: userDetail.countryCode),
                              ),
                              SizedBox(height: scaler.getHeight(1.5)),
                              CommonWidgets.phoneNoAndAddressFun(
                                  scaler,
                                  ImageConstants.address_icon,
                                  "address".tr(),
                                  userDetail.address ?? ""),
                              SizedBox(height: scaler.getHeight(3)),
                              Text("organized_events".tr()).boldText(
                                  ColorConstants.colorBlack,
                                  scaler.getTextSize(10),
                                  TextAlign.left),
                              SizedBox(height: scaler.getHeight(1.5)),
                            ],
                          ),
                        ),
                        OrganizedEventsCard(showAttendBtn: false),
                        userDetail.checkForInvitation!
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
                                          userDetail.cid!, false, "Reject");
                                    }, onTapBtn2: () {
                                      provider.acceptOrRejectInvitation(context,
                                          userDetail.cid!, true, "Accept");
                                    }),
                                )
                            : Container()
                      ],
                    ),
                  ),
                ),
              );
            });
          })),
    );
  }

  Widget bottomDesign(BuildContext context, ScreenScaler scaler,
      {required VoidCallback callClick,
      required VoidCallback smsClick,
      required VoidCallback whatsAppClick}) {
    return Column(
      children: [
        Card(
          color: ColorConstants.colorWhite.withOpacity(0.7),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            children: [
              SizedBox(height: scaler.getHeight(1.5)),
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
                child: Text("sms".tr()).regularText(ColorConstants.primaryColor,
                    scaler.getTextSize(11), TextAlign.center),
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
              SizedBox(height: scaler.getHeight(1.5)),
            ],
          ),
        ),
        CommonWidgets.cancelBtn(scaler, context, 5.0),
        SizedBox(height: scaler.getHeight(1)),
      ],
    );
  }
}
