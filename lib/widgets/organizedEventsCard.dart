import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/provider/organize_event_card_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/widgets/shimmer/organizedEventCardShimmer.dart';

class OrganizedEventsCard extends StatelessWidget {
  final bool showEventRespondBtn;
  final answer1Controller = TextEditingController();
  final answer2Controller = TextEditingController();
  final answer3Controller = TextEditingController();
  final answer4Controller = TextEditingController();
  final answer5Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  OrganizedEventsCard({Key? key, required this.showEventRespondBtn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return BaseView<OrganizeEventCardProvider>(onModelReady: (provider) {
      provider.getUserEvents(context);
    }, builder: (context, provider, _) {
      return provider.state == ViewState.Busy
          ? OrganizedEventCardShimmer(showEventRespondBtn: showEventRespondBtn)
          : provider.eventLists.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
                      child: Text("organized_events".tr()).boldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(10),
                          TextAlign.left),
                    ),
                    SizedBox(height: scaler.getHeight(1.5)),
                    Container(
                      // height: scaler.getHeight(28),
                      child: CarouselSlider.builder(
                        itemCount: provider.eventLists.length,
                        itemBuilder: (BuildContext context, int index,
                            int pageViewIndex) {
                          return GestureDetector(
                            onTap: showEventRespondBtn == true
                                ? () {
                                    provider.homePageProvider
                                        .setEventValuesForEdit(
                                            provider.eventLists[index]);
                                    provider.eventDetail.eventBtnStatus =
                                        CommonEventFunction.getEventBtnStatus(
                                            provider.eventLists[index],
                                            provider.userDetail.cid.toString());
                                    provider.eventDetail.textColor =
                                        CommonEventFunction
                                            .getEventBtnColorStatus(
                                                provider.eventLists[index],
                                                provider.userDetail.cid
                                                    .toString());
                                    provider.eventDetail.btnBGColor =
                                        CommonEventFunction
                                            .getEventBtnColorStatus(
                                                provider.eventLists[index],
                                                provider.userDetail.cid
                                                    .toString(),
                                                textColor: false);
                                    provider.eventDetail.eventMapData = provider
                                        .eventLists[index].invitedContacts;
                                    provider.eventDetail.eid =
                                        provider.eventLists[index].eid;
                                    provider.eventDetail.organiserId =
                                        provider.eventLists[index].organiserID;
                                    provider.eventDetail.organiserName =
                                        provider
                                            .eventLists[index].organiserName;
                                    provider.calendarDetail.fromCalendarPage =
                                        false;
                                    Navigator.pushNamed(context,
                                            RoutesConstants.eventDetailScreen)
                                        .then((value) {
                                      provider.getUserEvents(context);
                                      provider.unRespondedEventsApi(context);
                                    });
                                  }
                                : () {},
                            child: Card(
                              shadowColor: ColorConstants.colorWhite,
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      scaler.getBorderRadiusCircular(10)),
                              child: CustomShape(
                                  child: eventCard(scaler, context, provider,
                                      provider.eventLists[index], index),
                                  bgColor: ColorConstants.colorWhite,
                                  radius: scaler.getBorderRadiusCircular(10),
                                  width:
                                      MediaQuery.of(context).size.width / 1.2),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: scaler.getHeight(30.5),
                          enableInfiniteScroll: false,
                          // aspectRatio: 1.5,
                          viewportFraction: 0.9,
                        ),
                      ),
                    ),
                  ],
                )
              : Container();
    });
  }

  Widget eventCard(ScreenScaler scaler, BuildContext context,
      OrganizeEventCardProvider provider, Event eventList, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius:
                  scaler.getBorderRadiusCircularLR(10.0, 10.0, 0.0, 0.0),
              child: eventList.photoURL == null
                  ? Container(
                      height: scaler.getHeight(21),
                      width: MediaQuery.of(context).size.width / 1.2,
                      color: ColorConstants.primaryColor,
                    )
                  : ImageView(
                      path: eventList.photoURL,
                      fit: BoxFit.fill,
                      height: scaler.getHeight(21),
                      width: MediaQuery.of(context).size.width / 1.2,
                    ),
            ),
            Positioned(
                top: scaler.getHeight(1),
                left: scaler.getHeight(1.5),
                child: dateCard(scaler, eventList))
          ],
        ),
        Padding(
          padding: showEventRespondBtn
              ? scaler.getPaddingLTRB(2.5, 0.5, 2.5, 0.7)
              : scaler.getPaddingLTRB(2.5, 0.5, 7.5, 0.7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(eventList.title).boldText(ColorConstants.colorBlack,
                        scaler.getTextSize(10), TextAlign.left,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    //  SizedBox(height: scaler.getHeight(0.1)),
                    Text(eventList.description).regularText(
                        ColorConstants.colorGray,
                        scaler.getTextSize(8.5),
                        TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        isHeight: true),
                  ],
                ),
              ),
              showEventRespondBtn
                  ? SizedBox(width: scaler.getWidth(1))
                  : SizedBox(width: scaler.getWidth(0)),
              showEventRespondBtn
                  ? eventRespondBtn(context, scaler, eventList, provider, index)
                  : Container()
            ],
          ),
        )
      ],
    );
  }

  Widget dateCard(ScreenScaler scaler, Event event) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(8)),
      child: CustomShape(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateTimeHelper.getMonthByName(event.start)).regularText(
                ColorConstants.colorBlack,
                scaler.getTextSize(8.5),
                TextAlign.center),
            Text(event.start.day <= 9
                    ? "0" + event.start.day.toString()
                    : event.start.day.toString())
                .boldText(ColorConstants.colorBlack, scaler.getTextSize(11),
                    TextAlign.center)
          ],
        ),
        bgColor: ColorConstants.colorWhite,
        radius: scaler.getBorderRadiusCircular(8),
        width: scaler.getWidth(10),
        height: scaler.getHeight(4),
      ),
    );
  }

  Widget eventRespondBtn(BuildContext context, ScreenScaler scaler, Event event,
      OrganizeEventCardProvider provider, int index) {
    return GestureDetector(
      onTap: () {
        if (CommonEventFunction.getEventBtnStatus(
                event, provider.userDetail.cid.toString()) ==
            "respond") {
          answer1Controller.clear();
          answer2Controller.clear();
          answer3Controller.clear();
          answer4Controller.clear();
          answer5Controller.clear();
          CommonWidgets.respondToEventBottomSheet(context, scaler, going: () {
            provider.homePageProvider.getUserDetail(context);
            // if (event.multipleDates == true) {
            //   provider
            //       .getMultipleDateOptionsFromEvent(context, event.eid, index)
            //       .then((value) {
            //     alertForMultiDateAnswers(
            //         context, scaler, provider.multipleDate, provider, event);
            //   });
            // } else {
              if (event.form.values.isNotEmpty) {
                List<String> questionsList = [];
                for (var value in event.form.values) {
                  questionsList.add(value);
                }
                Navigator.of(context).pop();
                alertForQuestionnaireAnswers(
                    context, scaler, event, questionsList, provider);
              } else {
                Navigator.of(context).pop();
                provider.replyToEvent(context, event.eid, EVENT_ATTENDING);
              }
         //   }
          }, notGoing: () {
            Navigator.of(context).pop();
            provider.replyToEvent(context, event.eid, EVENT_NOT_ATTENDING);
          }, hide: () {
            Navigator.of(context).pop();
            provider.replyToEvent(context, event.eid, EVENT_NOT_INTERESTED);
          });
        } else if (CommonEventFunction.getEventBtnStatus(
                event, provider.userDetail.cid.toString()) ==
            "edit") {
          provider.homePageProvider.setEventValuesForEdit(event);
          provider.homePageProvider.clearMultiDateOption();
          Navigator.pushNamed(context, RoutesConstants.createEventScreen)
              .then((value) {
            provider.getUserEvents(context);
          });
        } else if (CommonEventFunction.getEventBtnStatus(
                event, provider.userDetail.cid.toString()) ==
            "cancelled") {
          if (provider.userDetail.cid == event.organiserID) {
            CommonWidgets.eventCancelBottomSheet(context, scaler, delete: () {
              Navigator.of(context).pop();
              provider.deleteEvent(context, event.eid);
            });
          } else {
            Container();
          }
        } else {
          Container();
        }
      },
      child: CustomShape(
        child: Center(
            child: provider.getMultipleDate[index] == true
                ? Container(
                height: scaler.getHeight(1.5),
                width: scaler.getWidth(3.0),
                child: CircularProgressIndicator(
                    color: ColorConstants.colorWhite))
                : Text(CommonEventFunction.getEventBtnStatus(
                            event, provider.auth.currentUser!.uid)
                        .toString()
                        .tr())
                .semiBoldText(
                    CommonEventFunction.getEventBtnColorStatus(
                        event, provider.auth.currentUser!.uid),
                    scaler.getTextSize(9.5),
                    TextAlign.center)),
        bgColor: CommonEventFunction.getEventBtnColorStatus(
            event, provider.auth.currentUser!.uid,
            textColor: false),
        radius: BorderRadius.all(
          Radius.circular(12),
        ),
        width: scaler.getWidth(20),
        height: scaler.getHeight(3.5),
      ),
    );
  }

  alertForQuestionnaireAnswers(
      BuildContext context,
      ScreenScaler scaler,
      Event event,
      List<String> questionsList,
      OrganizeEventCardProvider provider) {
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
                                textCapitalization:
                                    TextCapitalization.sentences,
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
                                  context, event.eid, answersMap);
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

  // alertForMultiDateAnswers(
  //     BuildContext context,
  //     ScreenScaler scaler,
  //     List<DateOption> multiDate,
  //     OrganizeEventCardProvider provider,
  //     Event event) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, StateSetter setInnerState) {
  //           return Container(
  //               width: double.infinity,
  //               child: AlertDialog(
  //                 contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
  //                 insetPadding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 24.0),
  //                 title:
  //                     CommonWidgets.answerMultiDateAlertTitle(context, scaler),
  //                 content: Container(
  //                   //  color: Colors.red,
  //                   height: scaler.getHeight(25.0),
  //                   width: scaler.getWidth(100.0),
  //                   child: GridView.builder(
  //                     shrinkWrap: true,
  //                     itemCount: provider.multipleDate.length,
  //                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                         crossAxisCount: 3,
  //                         crossAxisSpacing: 2.0,
  //                         mainAxisSpacing: 3.0),
  //                     itemBuilder: (context, index) {
  //                       return GestureDetector(
  //                         onTap: () {
  //                           setInnerState(() {
  //                             provider.selectedMultiDateIndex = index;
  //                             provider.attendDateBtnColor = true;
  //                             provider.selectedAttendDateDid =
  //                                 multiDate[index].did;
  //                             provider.selectedAttendDateEid =
  //                                 multiDate[index].eid;
  //                           });
  //                         },
  //                         child: CommonWidgets.gridViewOfMultiDateAlertDialog(
  //                             scaler, multiDate, index,
  //                             selectedIndex: provider.selectedMultiDateIndex),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //                 actions: [
  //                   provider.answerMultiDate == true
  //                       ? Center(child: CircularProgressIndicator())
  //                       : CommonWidgets.commonBtn(
  //                           scaler,
  //                           context,
  //                           "submit".tr(),
  //                           provider.attendDateBtnColor == true
  //                               ? ColorConstants.primaryColor
  //                               : ColorConstants.colorNewGray,
  //                           provider.attendDateBtnColor == true
  //                               ? ColorConstants.colorWhite
  //                               : ColorConstants.colorGray,
  //                           onTapFun: provider.attendDateBtnColor == true ||
  //                                   provider.selectedAttendDateDid != null
  //                               ? () {
  //                                   setInnerState(() {
  //                                     provider
  //                                         .answerMultiDateOption(
  //                                             context,
  //                                             provider.selectedAttendDateEid
  //                                                 .toString(),
  //                                             provider.selectedAttendDateDid
  //                                                 .toString())
  //                                         .then((value) {
  //                                       if (event.form.values.isNotEmpty) {
  //                                         List<String> questionsList = [];
  //                                         for (var value in event.form.values) {
  //                                           questionsList.add(value);
  //                                         }
  //                                         Navigator.of(context).pop();
  //                                         alertForQuestionnaireAnswers(
  //                                             context,
  //                                             scaler,
  //                                             event,
  //                                             questionsList,
  //                                             provider);
  //                                       } else {
  //                                         Navigator.of(context).pop();
  //                                         provider.replyToEvent(context,
  //                                             event.eid, EVENT_ATTENDING);
  //                                       }
  //                                     });
  //                                   });
  //                                 }
  //                               : () {})
  //                 ],
  //               ));
  //         });
  //       });
  // }
}
