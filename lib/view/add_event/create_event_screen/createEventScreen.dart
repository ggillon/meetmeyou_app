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
import 'package:meetmeyou_app/helper/common_used.dart';
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
  final _questionFormKey = GlobalKey<FormState>();
  List<Column> _fields = [];

  // List<String> questionsList = [];
  final questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: BaseView<CreateEventProvider>(
          onModelReady: (provider) {
            if (provider.eventDetail.editEvent == true) {
              provider.eventDetail.eventPhotoUrl =
                  provider.eventDetail.photoUrlEvent;
              eventNameController.text = provider.eventDetail.eventName ?? "";
              provider.startDate =
                  provider.eventDetail.startDateAndTime ?? DateTime.now();
              provider.startTime = TimeOfDay.fromDateTime(
                  provider.eventDetail.startDateAndTime ?? DateTime.now());
              provider.endDate =
                  provider.eventDetail.endDateAndTime ?? DateTime.now();
              provider.endTime = TimeOfDay.fromDateTime(
                  provider.eventDetail.endDateAndTime ?? DateTime.now());
              addressController.text = provider.eventDetail.eventLocation ?? "";
              eventDescriptionController.text =
                  provider.eventDetail.eventDescription ?? "";

              // getting questions from map form.
              if (provider.eventDetail.event!.form.isNotEmpty) {
                List<String> questionsList = [];
                for (var value in provider.eventDetail.event!.form.values) {
                  questionsList.add(value);
                  questionController.text = value;
                  questionnaireText(context, provider, scaler, addQue: false);
                }
                // List<String> keysList = [];
                // for (var key in provider.eventDetail.event!.form.keys) {
                //   keysList.add(key);
                // }

                if (questionsList.length > 0) {
                  provider.isSwitched = true;
                }
              }
            }
          },
          builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    selectedImage(context, scaler, provider),
                    //  SizedBox(height: scaler.getHeight(0.5)),
                    SafeArea(
                      child: Padding(
                        padding: scaler.getPaddingLTRB(3.0, 0.0, 3.0, 0.0),
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
                                hideKeyboard(context);
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
                            provider.eventDetail.editEvent == true
                                ? questionAndFeedback(context, scaler, provider)
                                : Container(),
                            provider.isSwitched == true && _fields.length > 0
                                ? SizedBox(height: scaler.getHeight(1.5))
                                : SizedBox(height: scaler.getHeight(0.0)),
                            provider.isSwitched == true
                                ? questionsListView(provider, scaler)
                                : Container(),
                            provider.isSwitched == true
                                ? SizedBox(height: scaler.getHeight(1.0))
                                : SizedBox(height: scaler.getHeight(0.0)),
                            provider.isSwitched == true
                                ? addQuestion(context, provider, scaler)
                                : Container(),
                            SizedBox(height: scaler.getHeight(2.5)),
                            provider.eventDetail.editEvent == true
                                ? GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      Navigator.pushNamed(
                                              context,
                                              RoutesConstants
                                                  .eventInviteFriendsScreen)
                                          .then((value) {
                                        provider.fromInviteScreen = true;
                                        provider.updateLoadingStatus(true);
                                        hideKeyboard(context);
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child:
                                              Text("invite_more_friends".tr())
                                                  .boldText(
                                                      ColorConstants
                                                          .primaryColor,
                                                      scaler.getTextSize(10.5),
                                                      TextAlign.center),
                                        ),
                                        ImageView(
                                            path:
                                                ImageConstants.small_arrow_icon,
                                            color: ColorConstants.primaryColor)
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: scaler.getHeight(3.5)),
                            provider.fromInviteScreen == true ||
                                    provider.eventDetail.editEvent == true
                                ? provider.state == ViewState.Busy
                                    ? Center(
                                        child: Column(
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(
                                                height: scaler.getHeight(1.5)),
                                          ],
                                        ),
                                      )
                                    : CommonWidgets.expandedRowButton(
                                        context,
                                        scaler,
                                        "cancel_event".tr(),
                                        "save_event".tr(),
                                        onTapBtn1: () {
                                          DialogHelper.showDialogWithTwoButtons(
                                              context,
                                              "cancel_event".tr(),
                                              "sure_to_cancel_event".tr(),
                                              negativeButtonLabel: "No",
                                              positiveButtonPress: () {
                                            Navigator.of(context).pop();
                                            provider.cancelEvent(context);
                                          });
                                        },
                                        btn1: false,
                                        onTapBtn2: () {
                                          provider.eventDetail.contactCIDs = [];
                                          provider.eventDetail.groupIndexList =
                                              [];
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (provider.image == null &&
                                                provider.eventDetail
                                                        .eventPhotoUrl ==
                                                    null) {
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
                                              if (provider.startTime
                                                      .isCompareTo(
                                                          provider.endTime) ==
                                                  1) {
                                                DialogHelper.showMessage(
                                                    context,
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
                                                    photoURL: provider
                                                        .eventDetail
                                                        .eventPhotoUrl);
                                              }
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
                                                  photoURL: provider.eventDetail
                                                      .eventPhotoUrl);
                                            }
                                          }
                                        })
                                : provider.state == ViewState.Busy
                                    ? Center(
                                        child: Column(
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(
                                                height: scaler.getHeight(1.5)),
                                          ],
                                        ),
                                      )
                                    : CommonWidgets.commonBtn(
                                        scaler,
                                        context,
                                        "next".tr(),
                                        ColorConstants.primaryColor,
                                        ColorConstants.colorWhite,
                                        onTapFun: () {
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
                                              provider.eventDetail
                                                      .eventPhotoUrl ==
                                                  null) {
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
                                                  photoURL: provider.eventDetail
                                                      .eventPhotoUrl,
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
                                                photoURL: provider
                                                    .eventDetail.eventPhotoUrl,
                                                photoFile: provider.image);
                                          }
                                        }
                                      }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
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
        margin: scaler.getMarginLTRB(1.0, 0.0, 1.0, 0.0),
        shadowColor: ColorConstants.colorWhite,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircularLR(0.0, 0.0, 16, 16)),
        color: ColorConstants.colorLightGray,
        child: Container(
          height: scaler.getHeight(34),
          width: double.infinity,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                      borderRadius:
                          scaler.getBorderRadiusCircularLR(0.0, 0.0, 16, 16),
                      child: provider.image == null
                          ? provider.eventDetail.eventPhotoUrl != null
                              ? ImageView(
                                  path: provider.eventDetail.eventPhotoUrl,
                                  fit: BoxFit.cover,
                                  height: scaler.getHeight(34),
                                  width: double.infinity,
                                )
                              : imageSelectedCard(context, scaler)
                          : provider.image != null
                              ? ImageView(
                                  file: provider.image,
                                  fit: BoxFit.cover,
                                  height: scaler.getHeight(34),
                                  width: double.infinity,
                                )
                              : imageSelectedCard(context, scaler)),
                  provider.image == null &&
                          provider.eventDetail.eventPhotoUrl == null
                      ? Container()
                      : Positioned(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                                padding:
                                    scaler.getPaddingLTRB(0.0, 4.0, 3.0, 0.0),
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
                hideKeyboard(context);
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
                hideKeyboard(context);
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
                hideKeyboard(context);
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
                child: Text(
                    // provider.startTime.hour >= 21
                    //     ? DateTimeHelper.dateConversion(
                    //         provider.endDate.add(Duration(days: 1)))
                    //     :
                DateTimeHelper.dateConversion(provider.endDate))
                    .regularText(ColorConstants.colorGray,
                        scaler.getTextSize(9.5), TextAlign.center),
              ),
            ),
            GestureDetector(
              onTap: () {
                hideKeyboard(context);
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
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
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
            hideKeyboard(context);
            provider.isSwitched = val;
            val == true ? Container() : _fields.clear();
            ;
            provider.updateLoadingStatus(true);
          },
        ),
      ],
    );
  }

  Widget addQuestion(
      BuildContext context, CreateEventProvider provider, ScreenScaler scaler) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_fields.length < 5) {
          popupForAddingQuestion(context, scaler, provider);
        } else {
          DialogHelper.showMessage(context, "cannot_add_more_than_5_que".tr());
        }
        questionController.clear();
        hideKeyboard(context);
      },
      child: Row(
        children: [
          SizedBox(width: scaler.getWidth(1.8)),
          Icon(Icons.add, color: ColorConstants.primaryColor, size: 15),
          SizedBox(width: scaler.getWidth(0.2)),
          Text(provider.isSwitched == true && _fields.length > 0
                  ? "add_another_question".tr()
                  : "add_question".tr())
              .mediumText(ColorConstants.primaryColor, 10.0, TextAlign.left),
        ],
      ),
    );
  }

  Widget questionsListView(CreateEventProvider provider, ScreenScaler scaler) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _fields[index],
            GestureDetector(
                onTap: () {
                  _fields.removeAt(index);
                  provider.updateQuestionStatus(true);
                },
                child: Icon(Icons.close))
          ],
        );
      },
    );
  }

  questionnaireText(
      BuildContext context, CreateEventProvider provider, ScreenScaler scaler,
      {bool addQue = true}) {
    // final controller = TextEditingController();
    final field =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("${"question".tr()} ${_fields.length + 1}")
          .boldText(ColorConstants.colorBlack, 9.5, TextAlign.left),
      SizedBox(height: scaler.getHeight(0.2)),
      Container(
        width: scaler.getWidth(78),
        child: Text(questionController.text).mediumText(
            ColorConstants.colorBlack, 12, TextAlign.left,
            maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
      SizedBox(height: scaler.getHeight(0.7)),
    ]);

    //   questionControllers.add(controller);

    _fields.add(field);
    // questionsList.add(questionController.text);
    addQue
        ? provider.addQuestionToEvent(context, provider.eventDetail.event!,
            _fields.length, questionController.text)
        : Container();
    provider.updateQuestionStatus(true);
  }

  popupForAddingQuestion(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            child: AlertDialog(
              title: Text('Add_Your_Question'.tr())
                  .boldText(ColorConstants.colorBlack, 14, TextAlign.left),
              content: Form(
                key: _questionFormKey,
                child: Container(
                  width: double.maxFinite,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: questionController,
                    style: ViewDecoration.textFieldStyle(
                        scaler.getTextSize(10), ColorConstants.colorBlack),
                    decoration: ViewDecoration.inputDecorationWithCurve(
                        "enter_your_question".tr(),
                        scaler,
                        ColorConstants.primaryColor,
                        textSize: 10),
                    onFieldSubmitted: (data) {
                      // FocusScope.of(context).requestFocus(nodes[1]);
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    maxLines: 2,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return "question_field_cannot_empty".tr();
                      }
                      {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              actions: <Widget>[
                Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          if (_questionFormKey.currentState!.validate()) {
                            questionnaireText(context, provider, scaler);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                            padding: scaler.getPadding(1, 2),
                            decoration: BoxDecoration(
                                color: ColorConstants.primaryColor,
                                borderRadius:
                                    scaler.getBorderRadiusCircular(10.0)),
                            child: Text('submit'.tr()).semiBoldText(
                                ColorConstants.colorWhite,
                                12,
                                TextAlign.left))),
                    SizedBox(height: scaler.getHeight(0.5))
                  ],
                )
              ],
            ),
          );
        });
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
              SizedBox(height: scaler.getHeight(1.5)),
            ],
          );
        });
  }
}
