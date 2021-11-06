import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const INTRODUCTION_COMPLETE = "introductionComplete";
  static const IS_USER_LOGIN = "userLogin";

  static SharedPreferences? prefs;



  /*static clearSharePref() async {
    prefs.clear();
  }*/
}
