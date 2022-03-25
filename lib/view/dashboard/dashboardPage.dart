import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/models/push_notification.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/view/add_event/addEventScreen.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/calendar/calendarPage.dart';
import 'package:meetmeyou_app/view/contacts/contactsScreen.dart';
import 'package:meetmeyou_app/view/home/homePage.dart';
import 'package:meetmeyou_app/view/settings/settingsPage.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:overlay_support/overlay_support.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key, required this.isFromLogin}) : super(key: key);
  bool isFromLogin;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CalendarPage(),
    AddEventScreen(),
    ContactsScreen(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return BaseView<DashboardProvider>(
      onModelReady: (provider) {
        //  if(widget.isFromLogin == null){
        provider.dynamicLinksApi.handleDynamicLink(context);
        //  }
        provider.onItemTapped(0);
        provider.unRespondedInvites(context);
        provider.unRespondedEvents(context);

        // For handling notification when the app is in foreground
        provider.registerNotification(context, scaler);

        // For handling notification when the app is in background
        // but not terminated
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          PushNotification notification = PushNotification(
            title: message.notification?.title,
            body: message.notification?.body,
          );

          provider.notificationInfo = notification;
          provider.updateNotify(true);

          if (provider.notificationInfo != null) {
            // For displaying the notification as an overlay
            showSimpleNotification(
                Text(provider.notificationInfo!.title!).boldText(
                    ColorConstants.colorBlack,
                    scaler.getTextSize(10.5),
                    TextAlign.left),
                leading: ImageView(path: ImageConstants.small_logo_icon),
                subtitle: Text(provider.notificationInfo!.body!).regularText(
                    ColorConstants.colorBlack,
                    scaler.getTextSize(10.0),
                    TextAlign.left),
                background: ColorConstants.colorWhite,
                duration: Duration(seconds: 3),
                position: NotificationPosition.bottom);
          } else {
            print("User declined or has not accepted permission");
          }
        });

        // For handling notification when the app is in terminated state
        provider.checkForInitialMessage();
      },
      builder: (context, provider, _) {
        return Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(provider.selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: provider.unRespondedEvent <= 0
                    ? ImageView(
                        path: ImageConstants.home_icon,
                      )
                    : Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topRight,
                        children: [
                          ImageView(
                            path: ImageConstants.home_icon,
                          ),
                          CommonWidgets.notificationBadge(
                              scaler, provider.unRespondedEvent)
                        ],
                      ),
                activeIcon: provider.unRespondedEvent <= 0
                    ? ImageView(
                        path: ImageConstants.home_icon_green,
                      )
                    : Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topRight,
                        children: [
                          ImageView(
                            path: ImageConstants.home_icon_green,
                          ),
                          CommonWidgets.notificationBadge(
                              scaler, provider.unRespondedEvent)
                        ],
                      ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: ImageView(path: ImageConstants.calendar_icon),
                activeIcon: ImageView(
                  path: ImageConstants.calendar_icon_green,
                ),
                label: 'Calender',
              ),
              BottomNavigationBarItem(
                icon: ImageView(path: ImageConstants.add_icon),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: provider.unRespondedInvite <= 0
                    ? ImageView(
                        path: ImageConstants.contacts_icon,
                      )
                    : Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topRight,
                        children: [
                          ImageView(
                            path: ImageConstants.contacts_icon,
                          ),
                          CommonWidgets.notificationBadge(
                              scaler, provider.unRespondedInvite)
                        ],
                      ),
                activeIcon: provider.unRespondedInvite <= 0
                    ? ImageView(
                        path: ImageConstants.contacts_icon_green,
                      )
                    : Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topRight,
                        children: [
                          ImageView(
                            path: ImageConstants.contacts_icon_green,
                          ),
                          CommonWidgets.notificationBadge(
                              scaler, provider.unRespondedInvite)
                        ],
                      ),
                label: 'Invite Friends',
              ),
              BottomNavigationBarItem(
                icon: ImageView(path: ImageConstants.settings_icon),
                activeIcon: ImageView(
                  path: ImageConstants.settings_icon_green,
                ),
                label: 'Settings',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            backgroundColor: ColorConstants.colorWhite,
            currentIndex: provider.selectedIndex,
            selectedItemColor: ColorConstants.primaryColor,
            unselectedItemColor: ColorConstants.colorGray,
            iconSize: 25,
            onTap: provider.onItemTapped,
            elevation: 5,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        );
      },
    );
  }
}
