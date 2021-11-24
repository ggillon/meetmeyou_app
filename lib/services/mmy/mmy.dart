
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'dart:io';
import 'profile.dart' as profileLib;
import 'contact.dart' as contactLib;
import 'package:meetmeyou_app/services/storage/storage.dart' as storageLib;

abstract class MMYEngine {

  /// Get the user profile or create new one
  Future<Profile> getUserProfile();
  /// Update the user profile
  Future<Profile> updateProfile({String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about, Map? other, Map? parameters});
  /// Get the user profile or create new one, leveraging the Auth user info
  Future<Profile> createUserProfile();
  /// Checks if profile exists
  Future<bool> isNew();
  /// Update the profile Profile
  Future<Profile> updateProfilePicture(File file);
  /// Delete User - Cautious
  Future<void> deleteUser();
  /// Get a contact, invitation or group from DB
  Future<Contact> getContact(String cid);
  /// Get a contact, invitation or group from DB
  Future<void> deleteContact(String cid);
  /// Get all contacts from contact list
  Future<List<Contact>> getContacts({bool confirmedContacts=false, bool groups=false, bool invitedContacts=false, bool invitations=false, bool rejectedContacts=false});
  /// Get all groups from contact list
  Future<List<String>> getContactIDs({bool confirmedContacts=false, bool groups=false, bool invitedContacts=false, bool invitations=false, bool rejectedContacts=false});
  /// Invite a Profile from DB
  Future<void> inviteProfile(String uid);
  /// Accept an invitation
  Future<void> respondInvitation(String cid, bool accept);
  /// Create a Group of contacts
  Future<Contact> newGroupContact(String name, {String photoURL, String about});
  /// Update a Group of contacts
  Future<Contact> updateGroupContact(String cid, {String? displayName, String? photoURL, String? about});
  /// Add contact(s) to group
  Future<Contact> addContactsToGroup(String groupCID, {String? contactCID, List<String> contactsCIDs});
  /// Remove contact(s) from group
  Future<Contact> removeContactsFromGroup(String groupCID, {String? contactCID, List<String> contactsCIDs});
  /// Search for profiles
  Future<List<Contact>> searchProfiles(String searchText);
  /// Import phone Contacts
  Future<List<Contact>> getPhoneContacts();
  /// Invite phone Contacts
  Future<void> invitePhoneContacts(List<Contact> contacts);
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
  Future<Profile> updateProfilePicture(File file) async {
   String photoURL = await storageLib.storeProfilePicture(file, uid: _currentUser.uid);
   return profileLib.updateProfile(_currentUser, photoUrl: photoURL);
  }

  @override
  Future<void> deleteUser() async {
    profileLib.deleteProfile(_currentUser);
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
  Future<void> deleteContact(String cid) async {
    return contactLib.deleteContact(_currentUser, cid: cid);
  }

  @override
  Future<List<String>> getContactIDs({bool confirmedContacts=false, bool groups=false, bool invitedContacts=false, bool invitations=false, bool rejectedContacts=false}) async {
    List<String> cidList = [];
    for(Contact contact in await getContacts(confirmedContacts: confirmedContacts, groups: groups, invitedContacts: invitedContacts, invitations: invitations, rejectedContacts: rejectedContacts)) {
      cidList.add(contact.cid);
    }
    return cidList;
  }

  @override
  Future<List<Contact>> getContacts({bool confirmedContacts=false, bool groups=false, bool invitedContacts=false, bool invitations=false, bool rejectedContacts=false}) async {
    List<Contact> contactList = [];
    List<String> filter = [];
    if(confirmedContacts) filter.add(CONTACT_CONFIRMED);
    if(groups) filter.add(CONTACT_GROUP);
    if(invitedContacts) filter.add(CONTACT_INVITED);
    if(invitations) filter.add(CONTACT_INVITATION);
    if(rejectedContacts) filter.add(CONTACT_INVITED);
    //if(private) filter.add(contactLib.CONTACT_PRIVATE);

    if(filter.isEmpty) { // by default, return confirmed contacts
      filter.add(CONTACT_CONFIRMED);
      filter.add(CONTACT_PRIVATE);
    }

    for(Contact contact in await contactLib.getContacts(_currentUser)) {
      if (filter.contains(contact.status)) {
        contactList.add(contact);
      }
    }
    return contactList;
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

  @override
  Future<Contact> addContactsToGroup(String groupCID, {String? contactCID, List<String>? contactsCIDs}) {
    return contactLib.addToGroup(_currentUser, groupCID, contactCid: contactCID, contactListCids: contactsCIDs);
  }

  @override
  Future<Contact> removeContactsFromGroup(String groupCID, {String? contactCID, List<String>? contactsCIDs}) {
    return contactLib.removeFromGroup(_currentUser, groupCID, contactCid: contactCID, contactListCids: contactsCIDs);
  }

  @override
  Future<List<Contact>> searchProfiles(String searchText) async {
    List<Contact> contactList = [];
    for(Profile profile in await profileLib.searchProfiles(_currentUser, searchText: searchText)) {
      contactList.add(contactLib.contactFromProfile(profile, uid: profile.uid));
    }
    return contactList;
  }

  @override
  Future<List<Contact>> getPhoneContacts() async {
    return contactLib.getPhoneContacts(_currentUser);
  }

  @override
  Future<void> invitePhoneContacts(List<Contact> contacts) async {
    //TODO: invite contacts
  }




}