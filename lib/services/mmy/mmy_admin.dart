import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

import '../../models/profile.dart';
import 'profile.dart' as profileLib;
import 'package:meetmeyou_app/services/database/database.dart';

abstract class MMYAdminEngine {

  Future<void> setAdmin(String uid);

}

class MMYAdmin implements MMYAdminEngine {

  MMYAdmin(this._currentUser);
  final User _currentUser;

  @override
  Future<void> setAdmin(String uid) async {
    Database db = FirestoreDB(uid: _currentUser.uid);
    Profile profile = (await db.getProfile(uid))!;
    profile.parameters['UserType'] = USER_TYPE_ADMIN;
  }

}