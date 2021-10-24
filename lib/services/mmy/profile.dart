import 'package:meetmeyou_app/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/services/database/database.dart';


// Use to get the user profile, if non exist will create one from user in auth.
Future<Profile> getUserProfile({required AuthBase auth}) async {
  final profile = await FirestoreDB(uid: auth.currentUser!.uid).getProfile(auth.currentUser!.uid);
  if (profile != null) {
    return profile;
  } else {
    return await createProfileFromUser(auth.currentUser!);
  }
}

// Create Profile from user Auth data, store it in Firebase
Future<Profile> createProfileFromUser(User user) async {

  String firstName = '';
  String lastName = '';

  try { // Trying as there can be strange names messing up the recognition
    if (user.displayName != null) {
      final names = user.displayName!.split(" ");
      firstName = names.removeAt(0);
      lastName = names.join(" ");
  } } catch(e) {print(e);}

  Profile profile = Profile(
      uid: user.uid,
      displayName: user.displayName ?? '',
      firstName: firstName,
      lastName: lastName,
      email: user.email ?? '',
      countryCode: '',
      phoneNumber: '',
      photoURL: user.photoURL ?? 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
      addresses: <String, dynamic>{},
      about: '',
      other: <String, dynamic>{},
      parameters: <String, dynamic>{'New': true},
  );

  FirestoreDB(uid: user.uid).setProfile(profile);

  return profile;
}


// Create Profile from fields, if fields are null they will be set to default value
Future<Profile> createProfile(AuthBase auth, {String? displayName, String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about,}) async {

  Profile profile = Profile(
    uid: auth.currentUser!.uid,
    displayName: displayName ?? '',
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    email: email ?? '',
    countryCode: countryCode ?? '',
    phoneNumber: phoneNumber ?? '',
    photoURL: photoUrl ?? 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
    addresses: <String, dynamic>{'Home': homeAddress ?? ''},
    about: about ?? '',
    other: <String, dynamic>{},
    parameters: <String, dynamic>{'New': true},
  );

  await FirestoreDB(uid: auth.currentUser!.uid).setProfile(profile);

  return profile;
}




// Create MMY Email user and profile in one go
Future<Profile> createMMYUser(AuthBase auth, {String? displayName, String? firstName, String? lastName, required String email, required String password, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about,}) async {

  User? user = await auth.createEmailUser(email, password);

  Profile profile = Profile(
    uid: auth.currentUser!.uid,
    displayName: displayName ?? '',
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    email: email,
    countryCode: countryCode ?? '',
    phoneNumber: phoneNumber ?? '',
    photoURL: photoUrl ?? 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
    addresses: <String, dynamic>{'Home': homeAddress ?? ''},
    about: about ?? '',
    other: <String, dynamic>{},
    parameters: <String, dynamic>{'New': true},
  );

  if (user != null) {
    await FirestoreDB(uid: auth.currentUser!.uid).setProfile(profile);
  }

  return profile;
}

// Update whatever fields are not null
Future<Profile> updateProfile(AuthBase auth, {String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about, Map? other, Map? parameters}) async {

  Database db = FirestoreDB(uid: auth.currentUser!.uid);

  final oldProfile = (await db.getProfile(auth.currentUser!.uid))!;

  String displayName = (firstName ?? oldProfile.firstName ?? '') + ' ' + (lastName ?? oldProfile.lastName ?? '');

  Profile profile = Profile(
    uid: auth.currentUser!.uid,
    displayName: displayName,
    firstName: firstName ?? oldProfile.firstName ?? '',
    lastName: lastName ?? oldProfile.lastName ?? '',
    email: email ?? oldProfile.email ?? '',
    countryCode: countryCode ?? oldProfile.countryCode ?? '',
    phoneNumber: phoneNumber ?? oldProfile.phoneNumber ?? '',
    photoURL: photoUrl ?? oldProfile.photoURL ?? 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
    addresses: <String, dynamic>{'Home': homeAddress ?? ''},
    about: about ?? oldProfile.about ?? '',
    other: other ?? oldProfile.other ?? <String, dynamic>{},
    parameters: parameters ?? oldProfile.parameters ?? <String, dynamic>{},
  );

  await db.setProfile(profile);

  return profile;
}

Future<Profile> setProfileParameter(AuthBase auth, {required String param, required dynamic value}) async {
  Database db = FirestoreDB(uid: auth.currentUser!.uid);
  final profile = (await db.getProfile(auth.currentUser!.uid))!;
  profile.parameters![param] = value;
  await db.setProfile(profile);
  return profile;
}


Future<void> deleteProfile(AuthBase auth) async {
  await FirestoreDB(uid: auth.currentUser!.uid).deleteProfile(auth.currentUser!.uid);
  await auth.currentUser!.delete();
}

// searches for Profiles in the database
Future<List<Profile>> searchProfiles(AuthBase auth, {required String searchText}) async {
  List<Profile> results = [];
  Database db = await FirestoreDB(uid: auth.currentUser!.uid);
  final searchWords = searchText.split(" ");
  List<String> searchFields = ['displayName', 'firstName', 'lastName', 'email', 'phoneNumber'];
  for (String field in searchFields) {
    for (var value in searchWords) {
      if (value.isNotEmpty) {
        final queryList = await db.queryProfiles(field: field, query: value);
        results = results + queryList;
      }
    }
  }



  return results;
}


// Create Profile from fields without storing it for tests purposes
Profile createNoDBProfile({required String uid, String? displayName, String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about,}) {

  Profile profile = Profile(
    uid: uid,
    displayName: displayName ?? '',
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    email: email ?? '',
    countryCode: countryCode ?? '',
    phoneNumber: phoneNumber ?? '',
    photoURL: photoUrl ?? 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
    addresses: <String, dynamic>{'Home': homeAddress ?? ''},
    about: about ?? '',
    other: <String, dynamic>{},
    parameters: <String, dynamic>{'New': true},
  );

  return profile;
}

