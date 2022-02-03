import 'package:flutter/material.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';

class MultipleDateOption{
  List<DateTime> startDate = [];
  List<DateTime> endDate = [];
  List<TimeOfDay> startTime = [];
  List<TimeOfDay> endTime = [];

  List<DateTime> startDateTime = [];
  List<DateTime> endDateTime = [];

// for multi date option
  TimeOfDay multiStartTime = TimeOfDay(hour: 19, minute: 0);
  TimeOfDay multiEndTime = TimeOfDay(hour: 19, minute: 0).addHour(3);

  List<Map> invitedContacts = [];
  List<List<String>> eventAttendingPhotoUrlLists = [];
  List<List<String>> eventAttendingKeysList = [];
}