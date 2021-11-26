import 'dart:io';

class UserDetail{
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? countryCode;
  String? phone;
  File? profileFile;
  String? profileUrl;
  String? address;
  bool? value ;
  String? cid;
  String? about;
  String? membersLength;
  Map? group;

  UserDetail({this.firstName, this.lastName, this.email, this.countryCode, this.phone, this.profileUrl, this.address, this.value, this.cid, this.about, this.membersLength, this.group});
}