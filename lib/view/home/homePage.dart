import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/helper/deep_linking.dart';
import 'package:meetmeyou_app/helper/shared_pref.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_permission_event.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/userEventsNotificationEvent.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/provider/home_page_provider.dart';
import 'package:meetmeyou_app/provider/public_home_page_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/services/mmy/event.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
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
    with TickerProviderStateMixin<HomePage> , WidgetsBindingObserver {
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
  var refreshKeyTab6 = GlobalKey<RefreshIndicatorState>();

  var refreshKeyTabPublication = GlobalKey<RefreshIndicatorState>();
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

    await this.provider.getPastEvents(context, refresh: true);
  }

  Future<Null> refreshListTab6() async {
    refreshKeyTab6.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    await this.provider.getIndexChanging(context, refresh: true);
  }

  Future<Null> refreshListTabPublication() async {
    refreshKeyTabPublication.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    await this.provider.getUserEvents(context, refresh: true, selector: [SELECTOR_ANNOUNCEMENT]);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        provider.getUserDetail(context);
        provider.userDetail.appleSignUpType == true ? provider.checkFilledProfile(context) : Container();
        provider.tabChangeEvent(context);
        await provider.getIndexChanging(context);
        provider.updatedDiscussions(context);
        provider.unRespondedEventsApi(context);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      // Nothing to do.
    }
    print('state = $state');
  }

  @override
  Widget build(BuildContext context) {
    final dashBoardProvider =
        Provider.of<DashboardProvider>(context, listen: false);
    this._dashboardProvider = dashBoardProvider;
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return  BaseView<HomePageProvider>(
      onModelReady: (provider) async {
        this.provider = provider;
          provider.getUserDetail(context);
          provider.userDetail.appleSignUpType == true ? provider.checkFilledProfile(context) : Container();
          widget.provider = provider;
          provider.tabController = TabController(length: 6, vsync: this);
          provider.tabChangeEvent(context);
         provider.tabTextIndexSelected = SharedPref.prefs!.getInt(SharedPref.homeToggleIndex) ?? 0;
         if(provider.tabTextIndexSelected == 0 || provider.tabTextIndexSelected == 1){
           provider.tabController!.index = SharedPref.prefs!.getInt(SharedPref.homeTabIndex) ?? 0;
           await provider.getIndexChanging(context);
         } else{
          await provider.getUserEvents(context, selector: [SELECTOR_ANNOUNCEMENT]);
         }
          provider.updatedDiscussions(context);
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            if ((provider.eventDetail.unRespondedEvent ?? 0) >
                (provider.eventDetail.unRespondedEvent1 ?? 0)) {
              dashBoardProvider.updateEventNotificationCount();
              provider.unRespondedEventsApi(context);
            }
          });

          provider.eventsNotifyEvent = provider.eventBus.on<UserEventsNotificationEvent>().listen((event) {
            if(event.eventId != null){
              provider.calendarDetail.fromAnotherPage = true;
              provider.eventDetail.eid = event.eventId;
              Navigator.pushNamed(context, RoutesConstants.eventDetailScreen).then((value) async {
                if(provider.tabTextIndexSelected == 0 || provider.tabTextIndexSelected == 1){
                  provider.tabController!.index = SharedPref.prefs!.getInt(SharedPref.homeTabIndex) ?? 0;
                  await provider.getIndexChanging(context);
                } else{
                  await provider.getUserEvents(context, selector: [SELECTOR_ANNOUNCEMENT]);
                }
                provider.unRespondedEvents(context, dashBoardProvider);
                provider.unRespondedEventsApi(context);
              });
            }
          });

          // this event will fire when user comes from link and when gets back from event detail
          //this event is fire so that we can refresh status of events in home screen.
        provider.eventInviteFromLink =  provider.eventBus.on<InviteEventFromLink>().listen((event) async {
          if(provider.tabTextIndexSelected == 0 || provider.tabTextIndexSelected == 1){
            provider.tabController!.index = SharedPref.prefs!.getInt(SharedPref.homeTabIndex) ?? 0;
            await provider.getIndexChanging(context);
          } else{
            await provider.getUserEvents(context, selector: [SELECTOR_ANNOUNCEMENT]);
          }
          provider.unRespondedEvents(context, dashBoardProvider);
          provider.unRespondedEventsApi(context);
        });

        // this will fire when user not accepted calendar permission in platform iOS.
        provider.calendarPermissionEvent = provider.eventBus.on<CalendarPermissionEvent>().listen((event) async {
          if(event.openSettings == true){
            await CommonWidgets.errorDialog(context, "enable_calendar_permission".tr());
          }
        });
      },
      builder: (context, provider, _) {
        return SafeArea(
          child: Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: (provider.checkAppleLoginFilledProfile == true || provider.checkAppleLoginFilledProfile == null) ? Container() : GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, RoutesConstants.editProfileScreen).then((value) {
                  provider.getIndexChanging(context);
                  provider.checkFilledProfile(context);
                });
              },
              child: Card(
                color: Colors.orange,
                child: Container(
                  width: double.infinity,
                  padding: scaler.getPaddingAll(10.0),
                  child: Text("click_here_to_edit".tr()).mediumText(ColorConstants.colorWhite,
                      scaler.getTextSize(11.2), TextAlign.center),
                ),
              ),
            ) ,

            backgroundColor: provider.userDetail.userType == USER_TYPE_PRO ? ColorConstants.colorLightCyan : (provider.userDetail.userType == USER_TYPE_ADMIN ? ColorConstants.colorLightRed :ColorConstants.colorWhite),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: scaler.getPaddingLTRB(2.5, 2.0, 4.5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("home".tr()).boldText(ColorConstants.colorBlack,
                          scaler.getTextSize(17.0), TextAlign.left),
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
                            child: Icon(Icons.search_outlined, color: ColorConstants.primaryColor, size: 30),
                          ),
                          SizedBox(width: scaler.getWidth(2.0)),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){
                              Navigator.pushNamed(context, RoutesConstants.notificationsHistoryScreen).then((value) {
                                provider.getIndexChanging(context);
                              });
                            },
                            child: Icon(Icons.notifications, color: ColorConstants.primaryColor, size: 28),
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
                Center(
                  child: Container(
                    width: scaler.getWidth(95),
                    padding: scaler.getPaddingLTRB(2.5, 0, 2.5, 0),
                    child: FlutterToggleTab(
                      marginSelected: EdgeInsets.zero,
                      width: scaler.getWidth(21),
                      borderRadius: 30,
                      height: scaler.getHeight(4.0),
                      selectedIndex: provider.tabTextIndexSelected,
                      selectedBackgroundColors: [ColorConstants.primaryColor],
                      selectedTextStyle: TextStyle(
                         fontFamily: StringConstants.spProDisplay,
                          color: Colors.white,
                          fontSize: scaler.getTextSize(10.5),
                          fontWeight: FontWeight.w600),
                      unSelectedTextStyle: TextStyle(
                          fontFamily: StringConstants.spProDisplay,
                          color: Colors.black,
                          fontSize: scaler.getTextSize(10.5),
                          fontWeight: FontWeight.w500),
                      labels: ['all'.tr(), 'events'.tr(), 'publications'.tr()],
                      selectedLabelIndex: (index) {
                        SharedPref.prefs!.setInt(SharedPref.homeToggleIndex, index);
                        SharedPref.prefs!.setInt(SharedPref.homeTabIndex, 0);
                        provider.tabController!.index = 0;
                        provider.tabTextIndexSelected = index;
                        if(index == 0 || index == 1){
                          provider.getIndexChanging(context);
                        } else if(index == 2){
                          provider.getUserEvents(context, selector: [SELECTOR_ANNOUNCEMENT]);
                        }
                          provider.updateLoadingStatus(false);
                      },
                      isScroll: false,
                    ),
                  ),
                ),
                SizedBox(height: scaler.getHeight(1.0)),

                provider.tabTextIndexSelected == 0 ? Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: scaler.getPaddingLTRB(2.0, 0, 0, 0),
                        child: TabBar(
                          labelPadding: scaler.getPadding(0.0, 2.5),
                          indicatorColor: Colors.transparent,
                          controller: widget.provider?.tabController,
                          isScrollable: true,
                          onTap: (index) {
                            if (provider.tabController!.indexIsChanging) {
                              //SharedPref.prefs!.setInt(SharedPref.homeTabIndex, provider.tabController!.index);
                              provider.getIndexChanging(context);
                            }
                            provider.updateValue(true);
                          },
                          tabs: [
                            Tab(
                                child: ClipRRect(
                              borderRadius: scaler.getBorderRadiusCircular(15.0),
                              child: Container(
                                padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
                                color: provider.tabController!.index == 0
                                    ? ColorConstants.primaryColor
                                    : ColorConstants.colorWhitishGray,
                                child: Text('all'.tr()).mediumText(
                                    provider.tabController!.index == 0
                                        ? ColorConstants.colorWhite
                                        : ColorConstants.colorGray,
                                    scaler.getTextSize(11.2),
                                    TextAlign.left),
                              ),
                            )),
                            Tab(
                                child: ClipRRect(
                              borderRadius: scaler.getBorderRadiusCircular(15.0),
                              child: Container(
                                padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
                                color: provider.tabController!.index == 1
                                    ? ColorConstants.primaryColor
                                    : ColorConstants.colorWhitishGray,
                                child: Text('going'.tr()).mediumText(
                                    provider.tabController!.index == 1
                                        ? ColorConstants.colorWhite
                                        : ColorConstants.colorGray,
                                    scaler.getTextSize(11.2),
                                    TextAlign.left),
                              ),
                            )),
                            Tab(
                                child: ClipRRect(
                              borderRadius: scaler.getBorderRadiusCircular(15.0),
                              child: Container(
                                padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
                                color: provider.tabController!.index == 2
                                    ? ColorConstants.primaryColor
                                    : ColorConstants.colorWhitishGray,
                                child: Text('not_going'.tr()).mediumText(
                                    provider.tabController!.index == 2
                                        ? ColorConstants.colorWhite
                                        : ColorConstants.colorGray,
                                    scaler.getTextSize(11.2),
                                    TextAlign.left),
                              ),
                            )),
                            Tab(
                                child: ClipRRect(
                              borderRadius: scaler.getBorderRadiusCircular(15.0),
                              child: Container(
                                padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
                                color: provider.tabController!.index == 3
                                    ? ColorConstants.primaryColor
                                    : ColorConstants.colorWhitishGray,
                                child: Text('not_replied'.tr()).mediumText(
                                    provider.tabController!.index == 3
                                        ? ColorConstants.colorWhite
                                        : ColorConstants.colorGray,
                                    scaler.getTextSize(11.2),
                                    TextAlign.left),
                              ),
                            )),
                            Tab(
                                child: ClipRRect(
                                  borderRadius: scaler.getBorderRadiusCircular(15.0),
                                  child: Container(
                                    padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
                                    color: provider.tabController!.index == 4
                                        ? ColorConstants.primaryColor
                                        : ColorConstants.colorWhitishGray,
                                    child: Text('past'.tr()).mediumText(
                                        provider.tabController!.index == 4
                                            ? ColorConstants.colorWhite
                                            : ColorConstants.colorGray,
                                        scaler.getTextSize(11.2),
                                        TextAlign.left),
                                  ),
                                )),
                            Tab(
                                child: ClipRRect(
                              borderRadius: scaler.getBorderRadiusCircular(15.0),
                              child: Container(
                                padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
                                color: provider.tabController!.index == 5
                                    ? ColorConstants.primaryColor
                                    : ColorConstants.colorWhitishGray,
                                child: Text('hidden'.tr()).mediumText(
                                    provider.tabController!.index == 5
                                        ? ColorConstants.colorWhite
                                        : ColorConstants.colorGray,
                                    scaler.getTextSize(11.2),
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
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
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
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
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
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
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
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
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
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
                                :
                            provider.state == ViewState.Busy
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
                                : RefreshIndicator(
                              onRefresh: refreshListTab5,
                              key: refreshKeyTab5,
                              child: upcomingEventsList(
                                  scaler,
                                  provider.eventLists,
                                  provider,
                                  dashBoardProvider, pastEvent: true),
                            ),
                            provider.state == ViewState.Busy
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
                                : RefreshIndicator(
                              onRefresh: refreshListTab6,
                              key: refreshKeyTab6,
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
                  ),
                ) : (provider.tabTextIndexSelected == 1 ?
                    Expanded(child: Column(
                    children: [
                      Padding(
                        padding: scaler.getPaddingLTRB(2.0, 0, 0, 0),
                        child: TabBar(
                          labelPadding: scaler.getPadding(0.0, 2.5),
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
                                    padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
                                    color: provider.tabController!.index == 0
                                        ? ColorConstants.primaryColor
                                        : ColorConstants.colorWhitishGray,
                                    child: Text('all'.tr()).mediumText(
                                        provider.tabController!.index == 0
                                            ? ColorConstants.colorWhite
                                            : ColorConstants.colorGray,
                                        scaler.getTextSize(11.2),
                                        TextAlign.left),
                                  ),
                                )),
                            Tab(
                                child: ClipRRect(
                                  borderRadius: scaler.getBorderRadiusCircular(15.0),
                                  child: Container(
                                    padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
                                    color: provider.tabController!.index == 1
                                        ? ColorConstants.primaryColor
                                        : ColorConstants.colorWhitishGray,
                                    child: Text('going'.tr()).mediumText(
                                        provider.tabController!.index == 1
                                            ? ColorConstants.colorWhite
                                            : ColorConstants.colorGray,
                                        scaler.getTextSize(11.2),
                                        TextAlign.left),
                                  ),
                                )),
                            Tab(
                                child: ClipRRect(
                                  borderRadius: scaler.getBorderRadiusCircular(15.0),
                                  child: Container(
                                    padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
                                    color: provider.tabController!.index == 2
                                        ? ColorConstants.primaryColor
                                        : ColorConstants.colorWhitishGray,
                                    child: Text('not_going'.tr()).mediumText(
                                        provider.tabController!.index == 2
                                            ? ColorConstants.colorWhite
                                            : ColorConstants.colorGray,
                                        scaler.getTextSize(11.2),
                                        TextAlign.left),
                                  ),
                                )),
                            Tab(
                                child: ClipRRect(
                                  borderRadius: scaler.getBorderRadiusCircular(15.0),
                                  child: Container(
                                    padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
                                    color: provider.tabController!.index == 3
                                        ? ColorConstants.primaryColor
                                        : ColorConstants.colorWhitishGray,
                                    child: Text('not_replied'.tr()).mediumText(
                                        provider.tabController!.index == 3
                                            ? ColorConstants.colorWhite
                                            : ColorConstants.colorGray,
                                        scaler.getTextSize(11.2),
                                        TextAlign.left),
                                  ),
                                )),
                            Tab(
                                child: ClipRRect(
                                  borderRadius: scaler.getBorderRadiusCircular(15.0),
                                  child: Container(
                                    padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
                                    color: provider.tabController!.index == 4
                                        ? ColorConstants.primaryColor
                                        : ColorConstants.colorWhitishGray,
                                    child: Text('past'.tr()).mediumText(
                                        provider.tabController!.index == 4
                                            ? ColorConstants.colorWhite
                                            : ColorConstants.colorGray,
                                        scaler.getTextSize(11.2),
                                        TextAlign.left),
                                  ),
                                )),
                            Tab(
                                child: ClipRRect(
                                  borderRadius: scaler.getBorderRadiusCircular(15.0),
                                  child: Container(
                                    padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
                                    color: provider.tabController!.index == 5
                                        ? ColorConstants.primaryColor
                                        : ColorConstants.colorWhitishGray,
                                    child: Text('hidden'.tr()).mediumText(
                                        provider.tabController!.index == 5
                                            ? ColorConstants.colorWhite
                                            : ColorConstants.colorGray,
                                        scaler.getTextSize(11.2),
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
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
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
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
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
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
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
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
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
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
                                :
                            provider.state == ViewState.Busy
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
                                : RefreshIndicator(
                              onRefresh: refreshListTab5,
                              key: refreshKeyTab5,
                              child: upcomingEventsList(
                                  scaler,
                                  provider.eventLists,
                                  provider,
                                  dashBoardProvider, pastEvent: true),
                            ),
                            provider.state == ViewState.Busy
                                ? CommonWidgets.loading(scaler)
                                : provider.eventLists.length == 0
                                ? CommonWidgets.noEventFoundText(scaler)
                                : RefreshIndicator(
                              onRefresh: refreshListTab6,
                              key: refreshKeyTab6,
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
                  )) : (
                    provider.state == ViewState.Busy
                        ? Expanded(child: CommonWidgets.loading(scaler))
                        : provider.eventLists.length == 0
                        ? Expanded(child: CommonWidgets.noEventFoundText(scaler))
                        : Expanded(
                          child: RefreshIndicator(
                            onRefresh: refreshListTabPublication,
                            key: refreshKeyTabPublication,
                            child: upcomingEventsList(
                            scaler,
                            provider.eventLists,
                            provider,
                            dashBoardProvider),
                          ),
                        )
                )
                ),

              ],
            ),
          ),
        );
      },
    );
  }


  Widget upcomingEventsList(ScreenScaler scaler, List<Event> eventList,
      HomePageProvider provider, DashboardProvider dashboardProvider, {bool pastEvent = false}) {
    return Padding(
      padding: scaler.getPaddingLTRB(6.8, 0.5, 6.8, 0.0),
      child: ListView.builder(
          itemCount: eventList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: scaler.getPaddingLTRB(0.0, 0.0, 0.0, 2.0),
              child: GestureDetector(
                onTap: () {
                  provider.setEventValuesForEdit(eventList[index]);
                  provider.eventDetail.eventBtnStatus =
                  eventList[index].eventType == EVENT_TYPE_PRIVATE
                      ? CommonEventFunction.getEventBtnStatus(
                          eventList[index], provider.userDetail.cid.toString())
                      : (CommonEventFunction.getAnnouncementBtnStatus(eventList[index], provider.auth.currentUser!.uid.toString()) == "attending") ? "hide".tr() : CommonEventFunction.getAnnouncementBtnStatus(
                      eventList[index], provider.userDetail.cid.toString());
                  provider.eventDetail.textColor =
                      (CommonEventFunction.getAnnouncementBtnStatus(eventList[index], provider.auth.currentUser!.uid.toString()) == "attending") ? ColorConstants.colorWhite : CommonEventFunction.getEventBtnColorStatus(
                          eventList[index], provider.userDetail.cid.toString());
                  provider.eventDetail.btnBGColor =
                  (CommonEventFunction.getAnnouncementBtnStatus(eventList[index], provider.auth.currentUser!.uid.toString()) == "attending") ? ColorConstants.primaryColor : CommonEventFunction.getEventBtnColorStatus(
                          eventList[index], provider.userDetail.cid.toString(),
                          textColor: false);
                  provider.eventDetail.eventMapData = eventList[index].invitedContacts;
                  provider.eventDetail.eid = eventList[index].eid;
                  provider.eventDetail.organiserId =
                      eventList[index].organiserID;
                  provider.eventDetail.organiserName =
                      eventList[index].organiserName;
                  provider.calendarDetail.fromAnotherPage = false;
                  // past event
                  provider.eventDetail.isPastEvent = pastEvent;

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
                      dashboardProvider, pastEvent: pastEvent),
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
      DashboardProvider dashboardProvider, {bool pastEvent = false}) {
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
                      height: scaler.getHeight(25),
                      width: double.infinity,
                      color: ColorConstants.primaryColor,
                    )
                  : ImageView(
                      path: eventList[index].photoURL,
                      fit: BoxFit.cover,
                      height: scaler.getHeight(25),
                      width: double.infinity,
                    ),
            ),
           provider.userDetail.cid == eventList[index].organiserID && CommonEventFunction.getEventBtnStatus(
               eventList[index], provider.userDetail.cid.toString()) ==
               "edit" ? Positioned(
               top: scaler.getHeight(1),
               left: scaler.getHeight(1.5),
               child: Container(
                 width: scaler.getWidth(80),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     dateCard(scaler, eventList[index]),
                    pastEvent == true ? Container() : (eventList[index].eventType == EVENT_TYPE_PRIVATE ? shareCard(scaler, eventList[index]) : Container())
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
                          scaler.getTextSize(11.5),
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
                                  scaler.getTextSize(9.0), TextAlign.left,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                    SizedBox(height: scaler.getHeight(0.2)),
                    (eventList[index].location == "" || eventList[index].location == null) ? SizedBox(height: scaler.getHeight(0.5))
                     : Row(
                      children: [
                        Icon(Icons.map, size: 17),
                        SizedBox(width: scaler.getWidth(1)),
                        Container(
                          width: scaler.getWidth(38),
                          child: Text(eventList[index].location).regularText(
                              ColorConstants.colorGray,
                              scaler.getTextSize(9.0),
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
              pastEvent == false ? (eventList[index].eventType == EVENT_TYPE_PRIVATE ? eventRespondBtn(scaler, eventList[index], provider, dashboardProvider, index)
               : ((eventList[index].form.isNotEmpty && eventList[index].organiserID != provider.auth.currentUser!.uid.toString() &&
                  (CommonEventFunction.getAnnouncementBtnStatus(eventList[index], provider.auth.currentUser!.uid.toString(), checkForAns: true) == "ans")) ?  Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  announcementRespondBtn(scaler, eventList[index], provider, dashboardProvider, index, 15.0),
                  SizedBox(width: scaler.getWidth(2.0)),
                  announcementAnswersRespondBtn(scaler, eventList[index], provider, dashboardProvider, index, 15.0)
                ],
              )
                  : announcementRespondBtn(scaler, eventList[index], provider, dashboardProvider, index, 24.0)))
               : pastEventRespondBtn(scaler, eventList[index], provider, dashboardProvider, index, pastEvent)
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
                scaler.getTextSize(10),
                TextAlign.center),
            Text(event.start.day <= 9
                    ? "0" + event.start.day.toString()
                    : event.start.day.toString())
                .boldText(ColorConstants.colorBlack, scaler.getTextSize(12.2),
                    TextAlign.center)
          ],
        ),
        bgColor: ColorConstants.colorWhite,
        radius: scaler.getBorderRadiusCircular(8),
        width: scaler.getWidth(11.2),
        height: scaler.getHeight(5),
      ),
    );
  }

  Widget shareCard(ScreenScaler scaler, Event event){
    return GestureDetector(
      onTap: () async{
       //  String eventLink = provider.mmyEngine!.getEventLink(event.eid);
       //  await provider.dynamicLinksApi.createLink(context, eventLink).then((value) {
       //    String shareLink = provider.dynamicLinksApi.dynamicUrl.toString();
       //    String fid = shareLink.split("https://meetmeyou.page.link/")[1];
       // //   Share.share("Please find link to the event I’m organising: https://meetmeyou.com/event?eid=${event.eid}&fid=${fid}");
       //   // Share.share("Please find link to the event I’m organising: ${shareLink}");
       //    Share.share("Please find link to the event I’m organising: https://meetmeyou.com/event?eid=${event.eid}");
       //  });
        Share.share("Please find link to the event I’m organising: https://meetmeyou.com/event?eid=${event.eid}");
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

  List<String> questionnaireKeysList = [];
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
            provider.calendarDetail.fromAnotherPage = false;
            Navigator.pushNamed(
                context, RoutesConstants.eventDetailScreen)
                .then((value) async {
              if(provider.tabTextIndexSelected == 0 || provider.tabTextIndexSelected == 1){
                provider.tabController!.index = SharedPref.prefs!.getInt(SharedPref.homeTabIndex) ?? 0;
                await provider.getIndexChanging(context);
              } else{
                await provider.getUserEvents(context, selector: [SELECTOR_ANNOUNCEMENT]);
              }
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
              for (var key in event.form.keys) {
                questionnaireKeysList.add(key);
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
        } else if (CommonEventFunction.getEventBtnStatus(event, provider.userDetail.cid.toString()) == "edit") {
            provider.setEventValuesForEdit(event);
            provider.clearMultiDateOption();
            Navigator.pushNamed(context, RoutesConstants.createEventScreen)
                .then((value) async {
              if(provider.tabTextIndexSelected == 0 || provider.tabTextIndexSelected == 1){
                provider.tabController!.index = SharedPref.prefs!.getInt(SharedPref.homeTabIndex) ?? 0;
                await provider.getIndexChanging(context);
              } else{
                await provider.getUserEvents(context, selector: [SELECTOR_ANNOUNCEMENT]);
              }
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
                        scaler.getTextSize(10.5),
                        TextAlign.center)),
        bgColor: CommonEventFunction.getEventBtnColorStatus(
            event, provider.userDetail.cid.toString(),
            textColor: false),
        radius: BorderRadius.all(
          Radius.circular(12),
        ),
        width: scaler.getWidth(24),
        height: scaler.getHeight(4.5),
      ),
    );
  }

  Widget pastEventRespondBtn(
      ScreenScaler scaler,
      Event event,
      HomePageProvider provider,
      DashboardProvider dashboardProvider,
      int index, bool pastEvent) {
    return GestureDetector(
      onTap: () {
       // if (provider.auth.currentUser!.uid == event.organiserID) {
       //      provider.eventDetail.isPastEvent = pastEvent;
       //      provider.setEventValuesForEdit(event);
       //      provider.eventDetail.eventMapData =
       //          event.invitedContacts;
       //      provider.eventDetail.eid = event.eid;
       //      provider.eventDetail.organiserId =
       //          event.organiserID;
       //      provider.eventDetail.organiserName =
       //          event.organiserName;
       //      provider.calendarDetail.fromAnotherPage = false;
       //      Navigator.pushNamed(
       //          context, RoutesConstants.eventDetailScreen)
       //          .then((value) {
       //        provider.getPastEvents(context);
       //      });
       //  } else {
       //    CommonWidgets.respondToEventBottomSheet(context, scaler, hide: (){
       //      Navigator.of(context).pop();
       //      dashboardProvider.updateEventNotificationCount();
       //      provider.replyToEvent(context, event.eid, EVENT_NOT_INTERESTED);
       //    }, pastEventOrAnnouncement: pastEvent);
       //  }
        CommonWidgets.respondToEventBottomSheet(context, scaler, hide: (){
          Navigator.of(context).pop();
          provider.replyToEvent(context, event.eid, EVENT_NOT_INTERESTED);
        }, pastEventOrAnnouncement: pastEvent);
      },
      child: CustomShape(
        child: Center(
            child: provider.getMultipleDate[index] == true
                ? Container(
                height: scaler.getHeight(1.5),
                width: scaler.getWidth(3.0),
                child: CircularProgressIndicator(
                    color: ColorConstants.colorWhite))
                : Text("hide".tr())
                .semiBoldText(
                ColorConstants.colorWhite,
                scaler.getTextSize(10.5),
                TextAlign.center)),
        bgColor: ColorConstants.primaryColor,
        radius: BorderRadius.all(
          Radius.circular(12),
        ),
        width: scaler.getWidth(24),
        height: scaler.getHeight(4.5),
      ),
    );
  }

  Widget announcementRespondBtn(
      ScreenScaler scaler,
      Event event,
      HomePageProvider provider,
      DashboardProvider dashboardProvider,
      int index, double width) {
    return GestureDetector(
      onTap: () {
        if (CommonEventFunction.getAnnouncementBtnStatus(event, provider.userDetail.cid.toString()) == "edit"){
          if (provider.auth.currentUser!.uid == event.organiserID) {
            provider.setEventValuesForAnnouncementEdit(event);
            Navigator.pushNamed(
                context, RoutesConstants.createAnnouncementScreen)
                .then((value) {
              provider.getIndexChanging(context);
            });
          }
        } else if (CommonEventFunction.getAnnouncementBtnStatus(event, provider.userDetail.cid.toString()) == "cancelled"){
          if (provider.userDetail.cid == event.organiserID) {
            CommonWidgets.eventCancelBottomSheet(context, scaler, delete: () {
              Navigator.of(context).pop();
              provider.deleteEvent(context, event.eid);
            });
          } else {
            Container();
          }
        }
        else {
          CommonWidgets.respondToEventBottomSheet(context, scaler, hide: (){
            Navigator.of(context).pop();
            provider.replyToEvent(context, event.eid, EVENT_NOT_INTERESTED);
          }, pastEventOrAnnouncement : true);
        }
      },
      child: CustomShape(
        child: Center(
            child: Text((CommonEventFunction.getAnnouncementBtnStatus(event, provider.auth.currentUser!.uid.toString()) == "attending") ? "hide".tr() : CommonEventFunction.getAnnouncementBtnStatus(
                event, provider.userDetail.cid.toString())
                .toString()
                .tr())
                .semiBoldText(
               (CommonEventFunction.getAnnouncementBtnStatus(event, provider.auth.currentUser!.uid.toString()) == "attending") ? ColorConstants.colorWhite : CommonEventFunction.getEventBtnColorStatus(
                    event, provider.userDetail.cid.toString()),
                scaler.getTextSize(10.5),
                TextAlign.center)),
        bgColor: (CommonEventFunction.getAnnouncementBtnStatus(
            event, provider.auth.currentUser!.uid.toString()) == "attending") ? ColorConstants.primaryColor : CommonEventFunction.getEventBtnColorStatus(
            event, provider.userDetail.cid.toString(),
            textColor: false),
        radius: BorderRadius.all(
          Radius.circular(12),
        ),
        width: scaler.getWidth(width),
        height: scaler.getHeight(4.5),
      ),
    );
  }

  Widget announcementAnswersRespondBtn(
      ScreenScaler scaler,
      Event event,
      HomePageProvider provider,
      DashboardProvider dashboardProvider,
      int index, double width) {
    return GestureDetector(
      onTap: () {
          List<String> questionsList = [];
          for (var value in event.form.values) {
            questionsList.add(value);
          }
          for (var key in event.form.keys) {
            questionnaireKeysList.add(key);
          }

          alertForQuestionnaireAnswers(context, scaler, event,
              questionsList, provider, dashboardProvider);

      },
      child: CustomShape(
        child: Center(
            child: Text("answer".tr())
                .semiBoldText(
                CommonEventFunction.getEventBtnColorStatus(
                    event, provider.userDetail.cid.toString()),
                scaler.getTextSize(10.5),
                TextAlign.center)),
        bgColor: CommonEventFunction.getEventBtnColorStatus(
            event, provider.userDetail.cid.toString(),
            textColor: false),
        radius: BorderRadius.all(
          Radius.circular(12),
        ),
        width: scaler.getWidth(width),
        height: scaler.getHeight(4.5),
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
                    .boldText(ColorConstants.colorBlack, 15.0, TextAlign.left),
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
                                  .mediumText(ColorConstants.colorBlack, 13,
                                      TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                              SizedBox(height: scaler.getHeight(0.2)),
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: answerController(index),
                                style: ViewDecoration.textFieldStyle(
                                    scaler.getTextSize(10.5),
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
                                // "1. text": answer1Controller.text,
                                // "2. text": answer2Controller.text,
                                // "3. text": answer3Controller.text,
                                // "4. text": answer4Controller.text,
                                // "5. text": answer5Controller.text
                              };
                              for(int i = 0; i < questionnaireKeysList.length; i++){
                                if(i == 0){
                                  answersMap.addAll({
                                    questionnaireKeysList[i]: answer1Controller.text
                                  });
                                } else if(i == 1){
                                  answersMap.addAll({
                                    questionnaireKeysList[i]: answer2Controller.text
                                  });
                                } else if(i == 2){
                                  answersMap.addAll({
                                    questionnaireKeysList[i]: answer3Controller.text
                                  });
                                } else if(i == 3){
                                  answersMap.addAll({
                                    questionnaireKeysList[i]: answer4Controller.text
                                  });
                                } else if(i == 4){
                                  answersMap.addAll({
                                    questionnaireKeysList[i]: answer5Controller.text
                                  });
                                }
                              }
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
                                  13,
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
