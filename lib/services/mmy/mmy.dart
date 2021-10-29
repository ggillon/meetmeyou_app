
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'profile.dart' as profileLib;
import 'contact.dart' as contactLib;

abstract class MMYEngine {

  /// Get the user profile or create new one
  Future<Profile> getUserProfile();
  /// Update the user profile
  Future<Profile> updateProfile({String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about, Map? other, Map? parameters});
  /// Get the user profile or create new one, leveraging the Auth user info
  Future<Profile> createUserProfile();
  /// Checks if profile exists
  Future<bool> isNew();


  /// Get a contact from contact list
  Future<Contact> getContact(String cid);
  /// Get all contacts from contact list
  Future<List<Contact>> getContacts();
  /// Get all the CIDs (Contact IDs) in contact list
  Future<List<String>> getContactIDs();
  /// Invite a Profile from DB
  Future<void> inviteProfile(String uid);
  /// Accept an invitation
  Future<void> respondInvitation(String cid, bool accept);
  /// Create a Group of contacts
  Future<Contact> newGroupContact(String name, {String photoURL, String about});
  /// Update a Group of contacts
  Future<Contact> updateGroupContact(String cid, {String? displayName, String? photoURL, String? about});

}

class MMY implements MMYEngine {
  /// Creates a MMYEngine class with access to features

  MMY(this._currentUser);
  final User _currentUser;

  @override
  Future<Profile> getUserProfile() {
    return profileLib.getUserProfile(_currentUser);
  }

  @override
  Future<Profile> updateProfile({String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about, Map? other, Map? parameters}) async {
    return profileLib.updateProfile(_currentUser, firstName: firstName, lastName: lastName, email: email, countryCode: countryCode, phoneNumber: phoneNumber, photoUrl: photoUrl, homeAddress: homeAddress, about: about, other: other, parameters: parameters);
  }

  @override
  Future<Profile> createUserProfile() {
    return profileLib.createProfileFromUser(_currentUser);
  }

  @override
  Future<bool> isNew() {
    return profileLib.isNewProfile(_currentUser);
  }

  @override
  Future<Contact> newGroupContact(String name, {String photoURL = contactLib.GROUP_PHOTOURL, String about = ''}) async {
    final contact =  await contactLib.createNewGroupContact(_currentUser, displayName: name);
    return contactLib.updateGroupContact(_currentUser, contact.cid,photoURL: photoURL, about: about);
  }

  @override
  Future<Contact> getContact(String cid) {
    return contactLib.getContact(_currentUser, cid: cid);
  }

  @override
  Future<List<String>> getContactIDs() {
    return contactLib.getContactsCIDs(_currentUser);
  }

  @override
  Future<List<Contact>> getContacts() {
    return contactLib.getContacts(_currentUser);
  }

  @override
  Future<void> inviteProfile(String uid) {
    return contactLib.inviteProfile(_currentUser, uid: uid);
  }

  @override
  Future<Contact> updateGroupContact(String cid, {String? displayName, String? photoURL, String? about}) {
    return contactLib.updateGroupContact(_currentUser, cid, displayName: displayName, photoURL: photoURL, about: about);
  }

  @override
  Future<void> respondInvitation(String cid, bool accept) {
    return contactLib.respondProfile(_currentUser, cid: cid, accept: accept);
  }

}