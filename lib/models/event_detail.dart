import 'package:flutter/material.dart';
import 'package:meetmeyou_app/models/event.dart';

class EventDetail{
  String? eid;
  String? eventBtnStatus;
  Color? textColor;
  Color? btnBGColor;
  Map? eventMapData;
  List<String>? attendingProfileKeys = [];

  EventDetail({this.eid, this.eventBtnStatus, this.textColor, this.btnBGColor, this.eventMapData, this.attendingProfileKeys});
}