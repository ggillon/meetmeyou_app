import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:image_stack/image_stack.dart';
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
import 'package:meetmeyou_app/view/add_event/event_invite_friends_screen/eventInviteFriendsScreen.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:meetmeyou_app/widgets/shimmer/multiDateShimmer.dart';
import 'package:permission_handler/permission_handler.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      key: _scaffoldKey,
        backgroundColor: ColorConstants.colorWhite,
        body: BaseView<CreateEventProvider>(
          onModelReady: (provider) {
            if (provider.eventDetail.editEvent == true) {
              provider.getEventParam(context, provider.eventDetail.eid.toString(), "photoAlbum");
              provider.eventDetail.eventPhotoUrl =
                  provider.eventDetail.photoUrlEvent;
              eventNameController.text = provider.eventDetail.eventName ?? "";
              provider.startDate =
                  provider.eventDetail.startDateAndTime ?? DateTime.now().add(Duration(days: 7));
              provider.startTime = TimeOfDay.fromDateTime(
                  provider.eventDetail.startDateAndTime ?? DateTime.now());
              provider.endDate =
                  provider.eventDetail.endDateAndTime ?? DateTime.now().add(Duration(days: 7));
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

              // for multiple date options
              if (provider.eventDetail.event!.multipleDates == true) {
                provider.getMultipleDateOptionsFromEvent(
                    context, provider.eventDetail.eid.toString()).then((value) {
                //  provider.eventAttendingUsersKeysList();
                });
              }

            //  provider.getUsersProfileUrl(context);
            }
          },
          builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                                  scaler.getTextSize(10.5),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.3)),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: eventNameController,
                              style: ViewDecoration.textFieldStyle(
                                  scaler.getTextSize(10.5),
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
                            SizedBox(height: scaler.getHeight(1.7)),
                            (provider.getMultipleDate == true ||
                                    provider.finalDate == true)
                                ? MultiDateShimmer()
                                : provider.addMultipleDate == true
                                    ? (provider.multipleDateOption.startDate
                                                    .length ==
                                                0 ||
                                            provider.multipleDateOption
                                                    .startDate.length ==
                                                null)
                                        ? addDateCard(context, scaler, provider)
                                        : Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width : scaler.getWidth(72),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.bottomLeft,
                                                      child: Text("date_options".tr())
                                                          .boldText(
                                                              Colors.black,
                                                              scaler.getTextSize(10.5),
                                                              TextAlign.center),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            scaler.getHeight(0.7)),
                                                    optionsDesign(scaler, provider),
                                                    SizedBox(
                                                        height:
                                                            scaler.getHeight(0.7)),
                                                    multipleDateCardListView(
                                                        context, scaler, provider),
                                                  ],
                                                ),
                                            ),
                                            SizedBox(width: scaler.getWidth(1.5)),
                                            addDateCard(context, scaler, provider)
                                          ],
                                        )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child:
                                                Text("start_date_and_time".tr())
                                                    .boldText(
                                                        Colors.black,
                                                        scaler.getTextSize(10.5),
                                                        TextAlign.center),
                                          ),
                                          SizedBox(
                                              height: scaler.getHeight(0.3)),
                                          startDateTimePickField(
                                              context, scaler, provider),
                                          SizedBox(
                                              height: scaler.getHeight(1.7)),
                                          provider.addEndDate == true
                                              ? Container()
                                              : GestureDetector(
                                                  onTap: () {
                                                    provider.addEndDate = true;
                                                    provider
                                                        .updateMultipleDateUiStatus(
                                                            true);
                                                  },
                                                  child: Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.add,
                                                              color: ColorConstants
                                                                  .primaryColor,
                                                              size: 16),
                                                          Text("add_end_date_time"
                                                                  .tr())
                                                              .mediumText(
                                                                  ColorConstants
                                                                      .primaryColor,
                                                                  scaler
                                                                      .getTextSize(
                                                                          10.8),
                                                                  TextAlign
                                                                      .center)
                                                        ],
                                                      )),
                                                ),
                                          provider.addEndDate == true
                                              ? Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: Text(
                                                          "end_date_and_time"
                                                              .tr())
                                                      .boldText(
                                                          Colors.black,
                                                          scaler
                                                              .getTextSize(10.5),
                                                          TextAlign.center),
                                                )
                                              : Container(),
                                          provider.addEndDate == true
                                              ? SizedBox(
                                                  height: scaler.getHeight(0.3))
                                              : Container(),
                                          provider.addEndDate == true
                                              ? endDateTimePickField(
                                                  context, scaler, provider)
                                              : Container(),
                                        ],
                                      ),
                            SizedBox(height: scaler.getHeight(0.9)),
                            provider.eventDetail.editEvent == true
                                ? Container()
                                : provider.addMultipleDate == true
                                    ? GestureDetector(
                                        onTap: () {
                                          // if (provider.multipleDateOption
                                          //     .startDate.isEmpty) {
                                          //   provider.addMultipleDate = false;
                                          //   provider.multipleDateOption
                                          //       .startDateTime
                                          //       .clear();
                                          //   provider
                                          //       .multipleDateOption.endDateTime
                                          //       .clear();
                                          // }
                                          // provider.removeMultiDate = true;
                                          provider.addMultipleDate = false;
                                          hideKeyboard(context);
                                          provider.multipleDateOption.startDate
                                              .clear();
                                          provider.multipleDateOption.endDate
                                              .clear();
                                          provider.multipleDateOption.startTime
                                              .clear();
                                          provider.multipleDateOption.endTime
                                              .clear();
                                          provider
                                              .multipleDateOption.startDateTime
                                              .clear();
                                          provider
                                              .multipleDateOption.endDateTime
                                              .clear();
                                          provider
                                              .updateMultipleDateUiStatus(true);
                                        },
                                        child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                                    "remove_multiple_date_options"
                                                        .tr())
                                                .mediumText(
                                                    ColorConstants.primaryColor,
                                                    scaler.getTextSize(10.8),
                                                    TextAlign.center)),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          provider.addMultipleDate = true;
                                          hideKeyboard(context);
                                          provider
                                              .updateMultipleDateUiStatus(true);
                                        },
                                        child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Row(
                                              children: [
                                                Icon(Icons.add,
                                                    color: ColorConstants
                                                        .primaryColor,
                                                    size: 16),
                                                Text("add_multiple_date_options"
                                                        .tr())
                                                    .mediumText(
                                                        ColorConstants
                                                            .primaryColor,
                                                        scaler.getTextSize(10.8),
                                                        TextAlign.center)
                                              ],
                                            )),
                                      ),
                            provider.eventDetail.editEvent == true
                                ? Container()
                                : SizedBox(height: scaler.getHeight(1.5)),
                            (provider.eventDetail.event?.multipleDates ==
                                        true &&
                                    provider.eventDetail.editEvent == true)
                                ? provider.imageAndKeys == true ? Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  padding: EdgeInsets.only(left: scaler.getWidth(6.0)),
                                    height: scaler.getHeight(1.5),
                                    width: scaler.getWidth(10),
                                    child: CircularProgressIndicator())) : GestureDetector(
                              behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      hideKeyboard(context);
                                      provider.multipleDateOption.startDate
                                              .isEmpty
                                          ? Container()
                                          : selectFinalDateAlert(
                                              context, scaler, provider);
                                    },
                                    child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text("select_final_date".tr())
                                            .mediumText(
                                                ColorConstants.primaryColor,
                                                scaler.getTextSize(11),
                                                TextAlign.center)),
                                  )
                                : Container(),
                            (provider.eventDetail.event?.multipleDates ==
                                        true &&
                                    provider.eventDetail.editEvent == true)
                                ? SizedBox(height: scaler.getHeight(1.7))
                                : Container(),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("event_location".tr()).boldText(
                                  Colors.black,
                                  scaler.getTextSize(10.5),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.3)),
                            GestureDetector(
                              onTap: () async {
                                hideKeyboard(context);
                                provider.removeMultiDate = false;
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
                                    scaler.getTextSize(10.5),
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
                                  // if (value!.trim().isEmpty) {
                                  //   return "event_location_required".tr();
                                  // }
                                  // {
                                  //   return null;
                                  // }
                                },
                              ),
                            ),
                            SizedBox(height: scaler.getHeight(2.2)),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("event_description".tr()).boldText(
                                  Colors.black,
                                  scaler.getTextSize(10.5),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.3)),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: eventDescriptionController,
                              style: ViewDecoration.textFieldStyle(
                                  scaler.getTextSize(10.5),
                                  ColorConstants.colorBlack),
                              decoration: ViewDecoration.inputDecorationWithCurve(
                                  "We are celebrating birthday with Thomas and his family."
                                  " If you are coming make sure you bring good mood and "
                                  "will to party whole night. We are going to have some "
                                  "pinatas so be ready to smash them. Let’s have some "
                                  "drinks and fun!",
                                  scaler,
                                  ColorConstants.primaryColor,
                                  textSize: 10.5),
                              onFieldSubmitted: (data) {
                                // FocusScope.of(context).requestFocus(nodes[1]);
                              },
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.multiline,
                              maxLines: 6,
                              validator: (value) {
                                // if (value!.trim().isEmpty) {
                                //   return "event_description_required".tr();
                                // }
                                // {
                                //   return null;
                                // }
                              },
                            ),
                            SizedBox(height: scaler.getHeight(1.7)),
                            provider.eventDetail.editEvent == true
                                ? photoGallerySwitch(context, scaler, provider)
                                : Container(),
                            provider.eventDetail.editEvent == true
                                ?  SizedBox(height: scaler.getHeight(1.7))
                                : Container(),
                            provider.eventDetail.editEvent == true
                                ? questionAndFeedback(context, scaler, provider)
                                : Container(),
                            provider.isSwitched == true && _fields.length > 0
                                ? SizedBox(height: scaler.getHeight(1.7))
                                : SizedBox(height: scaler.getHeight(0.0)),
                            provider.isSwitched == true
                                ? questionsListView(provider, scaler)
                                : Container(),
                            provider.isSwitched == true
                                ? SizedBox(height: scaler.getHeight(1.4))
                                : SizedBox(height: scaler.getHeight(0.0)),
                            provider.isSwitched == true
                                ? addQuestion(context, provider, scaler)
                                : Container(),
                            SizedBox(height: scaler.getHeight(2.8)),
                            provider.eventDetail.editEvent == true
                                ? CommonWidgets.inviteMoreFriends(context, scaler, onTap:  () {
                              Navigator.pushNamed(
                                  context,
                                  RoutesConstants
                                      .eventInviteFriendsScreen, arguments: EventInviteFriendsScreen(fromDiscussion: false, discussionId: "", fromChatDiscussion: false))
                                  .then((value) {
                                provider.fromInviteScreen = true;
                                provider.updateLoadingStatus(true);
                                hideKeyboard(context);
                              });
                            })
                                : Container(),
                            SizedBox(height: scaler.getHeight(4.0)),
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
                                            // if (provider.image == null &&
                                            //     provider.eventDetail
                                            //             .eventPhotoUrl ==
                                            //         null) {
                                            //   DialogHelper.showMessage(context,
                                            //       "Please Select image.");
                                            //   return;
                                            // }
                                            // else if (provider.startDate
                                            //     .isAfter(provider.endDate)) {
                                            //   DialogHelper.showMessage(context,
                                            //       "Start date cannot high than End date.");
                                            //   return;
                                            // }
                                            // else if (provider.startDate
                                            //         .toString()
                                            //         .substring(0, 11)
                                            //         .compareTo(provider.endDate
                                            //             .toString()
                                            //             .substring(0, 11)) ==
                                            //     0) {
                                            //   if (provider.startTime
                                            //           .isCompareTo(
                                            //               provider.endTime) ==
                                            //       1) {
                                            //     DialogHelper.showMessage(
                                            //         context,
                                            //         "Select correct time.");
                                            //   }
                                            //   else {
                                            //     provider.updateEvent(
                                            //         context,
                                            //         eventNameController.text,
                                            //         addressController.text,
                                            //         eventDescriptionController
                                            //             .text,
                                            //         DateTimeHelper
                                            //             .dateTimeFormat(
                                            //                 provider.startDate,
                                            //                 provider.startTime),
                                            //         DateTimeHelper
                                            //             .dateTimeFormat(
                                            //                 provider.endDate,
                                            //                 provider.endTime),
                                            //         photoURL: provider
                                            //             .eventDetail
                                            //             .eventPhotoUrl);
                                            //   }
                                            // }
                                           // else {
                                              provider.updateEvent(
                                                  _scaffoldKey.currentContext!,
                                                  eventNameController.text,
                                                  addressController.text,
                                                  eventDescriptionController
                                                      .text,
                                                  DateTimeHelper.dateTimeFormat(
                                                      provider.startDate,
                                                      provider.startTime),
                                                  DateTimeHelper.dateTimeFormat(
                                                      provider.endDate,
                                                      provider.endTime),
                                                  photoURL: provider.eventDetail
                                                      .eventPhotoUrl);
                                            }
                                        //  }
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
                                          // if (provider.image == null &&
                                          //     provider.eventDetail
                                          //             .eventPhotoUrl ==
                                          //         null) {
                                          //   DialogHelper.showMessage(context,
                                          //       "Please Select image.");
                                          //   return;
                                          // }
                                          // else if (provider.startDate
                                          //     .isAfter(provider.endDate)) {
                                          //   DialogHelper.showMessage(context,
                                          //       "Start date cannot high than End date.");
                                          //   return;
                                          // }

                                            if(provider.addMultipleDate == true){
                                            if(provider.multipleDateOption.startDate.length < 2){
                                              DialogHelper.showMessage(context,
                                                  "Please add at least two Multiple Date.");
                                            } else{
                                              provider.createEvent(
                                                  _scaffoldKey.currentContext!,
                                                  eventNameController.text,
                                                  addressController.text,
                                                  eventDescriptionController.text,
                                                  DateTimeHelper.dateTimeFormat(
                                                      provider.startDate,
                                                      provider.startTime),
                                                  DateTimeHelper.dateTimeFormat(
                                                      provider.endDate,
                                                      provider.endTime),
                                                  photoURL: provider
                                                      .eventDetail.eventPhotoUrl,
                                                  photoFile: provider.image);
                                            }
                                          } else {
                                            provider.createEvent(
                                                _scaffoldKey.currentContext!,
                                                eventNameController.text,
                                                addressController.text,
                                                eventDescriptionController.text,
                                                DateTimeHelper.dateTimeFormat(
                                                    provider.startDate,
                                                    provider.startTime),
                                                DateTimeHelper.dateTimeFormat(
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
        hideKeyboard(context);
        provider.removeMultiDate = false;
        if (await Permission.storage.request().isGranted) {
          CommonWidgets.selectImageBottomSheet(context, scaler, takePhotoTap: () {
            provider.getImage(_scaffoldKey.currentContext!, 1);
          }, choosePhotoTap: () {
            provider.getImage(_scaffoldKey.currentContext!, 2).catchError((e){
              CommonWidgets.errorDialog(context, "enable_storage_permission".tr());
            });
          }, defaultPhotoTap: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(
                context, RoutesConstants.defaultPhotoPage)
                .then((value) {
              provider.image = null;
              provider.eventDetail.eventPhotoUrl = value as String?;
              provider.setState(ViewState.Idle);
            });
          });
        } else if(await Permission.storage.request().isDenied){
          Map<Permission, PermissionStatus> statuses = await [
            Permission.storage,
          ].request();
        } else if(await Permission.storage.request().isPermanentlyDenied){
          CommonWidgets.errorDialog(context, "enable_storage_permission".tr());
        }
        // var value = await provider.permissionCheck();
        // if (value) {
        //   selectImageBottomSheet(context, scaler, provider);
        // }
      },
      child: Card(
        margin: scaler.getMarginLTRB(1.5, 0.0, 1.5, 0.0),
        shadowColor: ColorConstants.colorWhite,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircularLR(0.0, 0.0, 16, 16)),
        color: ColorConstants.colorLightGray,
        child: Container(
          height: scaler.getHeight(34.5),
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
                                  height: scaler.getHeight(34.5),
                                  width: double.infinity,
                                )
                              : CommonWidgets.selectImageCard(context, scaler)
                          : provider.image != null
                              ? ImageView(
                                  file: provider.image,
                                  fit: BoxFit.cover,
                                  height: scaler.getHeight(34.5),
                                  width: double.infinity,
                                )
                              : CommonWidgets.selectImageCard(context, scaler)),
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

  Widget startDateTimePickField(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
    return Container(
      height: scaler.getHeight(5),
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
                height: scaler.getHeight(3.0),
                child: Text(DateTimeHelper.dateConversion(provider.startDate))
                    .regularText(ColorConstants.colorGray,
                        scaler.getTextSize(10.5), TextAlign.center),
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
                height: scaler.getHeight(3.0),
                child: Text(DateTimeHelper.timeConversion(provider.startTime))
                    .regularText(ColorConstants.colorGray,
                        scaler.getTextSize(10.5), TextAlign.center),
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
      height: scaler.getHeight(5),
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
                height: scaler.getHeight(3.0),
                child: Text(
                        // provider.startTime.hour >= 21
                        //     ? DateTimeHelper.dateConversion(
                        //         provider.endDate.add(Duration(days: 1)))
                        //     :
                        DateTimeHelper.dateConversion(provider.endDate))
                    .regularText(ColorConstants.colorGray,
                        scaler.getTextSize(10.5), TextAlign.center),
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
                height: scaler.getHeight(3.0),
                child: Text(DateTimeHelper.timeConversion(provider.endTime))
                    .regularText(ColorConstants.colorGray,
                        scaler.getTextSize(10.5), TextAlign.center),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addDateCard(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        provider.removeMultiDate = false;

        Navigator.pushNamed(context, RoutesConstants.multipleDateTimeScreen)
            .then((value) {
          if(provider.eventDetail.editEvent == true){
            provider.clearMultiDateOption();
            provider.getMultipleDateOptionsFromEvent(
                context, provider.eventDetail.eid.toString());
          }
              provider.multipleDateOption.startDate.sort((a,b) {
                return a.compareTo(b);
              });
          provider.updateMultipleDateUiStatus(true);
        });
      },
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: BoxDecoration(
              color: ColorConstants.colorLightGray,
              borderRadius: scaler.getBorderRadiusCircular(12.0),
              boxShadow: [
                BoxShadow(
                    color: ColorConstants.colorWhitishGray, spreadRadius: 1)
              ]),
          child: Padding(
            padding: scaler.getPaddingLTRB(4.5, 2.0, 4.5, 2.0),
            child: Icon(Icons.add, size: 40, color: ColorConstants.colorGray),
          ),
        ),
      ),
    );
  }

  Widget multipleDateCardListView(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            // color: Colors.red,
            height: scaler.getHeight(9.2),
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: provider.multipleDateOption.startDate.length,
                itemBuilder: (context, index) {
                  return
                    // provider.removeMultiDate == true
                    //   ?
                    Stack(
                          children: [
                            Row(
                              children: [
                                multiDateCardDesign(scaler, provider, index),
                                SizedBox(width: scaler.getWidth(1.2)),
                              ],
                            ),
                            Positioned(
                              right: 0.0,
                              child: GestureDetector(
                                onTap: () {
                                  if(provider.eventDetail.editEvent == true){
                                    if(provider.multipleDateOption.startDate.length <=  2){
                                      DialogHelper.showMessage(context,
                                          "Multiple Date can't less than 2.");
                                    } else{
                                      provider.removeDateFromEvent(context, provider.eventDetail.eid.toString(), provider.multipleDate[index].did).then((value) {
                                        provider.clearMultiDateOption();
                                        provider.getMultipleDateOptionsFromEvent(
                                            context, provider.eventDetail.eid.toString());
                                        provider.multipleDateOption.startDate.sort((a,b) {
                                          return a.compareTo(b);
                                        });
                                        provider.updateMultipleDateUiStatus(true);
                                      });
                                    }
                                  } else{
                                    provider.multipleDateOption.startDate.removeAt(index);
                                    provider.multipleDateOption.endDate.removeAt(index);
                                    provider.multipleDateOption.startTime
                                        .removeAt(index);
                                    provider.multipleDateOption.endTime
                                        .removeAt(index);
                                    provider.multipleDateOption.startDateTime
                                        .removeAt(index);
                                    provider.multipleDateOption.endDateTime
                                        .removeAt(index);
                                    if (provider
                                        .multipleDateOption.startDate.isEmpty) {
                                      provider.addMultipleDate = false;
                                    }
                                    provider.updateMultipleDateUiStatus(true);
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: CircleAvatar(
                                    radius: 10.0,
                                    backgroundColor: ColorConstants.colorRed,
                                    child: Icon(Icons.close,
                                        color: ColorConstants.colorWhite, size: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                    //  : multiDateCardDesign(scaler, provider, index);
                }),
          ),
          // provider.eventDetail.editEvent == true
          //     ? Container()
          //     :
           SizedBox(width: scaler.getWidth(1.2)),
          // provider.eventDetail.editEvent == true
          //     ? Container()
          //     :
          // Container(
          //         margin: scaler.getMarginLTRB(0.0, 0.5, 0.5, 0.5),
          //         child: addDateCard(context, scaler, provider))
        ],
      ),
    );
  }

  Widget multiDateCardDesign(
      ScreenScaler scaler, CreateEventProvider provider, int index) {
    return Container(
      margin: scaler.getMarginLTRB(0.5, 0.5, 1.0, 0.5),
      padding: scaler.getPaddingLTRB(1.5, 1.0, 1.5, 0.5),
      width: scaler.getWidth(18.0),
      decoration: BoxDecoration(
          color: ColorConstants.colorLightGray,
          borderRadius: scaler.getBorderRadiusCircular(12.0),
          boxShadow: [
            BoxShadow(color: ColorConstants.colorWhitishGray, spreadRadius: 1)
          ]),
      child: Column(
       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: scaler.getHeight(0.3)),
          Text("${DateTimeHelper.getMonthByName(provider.multipleDateOption.startDate[index])} "
                  " ${provider.multipleDateOption.startDate[index].year}")
              .semiBoldText(Colors.deepOrangeAccent, scaler.getTextSize(9.0), TextAlign.center),
          SizedBox(height: scaler.getHeight(0.2)),
          Text(provider.multipleDateOption.startDate[index].day.toString())
              .boldText(ColorConstants.colorBlack, scaler.getTextSize(14.8), TextAlign.center),
        //  SizedBox(height: scaler.getHeight(0.2)),
          // Text(DateTimeHelper.getWeekDay(
          //         provider.multipleDateOption.startDate[index]))
          //     .mediumText(ColorConstants.colorBlack, 11, TextAlign.center),
          // SizedBox(height: scaler.getHeight(0.1)),
          // Container(
          //   width: scaler.getWidth(20),
          //   child: Text(
          //           // (provider.multipleDateOption.startDate[index]
          //           //                         .toString()
          //           //                         .substring(0, 11)) ==
          //           //                     (provider.multipleDateOption.endDate[index]
          //           //                         .toString()
          //           //                         .substring(0, 11))
          //           //                 ?
          //           "${DateTimeHelper.timeConversion(provider.multipleDateOption.startTime[index])} - ${DateTimeHelper.timeConversion(provider.multipleDateOption.endTime[index])}")
          //       //   : "${DateTimeHelper.timeConversion(provider.multipleDateOption.startTime[index])} - ${DateTimeHelper.timeConversion(provider.multipleDateOption.endTime[index])} (${DateTimeHelper.dateConversion(provider.multipleDateOption.endDate[index], date: false)})")
          //       .regularText(ColorConstants.colorGray, 10, TextAlign.center,
          //           maxLines: 2, overflow: TextOverflow.ellipsis),
         // )
        ],
      ),
    );
  }

  Widget optionsDesign(ScreenScaler scaler, CreateEventProvider provider) {
    return Row(
      children: [
        Icon(Icons.calendar_today),
        SizedBox(width: scaler.getWidth(1.5)),
        Text("${provider.multipleDateOption.startDate.length} ${"options".tr()}")
            .mediumText(ColorConstants.colorBlackDown, scaler.getTextSize(10.2),
                TextAlign.center),
        // Expanded(
        //     child: Container(
        //         alignment: Alignment.centerRight,
        //         child: ImageView(
        //           path: ImageConstants.small_arrow_icon,
        //           color: ColorConstants.colorGray,
        //           height: scaler.getHeight(1.5),
        //         )))
      ],
    );
  }

  Widget photoGallerySwitch(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("photo_gallery".tr()).boldText(
                Colors.black, scaler.getTextSize(10.5), TextAlign.center),
            SizedBox(height: scaler.getHeight(0.5)),
            Text("add_a_photo_gallery".tr()).regularText(
                Colors.black, scaler.getTextSize(10.5), TextAlign.center),
          ],
        ),
        FlutterSwitch(
          activeColor: ColorConstants.primaryColor,
          width: scaler.getWidth(11.5),
          height: scaler.getHeight(3.2),
          toggleSize: scaler.getHeight(2.4),
          value: provider.photoGallerySwitch,
          borderRadius: 30.0,
          padding: 2.0,
          showOnOff: false,
          onToggle: (val) async {
            hideKeyboard(context);
            provider.photoGallerySwitch = val;
            await provider.createEventAlbum(context, provider.eventDetail.eid.toString(), val);
            provider.updateLoadingStatus(true);
          },
        ),
      ],
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
                Colors.black, scaler.getTextSize(10.5), TextAlign.center),
            SizedBox(height: scaler.getHeight(0.5)),
            Text("ask_for_feedback".tr()).regularText(
                Colors.black, scaler.getTextSize(10.5), TextAlign.center),
          ],
        ),
        FlutterSwitch(
          activeColor: ColorConstants.primaryColor,
          width: scaler.getWidth(11.5),
          height: scaler.getHeight(3.2),
          toggleSize: scaler.getHeight(2.4),
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
              .mediumText(ColorConstants.primaryColor, 12.0, TextAlign.left),
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
            // GestureDetector(
            //     onTap: () {
            //       _fields.removeAt(index);
            //       provider.updateQuestionStatus(true);
            //     },
            //     child: Icon(Icons.close))
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
          .boldText(ColorConstants.colorBlack, 10.5, TextAlign.left),
      SizedBox(height: scaler.getHeight(0.2)),
      Container(
        width: scaler.getWidth(78),
        child: Text(questionController.text).mediumText(
            ColorConstants.colorBlack, 13, TextAlign.left,
            maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
      SizedBox(height: scaler.getHeight(0.7)),
    ]);

    //   questionControllers.add(controller);

    _fields.add(field);
    // questionsList.add(questionController.text);
    addQue
        ? provider.addQuestionToEvent(context, provider.eventDetail.event!, _fields.length, questionController.text)
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
                  .boldText(ColorConstants.colorBlack, 15, TextAlign.left),
              content: Form(
                key: _questionFormKey,
                child: Container(
                  width: double.maxFinite,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: questionController,
                    style: ViewDecoration.textFieldStyle(
                        scaler.getTextSize(11), ColorConstants.colorBlack),
                    decoration: ViewDecoration.inputDecorationWithCurve(
                        "enter_your_question".tr(),
                        scaler,
                        ColorConstants.primaryColor,
                        textSize: 11),
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
                                13,
                                TextAlign.left))),
                    SizedBox(height: scaler.getHeight(0.5))
                  ],
                )
              ],
            ),
          );
        });
  }

  bool finalDateBtnColor = false;
  String? selectedFinalDateDid;

  selectFinalDateAlert(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) async{
    provider.eventDetail.eventBtnStatus = "";
    await provider.imageUrlAndAttendingKeysList(context);
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setInnerState) {
            return Container(
                width: double.infinity,
                child: AlertDialog(
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  insetPadding: EdgeInsets.fromLTRB(15.0, 24.0, 15.0, 24.0),
                  title: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ImageView(
                              path: ImageConstants.eventFinalDateAlert_close),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("select_final_date".tr()).semiBoldText(
                            ColorConstants.colorBlack,
                            scaler.getTextSize(10.5),
                            TextAlign.center),
                      ),
                      SizedBox(height: scaler.getHeight(1.5)),
                      optionsDesign(scaler, provider),
                    ],
                  ),
                  content: Container(
                      //  color: Colors.red,
                      height: scaler.getHeight(22.0),
                      width: scaler.getWidth(100.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: provider.multipleDateOption.startDate.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                setInnerState(() {
                                  provider.selectedIndex = index;
                                  finalDateBtnColor = true;
                                  selectedFinalDateDid =
                                      provider.multipleDate[index].did;
                                  provider.updateMultipleDateUiStatus(true);
                                });
                              },
                              child:
                                 Column(
                                   children: [
                                     CommonWidgets.gridViewOfMultiDateAlertDialog(
                                         scaler, provider.multipleDate, index,
                                         selectedIndex: provider.selectedIndex),
                                     GestureDetector(
                                       behavior: HitTestBehavior.translucent,
                                       onTap: (){
                                         provider.eventDetail.attendingProfileKeys = provider.multipleDateOption.eventAttendingKeysList[index];
                                         Navigator.pushNamed(
                                             context,
                                             RoutesConstants
                                                 .eventAttendingScreen);
                                         },
                                       child: provider.multipleDateOption.eventAttendingPhotoUrlLists[index].length == 0 ? Container() : Row(
                                         children: [
                                           SizedBox(width: scaler.getWidth(2.5)),
                                           ImageStack(
                                             imageList: provider.multipleDateOption.eventAttendingPhotoUrlLists[index],
                                             totalCount: 3,
                                             imageRadius: 15,
                                             imageCount: 3,
                                             imageBorderColor:
                                             ColorConstants.colorWhite,
                                             backgroundColor:
                                             ColorConstants.primaryColor,
                                             imageBorderWidth: 1,
                                             extraCountTextStyle: TextStyle(
                                                 fontSize: 7.7,
                                                 color:
                                                 ColorConstants.colorWhite,
                                                 fontWeight: FontWeight.w500),
                                             showTotalCount: false,
                                           ),
                                           SizedBox(width: scaler.getWidth(1.5)),
                                           Text("available".tr()).regularText(
                                               ColorConstants.colorGray,
                                               scaler.getTextSize(8),
                                               TextAlign.center),
                                         ],
                                       ),
                                     ),
                                   ],
                                 ));
                        },
                      )),
                  actions: [
                    CommonWidgets.commonBtn(
                        scaler,
                        context,
                        "select_that_date".tr(),
                        finalDateBtnColor == true
                            ? ColorConstants.primaryColor
                            : ColorConstants.colorNewGray,
                        finalDateBtnColor == true
                            ? ColorConstants.colorWhite
                            : ColorConstants.colorGray,
                        onTapFun: finalDateBtnColor == true ||
                                selectedFinalDateDid != null
                            ? ()  {
                                provider.selectFinalDate(
                                    context, selectedFinalDateDid!);
                              }
                            : () {})
                  ],
                ));
          });
        });
  }
}
