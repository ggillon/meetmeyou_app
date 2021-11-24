import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/contact_description_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/organizedEventsCard.dart';

class ContactDescriptionScreen extends StatelessWidget {
  final UserDetail data;

  const ContactDescriptionScreen({Key? key, required this.data})
      : super(key: key);

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
                                  profilePic: ImageConstants.dummy_profile,
                                  firstName:
                                      data.firstName.toString().capitalize(),
                                  lastName: "",
                                  email: data.email, actionOnEmail: () {
                                provider.sendingMails(context);
                              }),
                              SizedBox(height: scaler.getHeight(2.5)),
                              GestureDetector(
                                onTap: () {
                                  CommonWidgets.bottomSheet(
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
                                    "58 478 95 6",
                                    countryCode: true,
                                    cCode: "+1"),
                              ),
                              SizedBox(height: scaler.getHeight(1.5)),
                              CommonWidgets.phoneNoAndAddressFun(
                                  scaler,
                                  ImageConstants.address_icon,
                                  "address".tr(),
                                  "Madison Square Garden"),
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
                        // data.value!
                        //     ? Expanded(
                        //         child: Container(
                        //           alignment: Alignment.bottomCenter,
                        //           child: Padding(
                        //             padding:
                        //                 scaler.getPaddingLTRB(2, 0.0, 2, 1),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceEvenly,
                        //               children: [
                        //                 Expanded(
                        //                   child: GestureDetector(
                        //                     onTap: () {
                        //                       Navigator.pop(context);
                        //                     },
                        //                     child: CustomShape(
                        //                       child: Center(
                        //                           child: Text("discard".tr())
                        //                               .mediumText(
                        //                                   ColorConstants
                        //                                       .primaryColor,
                        //                                   scaler
                        //                                       .getTextSize(10),
                        //                                   TextAlign.center)),
                        //                       bgColor: ColorConstants
                        //                           .primaryColor
                        //                           .withOpacity(0.2),
                        //                       radius: BorderRadius.all(
                        //                         Radius.circular(12),
                        //                       ),
                        //                       width: scaler.getWidth(40),
                        //                       height: scaler.getHeight(4.5),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 SizedBox(
                        //                   width: scaler.getWidth(2),
                        //                 ),
                        //                 Expanded(
                        //                     child: GestureDetector(
                        //                   onTap: () {},
                        //                   child: CustomShape(
                        //                     child: Center(
                        //                         child: Text("save_changes".tr())
                        //                             .mediumText(
                        //                                 ColorConstants
                        //                                     .colorWhite,
                        //                                 scaler.getTextSize(10),
                        //                                 TextAlign.center)),
                        //                     bgColor:
                        //                         ColorConstants.primaryColor,
                        //                     radius: BorderRadius.all(
                        //                       Radius.circular(12),
                        //                     ),
                        //                     width: scaler.getWidth(40),
                        //                     height: scaler.getHeight(4.5),
                        //                   ),
                        //                 )),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     : Container()
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
        CommonWidgets.cancelBtn(scaler, context),
        SizedBox(height: scaler.getHeight(1)),
      ],
    );
  }
}
