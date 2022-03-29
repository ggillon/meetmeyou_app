import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/models/contactInvitationNotificationEvent.dart';
import 'package:meetmeyou_app/models/messageNotificationEvent.dart';
import 'package:meetmeyou_app/models/push_notification.dart';
import 'package:meetmeyou_app/models/userEventsNotificationEvent.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/view/add_event/addEventScreen.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/calendar/calendarPage.dart';
import 'package:meetmeyou_app/view/contacts/contact_description/contactDescriptionScreen.dart';
import 'package:meetmeyou_app/view/contacts/contactsScreen.dart';
import 'package:meetmeyou_app/view/home/event_discussion_screen/new_event_discussion_screen.dart';
import 'package:meetmeyou_app/view/home/homePage.dart';
import 'package:meetmeyou_app/view/settings/settingsPage.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:overlay_support/overlay_support.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key, this.isFromLogin, this.eventOrChatId}) : super(key: key);
  bool? isFromLogin;
  String? eventOrChatId;

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

        provider.firebaseNotification.configureFireBase(context);


        provider.eventsNotifyEvent = provider.eventBus.on<UserEventsNotificationEvent>().listen((event) {
          if(provider.selectedIndex != 0){
            if(event.eventId != null){
              provider.calendarDetail.fromAnotherPage = true;
              provider.eventDetail.eid = event.eventId;
              Navigator.pushNamed(context, RoutesConstants.eventDetailScreen);
            }}
          });

       provider.messageNotifyEvent =  provider.eventBus.on<MessageNotificationEvent>().listen((event) {
            if(event.chatId != null){
              print("Message notification ~~~~~~~~~~~~~~~~~~~~~~~~${event.chatId}");
              Navigator.pushNamed(context, RoutesConstants.newEventDiscussionScreen,
                  arguments: NewEventDiscussionScreen(fromContactOrGroup: false, fromChatScreen: true, chatDid: event.chatId));
            }
        });

        provider.messageNotifyEvent =  provider.eventBus.on<ContactInvitationNotificationEvent>().listen((event) {
          if(event.contactId != null){
            Navigator.pushNamed(context, RoutesConstants.contactDescription, arguments: ContactDescriptionScreen(showEventScreen: false, isFromNotification: true, contactId: event.contactId));
          }
        });
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
