import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
import 'package:meetmeyou_app/provider/announcement_provider.dart';
import 'package:meetmeyou_app/view/add_event/event_invite_friends_screen/eventInviteFriendsScreen.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateAnnouncementScreen extends StatelessWidget {
  CreateAnnouncementScreen({Key? key}) : super(key: key);
  final titleController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _questionFormKey = GlobalKey<FormState>();
  List<Column> _fields = [];

  final questionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      key: _scaffoldKey,
      body: BaseView<AnnouncementProvider>(
        onModelReady: (provider){
          if(provider.announcementDetail.editAnnouncement == true){
            provider.getEventParam(context, provider.announcementDetail.announcementId.toString(), "photoAlbum", false);
            provider.getEventParam(context, provider.announcementDetail.announcementId.toString(), "discussion", true);
            titleController.text = provider.announcementDetail.announcementTitle.toString();
            descriptionController.text = provider.announcementDetail.announcementDescription.toString();
            if(provider.announcementDetail.announcementStartDateAndTime != null){
              provider.addDateAndTime = true;
              provider.startDate = provider.announcementDetail.announcementStartDateAndTime!;
              provider.startTime = TimeOfDay.fromDateTime(
                  provider.announcementDetail.announcementStartDateAndTime!);
              provider.endDate = provider.announcementDetail.announcementStartDateAndTime!;
              provider.endTime = TimeOfDay.fromDateTime(
                  provider.announcementDetail.announcementStartDateAndTime!);
            }
            if(provider.announcementDetail.announcementLocation != null){
              provider.addLocation = true;
              addressController.text = provider.announcementDetail.announcementLocation.toString();
            }

            // getting questions from map form.
            if (provider.eventDetail.event!.form.isNotEmpty) {
              List<String> questionsList = [];
              for (var value in provider.eventDetail.event!.form.values) {
                questionsList.add(value);
                questionController.text = value;
                questionnaireText(context, provider, scaler, addQue: false);
              }

              if (questionsList.length > 0) {
                provider.askInfoSwitch = true;
              }
            }
          }
        },
        builder: (context, provider, _){
          return  LayoutBuilder(builder: (context, constraint) {
            return  SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        selectedImage(context, scaler, provider),
                        SafeArea(
                          child: Padding(
                            padding: scaler.getPaddingLTRB(3.0, 0.0, 3.0, 0.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text("title".tr()).boldText(
                                      Colors.black,
                                      scaler.getTextSize(10.5),
                                      TextAlign.center),
                                ),
                                SizedBox(height: scaler.getHeight(0.3)),
                                TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  controller: titleController,
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
                                      return "title_required".tr();
                                    }
                                    {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height: scaler.getHeight(1.8)),
                                // provider.addDateAndTime ? dateAndTimeField(context, scaler, provider) :
                                // addDateTimeAndLocationText(scaler, "add_a_date_and_time".tr(),
                                //     onTap: (){
                                //       provider.addDateAndTime = true;
                                //       provider.updateLoadingStatus(true);
                                //     }),
                                // SizedBox(height: scaler.getHeight(1.8)),
                                provider.addLocation ? locationField(context, scaler, provider) :
                                addDateTimeAndLocationText(scaler, "add_a_location".tr(),
                                    onTap: (){
                                      provider.addLocation = true;
                                      provider.updateLoadingStatus(true);
                                    }),
                                SizedBox(height: scaler.getHeight(2.2)),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text("description".tr()).boldText(
                                      Colors.black,
                                      scaler.getTextSize(10.5),
                                      TextAlign.center),
                                ),
                                SizedBox(height: scaler.getHeight(0.3)),
                                TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  controller: descriptionController,
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
                                    //   return "description_required".tr();
                                    // }
                                    // {
                                    //   return null;
                                    // }
                                  },
                                ),
                            Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: scaler.getHeight(2.0)),
                                    discussionSwitch(context, scaler, provider),
                                    SizedBox(height: scaler.getHeight(2.0)),
                                    askForInfoSwitch(context, scaler, provider),
                                    provider.askInfoSwitch == true
                                        ? SizedBox(height: scaler.getHeight(1.8))
                                        : SizedBox(height: scaler.getHeight(0.0)),
                                    (provider.askInfoSwitch == true && _fields.length > 0)
                                        ? questionsListView(provider, scaler)
                                        : Container(),
                                    // provider.askInfoSwitch == true
                                    //     ? SizedBox(height: scaler.getHeight(1.4))
                                    //     : SizedBox(height: scaler.getHeight(0.0)),
                                    provider.askInfoSwitch == true
                                        ? addQuestion(context, provider, scaler)
                                        : Container(),
                                    SizedBox(height: scaler.getHeight(2.0)),
                                    photoGallerySwitch(context, scaler, provider),
                                    provider.announcementDetail.editAnnouncement == false ? Container() :
                                    SizedBox(height: scaler.getHeight(3.0)),
                                   provider.announcementDetail.editAnnouncement == false ? Container() :
                                   CommonWidgets.inviteMoreFriends(context, scaler, onTap:  () {
                                          Navigator.pushNamed(context, RoutesConstants.publicationVisibility).then((value) {
                                        provider.updateLoadingStatus(true);
                                        hideKeyboard(context);
                                      });
                                    }),
                                    SizedBox(height: scaler.getHeight(2.5)),
                                  ],
                                ),
                                dateAndTimeField(context, scaler, provider),
                                SizedBox(height: scaler.getHeight(3.5)),
                              ],
                            ),
                          ),
                        ),
                      provider.announcementDetail.editAnnouncement == true ?
                      provider.state == ViewState.Busy ? Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                                height: scaler.getHeight(1.5)),
                          ],
                        ),
                      )
                          : Expanded(
                        child: Container(
                            padding: scaler.getPaddingLTRB(3.0, 4.0, 3.0, 2.5),
                            alignment: Alignment.bottomCenter,
                            child: CommonWidgets.expandedRowButton(context, scaler, "cancel_announcement".tr(), "update_announcement".tr(),
                              onTapBtn1: () {
                                DialogHelper.showDialogWithTwoButtons(
                                    context,
                                    "cancel_announcement".tr(),
                                    "sure_to_cancel_announcement".tr(),
                                    negativeButtonLabel: "No",
                                    positiveButtonPress: () {
                                      Navigator.of(context).pop();
                                      provider.cancelAnnouncement(context);
                                    });
                              },
                              btn1: false,
                            onTapBtn2: (){
                              provider.updateAnnouncement(context, titleController.text, addressController.text, descriptionController.text,
                                  DateTimeHelper.dateTimeFormat(
                                      provider.startDate,
                                      provider.startTime), DateTimeHelper.dateTimeFormat(
                                      provider.endDate,
                                      provider.endTime) );
                            })),
                      )
                          :   Expanded(
                          child: Container(
                            padding: scaler.getPaddingLTRB(3.0, 4.0, 3.0, 2.5),
                            alignment: Alignment.bottomCenter,
                            child: provider.state == ViewState.Busy ? CircularProgressIndicator()
                                : CommonWidgets.commonBtn(
                                scaler,
                                context,
                                "next".tr(),
                                ColorConstants.primaryColor,
                                ColorConstants.colorWhite, onTapFun: (){
                              if (_formKey.currentState!.validate()) {
                              //  if (provider.image == null &&
                                //     provider.announcementDetail.announcementPhotoUrl == null) {
                                //   DialogHelper.showMessage(context,
                                //       "please_select_image".tr());
                                //   return;
                                // } else{
                                  provider.createAnnouncement(context, titleController.text, addressController.text, descriptionController.text,
                                    DateTimeHelper.dateTimeFormat(
                                      provider.startDate,
                                      provider.startTime), DateTimeHelper.dateTimeFormat(
                                          provider.endDate,
                                          provider.endTime));
                                }
                             // }
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });

        },
      )
    );
  }

  Widget selectedImage(
      BuildContext context, ScreenScaler scaler, AnnouncementProvider provider) {
    return GestureDetector(
      onTap: () async {
        hideKeyboard(context);

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
              provider.announcementDetail.announcementPhotoUrl = value as String?;
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
                          ? provider.announcementDetail.announcementPhotoUrl != null
                          ? ImageView(
                        path: provider.announcementDetail.announcementPhotoUrl,
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
                      provider.announcementDetail.announcementPhotoUrl == null
                      ? Container()
                      : Positioned(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          padding:
                          scaler.getPaddingLTRB(0.0, 5.0, 3.0, 0.0),
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

  Widget addDateTimeAndLocationText(ScreenScaler scaler, String txt, {VoidCallback? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              Icon(Icons.add,
                  color: ColorConstants
                      .primaryColor,
                  size: 16),
              Text(txt)
                  .mediumText(
                  ColorConstants
                      .primaryColor,
                  scaler.getTextSize(10.8),
                  TextAlign.center)
            ],
          )),
    );
  }

  Widget dateAndTimeField(BuildContext context, ScreenScaler scaler, AnnouncementProvider provider){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("display_until".tr())
            .boldText(
            Colors.black,
            scaler.getTextSize(10.5),
            TextAlign.center),
        SizedBox(
            height: scaler.getHeight(0.3)),
        endDateTimePickField(context, scaler, provider)
      ],
    );
  }

  Widget endDateTimePickField(
      BuildContext context, ScreenScaler scaler, AnnouncementProvider provider) {
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
                provider.pickDateDialog(context);
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
                child: Text(DateTimeHelper.dateConversion(provider.endDate))
                    .regularText(ColorConstants.colorGray,
                    scaler.getTextSize(10.5), TextAlign.center),
              ),
            ),
            GestureDetector(
              onTap: () {
                hideKeyboard(context);
                provider.selectTimeDialog(context);
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

  Widget locationField(BuildContext context, ScreenScaler scaler, AnnouncementProvider provider){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("location".tr())
            .boldText(
            Colors.black,
            scaler.getTextSize(10.5),
            TextAlign.center),
        SizedBox(
            height: scaler.getHeight(0.3)),
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
                scaler.getTextSize(10.5),
                ColorConstants.colorBlack),
            decoration:
            ViewDecoration.inputDecorationWithCurve(
              "Thomas Birthday Party",
              scaler,
              ColorConstants.primaryColor,
              icon: Icons.map,
            ),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.streetAddress,
          ),
        ),
      ],
    );
  }

  Widget photoGallerySwitch(
      BuildContext context, ScreenScaler scaler, AnnouncementProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("photo_gallery".tr()).boldText(
            Colors.black, scaler.getTextSize(10.5), TextAlign.center),
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
            provider.announcementDetail.editAnnouncement == true ?
            await provider.createEventAlbum(context, provider.announcementDetail.announcementId.toString(), val)
                : Container();
            provider.updateLoadingStatus(true);
          },
        ),
      ],
    );
  }

  Widget discussionSwitch(
      BuildContext context, ScreenScaler scaler, AnnouncementProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("discussion".tr()).boldText(
            Colors.black, scaler.getTextSize(10.5), TextAlign.center),
        FlutterSwitch(
          activeColor: ColorConstants.primaryColor,
          width: scaler.getWidth(11.5),
          height: scaler.getHeight(3.2),
          toggleSize: scaler.getHeight(2.4),
          value: provider.discussionSwitch,
          borderRadius: 30.0,
          padding: 2.0,
          showOnOff: false,
          onToggle: (val) async {
            hideKeyboard(context);
            provider.discussionSwitch = val;
           provider.announcementDetail.editAnnouncement == true ?
          await provider.setEventParam(context, provider.announcementDetail.announcementId.toString(), "discussion", provider.discussionSwitch)
             : Container();
            provider.updateLoadingStatus(true);
          },
        ),
      ],
    );
  }

  Widget askForInfoSwitch(
      BuildContext context, ScreenScaler scaler, AnnouncementProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("questionare".tr()).boldText(
                Colors.black, scaler.getTextSize(10.5), TextAlign.center),
            SizedBox(height: scaler.getHeight(0.5)),
            Text("ask_for_info".tr()).regularText(
                Colors.black, scaler.getTextSize(10.5), TextAlign.center),
          ],
        ),
        FlutterSwitch(
          activeColor: ColorConstants.primaryColor,
          width: scaler.getWidth(11.5),
          height: scaler.getHeight(3.2),
          toggleSize: scaler.getHeight(2.4),
          value: provider.askInfoSwitch,
          borderRadius: 30.0,
          padding: 2.0,
          showOnOff: false,
          onToggle: (val) {
            hideKeyboard(context);
            provider.askInfoSwitch = val;
            val == true ? Container() : _fields.clear();
            provider.updateLoadingStatus(true);
          },
        ),
      ],
    );
  }

  Widget addQuestion(
      BuildContext context, AnnouncementProvider provider, ScreenScaler scaler) {
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
          Text(provider.askInfoSwitch == true && _fields.length > 0
              ? "add_another_question".tr()
              : "add_question".tr())
              .mediumText(ColorConstants.primaryColor, 12.0, TextAlign.left),
        ],
      ),
    );
  }

  Widget questionsListView(AnnouncementProvider provider, ScreenScaler scaler) {
    return SizedBox(
      height: scaler.getHeight(10),
      width: double.infinity,
      child: ListView.builder(
      //  physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _fields.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${"question".tr()} ${index + 1}")
                  .boldText(ColorConstants.colorBlack, 10.5, TextAlign.left),
              SizedBox(height: scaler.getHeight(0.2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _fields[index],
                provider.announcementDetail.editAnnouncement ? Container() : GestureDetector(
                      onTap: () {
                        _fields.removeAt(index);
                        provider.updateLoadingStatus(true);
                      },
                      child: Icon(Icons.close))
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  questionnaireText(
      BuildContext context, AnnouncementProvider provider, ScreenScaler scaler,
      {bool addQue = true}) {
    final field =
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
    if(provider.announcementDetail.editAnnouncement){
      addQue
          ? provider.addQuestionToEvent(context, provider.eventDetail.event!,
          _fields.length, questionController.text)
          : Container();
    } else{
      provider.questionsList.add(questionController.text);
    }

    provider.updateLoadingStatus(true);
  }

  popupForAddingQuestion(
      BuildContext context, ScreenScaler scaler, AnnouncementProvider provider) {
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

}
