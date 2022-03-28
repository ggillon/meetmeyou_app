import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:meetmeyou_app/helper/shared_pref.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/userEventsNotificationEvent.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/provider/home_page_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_search_delegate.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/widgets/organizedEventsCard.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uni_links/uni_links.dart';

class HomePage extends StatefulWidget {
  AuthBase auth = locator<AuthBase>();
  HomePageProvider? provider;

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  final answer1Controller = TextEditingController();
  final answer2Controller = TextEditingController();
  final answer3Controller = TextEditingController();
  final answer4Controller = TextEditingController();
  final answer5Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var refreshKeyTab1 = GlobalKey<RefreshIndicatorState>();
  var refreshKeyTab2 = GlobalKey<RefreshIndicatorState>();
  var refreshKeyTab3 = GlobalKey<RefreshIndicatorState>();
  var refreshKeyTab4 = GlobalKey<RefreshIndicatorState>();
  var refreshKeyTab5 = GlobalKey<RefreshIndicatorState>();
  HomePageProvider provider = HomePageProvider();
  DashboardProvider _dashboardProvider = DashboardProvider();

  Future<Null> refreshListTab1() async {
    refreshKeyTab1.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    //network call and setState so that view will render the new values
    await this.provider.getIndexChanging(context, refresh: true);
  }

  Future<Null> refreshListTab2() async {
    refreshKeyTab2.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    await this.provider.getIndexChanging(context, refresh: true);
  }

  Future<Null> refreshListTab3() async {
    refreshKeyTab3.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    await this.provider.getIndexChanging(context, refresh: true);
  }

  Future<Null> refreshListTab4() async {
    refreshKeyTab4.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    await this.provider.getIndexChanging(context, refresh: true);
  }

