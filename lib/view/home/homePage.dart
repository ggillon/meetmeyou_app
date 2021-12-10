import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/helper/shared_pref.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/home_page_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/widgets/organizedEventsCard.dart';

class HomePage extends StatefulWidget {
  AuthBase auth = locator<AuthBase>();
  HomePageProvider? provider;

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin<HomePage> {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
          //     body: Container(
          //         child: Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Text("Home Page").semiBoldText(ColorConstants.colorBlack,
          //           scaler.getTextSize(10), TextAlign.center),
          //       SizedBox(
          //         height: scaler.getHeight(3),
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           auth.signOut();
          //           UserDetail userDetail = locator<UserDetail>();
          //           userDetail.profileUrl = null;
          //           SharedPref.clearSharePref();
          //           //SharedPref.prefs?.setBool(SharedPref.IS_USER_LOGIN, false);
          //           Navigator.of(context).pushNamedAndRemoveUntil(
          //               RoutesConstants.loginOptions, (route) => false);
          //         },
          //         child: Text("Sign Out").semiBoldText(ColorConstants.primaryColor,
          //             scaler.getTextSize(14), TextAlign.center),
          //       ),
          //     ],
          //   ),
          // ))
          body: BaseView<HomePageProvider>(
        onModelReady: (provider) {
          provider.getUserDetail(context);
          widget.provider = provider;
          provider.tabController = TabController(length: 5, vsync: this);
          provider.tabChangeEvent(context);
          provider.getIndexChanging(context);
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
                    ImageView(path: ImageConstants.search_icon)
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
                            : upcomingEventsList(
                                scaler, provider.eventLists, provider),
                    provider.state == ViewState.Busy
                        ? loading(scaler)
                        : provider.eventLists.length == 0
                            ? noEventFoundText(scaler)
                            : upcomingEventsList(
                                scaler, provider.eventLists, provider),
                    provider.state == ViewState.Busy
                        ? loading(scaler)
                        : provider.eventLists.length == 0
                            ? noEventFoundText(scaler)
                            : upcomingEventsList(
                                scaler, provider.eventLists, provider),
                    provider.state == ViewState.Busy
                        ? loading(scaler)
                        : provider.eventLists.length == 0
                            ? noEventFoundText(scaler)
                            : upcomingEventsList(
                                scaler, provider.eventLists, provider),
                    provider.state == ViewState.Busy
                        ? loading(scaler)
                        : provider.eventLists.length == 0
                            ? noEventFoundText(scaler)
                            : upcomingEventsList(
                                scaler, provider.eventLists, provider),
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

  Widget upcomingEventsList(
      ScreenScaler scaler, List<Event> eventList, HomePageProvider provider) {
    return Padding(
      padding: scaler.getPaddingLTRB(5.8, 0.5, 5.8, 0.0),
      child: ListView.builder(
          itemCount: eventList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: scaler.getPaddingLTRB(0.0, 0.0, 0.0, 1.0),
              child: GestureDetector(
                onTap: () {
                  provider.eventDetail.eventBtnStatus =
                      provider.getEventBtnStatus(eventList[index]);
                  provider.eventDetail.textColor =
                      provider.getEventBtnColorStatus(eventList[index]);
                  provider.eventDetail.btnBGColor =
                      provider.getEventBtnColorStatus(eventList[index],
                          textColor: false);
                  provider.eventDetail.eventMapData = eventList[index].invitedContacts;
                  provider.eventDetail.eid = eventList[index].eid;
                  Navigator.pushNamed(
                      context, RoutesConstants.eventDetailScreen,
                      arguments: eventList[index]).then((value) {
                        provider.getIndexChanging(context);
                  });
                },
                child: Card(
                  shadowColor: ColorConstants.colorWhite,
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: scaler.getBorderRadiusCircular(10)),
                  // child: CustomShape(
                  child: eventCard(scaler, context, eventList, index, provider),
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

  Widget eventCard(ScreenScaler scaler, BuildContext context,
      List<Event> eventList, int index, HomePageProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius:
                  scaler.getBorderRadiusCircularLR(10.0, 10.0, 0.0, 0.0),
              child: ImageView(
                path: eventList[index].photoURL,
                fit: BoxFit.fill,
                height: scaler.getHeight(21),
                //  width: MediaQuery.of(context).size.width / 1.2,
              ),
            ),
            Positioned(
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
                          width: scaler.getWidth(37),
                          child: Text(DateTimeHelper.getWeekDay(
                                      eventList[index].start) +
                                  " - " +
                                  DateTimeHelper.convertEventDateToTimeFormat(
                                      eventList[index].start) +
                                  " to " +
                                  DateTimeHelper.convertEventDateToTimeFormat(
                                      eventList[index].end))
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
                          width: scaler.getWidth(37),
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
              eventRespondBtn(scaler, eventList[index], provider)
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

  Widget eventRespondBtn(
      ScreenScaler scaler, Event event, HomePageProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.getEventBtnStatus(event) == "respond"
            ? CommonWidgets.respondToEventBottomSheet(context, scaler,
                going: () {
                Navigator.of(context).pop();
                provider.replyToEvent(context, event.eid, EVENT_ATTENDING);
              }, notGoing: () {
                Navigator.of(context).pop();
                provider.replyToEvent(context, event.eid, EVENT_NOT_ATTENDING);
              }, hide: () {
                Navigator.of(context).pop();
                provider.replyToEvent(context, event.eid, EVENT_NOT_INTERESTED);
              })
            : Container();
      },
      child: CustomShape(
        child: Center(
            child: Text(provider.getEventBtnStatus(event).toString().tr())
                .semiBoldText(provider.getEventBtnColorStatus(event),
                    scaler.getTextSize(9.5), TextAlign.center)),
        bgColor: provider.getEventBtnColorStatus(event, textColor: false),
        radius: BorderRadius.all(
          Radius.circular(12),
        ),
        width: scaler.getWidth(20),
        height: scaler.getHeight(3.5),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
