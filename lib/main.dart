//@dart=2.11
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'helper/shared_pref.dart';
import 'test.dart';
import 'router.dart' as router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  SharedPref.prefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  test();
  runApp(EasyLocalization(
    supportedLocales: [
      Locale('en'),
    ],
    path: 'langs',
    fallbackLocale: Locale('en'),
    child: new MyApp(),
  ));
  setupLocator();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (_) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MeetMeYou',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: EasyLocalization.of(context).supportedLocales,
        locale: EasyLocalization.of(context).locale,
        theme: ThemeData(
          primarySwatch: color,
        ),
        onGenerateRoute: router.Router.generateRoute,
        initialRoute:
            SharedPref.prefs.getBool(SharedPref.INTRODUCTION_COMPLETE) == null
                ? RoutesConstants.introductionPage
                : SharedPref.prefs.getBool(SharedPref.IS_USER_LOGIN) == null ||
                        SharedPref.prefs.getBool(SharedPref.IS_USER_LOGIN) ==
                            false
                    ? RoutesConstants.loginOptions
                    : RoutesConstants.dashboardPage,
      ),
    );
  }


  MaterialColor color = const MaterialColor(0xFF00B9A7, <int, Color>{
    50: Color(0xFF00B9A7),
    100: Color(0xFF00B9A7),
    200: Color(0xFF00B9A7),
    300: Color(0xFF00B9A7),
    400: Color(0xFF00B9A7),
    500: Color(0xFF00B9A7),
    600: Color(0xFF00B9A7),
    700: Color(0xFF00B9A7),
    800: Color(0xFF00B9A7),
    900: Color(0xFF00B9A7),
  });
}
