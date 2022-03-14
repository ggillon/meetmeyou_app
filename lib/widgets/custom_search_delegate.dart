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
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/search_result.dart';
import 'package:meetmeyou_app/provider/custom_search_delegate_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/home/homePage.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class CustomSearchDelegate extends SearchDelegate   {
  final answer1Controller = TextEditingController();
  final answer2Controller = TextEditingController();
  final answer3Controller = TextEditingController();
  final answer4Controller = TextEditingController();
  final answer5Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    // if (query.length < 3) {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Center(
    //         child: Text(
    //           "Search term must be longer than two letters.",
    //         ),
    //       )
    //     ],
    //   );
    // }

   return BaseView<CustomSearchDelegateProvider>(
     onModelReady: (provider){
       provider.search(context, query);
     },
       builder: (context, provider, _){
     return provider.state == ViewState.Busy ?  Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Center(child: CircularProgressIndicator()),
         SizedBox(height: scaler.getHeight(1)),
         Text("searching_data".tr()).mediumText(
             ColorConstants.primaryColor,
             scaler.getTextSize(10),
             TextAlign.left),
       ],
     ) : (provider.contactsList.isEmpty && provider.eventLists.isEmpty) ?  Expanded(
       child:
       Center(
         child: Text("no_data_found".tr())
             .mediumText(
             ColorConstants.primaryColor,
             scaler.getTextSize(10),
             TextAlign.left),
       ),
     ) :  Column(
       children: [
         (provider.contactsList.isEmpty || provider.contactsList == null) ?
             Container()
             :  Expanded(
           child: Padding(
             padding: scaler.getPaddingAll(10.5),
             child: Column(
               children: <Widget>[
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("people".tr()).boldText(ColorConstants.colorBlack, 20.0, TextAlign.left),
                     GestureDetector(
                       onTap: (){

                       },
                     child: Text("see_all".tr()).mediumText(ColorConstants.primaryColor, 15.0, TextAlign.left),)
                   ],
                 ),
                 SizedBox(height: scaler.getHeight(1.0)),
                 contactList(scaler, provider),
               ],
             ),
           ),
         ),
         (provider.eventLists.isEmpty || provider.eventLists == null) ? Container() :  Expanded(
           child: Padding(
             padding: scaler.getPaddingLTRB(2.5, 1.5, 2.5, 0.0),
             child: Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("events".tr()).boldText(ColorConstants.colorBlack, 20.0, TextAlign.left),
                     GestureDetector(
                       onTap: (){

                       },
                       child: Text("see_all".tr()).mediumText(ColorConstants.primaryColor, 15.0, TextAlign.left),)
                   ],
                 ),
                 SizedBox(height: scaler.getHeight(1.0)),
                eventsList(scaler, provider),
               ],
             ),
           ),
         )
       ],
     );
   });


  }

  Widget contactList(ScreenScaler scaler, CustomSearchDelegateProvider provider) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.contactsList.length <= 3 ? provider.contactsList.length : 3,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: provider.contactsList[index].status ==
                            'Listed profile' ||
                        provider.contactsList[index].status ==
                            'Invited contact'
                    ? () {}
                    : () {
                  provider.setContactsValue(provider.contactsList[index]);
                  provider.discussionDetail.userId = provider.contactsList[index].cid;
                        Navigator.pushNamed(
                            context, RoutesConstants.contactDescription,
                        );
                      },
                child: CommonWidgets.userContactCard(
                    scaler,
                    provider.contactsList[index].email,
                    provider.contactsList[index].displayName,
                    profileImg: provider.contactsList[index].photoURL,
                    searchStatus: provider.contactsList[index].status,
                    search: true, addIconTapAction: () {
                  // provider.inviteProfile(_scaffoldKey.currentContext!,
                  //     provider.searchContactList[index]);
                }),
              );
            }),
      ),
    );
  }

  Widget eventsList(ScreenScaler scaler, CustomSearchDelegateProvider provider){
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.eventLists.length <= 3 ? provider.eventLists.length : 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: scaler.getPaddingLTRB(1.0, 0.0, 1.0, 1.0),
                child: GestureDetector(
                  onTap: (){},
                  child:  Card(
                    shadowColor: ColorConstants.colorWhite,
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: scaler.getBorderRadiusCircular(10)),
                    child: eventCard(scaler, context, provider, provider.eventLists[index], index),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget eventCard(ScreenScaler scaler, BuildContext context,
      CustomSearchDelegateProvider provider, Event eventList, int index) {
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
                width: double.infinity,
                color: ColorConstants.primaryColor,
              )
                  : ImageView(
                path: eventList.photoURL,
                fit: BoxFit.cover,
                height: scaler.getHeight(21),
                width: double.infinity,
              ),
            ),
            Positioned(
                top: scaler.getHeight(1),
                left: scaler.getHeight(1.5),
                child: dateCard(scaler, eventList))
          ],
        ),
        Padding(
          padding: scaler.getPaddingLTRB(3.0, 0.8, 3.0, 0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: scaler.getWidth(45),
                      child: Text(eventList.title).boldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(10),
                          TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(height: scaler.getHeight(0.2)),
                    Row(
                      children: [
                        ImageView(path: ImageConstants.clock_icon),
                        SizedBox(width: scaler.getWidth(1)),
                        Container(
                          width: scaler.getWidth(38),
                          child: Text(eventList.start.toString().substring(0, 11) ==
                              eventList
                                  .end
                                  .toString()
                                  .substring(0, 11)
                              ? DateTimeHelper.getWeekDay(eventList.start) +
                              " - " +
                              DateTimeHelper.convertEventDateToTimeFormat(
                                  eventList.start) +
                              " to " +
                              DateTimeHelper.convertEventDateToTimeFormat(
                                  eventList.end)
                              : DateTimeHelper.getWeekDay(eventList.start) +
                              " - " +
                              DateTimeHelper.convertEventDateToTimeFormat(
                                  eventList.start) +
                              " to " +
                              DateTimeHelper.dateConversion(
                                  eventList.end,
                                  date: false) +
                              "(${DateTimeHelper.convertEventDateToTimeFormat(eventList.end)})")
                              .regularText(ColorConstants.colorGray,
                              scaler.getTextSize(7.7), TextAlign.left,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                    SizedBox(height: scaler.getHeight(0.2)),
                    Row(
                      children: [
                        Icon(Icons.map, size: 17),
                        SizedBox(width: scaler.getWidth(1)),
                        Container(
                          width: scaler.getWidth(38),
                          child: Text(eventList.location).regularText(
                              ColorConstants.colorGray,
                              scaler.getTextSize(7.7),
                              TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(width: scaler.getWidth(1)),
              eventRespondBtn(context, scaler, eventList, provider, index)
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
      CustomSearchDelegateProvider provider, int index) {
    return GestureDetector(
      onTap: () {
        if (CommonEventFunction.getEventBtnStatus(event, provider.auth.currentUser!.uid.toString()) == "respond") {
          answer1Controller.clear();
          answer2Controller.clear();
          answer3Controller.clear();
          answer4Controller.clear();
          answer5Controller.clear();
          CommonWidgets.respondToEventBottomSheet(context, scaler, multipleDate: event.multipleDates, multiDate: (){
            Navigator.of(context).pop();
            provider.homePageProvider
                .setEventValuesForEdit(
                provider.eventLists[index]);
            provider.eventDetail.eventBtnStatus =
                CommonEventFunction.getEventBtnStatus(
                    provider.eventLists[index],
                    provider.auth.currentUser!.uid.toString());
            provider.eventDetail.textColor =
                CommonEventFunction
                    .getEventBtnColorStatus(
                    provider.eventLists[index],
                    provider.auth.currentUser!.uid.toString());
            provider.eventDetail.btnBGColor =
                CommonEventFunction
                    .getEventBtnColorStatus(
                    provider.eventLists[index],
                    provider.auth.currentUser!.uid.toString(),
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
           //   provider.getUserEvents(context);
              provider.search(context, query);
              provider.unRespondedEventsApi(context);
            });
          },going: () {
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
            event, provider.auth.currentUser!.uid.toString()) ==
            "edit") {
          provider.homePageProvider.setEventValuesForEdit(event);
          provider.homePageProvider.clearMultiDateOption();
          Navigator.pushNamed(context, RoutesConstants.createEventScreen)
              .then((value) {
          //  provider.getUserEvents(context);
            provider.search(context, query);
          });
        } else if (CommonEventFunction.getEventBtnStatus(
            event, provider.auth.currentUser!.uid.toString()) ==
            "cancelled") {
          if (provider.auth.currentUser!.uid.toString() == event.organiserID) {
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
      CustomSearchDelegateProvider provider) {
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
    @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
      return Column();
  }
}