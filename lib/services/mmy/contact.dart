import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/services/database/database.dart';
import 'package:meetmeyou_app/services/database/id_gen.dart';
import 'package:meetmeyou_app/services/mmy/profile.dart';

//Contact Status
const CONTACT_NEW = 'New contact';
const CONTACT_PRIVATE = 'Private contact';
const CONTACT_CONFIRMED = 'Confirmed contact';
const CONTACT_INVITED = 'Invited contact';
const CONTACT_INVITATION = 'Invitation';
const CONTACT_REJECTED = 'Rejected invitation';
const CONTACT_GROUP = 'Contact Group';
const CONTACT_PROFILE = 'Listed profile';

// Create a new contact
Future<Contact> createNewPrivateContact(AuthBase auth, {String? displayName, String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about,}) async {
  Contact contact = Contact(
    cid: cidGenerator(),
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
    group: null,
    status: CONTACT_PRIVATE,
  );

  await FirestoreDB(uid: auth.currentUser!.uid).setContact(contact);

  return contact;
}

// Get a particular contact
Future<Contact> getContact(AuthBase auth, {required String cid}) async {
  return await FirestoreDB(uid: auth.currentUser!.uid).getContact(auth.currentUser!.uid, cid);
}

// Get all contacts
Future<List<Contact>> getContacts(AuthBase auth,) async {
  return await FirestoreDB(uid: auth.currentUser!.uid).getContacts(auth.currentUser!.uid);
}

// Get all contacts CIDs
Future<List<String>> getContactsCIDs(AuthBase auth,) async {
  List<String> CIDs = [];
  final contactList = await FirestoreDB(uid: auth.currentUser!.uid).getContacts(auth.currentUser!.uid);
  for(Contact contact in contactList) {
    CIDs.add(contact.cid);
  }
  return CIDs;
}


// Update a contact, with whatever field is not null
Future<Contact> updatePrivateContact(AuthBase auth, String cid, {String? displayName, String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about, Map? other, String? status,}) async {

  Database db = FirestoreDB(uid: auth.currentUser!.uid);

  final oldContact = await db.getContact(auth.currentUser!.uid, cid);

  Contact contact = Contact(
    uid: auth.currentUser!.uid,
    cid: cid,
    displayName: displayName ?? oldContact.displayName ?? '',
    firstName: firstName ?? oldContact.firstName ?? '',
    lastName: lastName ?? oldContact.lastName ?? '',
    email: email ?? oldContact.email ?? '',
    countryCode: countryCode ?? oldContact.countryCode ?? '',
    phoneNumber: phoneNumber ?? oldContact.phoneNumber ?? '',
    photoURL: photoUrl ?? oldContact.photoURL ?? 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
    addresses: <String, dynamic>{'Home': homeAddress ?? ''},
    about: about ?? oldContact.about ?? '',
    other: other ?? oldContact.other ?? <String, dynamic>{},
    status: status ?? oldContact.status ?? CONTACT_PRIVATE,
    group: oldContact.group,
  );

  await db.setContact(contact);

  return contact;
}

// Generate a contact from a profile, to display in contact sheet ; beware uid is set to profile.uid -> need to be changed
Contact contactFromProfile(Profile profile, {String? uid}) {
  return Contact(
    cid: profile.uid,
    uid: uid ?? profile.uid,
    displayName: profile.displayName ?? '',
    firstName: profile.firstName ?? '',
    lastName: profile.lastName ?? '',
    email: profile.email ?? '',
    countryCode: profile.countryCode ?? '',
    phoneNumber: profile.phoneNumber ?? '',
    photoURL: profile.photoURL ?? 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
    addresses: profile.addresses ?? <String, dynamic>{'Home': ''},
    about: profile.about ?? '',
    other: <String, dynamic>{},
    group: null,
    status: CONTACT_PROFILE,
  );
}

// Group contact functions : create
Future<Contact> createNewGroupContact(AuthBase auth, {required String displayName, String? photoURL, String? about}) async {
  Contact contact = Contact(
    cid: cidGenerator(),
    uid: auth.currentUser!.uid,
    displayName: displayName,
    firstName: '',
    lastName: '',
    email: '',
    countryCode: 'NA',
    phoneNumber: '',
    photoURL: photoURL ?? 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
    addresses: <String, dynamic>{'Home': ''},
    about: about ?? '',
    other: <String, dynamic>{},
    group: <String, dynamic>{},
    status: CONTACT_PRIVATE,
  );

  await FirestoreDB(uid: auth.currentUser!.uid).setContact(contact);

  return contact;
}

