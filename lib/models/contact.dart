import 'constants.dart';

//Contact Status
const CONTACT_NEW = 'New contact';
const CONTACT_PRIVATE = 'Private contact';
const CONTACT_CONFIRMED = 'Confirmed contact';
const CONTACT_INVITED = 'Invited contact';
const CONTACT_INVITATION = 'Invitation';
const CONTACT_REJECTED = 'Rejected invitation';
const CONTACT_GROUP = 'Contact Group';
const CONTACT_PROFILE = 'Listed profile';

const CONTACT_PHOTOURL = 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media';
const GROUP_PHOTOURL = 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media';



class Contact {
  Contact({required this.cid, required this.uid, required this.displayName, required this.firstName, required this.lastName, required this.email, required this.countryCode, required this.phoneNumber, required this.photoURL, required this.addresses, required this.about, required this.other, required this.group, required this.status});
  String cid;
  String uid;
  String displayName;
  String firstName;
  String lastName;
  String email;
  String countryCode;
  String phoneNumber;
  String photoURL;
  Map addresses;
  String about;
  Map other;
  String status;
  Map group;

  bool get isFavourite {
    if(other.containsKey('Favourite')) {
      return other['Favourite'];
    } else {return false;}
  }

  factory Contact.fromMap(Map<String, dynamic> data) {
    final String cid= data['cid'] ?? '';
    final String uid= data['uid'] ?? '';
    final String displayName = data['displayName'] ?? '';
    final String firstName= data['firstName'] ?? '';
    final String lastName = data['lastName'] ?? '';
    final String email = data['email'] ?? '';
    final String countryCode = data['countryCode'] ?? '';
    final String phoneNumber = data['phoneNumber'] ?? '';
    final String photoURL = data['photoURL'] ?? CONTACT_PHOTOURL;
    final Map addresses = data['addresses'] ?? EMPTY_MAP;
    final String about = data['about'] ?? '';
    final Map other = data['other'] ?? EMPTY_MAP;
    final String status = data['status'] ?? '';
    final Map group = data['group'] ?? EMPTY_MAP;


    return Contact(cid: cid, uid: uid, displayName: displayName, firstName: firstName, lastName: lastName, email: email, countryCode: countryCode, phoneNumber: phoneNumber, photoURL: photoURL, addresses: addresses, other: other, status: status, group: group, about: about);
  }

  Contact getFromMap(Map<String, dynamic> data) {
    final String cid= data['cid'] ?? '';
    final String uid= data['uid'] ?? '';
    final String displayName = data['displayName'] ?? '';
    final String firstName= data['firstName'] ?? '';
    final String lastName = data['lastName'] ?? '';
    final String email = data['email'] ?? '';
    final String countryCode = data['countryCode'] ?? '';
    final String phoneNumber = data['phoneNumber'] ?? '';
    final String photoURL = data['photoURL'] ?? CONTACT_PHOTOURL;
    final Map addresses = data['addresses'] ?? EMPTY_MAP;
    final String about = data['about'] ?? '';
    final Map other = data['other'] ?? EMPTY_MAP;
    final String status = data['status'] ?? '';
    final Map group = data['group'] ?? EMPTY_MAP;


    return Contact(cid: cid, uid: uid, displayName: displayName, firstName: firstName, lastName: lastName, email: email, countryCode: countryCode, phoneNumber: phoneNumber, photoURL: photoURL, addresses: addresses, other: other, status: status, group: group, about: about);
  }

  Map<String, dynamic> toMap() {
    return {
      'cid': cid,
      'uid': uid,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'addresses': addresses,
      'about': about,
      'other': other,
      'group': group,
      'status': status,
    };
  }


}

