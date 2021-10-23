class Contact {
  Contact({required this.cid, required this.uid, required this.displayName, required this.firstName, required this.lastName, required this.email, this.countryCode, this.phoneNumber, required this.photoURL, required this.addresses, required this.about, required this.other, this.group, required this.status});
  String cid;
  String uid;
  String? displayName;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? photoURL;
  Map? addresses;
  String? about;
  Map? other;
  String? status;
  Map? group;

  factory Contact.fromMap(Map<String, dynamic> data) {
    final String cid= data['cid'];
    final String uid= data['uid'];
    final String? displayName = data['displayName'];
    final String? firstName= data['firstName'];
    final String? lastName = data['lastName'];
    final String? email = data['email'];
    final String? countryCode = data['countryCode'];
    final String? phoneNumber = data['phoneNumber'];
    final String? photoURL = data['photoURL'];
    final Map? addresses = data['addresses'];
    final String? about = data['about'];
    final Map? other = data['other'];
    final String status = data['status'];
    final Map group = data['group'];


    return Contact(cid: cid, uid: uid, displayName: displayName, firstName: firstName, lastName: lastName, email: email, countryCode: countryCode, phoneNumber: phoneNumber, photoURL: photoURL, addresses: addresses, other: other, status: status, group: group, about: about);
  }

  Contact getFromMap(Map<String, dynamic> data) {
    final String cid= data['cid'];
    final String uid= data['uid'];
    final String? displayName = data['displayName'];
    final String? firstName= data['firstName'];
    final String? lastName = data['lastName'];
    final String? email = data['email'];
    final String? countryCode = data['countryCode'];
    final String? phoneNumber = data['phoneNumber'];
    final String? photoURL = data['photoURL'];
    final Map? addresses = data['addresses'];
    final String? about = data['about'];
    final Map? other = data['other'];
    final String status = data['status'];
    final Map group = data['group'];


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