  Future<Null> refreshListTab5() async {
    refreshKeyTab5.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    await this.provider.getIndexChanging(context, refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final dashBoardProvider =
        Provider.of<DashboardProvider>(context, listen: false);
    this._dashboardProvider = dashBoardProvider;
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
          body: BaseView<HomePageProvider>(
        onModelReady: (provider) async {
          this.provider = provider;
          provider.getUserDetail(context);
          widget.provider = provider;
          provider.tabController = TabController(length: 5, vsync: this);
           provider.tabChangeEvent(context);
          await provider.getIndexChanging(context);
           provider.updatedDiscussions(context);
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if ((provider.eventDetail.unRespondedEvent ?? 0) >
                (provider.eventDetail.unRespondedEvent1 ?? 0)) {
              dashBoardProvider.updateEventNotificationCount();
              provider.unRespondedEventsApi(context);
            }
          });

         // provider.firebaseNotification.configureFireBase(context);

            provider.eventBus.on<UserEventsNotificationEvent>().listen((event) {
              if(event.eventId != null){
                 provider.calendarDetail.fromCalendarPage = true;
                  provider.eventDetail.eid = event.eventId;
                  Navigator.pushNamed(context, RoutesConstants.eventDetailScreen).then((value) {
                    provider.getIndexChanging(context);
                    provider.unRespondedEvents(context, dashBoardProvider);
                    provider.unRespondedEventsApi(context);
                  });
              }
          });

          // // For handling notification when the app is in background
          // // but not terminated
          // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          //   if(message.data["id"] != null){
          //     provider.calendarDetail.fromCalendarPage = true;
          //     provider.eventDetail.eid = message.data["id"];
          //     Navigator.pushNamed(context, RoutesConstants.eventDetailScreen).then((value) {
          //       provider.getIndexChanging(context);
          //       provider.unRespondedEvents(context, dashBoardProvider);
          //       provider.unRespondedEventsApi(context);
          //     });
          //   }
          // });
          //
          // // For handling notification when the app is in terminated state
          // provider.checkForInitialMessage(context, dashBoardProvider);
        },
        builder: (context, provider, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: scaler.getPaddingLTRB(2.5, 2.0, 4.5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("home".tr()).boldText(ColorConstants.colorBlack,
                        scaler.getTextSize(16), TextAlign.left),
                    Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            showSearch(
                              context: context,
                              delegate: CustomSearchDelegate(),
                            ).then((value) {
                              provider.getIndexChanging(context);
                            });
                          },
                          child:
                              Icon(Icons.search_outlined, color: ColorConstants.primaryColor, size: 30),
                        ),
                        SizedBox(width: scaler.getWidth(2.0)),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            Navigator.pushNamed(context, RoutesConstants.chatsScreen).then((value) {
                              provider.updatedDiscussions(context);
                            });
                          },
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topRight,
                              children: [
                                Icon(Icons.message, color: ColorConstants.primaryColor, size: 28),
                                CommonWidgets.notificationBadge(scaler,
                                    provider.chatNotificationCount ?? 0)
                              ],
                            ),
                            ),
                      ],
                    )
                   // ImageView(path: ImageConstants.search_icon)
                  ],
                ),
              ),
              SizedBox(height: scaler.getHeight(2.0)),
              Padding(
                padding: scaler.getPaddingLTRB(2.5, 0, 2.5, 0),
                child: Text("my_upcoming_events".tr()).boldText(
                    ColorConstants.colorBlack,
                    scaler.getTextSize(12),
                    TextAlign.left),
              ),
              SizedBox(height: scaler.getHeight(0.5)),
              Padding(
                padding: scaler.getPaddingLTRB(2.0, 0, 0, 0),
                child: TabBar(
                  labelPadding: scaler.getPadding(0.0, 1.5),
                  indicatorColor: Colors.transparent,
                  controller: widget.provider?.tabController,
                  isScrollable: true,
                  onTap: (index) {
                    if (provider.tabController!.indexIsChanging) {
                      provider.getIndexChanging(context);
                    }
                    provider.updateValue(true);
                  },
                  tabs: [
                    Tab(
                        child: ClipRRect(
                      borderRadius: scaler.getBorderRadiusCircular(15.0),
                      child: Container(
                        padding: scaler.getPaddingLTRB(3.0, 0.5, 3.0, 0.5),
                        color: provider.tabController!.index == 0
                            ? ColorConstants.primaryColor
                            : ColorConstants.colorWhitishGray,
                        child: Text('all'.tr()).mediumText(
                            provider.tabController!.index == 0
                                ? ColorConstants.colorWhite
                                : ColorConstants.colorGray,
                            scaler.getTextSize(9.5),
                            TextAlign.left),
                      ),
                    )),
                    Tab(
                        child: ClipRRect(
                      borderRadius: scaler.getBorderRadiusCircular(15.0),
                      child: Container(
                        padding: scaler.getPaddingLTRB(3.0, 0.5, 3.0, 0.5),
                        color: provider.tabController!.index == 1
                            ? ColorConstants.primaryColor
                            : ColorConstants.colorWhitishGray,
                        child: Text('going'.tr()).mediumText(
                            provider.tabController!.index == 1
                                ? ColorConstants.colorWhite
                                : ColorConstants.colorGray,
                            scaler.getTextSize(9.5),
                            TextAlign.left),
                      ),
                    )),
                    Tab(
                        child: ClipRRect(
                      borderRadius: scaler.getBorderRadiusCircular(15.0),
                      child: Container(
                        padding: scaler.getPaddingLTRB(3.0, 0.5, 3.0, 0.5),
                        color: provider.tabController!.index == 2
                            ? ColorConstants.primaryColor
                            : ColorConstants.colorWhitishGray,
                        child: Text('not_going'.tr()).mediumText(
                            provider.tabController!.index == 2
                                ? ColorConstants.colorWhite
                                : ColorConstants.colorGray,
                            scaler.getTextSize(9.5),
                            TextAlign.left),
                      ),
                    )),
                    Tab(
                        child: ClipRRect(
                      borderRadius: scaler.getBorderRadiusCircular(15.0),
                      child: Container(
                        padding: scaler.getPaddingLTRB(3.0, 0.5, 3.0, 0.5),
                        color: provider.tabController!.index == 3
                            ? ColorConstants.primaryColor
                            : ColorConstants.colorWhitishGray,
                        child: Text('not_replied'.tr()).mediumText(
                            provider.tabController!.index == 3
                                ? ColorConstants.colorWhite
                                : ColorConstants.colorGray,
                            scaler.getTextSize(9.5),
                            TextAlign.left),
                      ),
                    )),
                    Tab(
                        child: ClipRRect(
                      borderRadius: scaler.getBorderRadiusCircular(15.0),
                      child: Container(
                        padding: scaler.getPaddingLTRB(3.0, 0.5, 3.0, 0.5),
                        color: provider.tabController!.index == 4
                            ? ColorConstants.primaryColor
                            : ColorConstants.colorWhitishGray,
                        child: Text('hidden'.tr()).mediumText(
                            provider.tabController!.index == 4
                                ? ColorConstants.colorWhite
                                : ColorConstants.colorGray,
                            scaler.getTextSize(9.5),
                            TextAlign.left),
                      ),
                    )),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: provider.tabController,
                  children: <Widget>[
                    provider.state == ViewState.Busy
                        ? loading(scaler)
                        : provider.eventLists.length == 0
                            ? noEventFoundText(scaler)
                            : RefreshIndicator(
                                onRefresh: refreshListTab1,
                                key: refreshKeyTab1,
                                child: upcomingEventsList(
                                    scaler,
                                    provider.eventLists,
                                    provider,
                                    dashBoardProvider),
                              ),
                    provider.state == ViewState.Busy
                        ? loading(scaler)
                        : provider.eventLists.length == 0
                            ? noEventFoundText(scaler)
                            : RefreshIndicator(
                                onRefresh: refreshListTab2,
                                key: refreshKeyTab2,
                                child: upcomingEventsList(
                                    scaler,
                                    provider.eventLists,
                                    provider,
                                    dashBoardProvider),
                              ),
                    provider.state == ViewState.Busy
                        ? loading(scaler)
                        : provider.eventLists.length == 0
                            ? noEventFoundText(scaler)
                            : RefreshIndicator(
                                onRefresh: refreshListTab3,
                                key: refreshKeyTab3,
                                child: upcomingEventsList(
                                    scaler,
                                    provider.eventLists,
                                    provider,
                                    dashBoardProvider),
                              ),
                    provider.state == ViewState.Busy
                        ? loading(scaler)
                        : provider.eventLists.length == 0
                            ? noEventFoundText(scaler)
                            : RefreshIndicator(
                                onRefresh: refreshListTab4,
                                key: refreshKeyTab4,
                                child: upcomingEventsList(
                                    scaler,
                                    provider.eventLists,
                                    provider,
                                    dashBoardProvider),
                              ),
                    provider.state == ViewState.Busy
                        ? loading(scaler)
                        : provider.eventLists.length == 0
                            ? noEventFoundText(scaler)
                            : RefreshIndicator(
                                onRefresh: refreshListTab5,
                                key: refreshKeyTab5,
                                child: upcomingEventsList(
                                    scaler,
                                    provider.eventLists,
                                    provider,
                                    dashBoardProvider),
                              ),
                  ],
                ),
              ),
            ],
          );
        },
      )),
    );
  }

  Widget loading(ScreenScaler scaler) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: CircularProgressIndicator()),
        SizedBox(height: scaler.getHeight(1)),
        Text("loading_event".tr()).mediumText(ColorConstants.primaryColor,
            scaler.getTextSize(10), TextAlign.left),
      ],
    );
  }

  Widget noEventFoundText(ScreenScaler scaler) {
    return Center(
      child: Text("sorry_no_event_found".tr()).mediumText(
          ColorConstants.primaryColor, scaler.getTextSize(10), TextAlign.left),
    );
  }

  Widget upcomingEventsList(ScreenScaler scaler, List<Event> eventList,
      HomePageProvider provider, DashboardProvider dashboardProvider) {
    return Padding(
      padding: scaler.getPaddingLTRB(5.8, 0.5, 5.8, 0.0),
      child: ListView.builder(
          itemCount: eventList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: scaler.getPaddingLTRB(0.0, 0.0, 0.0, 1.0),
              child: GestureDetector(
                onTap: () {
                  provider.setEventValuesForEdit(eventList[index]);
                  provider.eventDetail.eventBtnStatus =
                      CommonEventFunction.getEventBtnStatus(
                          eventList[index], provider.userDetail.cid.toString());
                  provider.eventDetail.textColor =
                      CommonEventFunction.getEventBtnColorStatus(
                          eventList[index], provider.userDetail.cid.toString());
                  provider.eventDetail.btnBGColor =
                      CommonEventFunction.getEventBtnColorStatus(
                          eventList[index], provider.userDetail.cid.toString(),
                          textColor: false);
                  provider.eventDetail.eventMapData = eventList[index].invitedContacts;
                  provider.eventDetail.eid = eventList[index].eid;
                  provider.eventDetail.organiserId =
                      eventList[index].organiserID;
                  provider.eventDetail.organiserName =
                      eventList[index].organiserName;
                  provider.calendarDetail.fromCalendarPage = false;
                  Navigator.pushNamed(
                          context, RoutesConstants.eventDetailScreen)
                      .then((value) {
                    provider.getIndexChanging(context);
                    provider.unRespondedEvents(context, dashboardProvider);
                    provider.unRespondedEventsApi(context);
                    // if (provider.eventDetail.unRespondedEvent! > provider.eventDetail.unRespondedEvent1!.toInt()) {
                    //   dashboardProvider.updateEventNotificationCount();
                    // }
                  });
                },
                child: Card(
                  shadowColor: ColorConstants.colorWhite,
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: scaler.getBorderRadiusCircular(10)),
                  // child: CustomShape(
                  child: eventCard(scaler, context, eventList, index, provider,
                      dashboardProvider),
                  //  bgColor: ColorConstants.colorWhite,
                  //   radius: scaler.getBorderRadiusCircular(10),
                  //  width: MediaQuery.of(context).size.width / 1.2
                  //    ),
                ),
              ),
            );
          }),
    );
  }

  Widget eventCard(
      ScreenScaler scaler,
      BuildContext context,
      List<Event> eventList,
      int index,
      HomePageProvider provider,
      DashboardProvider dashboardProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius:
                  scaler.getBorderRadiusCircularLR(10.0, 10.0, 0.0, 0.0),
              child: eventList[index].photoURL == null
                  ? Container(
                      height: scaler.getHeight(21),
                      width: double.infinity,
                      color: ColorConstants.primaryColor,
                    )
                  : ImageView(
                      path: eventList[index].photoURL,
                      fit: BoxFit.cover,
                      height: scaler.getHeight(21),
                      width: double.infinity,
                    ),
            ),
           provider.userDetail.cid == eventList[index].organiserID && CommonEventFunction.getEventBtnStatus(
               eventList[index], provider.userDetail.cid.toString()) ==
               "edit" ? Positioned(
               top: scaler.getHeight(1),
               left: scaler.getHeight(1.5),
               child: Container(
                 width: scaler.getWidth(70),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     dateCard(scaler, eventList[index]),
                     shareCard(scaler, eventList[index])
                   ],
                 ),
               )) :  Positioned(
                top: scaler.getHeight(1),
                left: scaler.getHeight(1.5),
                child: dateCard(scaler, eventList[index]))
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
                      child: Text(eventList[index].title).boldText(
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
                          child: Text(eventList[index].start.toString().substring(0, 11) ==
                                      eventList[index]
                                          .end
                                          .toString()
                                          .substring(0, 11)
                                  ? DateTimeHelper.getWeekDay(eventList[index].start) +
                                      " - " +
                                      DateTimeHelper.convertEventDateToTimeFormat(
                                          eventList[index].start) +
                                      " to " +
                                      DateTimeHelper.convertEventDateToTimeFormat(
                                          eventList[index].end)
                                  : DateTimeHelper.getWeekDay(eventList[index].start) +
                                      " - " +
                                      DateTimeHelper.convertEventDateToTimeFormat(
                                          eventList[index].start) +
                                      " to " +
                                      DateTimeHelper.dateConversion(
                                          eventList[index].end,
                                          date: false) +
                                      "(${DateTimeHelper.convertEventDateToTimeFormat(eventList[index].end)})")
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
                          child: Text(eventList[index].location).regularText(
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
              eventRespondBtn(
                  scaler, eventList[index], provider, dashboardProvider, index)
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

  Widget shareCard(ScreenScaler scaler, Event event){
    return GestureDetector(
      onTap: () async{
        String eventLink = provider.mmyEngine!.getEventLink(event.eid);
        await provider.dynamicLinksApi.createLink(context, eventLink).then((value) {
          String shareLink = provider.dynamicLinksApi.dynamicUrl.toString();
          Share.share("Please find link to the event I’m organising: ${shareLink}");
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircular(75)),
          child: Container(
            padding: scaler.getPaddingAll(6.0),
              child: ImageView(path: ImageConstants.eventShare_icon)),
      ),
    );
  }

  Widget eventRespondBtn(
      ScreenScaler scaler,
      Event event,
      HomePageProvider provider,
      DashboardProvider dashboardProvider,
      int index) {
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
          CommonWidgets.respondToEventBottomSheet(context, scaler, multipleDate: event.multipleDates, multiDate: (){
            Navigator.of(context).pop();
            provider.setEventValuesForEdit(event);
            provider.eventDetail.eventBtnStatus = CommonEventFunction.getEventBtnStatus(
                    event, provider.userDetail.cid.toString());
            provider.eventDetail.textColor =
                CommonEventFunction.getEventBtnColorStatus(
                    event, provider.userDetail.cid.toString());
            provider.eventDetail.btnBGColor =
                CommonEventFunction.getEventBtnColorStatus(
                    event, provider.userDetail.cid.toString(),
                    textColor: false);
            provider.eventDetail.eventMapData =
                event.invitedContacts;
            provider.eventDetail.eid = event.eid;
            provider.eventDetail.organiserId =
                event.organiserID;
            provider.eventDetail.organiserName =
                event.organiserName;
            provider.calendarDetail.fromCalendarPage = false;
            Navigator.pushNamed(
                context, RoutesConstants.eventDetailScreen)
                .then((value) {
              provider.getIndexChanging(context);
              provider.unRespondedEvents(context, dashboardProvider);
              provider.unRespondedEventsApi(context);
            });
          }, going: () {
            // if (event.multipleDates == true) {
            //   provider
            //       .getMultipleDateOptionsFromEvent(context, event.eid, index)
            //       .then((value) {
            //     alertForMultiDateAnswers(context, scaler, provider.multipleDate,
            //         provider, event, dashboardProvider);
            //   });
            // } else {
            if (event.form.values.isNotEmpty) {
              List<String> questionsList = [];
              for (var value in event.form.values) {
                questionsList.add(value);
              }
              Navigator.of(context).pop();
              alertForQuestionnaireAnswers(context, scaler, event,
                  questionsList, provider, dashboardProvider);
            } else {
              Navigator.of(context).pop();
              dashboardProvider.updateEventNotificationCount();
              provider.replyToEvent(context, event.eid, EVENT_ATTENDING);
            }
            // }
          }, notGoing: () {
            Navigator.of(context).pop();
            dashboardProvider.updateEventNotificationCount();
            provider.replyToEvent(context, event.eid, EVENT_NOT_ATTENDING);
          }, hide: () {
            Navigator.of(context).pop();
            dashboardProvider.updateEventNotificationCount();
            provider.replyToEvent(context, event.eid, EVENT_NOT_INTERESTED);
          });
        } else if (CommonEventFunction.getEventBtnStatus(
                event, provider.userDetail.cid.toString()) ==
            "edit") {
          provider.setEventValuesForEdit(event);
          provider.clearMultiDateOption();
          Navigator.pushNamed(context, RoutesConstants.createEventScreen)
              .then((value) {
            provider.getIndexChanging(context);
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
                            event, provider.userDetail.cid.toString())
                        .toString()
                        .tr())
                    .semiBoldText(
                        CommonEventFunction.getEventBtnColorStatus(
                            event, provider.userDetail.cid.toString()),
                        scaler.getTextSize(9.5),
                        TextAlign.center)),
        bgColor: CommonEventFunction.getEventBtnColorStatus(
            event, provider.userDetail.cid.toString(),
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
      HomePageProvider provider,
      DashboardProvider dashboardProvider) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            child: AlertDialog(
                title: Text("event_form_questionnaire".tr())
                    .boldText(ColorConstants.colorBlack, 14.0, TextAlign.left),
                content: Form(
                  key: _formKey,
                  child: Container(
                    // height: scaler.getHeight(40),
                    width: scaler.getWidth(75),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: questionsList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
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
                              dashboardProvider.updateEventNotificationCount();
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
  //     HomePageProvider provider,
  //     Event event,
  //     DashboardProvider dashboardProvider) {
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
  //                                             provider,
  //                                             dashboardProvider);
  //                                       } else {
  //                                         Navigator.of(context).pop();
  //                                         dashboardProvider
  //                                             .updateEventNotificationCount();
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

  @override
  bool get wantKeepAlive => true;
}
