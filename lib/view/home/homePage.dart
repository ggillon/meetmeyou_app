import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/shared_pref.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';

class HomePage extends StatelessWidget {
  AuthBase auth = locator<AuthBase>();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
        body: Container(
            child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Home Page").semiBoldText(ColorConstants.colorBlack,
              scaler.getTextSize(10), TextAlign.center),
          SizedBox(
            height: scaler.getHeight(3),
          ),
          GestureDetector(
            onTap: () {
              auth.signOut();
              SharedPref.clearSharePref();
              //SharedPref.prefs?.setBool(SharedPref.IS_USER_LOGIN, false);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutesConstants.loginOptions, (route) => false);
            },
            child: Text("Sign Out").semiBoldText(ColorConstants.primaryColor,
                scaler.getTextSize(14), TextAlign.center),
          ),
        ],
      ),
    )));
  }
}