/* GROUP CONTACT FUCNTIONS*/

// Group contact functions : update a group contact
Future<Contact> updateGroupContact(AuthBase auth, String cid, {String? displayName, String? photoURL, String? about}) async {
  Contact contact = await updatePrivateContact(auth, cid, displayName: displayName, photoUrl: photoURL, about: about);
  await FirestoreDB(uid: auth.currentUser!.uid).setContact(contact);
  return contact;
}

// Group contact functions : add one or more contacts, returns the group as contact
Future<Contact> addToGroup(AuthBase auth, String cid, {String? contactCid, List<String>? contactListCids}) async {
  Contact group = await getContact(auth, cid: cid);
  if(contactCid != null && group.group != null) {
    Contact contact = await getContact(auth, cid: contactCid);
    group.group!.addAll({contact.cid: contact.displayName});
  }
  if(contactListCids != null && group.group != null) {
    for(String contactCid in contactListCids) {
      Contact contact = await getContact(auth, cid: contactCid);
      group.group!.addAll({contact.cid: contact.displayName});
    }
  }
  await FirestoreDB(uid: auth.currentUser!.uid).setContact(group);
  return group;
}

// Group contact functions : remove one or more contacts, returns the group as contact
Future<Contact> removeFromGroup(AuthBase auth, String cid, {String? contactCid, List<String>? contactListCids}) async {
  Contact group = await getContact(auth, cid: cid);
  if(contactCid != null && group.group != null) {
    if(group.group!.containsKey(contactCid)) {
      group.group!.remove(contactCid);
    }
  }
  if(contactListCids != null && group.group != null) {
    for(String contactCid in contactListCids) {
      if(group.group!.containsKey(contactCid)) {
        group.group!.remove(contactCid);
      }
    }
  }
  await FirestoreDB(uid: auth.currentUser!.uid).setContact(group);
  return group;
}

/* INVITE CONTACT FUNCTIONS*/

// Invite a profile, send an invitation
Future<void> inviteProfile(AuthBase auth, {required String uid}) async {
  Database db = FirestoreDB(uid: auth.currentUser!.uid);

  // Add an invited contact to current user
  Contact invited = contactFromProfile(await db.getProfile(uid), uid: auth.currentUser!.uid);
  invited.status = CONTACT_INVITED; // change status to invited contact
  await db.setContact(invited);

  // Add an invitation to invited profile
  Contact invitation = contactFromProfile(await getUserProfile(auth: auth), uid: uid);
  invitation.status = CONTACT_INVITATION; // change status to invitation contact
  await db.setContact(invitation);
}

Future<void> respondProfile(AuthBase auth, {required String cid, required bool accept}) async {
  Database db = FirestoreDB(uid: auth.currentUser!.uid);
  if (accept) { // Accepted invitation
    // Convert invitation into a contact
    Contact invitation = await db.getContact(auth.currentUser!.uid, cid);
    if (invitation.status == CONTACT_INVITATION) {
      invitation.status = CONTACT_PROFILE; // change to MMY Profile contact
      await db.setContact(invitation);
    }

    // Convert invited contact of profile sending invitation into a profile contact
    Contact invited = await db.getContact(cid, auth.currentUser!.uid);
    if (invited.status == CONTACT_INVITED) {
      invited.status = CONTACT_PROFILE; // change to MMY Profile contact
      await db.setContact(invitation);
    }
  } else {
    // Delete invitation
    Contact invitation = await db.getContact(auth.currentUser!.uid, cid);
    if (invitation.status == CONTACT_INVITATION) {
      await db.deleteContact(auth.currentUser!.uid, cid);
    }
    // Convert invited contact to rejected contact
    Contact invited = await db.getContact(cid, auth.currentUser!.uid);
    if (invited.status == CONTACT_INVITED) {
      invited.status = CONTACT_REJECTED; // change to a rejected contact
      await db.setContact(invitation);
    }
  }
}

// Linking two profile - happens when one invites the second one to an event, they become linked
Future<void> linkProfiles(AuthBase auth, {required String uid,}) async {
  Database db = FirestoreDB(uid: auth.currentUser!.uid);
  Contact contact1 = contactFromProfile(await db.getProfile(uid), uid: auth.currentUser!.uid);
  Contact contact2 = contactFromProfile(await db.getProfile(auth.currentUser!.uid), uid: uid);
  await db.setContact(contact1);
  await db.setContact(contact2);
}