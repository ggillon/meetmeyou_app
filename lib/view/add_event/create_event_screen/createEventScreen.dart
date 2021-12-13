import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/create_event_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CreateEventScreen extends StatelessWidget {
  CreateEventScreen({Key? key}) : super(key: key);
  final eventNameController = TextEditingController();
  final addressController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorConstants.colorWhite,
          body: BaseView<CreateEventProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      selectedImage(context, scaler, provider),
                      SizedBox(height: scaler.getHeight(0.5)),
                      Padding(
                        padding: scaler.getPaddingAll(11),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("event_name".tr()).boldText(
                                  Colors.black,
                                  scaler.getTextSize(9.5),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.2)),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: eventNameController,
                              style: ViewDecoration.textFieldStyle(
                                  scaler.getTextSize(9.5),
                                  ColorConstants.colorBlack),
                              decoration:
                                  ViewDecoration.inputDecorationWithCurve(
                                      "Thomas Birthday Party",
                                      scaler,
                                      ColorConstants.primaryColor),
                              onFieldSubmitted: (data) {
                                // FocusScope.of(context).requestFocus(nodes[1]);
                              },
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "event_name_required".tr();
                                }
                                {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: scaler.getHeight(1.5)),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("start_date_and_time".tr()).boldText(
                                  Colors.black,
                                  scaler.getTextSize(9.5),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.2)),
                            startDateTimePickField(context, scaler, provider),
                            SizedBox(height: scaler.getHeight(1.5)),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("end_date_and_time".tr()).boldText(
                                  Colors.black,
                                  scaler.getTextSize(9.5),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.2)),
                            endDateTimePickField(context, scaler, provider),
                            SizedBox(height: scaler.getHeight(1.5)),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("event_location".tr()).boldText(
                                  Colors.black,
                                  scaler.getTextSize(9.5),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.2)),
                            GestureDetector(
                              onTap: () async {
                                Navigator.pushNamed(
                                        context, RoutesConstants.autoComplete)
                                    .then((value) {
                                  if (value != null) {
                                    Map<String, String> detail =
                                        value as Map<String, String>;
                                    final lat = value["latitude"];
                                    final lng = value["longitude"];
                                    final selectedAddress = detail["address"];
                                    addressController.text =
                                        selectedAddress != null
                                            ? selectedAddress
                                            : "";
                                  }
                                });
                              },
                              child: TextFormField(
                                enabled: false,
                                controller: addressController,
                                style: ViewDecoration.textFieldStyle(
                                    scaler.getTextSize(9.5),
                                    ColorConstants.colorBlack),
                                decoration:
                                    ViewDecoration.inputDecorationWithCurve(
                                  "Thomas Birthday Party",
                                  scaler,
                                  ColorConstants.primaryColor,
                                  icon: Icons.map,
                                  // imageView: true,
                                  // path: ImageConstants.map_icon
                                ),
                                onFieldSubmitted: (data) {
                                  // FocusScope.of(context).requestFocus(nodes[1]);
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.streetAddress,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "event_location_required".tr();
                                  }
                                  {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: scaler.getHeight(2)),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("event_description".tr()).boldText(
                                  Colors.black,
                                  scaler.getTextSize(9.5),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.2)),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: eventDescriptionController,
                              style: ViewDecoration.textFieldStyle(
                                  scaler.getTextSize(10),
                                  ColorConstants.colorBlack),
                              decoration: ViewDecoration.inputDecorationWithCurve(
                                  "We are celebrating birthday with Thomas and his family."
                                  " If you are coming make sure you bring good mood and "
                                  "will to party whole night. We are going to have some "
                                  "pinatas so be ready to smash them. Let’s have some "
                                  "drinks and fun!",
                                  scaler,
                                  ColorConstants.primaryColor,
                                  textSize: 10),
                              onFieldSubmitted: (data) {
                                // FocusScope.of(context).requestFocus(nodes[1]);
                              },
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.multiline,
                              maxLines: 6,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "event_description_required".tr();
                                }
                                {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: scaler.getHeight(1.5)),
                            questionAndFeedback(scaler, provider),
                            SizedBox(height: scaler.getHeight(7.5)),
                            provider.fromInviteScreen
                                ? provider.state == ViewState.Busy
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CommonWidgets.expandedRowButton(
                                        context,
                                        scaler,
                                        "cancel_event".tr(),
                                        "save_event".tr(), onTapBtn2: () {
                                        if (_formKey.currentState!.validate()) {
                                          if (provider.image == null &&
                                              provider.eventDetail.eventPhotoUrl == null) {
                                            DialogHelper.showMessage(context,
                                                "Please Select image.");
                                            return;
                                          } else if (provider.startDate
                                              .isAfter(provider.endDate)) {
                                            DialogHelper.showMessage(context,
                                                "Start date cannot high than End date.");
                                            return;
                                          } else if (provider.startDate
                                                  .toString()
                                                  .substring(0, 11)
                                                  .compareTo(provider.endDate
                                                      .toString()
                                                      .substring(0, 11)) ==
                                              0) {
                                            if (provider.startTime.isCompareTo(
                                                    provider.endTime) ==
                                                1) {
                                              DialogHelper.showMessage(context,
                                                  "Select correct time.");
                                            } else {
                                              provider.updateEvent(
                                                  context,
                                                  eventNameController.text,
                                                  addressController.text,
                                                  eventDescriptionController
                                                      .text,
                                                  provider.dateTimeFormat(
                                                      provider.startDate,
                                                      provider.startTime),
                                                  provider.dateTimeFormat(
                                                      provider.endDate,
                                                      provider.endTime),
                                                  photoURL: provider.eventDetail.eventPhotoUrl);
                                            }
                                          } else {
                                            provider.updateEvent(
                                                context,
                                                eventNameController.text,
                                                addressController.text,
                                                eventDescriptionController.text,
                                                provider.dateTimeFormat(
                                                    provider.startDate,
                                                    provider.startTime),
                                                provider.dateTimeFormat(
                                                    provider.endDate,
                                                    provider.endTime),
                                                photoURL: provider.eventDetail.eventPhotoUrl);
                                          }
                                        }
                                      })
                                : provider.state == ViewState.Busy
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CommonWidgets.commonBtn(
                                        scaler,
                                        context,
                                        "next".tr(),
                                        ColorConstants.colorNewGray,
                                        ColorConstants.colorGray, onTapFun: () {
                                        // Navigator.pushNamed(
                                        //         context,
                                        //         RoutesConstants
                                        //             .eventInviteFriendsScreen)
                                        //     .then((value) {
                                        //   provider.fromInviteScreen = true;
                                        //   provider.updateLoadingStatus(true);
                                        // });
                                        if (_formKey.currentState!.validate()) {
                                          if (provider.image == null &&
                                              provider.eventDetail.eventPhotoUrl == null) {
                                            DialogHelper.showMessage(context,
                                                "Please Select image.");
                                            return;
                                          } else if (provider.startDate
                                              .isAfter(provider.endDate)) {
                                            DialogHelper.showMessage(context,
                                                "Start date cannot high than End date.");
                                            return;
                                          } else if (provider.startDate
                                                  .toString()
                                                  .substring(0, 11)
                                                  .compareTo(provider.endDate
                                                      .toString()
                                                      .substring(0, 11)) ==
                                              0) {
                                            if (provider.startTime.isCompareTo(
                                                    provider.endTime) ==
                                                1) {
                                              DialogHelper.showMessage(context,
                                                  "Select correct time.");
                                            } else {
                                              provider.createEvent(
                                                  context,
                                                  eventNameController.text,
                                                  addressController.text,
                                                  eventDescriptionController
                                                      .text,
                                                  provider.dateTimeFormat(
                                                      provider.startDate,
                                                      provider.startTime),
                                                  provider.dateTimeFormat(
                                                      provider.endDate,
                                                      provider.endTime),
                                                  photoURL: provider.eventDetail.eventPhotoUrl,
                                                  photoFile: provider.image);
                                            }
                                          } else {
                                            provider.createEvent(
                                                context,
                                                eventNameController.text,
                                                addressController.text,
                                                eventDescriptionController.text,
                                                provider.dateTimeFormat(
                                                    provider.startDate,
                                                    provider.startTime),
                                                provider.dateTimeFormat(
                                                    provider.endDate,
                                                    provider.endTime),
                                                photoURL: provider.eventDetail.eventPhotoUrl,
                                                photoFile: provider.image);
                                          }
                                        }
                                      }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget selectedImage(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
    return GestureDetector(
      onTap: () async {
        var value = await provider.permissionCheck();
        if (value) {
          selectImageBottomSheet(context, scaler, provider);
        }
      },
      child: Card(
        margin: scaler.getMarginAll(0.0),
        shadowColor: ColorConstants.colorWhite,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircularLR(0.0, 0.0, 15, 15)),
        color: ColorConstants.colorLightGray,
        child: Container(
          height: scaler.getHeight(30),
          width: double.infinity,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                      borderRadius:
                          scaler.getBorderRadiusCircularLR(0.0, 0.0, 15, 15),
                      child: provider.image == null
                          ? provider.eventDetail.eventPhotoUrl != null
                              ? ImageView(
                                  path: provider.eventDetail.eventPhotoUrl,
                                  fit: BoxFit.cover,
                                  height: scaler.getHeight(30),
                                  width: double.infinity,
                                )
                              : imageSelectedCard(context, scaler)
                          : provider.image != null
                              ? ImageView(
                                  file: provider.image,
                                  fit: BoxFit.cover,
                                  height: scaler.getHeight(30),
                                  width: double.infinity,
                                )
                              : imageSelectedCard(context, scaler)),
                  provider.image == null && provider.eventDetail.eventPhotoUrl == null
                      ? Container()
                      : Positioned(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                                padding:
                                    scaler.getPaddingLTRB(0.0, 2, 3.0, 0.0),
                                alignment: Alignment.centerRight,
                                child: ImageView(
                                    path: ImageConstants.close_icon,
                                    color: ColorConstants.colorWhite)),
                          ),
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget imageSelectedCard(BuildContext context, ScreenScaler scaler) {
    return Container(
      padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(height: scaler.getHeight(4.5)),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                alignment: Alignment.centerRight,
                child: ImageView(path: ImageConstants.close_icon)),
          ),
          SizedBox(height: scaler.getHeight(0.5)),
          Stack(
            alignment: Alignment.center,
            children: [
              ImageView(path: ImageConstants.image_border_icon),
              Positioned(
                  child: ImageView(path: ImageConstants.image_frame_icon))
            ],
          ),
          SizedBox(height: scaler.getHeight(1)),
          Text("select_image".tr()).regularText(ColorConstants.primaryColor,
              scaler.getTextSize(9.5), TextAlign.left),
          SizedBox(height: scaler.getHeight(3)),
        ],
      ),
    );
  }

  Widget startDateTimePickField(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
    return Container(
      height: scaler.getHeight(4),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorConstants.colorLightGray,
          border: Border.all(
            color: ColorConstants.colorLightGray,
          ),
          borderRadius: scaler.getBorderRadiusCircular(8.0)),
      child: Container(
        padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                provider.pickDateDialog(context, true);
              },
              child: Container(
                padding: scaler.getPaddingLTRB(1.5, 0.0, 1.5, 0.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ColorConstants.colorWhite,
                    border: Border.all(
                      color: ColorConstants.colorWhite,
                    ),
                    borderRadius: scaler.getBorderRadiusCircular(8.0)),
                height: scaler.getHeight(2.5),
                child: Text(DateTimeHelper.dateConversion(provider.startDate))
                    .regularText(ColorConstants.colorGray,
                        scaler.getTextSize(9.5), TextAlign.center),
              ),
            ),
            GestureDetector(
              onTap: () {
                provider.selectTimeDialog(context, true);
              },
              child: Container(
                padding: scaler.getPaddingLTRB(1.5, 0.0, 1.5, 0.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ColorConstants.colorWhite,
                    border: Border.all(
                      color: ColorConstants.colorWhite,
                    ),
                    borderRadius: scaler.getBorderRadiusCircular(8.0)),
                height: scaler.getHeight(2.5),
                child: Text(DateTimeHelper.timeConversion(provider.startTime))
                    .regularText(ColorConstants.colorGray,
                        scaler.getTextSize(9.5), TextAlign.center),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget endDateTimePickField(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
    return Container(
      height: scaler.getHeight(4),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorConstants.colorLightGray,
          border: Border.all(
            color: ColorConstants.colorLightGray,
          ),
          borderRadius: scaler.getBorderRadiusCircular(8.0)),
      child: Container(
        padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                provider.pickDateDialog(context, false);
              },
              child: Container(
                padding: scaler.getPaddingLTRB(1.5, 0.0, 1.5, 0.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ColorConstants.colorWhite,
                    border: Border.all(
                      color: ColorConstants.colorWhite,
                    ),
                    borderRadius: scaler.getBorderRadiusCircular(8.0)),
                height: scaler.getHeight(2.5),
                child: Text(DateTimeHelper.dateConversion(provider.endDate))
                    .regularText(ColorConstants.colorGray,
                        scaler.getTextSize(9.5), TextAlign.center),
              ),
            ),
            GestureDetector(
              onTap: () {
                provider.selectTimeDialog(context, false);
              },
              child: Container(
                padding: scaler.getPaddingLTRB(1.5, 0.0, 1.5, 0.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ColorConstants.colorWhite,
                    border: Border.all(
                      color: ColorConstants.colorWhite,
                    ),
                    borderRadius: scaler.getBorderRadiusCircular(8.0)),
                height: scaler.getHeight(2.5),
                child: Text(DateTimeHelper.timeConversion(provider.endTime))
                    .regularText(ColorConstants.colorGray,
                        scaler.getTextSize(9.5), TextAlign.center),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget questionAndFeedback(
      ScreenScaler scaler, CreateEventProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("questionare".tr()).boldText(
                Colors.black, scaler.getTextSize(9.5), TextAlign.center),
            SizedBox(height: scaler.getHeight(0.2)),
            Text("ask_for_feedback".tr()).regularText(
                Colors.black, scaler.getTextSize(9.5), TextAlign.center),
          ],
        ),
        FlutterSwitch(
          activeColor: ColorConstants.primaryColor,
          width: scaler.getWidth(10.5),
          height: scaler.getHeight(2.3),
          toggleSize: scaler.getHeight(1.8),
          value: provider.isSwitched,
          borderRadius: 30.0,
          padding: 2.0,
          showOnOff: false,
          onToggle: (val) {
            provider.isSwitched = val;
            provider.updateLoadingStatus(true);
          },
        ),
      ],
    );
  }

  selectImageBottomSheet(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
    return showModalBottomSheet(
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircularLR(25.0, 25.0, 0.0, 0.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Column(
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
                    onTap: () {
                      provider.getImage(context, 1);
                    },
                    child: Text("take_a_photo".tr()).regularText(
                        ColorConstants.primaryColor,
                        scaler.getTextSize(11),
                        TextAlign.center),
                  ),
                  SizedBox(height: scaler.getHeight(0.9)),
                  Divider(),
                  SizedBox(height: scaler.getHeight(0.9)),
                  GestureDetector(
                    onTap: () {
                      provider.getImage(context, 2);
                    },
                    child: Text("choose_photo".tr()).regularText(
                        ColorConstants.primaryColor,
                        scaler.getTextSize(11),
                        TextAlign.center),
                  ),
                  SizedBox(height: scaler.getHeight(0.9)),
                  Divider(),
                  SizedBox(height: scaler.getHeight(0.9)),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(
                              context, RoutesConstants.defaultPhotoPage)
                          .then((value) {
                        provider.image = null;
                        provider.eventDetail.eventPhotoUrl = value as String?;
                        provider.setState(ViewState.Idle);
                      });
                    },
                    child: Text("default_photo".tr()).regularText(
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
              SizedBox(height: scaler.getHeight(1)),
            ],
          );
        });
  }
}
