import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/event.dart';

class AnnouncementDetail{

  String? announcementPhotoUrl;
  String? announcementId;
  bool editAnnouncement = false;
  Event? publication;

  // this value are used in edit or update announcement
  String? announcementTitle;
  DateTime? announcementStartDateAndTime;
  String? announcementLocation;
  String? announcementDescription;

  //these variables are used in invite contact and group checkboxes
  List<String> contactCIDs = [];
  List<String> groupIndexList = [];
  List<Contact> checkGroupList = [];

}