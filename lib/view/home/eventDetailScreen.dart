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
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/provider/event_detail_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/dashboard/dashboardPage.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatelessWidget {
  // final Event event;
  final answer1Controller = TextEditingController();
  final answer2Controller = TextEditingController();
  final answer3Controller = TextEditingController();
  final answer4Controller = TextEditingController();
  final answer5Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  EventDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final dashBoardProvider = Provider.of<DashboardProvider>(context, listen: false);
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      key: _scaffoldkey,
      body: BaseView<EventDetailProvider>(
        onModelReady: (provider) {
          provider.calendarDetail.fromCalendarPage == true
              ? Container()
              : provider.eventGoingLength();
          provider.calendarDetail.fromCalendarPage == true
              ? Container()
              : provider.getUsersProfileUrl(context);
          provider.calendarDetail.fromCalendarPage == true
              ? Container()
              : provider.getOrganiserProfileUrl(
                  context, provider.eventDetail.organiserId!);
          provider.calendarDetail.fromCalendarPage == true
              ? provider.getEvent(context, provider.eventDetail.eid!)
              : Container();
        },
        builder: (context, provider, _) {
          return provider.calendarDetail.fromCalendarPage == true &&
                  provider.eventValue == true
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                    SizedBox(height: scaler.getHeight(1)),
                    Text("fetching_event".tr()).mediumText(
                        ColorConstants.primaryColor,
                        scaler.getTextSize(10),
                        TextAlign.left),
                  ],
                )
              : SingleChildScrollView(
                  child: Column(children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      imageView(context, scaler, provider),
                      Positioned(
                        bottom: -48,
                        child: titleDateLocationCard(scaler, provider),
                      )
                    ],
                  ),
                  SizedBox(height: scaler.getHeight(3.5)),
                  SafeArea(
                    child: Padding(
                      padding: scaler.getPaddingLTRB(3, 1.0, 3, 1.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (provider.value == true)
                            Center(child: CircularProgressIndicator())
                          else
                            CommonWidgets.commonBtn(
                                scaler,
                                context,
                                provider.eventDetail.eventBtnStatus!.tr(),
                                provider.eventDetail.btnBGColor!,
                                provider.eventDetail.textColor!, onTapFun: () {
                              if (provider.eventDetail.eventBtnStatus ==
                                  "respond") {
                                CommonWidgets.respondToEventBottomSheet(
                                    context, scaler, going: () {
                                  if (provider
                                      .eventDetail.event!.form.isNotEmpty) {
                                    List<String> questionsList = [];
                                    for (var value in provider
                                        .eventDetail.event!.form.values) {
                                      questionsList.add(value);
                                    }
                                    Navigator.of(context).pop();
                                    alertForQuestionnaireAnswers(
                                        _scaffoldkey.currentContext!,
                                        scaler,
                                        questionsList,
                                        provider);
                                  } else {
                                    Navigator.of(context).pop();
                                    provider.replyToEvent(
                                        context,
                                        provider.eventDetail.eid!,
                                        EVENT_ATTENDING);
                                  }
                                }, notGoing: () {
                                  Navigator.of(context).pop();
                                  provider.replyToEvent(
                                      context,
                                      provider.eventDetail.eid!,
                                      EVENT_NOT_ATTENDING);
                                }, hide: () {
                                  Navigator.of(context).pop();
                                  provider.replyToEvent(
                                      context,
                                      provider.eventDetail.eid!,
                                      EVENT_NOT_INTERESTED);
                                });
                              } else if (provider.eventDetail.eventBtnStatus ==
                                  "edit") {
                                // provider.setEventValuesForEdit(event);
                                Navigator.pushNamed(context,
                                        RoutesConstants.createEventScreen)
                                    .then((value) {
                                  provider.updateBackValue(true);
                                });
                              } else if (provider.eventDetail.eventBtnStatus ==
                                  "cancelled") {
                                if (provider.userDetail.cid ==
                                    provider.eventDetail.organiserId!) {
                                  CommonWidgets.eventCancelBottomSheet(
                                      context, scaler, delete: () {
                                    Navigator.of(context).pop();
                                    provider.deleteEvent(context,
                                        provider.eventDetail.eid.toString());
                                  });
                                } else {
                                  Container();
                                }
                              } else {
                                Container();
                              }
                            }),
                          SizedBox(height: scaler.getHeight(1)),
                          organiserCard(scaler, provider),
                          SizedBox(height: scaler.getHeight(1)),
                          provider.eventAttendingLength == 0
                              ? Container()
                              : GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    provider.eventDetail.attendingProfileKeys =
                                        provider.eventAttendingKeysList;
                                    Navigator.pushNamed(context,
                                            RoutesConstants.eventAttendingScreen)
                                        .then((value) {
                                      provider.eventAttendingLength = (provider
                                              .eventDetail
                                              .attendingProfileKeys
                                              ?.length ??
                                          0);
                                      provider.eventAttendingKeysList = provider
                                          .eventDetail.attendingProfileKeys!;
                                      provider.eventAttendingPhotoUrlLists = [];
                                      provider.getUsersProfileUrl(context);
                                      provider.updateBackValue(true);
                                    });
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Stack(
                                          alignment: Alignment.centerRight,
                                          clipBehavior: Clip.none,
                                          children: [
                                            ImageStack(
                                              imageList: provider
                                                  .eventAttendingPhotoUrlLists,
                                              totalCount: provider
                                                  .eventAttendingPhotoUrlLists
                                                  .length,
                                              imageRadius: 25,
                                              imageCount: provider
                                                  .imageStackLength(provider
                                                      .eventAttendingPhotoUrlLists
                                                      .length),
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
                                            Positioned(
                                              right: -22,
                                              child: provider
                                                          .eventAttendingPhotoUrlLists
                                                          .length <=
                                                      6
                                                  ? Container()
                                                  : ClipRRect(
                                                      borderRadius: scaler
                                                          .getBorderRadiusCircular(
                                                              15.0),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        color: ColorConstants
                                                            .primaryColor,
                                                        height:
                                                            scaler.getHeight(2.0),
                                                        width: scaler.getWidth(6),
                                                        child: Text((provider
                                                                        .eventAttendingPhotoUrlLists
                                                                        .length -
                                                                    6)
                                                                .toString())
                                                            .mediumText(
                                                                ColorConstants
                                                                    .colorWhite,
                                                                scaler
                                                                    .getTextSize(
                                                                        7.7),
                                                                TextAlign.center),
                                                      ),
                                                    ),
                                            )
                                          ],
                                        ),
                                        provider.eventAttendingPhotoUrlLists
                                                    .length <=
                                                6
                                            ? SizedBox(width: scaler.getWidth(1))
                                            : SizedBox(width: scaler.getWidth(6)),
                                        Text("going".tr()).regularText(
                                            ColorConstants.colorGray,
                                            scaler.getTextSize(8),
                                            TextAlign.center),
                                      ],
                                    ),
                                  ),
                                ),
                          SizedBox(height: scaler.getHeight(1)),
                          Text("event_description".tr()).boldText(
                              ColorConstants.colorBlack,
                              scaler.getTextSize(9.5),
                              TextAlign.left),
                          SizedBox(height: scaler.getHeight(2)),
                          Text(provider.eventDetail.eventDescription ?? "")
                              .regularText(ColorConstants.colorBlack,
                                  scaler.getTextSize(10), TextAlign.left),
                          SizedBox(height: scaler.getHeight(2.5)),
                          eventDiscussionCard(context, scaler)
                        ],
                      ),
                    ),
                  )
                ]));
        },
      ),
    );
  }

  Widget imageView(
      BuildContext context, ScreenScaler scaler, EventDetailProvider provider) {
    return Card(
      margin: scaler.getMarginAll(0.0),
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
                  child: provider.eventDetail.photoUrlEvent == null ||
                          provider.eventDetail.photoUrlEvent == ""
                      ? Container(
                          color: ColorConstants.primaryColor,
                          height: scaler.getHeight(34),
                          width: double.infinity,
                        )
                      : ImageView(
                          path: provider.eventDetail.photoUrlEvent,
                          fit: BoxFit.cover,
                          height: scaler.getHeight(34),
                          width: double.infinity,
                        ),
                ),
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      //  provider.calendarDetail.fromCalendarPage == true ? Navigator.of(context).popUntil((route) => route.isFirst) : Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        padding: scaler.getPaddingLTRB(3.0, 4.0, 3.0, 0.0),
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ImageView(
                                path: ImageConstants.back,
                                color: ColorConstants.colorWhite),
                            ImageView(
                                path: ImageConstants.close_icon,
                                color: ColorConstants.colorWhite),
                          ],
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bool showText = true;

  Widget titleDateLocationCard(
      ScreenScaler scaler, EventDetailProvider provider) {
    return Padding(
      padding: scaler.getPaddingLTRB(3.0, 0.0, 3.0, 0.0),
      child: Card(
          shadowColor: ColorConstants.colorWhite,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
              borderRadius: scaler.getBorderRadiusCircular(10)),
          child: Padding(
            padding: scaler.getPaddingLTRB(2.5, 1.0, 2.0, 1.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                dateCard(scaler, provider),
                SizedBox(width: scaler.getWidth(1.8)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: scaler.getWidth(55),
                      child: Text(provider.eventDetail.eventName ?? "")
                          .boldText(ColorConstants.colorBlack,
                              scaler.getTextSize(10), TextAlign.left,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(height: scaler.getHeight(0.3)),
                    Row(
                      children: [
                        ImageView(path: ImageConstants.event_clock_icon),
                        SizedBox(width: scaler.getWidth(1)),
                        Container(
                          width: scaler.getWidth(50),
                          child: Text(provider.eventDetail.startDateAndTime ==
                                      provider.eventDetail.endDateAndTime
                                  ? DateTimeHelper.getWeekDay(provider.eventDetail.startDateAndTime ?? DateTime.now()) +
                                      " - " +
                                      DateTimeHelper.convertEventDateToTimeFormat(
                                          provider.eventDetail.startDateAndTime ??
                                              DateTime.now()) +
                                      " to " +
                                      DateTimeHelper.convertEventDateToTimeFormat(
                                          provider.eventDetail.endDateAndTime ??
                                              DateTime.now())
                                  : DateTimeHelper.getWeekDay(provider.eventDetail.startDateAndTime ?? DateTime.now()) +
                                      " - " +
                                      DateTimeHelper.convertEventDateToTimeFormat(
                                          provider.eventDetail.startDateAndTime ??
                                              DateTime.now()) +
                                      " to " +
                                      DateTimeHelper.dateConversion(provider.eventDetail.endDateAndTime ?? DateTime.now(), date: false) +
                                      " ( ${DateTimeHelper.convertEventDateToTimeFormat(provider.eventDetail.endDateAndTime ?? DateTime.now())})")
                              .regularText(ColorConstants.colorGray, scaler.getTextSize(9.5), TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                    SizedBox(height: scaler.getHeight(0.3)),
                    Row(
                      children: [
                        ImageView(path: ImageConstants.map),
                        SizedBox(width: scaler.getWidth(1)),
                        Container(
                          width: scaler.getWidth(50),
                          child: Text(provider.eventDetail.eventLocation ?? "")
                              .regularText(ColorConstants.colorGray,
                                  scaler.getTextSize(9.5), TextAlign.left,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget dateCard(ScreenScaler scaler, EventDetailProvider provider) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(8)),
      child: Container(
        decoration: BoxDecoration(
            color: ColorConstants.primaryColor.withOpacity(0.2),
            borderRadius: scaler.getBorderRadiusCircular(
                8.0) // use instead of BorderRadius.all(Radius.circular(20))
            ),
        padding: scaler.getPaddingLTRB(3.0, 0.3, 3.0, 0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateTimeHelper.getMonthByName(
                    provider.eventDetail.startDateAndTime ?? DateTime.now()))
                .regularText(ColorConstants.primaryColor,
                    scaler.getTextSize(11), TextAlign.center),
            Text(provider.eventDetail.startDateAndTime!.day <= 9
                    ? "0" +
                        provider.eventDetail.startDateAndTime!.day.toString()
                    : provider.eventDetail.startDateAndTime!.day.toString())
                .boldText(ColorConstants.primaryColor, scaler.getTextSize(14),
                    TextAlign.center)
          ],
        ),
      ),
    );
  }

  Widget organiserCard(ScreenScaler scaler, EventDetailProvider provider) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(8)),
      child: Padding(
        padding: scaler.getPaddingLTRB(2.0, 0.7, 2.0, 0.7),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: scaler.getBorderRadiusCircular(15.0),
                child: provider.userDetail.profileUrl == null
                    ? Container(
                        color: ColorConstants.primaryColor,
                        height: scaler.getHeight(2.8),
                        width: scaler.getWidth(9),
                      )
                    : Container(
                        height: scaler.getHeight(2.8),
                        width: scaler.getWidth(9),
                        child: ImageView(
                            path: provider.userDetail.profileUrl,
                            height: scaler.getHeight(2.8),
                            width: scaler.getWidth(9),
                            fit: BoxFit.cover),
                      )),
            SizedBox(width: scaler.getWidth(2)),
            Expanded(
                child: Container(
              alignment: Alignment.centerLeft,
              child: Text(provider.eventDetail.organiserName! +
                      " " +
                      "(${"organiser".tr()})")
                  .semiBoldText(ColorConstants.colorBlack,
                      scaler.getTextSize(9.8), TextAlign.left,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
            )),
            SizedBox(width: scaler.getWidth(2)),
            ImageView(
              path: ImageConstants.event_arrow_icon,
            )
          ],
        ),
      ),
    );
  }

  Widget eventDiscussionCard(BuildContext context, ScreenScaler scaler) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesConstants.eventDiscussionScreen);
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircular(8)),
        child: Padding(
          padding: scaler.getPaddingLTRB(2.0, 0.7, 2.0, 0.7),
          child: Row(
            children: [
              ImageView(path: ImageConstants.event_chat_icon),
              SizedBox(width: scaler.getWidth(2)),
              Expanded(
                  child: Container(
                alignment: Alignment.centerLeft,
                child: Text("event_discussion".tr()).mediumText(
                    ColorConstants.colorBlack,
                    scaler.getTextSize(9.5),
                    TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              )),
              SizedBox(width: scaler.getWidth(2)),
              ImageView(
                path: ImageConstants.small_arrow_icon,
              )
            ],
          ),
        ),
      ),
    );
  }

  alertForQuestionnaireAnswers(BuildContext context, ScreenScaler scaler,
      List<String> questionsList, EventDetailProvider provider) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            child: AlertDialog(
                title: Text("event_form_questionnaire".tr())
                    .boldText(ColorConstants.colorBlack, 14.0, TextAlign.left),
                content: Container(
                  width: scaler.getWidth(75),
                  child: Form(
                    key: _formKey,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: questionsList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${index + 1}. ${questionsList[index]}")
                                  .mediumText(ColorConstants.colorBlack, 12,
                                      TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                              SizedBox(height: scaler.getHeight(0.2)),
                              TextFormField(
                                textCapitalization: TextCapitalization.sentences,
                                controller: answerController(index),
                                style: ViewDecoration.textFieldStyle(
                                    scaler.getTextSize(9.5),
                                    ColorConstants.colorBlack),
                                decoration:
                                    ViewDecoration.inputDecorationWithCurve(
                                        " ${"answer".tr()} ${index + 1}",
                                        scaler,
                                        ColorConstants.primaryColor),
                                onFieldSubmitted: (data) {
                                  // FocusScope.of(context).requestFocus(nodes[1]);
                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "answer_required".tr();
                                  }
                                  {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: scaler.getHeight(1.0)),
                            ],
                          );
                        }),
                  ),
                ),
                actions: <Widget>[
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              final Map<String, dynamic> answersMap = {
                                "1. text": answer1Controller.text,
                                "2. text": answer2Controller.text,
                                "3. text": answer3Controller.text,
                                "4. text": answer4Controller.text,
                                "5. text": answer5Controller.text
                              };
                              Navigator.of(context).pop();
                              provider.answersToEventQuestionnaire(
                                  _scaffoldkey.currentContext!,
                                  provider.eventDetail.eid!,
                                  answersMap);
                            }
                          },
                          child: Container(
                              padding: scaler.getPadding(1, 2),
                              decoration: BoxDecoration(
                                  color: ColorConstants.primaryColor,
                                  borderRadius:
                                      scaler.getBorderRadiusCircular(10.0)),
                              child: Text('submit_answers'.tr()).semiBoldText(
                                  ColorConstants.colorWhite,
                                  12,
                                  TextAlign.left))),
                      SizedBox(height: scaler.getHeight(0.5))
                    ],
                  )
                ]),
          );
        });
  }

  answerController(int index) {
    switch (index) {
      case 0:
        return answer1Controller;

      case 1:
        return answer2Controller;

      case 2:
        return answer3Controller;

      case 3:
        return answer4Controller;

      case 4:
        return answer5Controller;
    }
  }
}
