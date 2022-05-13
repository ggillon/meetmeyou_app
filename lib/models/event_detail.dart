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
  List<String>? allAttendingProfileKeys = [];
  String? eventPhotoUrl;
  int? unRespondedEvent = 0;
  int? unRespondedEvent1 = 0;
  String? organiserId;
  String? organiserName;

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
  Event? event;
  Map? questionnaire;

  int? eventListLength;

  // past event
  bool isPastEvent = false;

  EventDetail({this.eid, this.eventBtnStatus, this.textColor, this.btnBGColor, this.eventMapData, this.attendingProfileKeys, this.eventPhotoUrl, this.unRespondedEvent, this.allAttendingProfileKeys, this.organiserId, this.organiserName, this.eventListLength});

  EventDetail.editEvent({this.editEvent, this.photoUrlEvent, this.eventName, this.startDateAndTime, this.endDateAndTime, this.eventLocation, this.eventDescription, this.event, this.questionnaire});
}