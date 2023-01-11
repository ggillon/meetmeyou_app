import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateTimeHelper {
  static String? formattedDate;
  static String? formattedTime;

  static List<String> MONTHS = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  static dateConversion(DateTime now, {bool date = true}) {
    int day = now.day;
    int month = now.month;
    int year = now.year;
    String mon = MONTHS[month - 1];
    formattedDate = date ? "${day}.${mon} ${year}." : "${day} ${mon} ${year}";
    return formattedDate;
  }

  static timeConversion(TimeOfDay now) {
    int hour = now.hour;
    int min = now.minute;
    formattedTime =
        "${hour <= 9 ? "0" + hour.toString() : hour}:${min <= 9 ? "0" + min.toString() : min}";
    return formattedTime;
  }

  static convertEventDateToTimeFormat(DateTime date) {
    int hour = date.hour;
    int min = date.minute;
    String formattedTime =
        "${hour <= 9 ? "0" + hour.toString() : hour}:${min <= 9 ? "0" + min.toString() : min}";
    return formattedTime;
  }

  static getWeekDay(DateTime date) {
    int weekday = date.weekday;
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Err';
    }
  }

  static getMonthByName(DateTime date) {
    int month = date.month;
    String mon = MONTHS[month - 1];
    return mon.substring(0, 3);
  }

  static getFullMonthByName(DateTime date) {
    int month = date.month;
    String mon = MONTHS[month - 1];
    return mon;
  }

  static dateTimeFormat(DateTime date, TimeOfDay time) {
    String dateTimeString = date.toString().substring(0, 11) + DateTimeHelper.timeConversion(time);
    DateTime tempDate = DateTime.parse(dateTimeString);
     // print(dateTimeString);
     // print(tempDate);
    return tempDate;
  }

  static notificationDateFormat(DateTime date){
    int day = date.day;

    int month = date.month;
    String mon = MONTHS[month - 1];

    int year = date.year;

    return "${day} ${mon} ${year}";
  }

  static chatHeaderDateFormat(DateTime date, bool currentYear){
    int day = date.day;

    int month = date.month;
    String mon = MONTHS[month - 1];

    int year = date.year;

    return currentYear == true ? "${getWeekDay(date).toString().substring(0,3)} ${day} ${mon.substring(0,3)}" : "${getWeekDay(date).toString().substring(0,3)} ${day} ${mon.substring(0,3)} ${year}";
  }
}
