import 'dart:io';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/photo.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/view/add_event/create_announcement_screen/create_announcement_screen.dart';
import 'package:meetmeyou_app/view/add_event/create_event_screen/createEventScreen.dart';
import 'package:meetmeyou_app/view/add_event/default_photo_page/defaultPhotoPage.dart';
import 'package:meetmeyou_app/view/add_event/event_attending_screen/eventAttendingScreen.dart';
import 'package:meetmeyou_app/view/add_event/event_invite_friends_screen/eventInviteFriendsScreen.dart';
import 'package:meetmeyou_app/view/add_event/multiple_date_time_screen/multipleDateTimeScreen.dart';
import 'package:meetmeyou_app/view/add_event/public_location_create_event/public_location_create_event_screen.dart';
import 'package:meetmeyou_app/view/calendar/calendarPage.dart';
import 'package:meetmeyou_app/view/calendar/choose_event_screen/chooseEventScreen.dart';
import 'package:meetmeyou_app/view/contacts/contactsScreen.dart';
import 'package:meetmeyou_app/view/contacts/group_contacts/groupContactsScreen.dart';
import 'package:meetmeyou_app/view/contacts/contact_description/contactDescriptionScreen.dart';
import 'package:meetmeyou_app/view/contacts/create_edit_group/createEditGroupScreen.dart';
import 'package:meetmeyou_app/view/contacts/editContactScreen.dart';
import 'package:meetmeyou_app/view/contacts/group_description/GroupDescriptionScreen.dart';
import 'package:meetmeyou_app/view/contacts/search_profile/searchProfileScreen.dart';
import 'package:meetmeyou_app/view/dashboard/dashboardPage.dart';
import 'package:meetmeyou_app/view/edit_profile/editProfileScreen.dart';
import 'package:meetmeyou_app/view/home/chats_screen/chats_screen.dart';
import 'package:meetmeyou_app/view/home/check_attendance_screen/check_attendance_screen.dart';
import 'package:meetmeyou_app/view/home/eventDetailScreen.dart';
import 'package:meetmeyou_app/view/home/event_discussion_screen/eventDiscussionScreen.dart';
import 'package:meetmeyou_app/view/home/event_discussion_screen/new_event_discussion_screen.dart';
import 'package:meetmeyou_app/view/home/event_gallery_page/event_gallery_page.dart';
import 'package:meetmeyou_app/view/home/event_gallery_view_image/event_gallery_view_image.dart';
import 'package:meetmeyou_app/view/home/group_image_view/group_image_view.dart';
import 'package:meetmeyou_app/view/home/homePage.dart';
import 'package:meetmeyou_app/view/home/notifications_history_screen/notifications_history_screen.dart';
import 'package:meetmeyou_app/view/home/public_home_page/public_home_page.dart';
import 'package:meetmeyou_app/view/home/see_all_events/see_all_events.dart';
import 'package:meetmeyou_app/view/home/see_all_people/see_all_people.dart';
import 'package:meetmeyou_app/view/home/view_image_screen/view_image_screen.dart';
import 'package:meetmeyou_app/view/home/view_replies_to_form_screen/view_replies_to_form_screen.dart';
import 'package:meetmeyou_app/view/introduction/introduction_page.dart';
import 'package:meetmeyou_app/view/landing_page.dart';
import 'package:meetmeyou_app/view/login/loginPage.dart';
import 'package:meetmeyou_app/view/login_options/loginOptionsPage.dart';
import 'package:meetmeyou_app/view/my_account/myAccountScreen.dart';
import 'package:meetmeyou_app/view/settings/about/aboutPage.dart';
import 'package:meetmeyou_app/view/settings/calendar_settings/calendarSettingsScreen.dart';
import 'package:meetmeyou_app/view/settings/history/historyScreen.dart';
import 'package:meetmeyou_app/view/settings/invite_friends/inviteFriendsScreen.dart';
import 'package:meetmeyou_app/view/settings/notifcation_settings/notification_settings.dart';
import 'package:meetmeyou_app/view/settings/privacy_policy_and_terms/privacyPolicyAndTerms.dart';
import 'package:meetmeyou_app/view/settings/rejected_invites/rejectedInvitesScreen.dart';
import 'package:meetmeyou_app/view/settings/rejected_invites_description/rejectedInvitesDescriptionScreen.dart';
import 'package:meetmeyou_app/view/signup/signupPage.dart';
import 'package:meetmeyou_app/view/verify_screen/verifyScreen.dart';
import 'package:meetmeyou_app/widgets/image_cropper.dart';

