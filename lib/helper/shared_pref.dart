import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const INTRODUCTION_COMPLETE = "introductionComplete";
  static const IS_USER_LOGIN = "userLogin";
  static const contactScreenFirstTime = "contactScreenFirstTime";
  static const homeToggleIndex = "homeToggleIndex";
  static const homeTabIndex = "homeTabIndex";

  static SharedPreferences? prefs;


  static clearSharePref() async {
   prefs!.setBool(IS_USER_LOGIN, false);
   prefs!.setInt(homeToggleIndex, 0);
   prefs!.setInt(homeTabIndex, 0);
  }
}
