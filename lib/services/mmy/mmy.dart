
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'profile.dart' as profileLib;

abstract class MMYEngine {

  /// Get the user profile
  Future<Profile> getUserProfile();
  /// Update the user profile
  Future<Profile> updateProfile({String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about, Map? other, Map? parameters});


}

class MMY implements MMYEngine {
  /// Creates a MMYEngine class with access to features

  MMY(this._auth);
  final AuthBase _auth;

  @override
  Future<Profile> getUserProfile() async {
    return profileLib.getUserProfile(auth: _auth);
  }

  @override
  Future<Profile> updateProfile({String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about, Map? other, Map? parameters}) async {
    return profileLib.updateProfile(_auth, firstName: firstName, lastName: lastName, email: email, countryCode: countryCode, phoneNumber: phoneNumber, photoUrl: photoUrl, homeAddress: homeAddress, about: about, other: other, parameters: parameters);
  }

}