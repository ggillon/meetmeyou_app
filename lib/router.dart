import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meetmeyou_app/view/introduction/introduction_page.dart';
import 'package:meetmeyou_app/view/landing_page.dart';
import 'package:meetmeyou_app/view/login/loginPage.dart';
import 'package:meetmeyou_app/view/login_options/loginOptionsPage.dart';
import 'package:meetmeyou_app/view/signup/signupPage.dart';
import 'package:meetmeyou_app/view/verify_screen/verifyScreen.dart';

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
            builder: (_) => VerifyScreen(), settings: settings);

      case RoutesConstants.signUpPage:
        return MaterialPageRoute(
            builder: (_) => SignUpPage(), settings: settings);


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
