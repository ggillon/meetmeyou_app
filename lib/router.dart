import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/view/about/aboutPage.dart';
import 'package:meetmeyou_app/view/calendar_settings/calendarSettingsScreen.dart';
import 'package:meetmeyou_app/view/contacts/group_contacts/groupContactsScreen.dart';
import 'package:meetmeyou_app/view/contacts/contact_description/contactDescriptionScreen.dart';
import 'package:meetmeyou_app/view/contacts/create_edit_group/createEditGroupScreen.dart';
import 'package:meetmeyou_app/view/contacts/editContactScreen.dart';
import 'package:meetmeyou_app/view/contacts/group_description/GroupDescriptionScreen.dart';
import 'package:meetmeyou_app/view/contacts/search_profile/searchProfileScreen.dart';
import 'package:meetmeyou_app/view/dashboard/dashboardPage.dart';
import 'package:meetmeyou_app/view/edit_profile/editProfileScreen.dart';
import 'package:meetmeyou_app/view/history/historyScreen.dart';
import 'package:meetmeyou_app/view/home/homePage.dart';
import 'package:meetmeyou_app/view/introduction/introduction_page.dart';
import 'package:meetmeyou_app/view/invite_friends/inviteFriendsScreen.dart';
import 'package:meetmeyou_app/view/landing_page.dart';
import 'package:meetmeyou_app/view/login/loginPage.dart';
import 'package:meetmeyou_app/view/login_options/loginOptionsPage.dart';
import 'package:meetmeyou_app/view/my_account/myAccountScreen.dart';
import 'package:meetmeyou_app/view/privacy_policy_and_terms/privacyPolicyAndTerms.dart';
import 'package:meetmeyou_app/view/settings/rejected_invites/rejectedInvitesScreen.dart';
import 'package:meetmeyou_app/view/settings/rejected_invites_description/rejectedInvitesDescriptionScreen.dart';
import 'package:meetmeyou_app/view/signup/signupPage.dart';
import 'package:meetmeyou_app/view/verify_screen/verifyScreen.dart';

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
        return MaterialPageRoute(
            builder: (_) => DashboardPage(), settings: settings);

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
        return MaterialPageRoute(
            builder: (_) => ContactDescriptionScreen(),
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
