import 'dart:io';

import 'package:meetmeyou_app/models/contact.dart';

class UserDetail {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? countryCode;
  String? phone;
  File? profileFile;
  String? profileUrl;
  String? address;
  bool? checkForInvitation;
  String? cid;
  String? about;
  String? membersLength;
  Map? group;

  /*bool? createGroup;
  String? groupName;
  List<Contact>? groupConfirmContactList = [];
  String? groupCid;*/

  UserDetail(
      {this.firstName,
      this.lastName,
      this.email,
      this.countryCode,
      this.phone,
      this.profileUrl,
      this.address,
      this.checkForInvitation,
      this.cid,
      this.about,
      this.membersLength,
      this.group,});

 /* UserDetail.createEditGroup(
      {this.createGroup,
      this.groupName,
      this.about,
      this.groupConfirmContactList,
      this.groupCid});*/
}
