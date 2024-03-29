import 'dart:io';
import 'package:contacts_service/contacts_service.dart' as phoneContact;
import 'package:meetmeyou_app/services/mmy/mmy_creator.dart';

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


  int? unRespondedInvites = 0;
  int? unRespondedInvites1 = 0;
  /*bool? createGroup;
  String? groupName;
  List<Contact>? groupConfirmContactList = [];
  String? groupCid;*/

  Iterable<phoneContact.Contact> phoneContacts = [];

  String? userType;

  bool appleSignUpType = false;

  //for checking contact screen first time
  bool checkContactScreen = false;

  // this is used in deep link , when user logout and login again
  // to handle if user comes from deep link event not fetches again
  bool loginAfterDeepLink = true;

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
      this.group, this.unRespondedInvites, this.unRespondedInvites1});

 /* UserDetail.createEditGroup(
      {this.createGroup,
      this.groupName,
      this.about,
      this.groupConfirmContactList,
      this.groupCid});*/
}