import 'widgets/autoCompletePlaces.dart';
import 'constants/routes_constants.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConstants.landingPage:
        return MaterialPageRoute(
            builder: (_) => LandingPage(), settings: settings);

      case RoutesConstants.introductionPage:
        return MaterialPageRoute(
            builder: (_) => IntroductionPage(), settings: settings);

      case RoutesConstants.loginOptions:
        return MaterialPageRoute(
            builder: (_) => LoginOptions(), settings: settings);

      case RoutesConstants.login:
        return MaterialPageRoute(
            builder: (_) => LoginPage(), settings: settings);

      case RoutesConstants.verifyPage:
        return MaterialPageRoute(
            builder: (_) => VerifyScreen(
                  userDetail: settings.arguments as UserDetail,
                ),
            settings: settings);

      case RoutesConstants.autoComplete:
        return MaterialPageRoute(
            builder: (_) => CustomSearchScaffold(), settings: settings);

      case RoutesConstants.signUpPage:
        String value = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => SignUpPage(
                  signUpType: value,
                ),
            settings: settings);

      case RoutesConstants.dashboardPage:
        final args = settings.arguments as DashboardPage;
        return MaterialPageRoute(builder: (_) => DashboardPage(isFromLogin: null), settings: settings);

      case RoutesConstants.myAccountScreen:
        return MaterialPageRoute(
            builder: (_) => MyAccountScreen(), settings: settings);

      case RoutesConstants.editProfileScreen:
        return MaterialPageRoute(
            builder: (_) => EditProfileScreen(), settings: settings);

      case RoutesConstants.aboutPage:
        return MaterialPageRoute(
            builder: (_) => AboutPage(), settings: settings);

      case RoutesConstants.privacyPolicyAndTermsPage:
        return MaterialPageRoute(
            builder: (_) => PrivacyPolicyAndTermsPage(
                privacyPolicy: settings.arguments as bool),
            settings: settings);

      case RoutesConstants.inviteFriendsScreen:
        return MaterialPageRoute(
            builder: (_) => InviteFriendsScreen(), settings: settings);

      case RoutesConstants.historyScreen:
        return MaterialPageRoute(
            builder: (_) => HistoryScreen(), settings: settings);

      case RoutesConstants.calendarSettingsScreen:
        return MaterialPageRoute(
            builder: (_) => CalendarSettingsScreen(), settings: settings);

      case RoutesConstants.contactDescription:
        final args = settings.arguments as ContactDescriptionScreen;
        return MaterialPageRoute(
            builder: (_) => ContactDescriptionScreen(showEventScreen: args.showEventScreen, isFromNotification: args.isFromNotification, contactId: args.contactId),
            settings: settings);

      case RoutesConstants.editContactScreen:
        return MaterialPageRoute(
            builder: (_) => EditContactScreen(), settings: settings);

      case RoutesConstants.rejectedInvitesScreen:
        return MaterialPageRoute(
            builder: (_) => RejectedInvitesScreen(), settings: settings);

      case RoutesConstants.searchProfileScreen:
        return MaterialPageRoute(
            builder: (_) => SearchProfileScreen(), settings: settings);

      case RoutesConstants.rejectedInvitesDescriptionScreen:
        return MaterialPageRoute(
            builder: (_) => RejectedInvitesDescriptionScreen(), settings: settings);

      case RoutesConstants.groupDescriptionScreen:
        return MaterialPageRoute(
            builder: (_) => GroupDescriptionScreen(), settings: settings);

      case RoutesConstants.createEditGroupScreen:
        return MaterialPageRoute(
            builder: (_) => CreateEditGroupScreen(), settings: settings);

      case RoutesConstants.groupContactsScreen:
        return MaterialPageRoute(builder: (_) => GroupContactsScreen(), settings: settings);

      case RoutesConstants.createEventScreen:
        return MaterialPageRoute(builder: (_) => CreateEventScreen(), settings: settings);

      case RoutesConstants.defaultPhotoPage:
        return MaterialPageRoute(builder: (_) => DefaultPhotoPage(), settings: settings);

      case RoutesConstants.eventInviteFriendsScreen:
        final argument = settings.arguments as EventInviteFriendsScreen;
        return MaterialPageRoute(builder: (_) => EventInviteFriendsScreen(fromDiscussion: argument.fromDiscussion , discussionId: argument.discussionId ?? "", fromChatDiscussion: argument.fromChatDiscussion,), settings: settings);

      case RoutesConstants.eventDetailScreen:
        return MaterialPageRoute(builder: (_) => EventDetailScreen(), settings: settings);

      case RoutesConstants.eventAttendingScreen:
        return MaterialPageRoute(builder: (_) => EventAttendingScreen(), settings: settings);

      case RoutesConstants.chooseEventScreen:
        return MaterialPageRoute(builder: (_) => ChooseEventScreen(), settings: settings);

      case RoutesConstants.calendarScreen:
        return MaterialPageRoute(builder: (_) => CalendarPage(), settings: settings);

      case RoutesConstants.eventDiscussionScreen:
        return MaterialPageRoute(builder: (_) => EventDiscussionScreen(), settings: settings);

      case RoutesConstants.newEventDiscussionScreen:
        final argument = settings.arguments as NewEventDiscussionScreen;
        return MaterialPageRoute(builder: (_) => NewEventDiscussionScreen(fromContactOrGroup: argument.fromContactOrGroup , fromChatScreen:  argument.fromChatScreen, chatDid: argument.chatDid,), settings: settings);

      case RoutesConstants.multipleDateTimeScreen:
        return MaterialPageRoute(builder: (_) => MultipleDateTmeScreen(), settings: settings);

      case RoutesConstants.chatsScreen:
        return MaterialPageRoute(builder: (_) => ChatsScreen(), settings: settings);

      case RoutesConstants.viewImageScreen:
        return MaterialPageRoute(builder: (_) => ViewImageScreen(viewImageData: settings.arguments as ViewImageData), settings: settings);

      case RoutesConstants.groupImageView:
        return MaterialPageRoute(builder: (_) => GroupImageView(groupImageData: settings.arguments as GroupImageData,), settings: settings);

      case RoutesConstants.seeAllPeople:
        return MaterialPageRoute(builder: (_) => SeeAllPeople(contactsList: settings.arguments as List<Contact>), settings: settings);

      case RoutesConstants.seeAllEvents:
        final args = settings.arguments as SeeAllEvents;
        return MaterialPageRoute(builder: (_) => SeeAllEvents(query: args.query, eventLists: args.eventLists,), settings: settings);

      case RoutesConstants.notificationSettings:
        return MaterialPageRoute(builder: (_) => NotificationSettings(), settings: settings);

      case RoutesConstants.notificationsHistoryScreen:
        return MaterialPageRoute(builder: (_) => NotificationsHistoryScreen(), settings: settings);

      case RoutesConstants.publicLocationCreateEventScreen:
        return MaterialPageRoute(builder: (_) => PublicLocationCreateEventScreen(), settings: settings);

      case RoutesConstants.checkAttendanceScreen:
        return MaterialPageRoute(builder: (_) => CheckAttendanceScreen(), settings: settings);

      case RoutesConstants.imageCropper:
        return MaterialPageRoute(builder: (_) => ImageCrop(image: settings.arguments as File), settings: settings);

      case RoutesConstants.eventGalleryPage:
        return MaterialPageRoute(builder: (_) => EventGalleryPage(), settings: settings);

      case RoutesConstants.eventGalleryImageView:
        return MaterialPageRoute(builder: (_) => EventGalleryImageView(mmyPhoto: settings.arguments as MMYPhoto), settings: settings);

      case RoutesConstants.createAnnouncementScreen:
        return MaterialPageRoute(builder: (_) => CreateAnnouncementScreen(), settings: settings);

      case RoutesConstants.viewRepliesToFormScreen:
        return MaterialPageRoute(builder: (_) => ViewRepliesToFormScreen(), settings: settings);

      default:
        //return MaterialPageRoute(builder: (_) =>  Testing());
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
