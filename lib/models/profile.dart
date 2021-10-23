class Profile {
  Profile({required this.uid, required this.displayName, required this.firstName, required this.lastName, required this.email, required this.countryCode, required this.phoneNumber, required this.photoURL, required this.addresses, required this.about, required this.other, required this.parameters});
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
  Map? parameters;

  factory Profile.fromMap(Map<String, dynamic> data) {
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
    final Map? parameters = data['parameters'];

    return Profile(uid: uid, displayName: displayName, firstName: firstName, lastName: lastName, email: email, countryCode: countryCode, phoneNumber: phoneNumber, photoURL: photoURL, addresses: addresses, about: about, other: other, parameters: parameters);
  }

  Profile getFromMap(Map<String, dynamic> data) {
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
    final Map? parameters = data['parameters'];

    return Profile(uid: uid, displayName: displayName, firstName: firstName, lastName: lastName, email: email, countryCode: countryCode, phoneNumber: phoneNumber, photoURL: photoURL, addresses: addresses, about: about, other: other, parameters: parameters);

  }

  Map<String, dynamic> toMap() {
    return {
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
      'parameters': parameters,
    };
  }
}