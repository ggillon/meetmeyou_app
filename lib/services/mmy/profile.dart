import 'package:meetmeyou_app/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/services/database/database.dart';


// Use to get the user profile, if non exist will create one from user in auth.
Future<Profile> getUserProfile(User currentUser,
    {bool user = true, String? uid}) async {
  final profile = user
      ? await FirestoreDB(uid: currentUser.uid).getProfile(currentUser.uid)
      : await FirestoreDB(uid: uid!).getProfile(uid);
  if (profile != null) {
    return profile;
  } else {
    return await createProfileFromUser(currentUser);
  }
}

// Check if profile exists
Future<bool> isNewProfile(User currentUser) async {
  try {
    final profile =
        await FirestoreDB(uid: currentUser.uid).getProfile(currentUser.uid);
    if (profile == null) {
      return true;
    } else {
      if (profile.parameters
          .containsKey('New')) if (profile.parameters['New'] == true)
        return true;
      return false;
    }
  } catch (e) {
    return true;
  }
}


// Create Profile from user Auth data, store it in Firebase
Future<Profile> createProfileFromUser(User user) async {

  String firstName = '';
  String lastName = '';

  try {
    // Trying as there can be strange names messing up the recognition
    if (user.displayName != null) {
      final names = user.displayName!.split(" ");
      firstName = names.removeAt(0);
      lastName = names.join(" ");
    }
  } catch (e) {
    print(e);
  }

  Profile profile = Profile(
    uid: user.uid,
    displayName: user.displayName ?? '',
    firstName: firstName,
    lastName: lastName,
    email: user.email ?? '',
    countryCode: '',
    phoneNumber: '',
    photoURL: user.photoURL ??
        'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
    addresses: <String, dynamic>{},
    about: '',
    other: <String, dynamic>{},
    parameters: <String, dynamic>{'New': true},
  );

  FirestoreDB(uid: user.uid).setProfile(profile);

  return profile;
}

// Create Profile from fields, if fields are null they will be set to default value
Future<Profile> createProfile(
  User currentUser, {
  String? displayName,
  String? firstName,
  String? lastName,
  String? email,
  String? countryCode,
  String? phoneNumber,
  String? photoUrl,
  String? homeAddress,
  String? about,
}) async {
  Profile profile = Profile(
    uid: currentUser.uid,
    displayName: displayName ?? '',
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    email: email ?? '',
    countryCode: countryCode ?? '',
    phoneNumber: phoneNumber ?? '',
    photoURL: photoUrl ??
        'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
    addresses: <String, dynamic>{'Home': homeAddress ?? ''},
    about: about ?? '',
    other: <String, dynamic>{},
    parameters: <String, dynamic>{'New': true},
  );

  await FirestoreDB(uid: currentUser.uid).setProfile(profile);

  return profile;
}

// Update whatever fields are not null
Future<Profile> updateProfile(User currentUser,
    {String? firstName,
    String? lastName,
    String? email,
    String? countryCode,
    String? phoneNumber,
    String? photoUrl,
    String? homeAddress,
    String? about,
    Map? other,
    Map? parameters}) async {
  Database db = FirestoreDB(uid: currentUser.uid);

  final oldProfile = (await db.getProfile(currentUser.uid))!;

  String displayName = (firstName ?? oldProfile.firstName) +
      ' ' +
      (lastName ?? oldProfile.lastName);

  Profile profile = Profile(
    uid: currentUser.uid,
    displayName: displayName,
    firstName: firstName ?? oldProfile.firstName,
    lastName: lastName ?? oldProfile.lastName,
    email: email ?? oldProfile.email,
    countryCode: countryCode ?? oldProfile.countryCode,
    phoneNumber: phoneNumber ?? oldProfile.phoneNumber,
    photoURL: photoUrl ?? oldProfile.photoURL,
    addresses: homeAddress != null
        ? <String, dynamic>{'Home': homeAddress}
        : oldProfile.addresses,
    about: about ?? oldProfile.about,
    other: other ?? oldProfile.other,
    parameters: parameters ?? oldProfile.parameters,
  );

  await db.setProfile(profile);

  return profile;
}

Future<Profile> setProfileParameter(User currentUser,
    {required String param, required dynamic value}) async {
  Database db = FirestoreDB(uid: currentUser.uid);
  final profile = (await db.getProfile(currentUser.uid))!;
  profile.parameters[param] = value;
  await db.setProfile(profile);
  return profile;
}

Future<void> deleteProfile(User currentUser) async {
  await FirestoreDB(uid: currentUser.uid).deleteProfile(currentUser.uid);
  await currentUser.delete();
}

// searches for Profiles in the database
Future<List<Profile>> searchProfiles(User currentUser,
    {required String searchText}) async {
  List<Profile> results = [];
  Database db = await FirestoreDB(uid: currentUser.uid);
  final searchWords = searchText.split(" ");
  List<String> searchFields = [
    'displayName',
    'firstName',
    'lastName',
    'email',
    'phoneNumber'
  ];
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
Profile createLocalProfile({
  required String uid,
  String? displayName,
  String? firstName,
  String? lastName,
  String? email,
  String? countryCode,
  String? phoneNumber,
  String? photoUrl,
  String? homeAddress,
  String? about,
}) {
  Profile profile = Profile(
    uid: uid,
    displayName: displayName ?? '',
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    email: email ?? '',
    countryCode: countryCode ?? '',
    phoneNumber: phoneNumber ?? '',
    photoURL: photoUrl ??
        'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
    addresses: <String, dynamic>{'Home': homeAddress ?? ''},
    about: about ?? '',
    other: <String, dynamic>{},
    parameters: <String, dynamic>{'New': true},
  );

  return profile;
}


// PARAMS

const PARAM_NOTIFY_EVENT = "NotifyEvent";
const PARAM_NOTIFY_INVITATION = "NotifyInvitation";
const PARAM_NOTIFY_DISCUSSION = "NotifyDiscussion";



