import 'dart:io';

import 'package:meetmeyou_app/models/contact.dart';

class GroupDetail {
  bool? createGroup;
  String? groupName;
  String? about;
  List<Contact>? groupConfirmContactList = [];
  String? groupCid;
  String? groupPhotoUrl;
  String? membersLength;
  Map? group;
  bool? checkBoxCheck;


  GroupDetail(
      {this.createGroup,
      this.groupName,
      this.about,
      this.groupCid,
      this.groupConfirmContactList,
      this.groupPhotoUrl,
      this.membersLength,
      this.group, this.checkBoxCheck});
}
