// Flutter imports

// Service imports
import 'package:meetmeyou_app/models/contact.dart';

import 'firestore_service.dart';
import 'api_path.dart';

//Data models import
import 'package:meetmeyou_app/models/profile.dart';


abstract class Database {

  String get userID;

  // Profile DB Functions
  Future<void> setProfile(Profile profile);
  Future<Profile?> getProfile(String uid);
  Future<void> deleteProfile(String uid);
  Future<List<Profile>> queryProfiles({required String field, required String query});

  // Contact DB Functions
  Future<void> setContact(Contact contact);
  Future<Contact> getContact(String uid, String cid);
  Future<void> deleteContact(String uid, String cid);
  Future<List<Contact>> getContacts(String uid);
}

class FirestoreDB implements Database {

  FirestoreDB({required this.uid});
  final String uid;
  @override
  String get userID => uid;
  final _service = FirestoreService.instance;

  // PROFILE METHODS
  Future<void> setProfile(Profile profile) async {
    _service.setData(
      path: APIPath.profile(profile.uid),
      data: profile.toMap(),
    );
  }

  Future<Profile?> getProfile(String uid) async {
    return _service.getData(
      path: APIPath.profile(uid),
      builder: (data) {return Profile.fromMap(data);},
    );
  }

  Future<void> deleteProfile(String uid,) async {
    _service.deleteData(path: APIPath.profile(uid,));
  }

  Future<List<Profile>> queryProfiles({required String field, required String query}) async {
    return await _service.getListDataWhere(
      path: APIPath.profiles(),
      field: field,
      value: query,
      builder: (data) {
        return Profile.fromMap(data);
      },
    );
  }

  // Contact METHODS
  Future<void> setContact(Contact contact) async {
    _service.setData(
      path: APIPath.userContact(contact.uid, contact.cid),
      data: contact.toMap(),
    );
  }

  Future<Contact> getContact(String uid, String cid) async {
    return _service.getData(
      path: APIPath.userContact(uid, cid),
      builder: (data) {return Contact.fromMap(data);},
    );
  }

  Future<List<Contact>> getContacts(String uid,) async {
    return _service.getListData(
        path: APIPath.userContacts(uid),
        builder: (data) => Contact.fromMap(data)
    );
  }

  Future<void> deleteContact(String uid, String cid) async {
    _service.deleteData(path: APIPath.userContact(uid, cid));
  }


}
