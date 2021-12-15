import 'package:flutter/material.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/event.dart';

class EventDetail{
  String? eid;
  String? eventBtnStatus;
  Color? textColor;
  Color? btnBGColor;
  Map? eventMapData;
  List<String>? attendingProfileKeys = [];
  String? eventPhotoUrl;
  int? unRespondedEvent = 0;
  int? unRespondedEvent1 = 0;

  //these variables are used in invite contact and group checkboxes
  List<String> contactCIDs = [];
  List<String> groupIndexList = [];
  List<Contact> checkGroupList = [];


  // these variables are used for edit event
  bool? editEvent;
  String? photoUrlEvent;
  String? eventName;
  DateTime? startDateAndTime;
  DateTime? endDateAndTime;
  String? eventLocation;
  String? eventDescription;

  EventDetail({this.eid, this.eventBtnStatus, this.textColor, this.btnBGColor, this.eventMapData, this.attendingProfileKeys, this.eventPhotoUrl, this.unRespondedEvent});

  EventDetail.editEvent({this.editEvent, this.photoUrlEvent, this.eventName, this.startDateAndTime, this.endDateAndTime, this.eventLocation, this.eventDescription});
}