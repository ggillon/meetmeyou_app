import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/models/constants.dart';
import 'package:meetmeyou_app/services/database/database.dart';
import 'package:meetmeyou_app/services/database/id_gen.dart';
import 'package:meetmeyou_app/services/mmy/profile.dart';
import 'package:contacts_service/contacts_service.dart' as Phone;
import 'package:permission_handler/permission_handler.dart';


const CONTACT_PHOTOURL = 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media';
const GROUP_PHOTOURL = 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media';

// Create a new contact
Future<Contact> createNewPrivateContact(User currentUser, {String? displayName, String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about,}) async {
  Contact contact = Contact(
    cid: cidGenerator(),
    uid: currentUser.uid,
    displayName: displayName ?? '',
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    email: email ?? '',
    countryCode: countryCode ?? '',
    phoneNumber: phoneNumber ?? '',
    photoURL: photoUrl ?? 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
    addresses: <String, dynamic>{'Home': homeAddress ?? ''},
    about: about ?? '',
    other: EMPTY_MAP,
    group: EMPTY_MAP,
    status: CONTACT_PRIVATE,
  );

  await FirestoreDB(uid: currentUser.uid).setContact(currentUser.uid, contact);

  return contact;
}

Contact createLocalContact(User currentUser, {String? displayName, String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about,}) {
  Contact contact = Contact(
    cid: cidGenerator(),
    uid: currentUser.uid,
    displayName: displayName ?? '',
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    email: email ?? '',
    countryCode: countryCode ?? '',
    phoneNumber: phoneNumber ?? '',
    photoURL: photoUrl ?? 'https://firebasestorage.googleapis.com/v0/b/meetmeyou-9fd90.appspot.com/o/contact.png?alt=media',
    addresses: <String, dynamic>{'Home': homeAddress ?? ''},
    about: about ?? '',
    other: EMPTY_MAP,
    group: EMPTY_MAP,
    status: CONTACT_PRIVATE,
  );
  return contact;
}

// Get a particular contact
Future<Contact> getContact(User currentUser, {required String cid}) async {
  return await FirestoreDB(uid: currentUser.uid).getContact(currentUser.uid, cid);
}

// Delete a particular contact
Future<void> deleteContact(User currentUser, {required String cid}) async {
  return await FirestoreDB(uid: currentUser.uid).deleteContact(currentUser.uid, cid);
}

// Get all contacts
Future<List<Contact>> getContacts(User currentUser,) async {
  return await FirestoreDB(uid: currentUser.uid).getContacts(currentUser.uid);
}

// Get all contacts CIDs
Future<List<String>> getContactsCIDs(User currentUser,) async {
  List<String> CIDs = [];
  final contactList = await FirestoreDB(uid: currentUser.uid).getContacts(currentUser.uid);
  for(Contact contact in contactList) {
    CIDs.add(contact.cid);
  }
  return CIDs;
}


// Update a contact, with whatever field is not null
Future<Contact> updatePrivateContact(User currentUser, String cid, {String? displayName, String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about, Map? other, String? status,}) async {

  Database db = FirestoreDB(uid: currentUser.uid);

  final oldContact = await db.getContact(currentUser.uid, cid);

  Contact contact = Contact(
    uid: currentUser.uid,
    cid: cid,
    displayName: displayName ?? oldContact.displayName,
    firstName: firstName ?? oldContact.firstName,
    lastName: lastName ?? oldContact.lastName,
    email: email ?? oldContact.email,
    countryCode: countryCode ?? oldContact.countryCode,
    phoneNumber: phoneNumber ?? oldContact.phoneNumber,
    photoURL: photoUrl ?? oldContact.photoURL,
    addresses: <String, dynamic>{'Home': homeAddress ?? ''},
    about: about ?? oldContact.about,
    other: other ?? oldContact.other,
    status: status ?? oldContact.status,
    group: oldContact.group,
  );

  await db.setContact(currentUser.uid, contact);

  return contact;
}

// Generate a contact from a profile, to display in contact sheet ; beware uid is set to profile.uid -> need to be changed
Contact contactFromProfile(Profile profile, {String? uid}) {
  return Contact(
    cid: profile.uid,
    uid: uid ?? profile.uid,
    displayName: profile.displayName,
    firstName: profile.firstName,
    lastName: profile.lastName,
    email: profile.email,
    countryCode: profile.countryCode,
    phoneNumber: profile.phoneNumber,
    photoURL: profile.photoURL,
    addresses: profile.addresses,
    about: profile.about,
    other: EMPTY_MAP,
    group: EMPTY_MAP,
    status: CONTACT_PROFILE,
  );
}

// Group contact functions : create
Future<Contact> createNewGroupContact(User currentUser, {required String displayName, String? photoURL, String? about}) async {
  Contact contact = Contact(
    cid: cidGenerator(),
    uid: currentUser.uid,
    displayName: displayName,
    firstName: '',
    lastName: '',
    email: '',
    countryCode: 'NA',
    phoneNumber: '',
    photoURL: photoURL ?? 'https://i2.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/07/new-google-groups-logo.png?ssl=1',
    addresses: <String, dynamic>{'Home': ''},
    about: about ?? '',
    other: <String, dynamic>{},
    group: <String, dynamic>{},
    status: CONTACT_GROUP,
  );

  await FirestoreDB(uid: currentUser.uid).setContact(currentUser.uid, contact);

  return contact;
}

/* GROUP CONTACT FUCNTIONS*/

// Group contact functions : update a group contact
Future<Contact> updateGroupContact(User currentUser, String cid, {String? displayName, String? photoURL, String? about}) async {
  Contact contact = await updatePrivateContact(currentUser, cid, displayName: displayName, photoUrl: photoURL, about: about);
  await FirestoreDB(uid: currentUser.uid).setContact(currentUser.uid, contact);
  return contact;
}

// Group contact functions : add one or more contacts, returns the group as contact
Future<Contact> addToGroup(User currentUser, String cid, {String? contactCid, List<String>? contactListCids}) async {
  Contact group = await getContact(currentUser, cid: cid);
  if(contactCid != null) {
    Contact contact = await getContact(currentUser, cid: contactCid);
    group.group.addAll(<String, dynamic>{contact.cid: contact.displayName});
  }
  if(contactListCids != null) {
    for(String contactCid in contactListCids) {
      Contact contact = await getContact(currentUser, cid: contactCid);
      group.group.addAll(<String, dynamic>{contact.cid: contact.displayName});
    }
  }
  await FirestoreDB(uid: currentUser.uid).setContact(currentUser.uid, group);
  return group;
}

// Group contact functions : remove one or more contacts, returns the group as contact
Future<Contact> removeFromGroup(User currentUser, String cid, {String? contactCid, List<String>? contactListCids}) async {
  Contact group = await getContact(currentUser, cid: cid);
  if(contactCid != null) {
    if(group.group.containsKey(contactCid)) {
      group.group.remove(contactCid);
    }
  }
  if(contactListCids != null) {
    for(String contactCid in contactListCids) {
      if(group.group.containsKey(contactCid)) {
        group.group.remove(contactCid);
      }
    }
  }
  await FirestoreDB(uid: currentUser.uid).setContact(currentUser.uid, group);
  return group;
}

/* INVITE CONTACT FUNCTIONS*/

// Invite a profile, send an invitation
Future<void> inviteProfile(User currentUser, {required String uid}) async {
  Database db = FirestoreDB(uid: currentUser.uid);

  // Add an invited contact to current user
  Contact invited = contactFromProfile((await db.getProfile(uid))!, uid: currentUser.uid);
  invited.status = CONTACT_INVITED; // change status to invited contact
  await db.setContact(currentUser.uid, invited);

  // Add an invitation to invited profile
  Contact invitation = contactFromProfile(await getUserProfile(currentUser), uid: uid);
  invitation.status = CONTACT_INVITATION; // change status to invitation contact
  await db.setContact(uid, invitation);
}

Future<void> respondProfile(User currentUser, {required String cid, required bool accept}) async {
  Database db = FirestoreDB(uid: currentUser.uid);
  if (accept) { // Accepted invitation
    // Convert invitation into a contact
    Contact invitation = await db.getContact(currentUser.uid, cid);
    if (invitation.status == CONTACT_INVITATION) {
      invitation.status = CONTACT_CONFIRMED; // change to MMY Profile contact
      await db.setContact(currentUser.uid, invitation);
    }

    // Convert invited contact of profile sending invitation into a profile contact
    Contact invited = await db.getContact(cid, currentUser.uid);
    if (invited.status == CONTACT_INVITED) {
      invited.status = CONTACT_CONFIRMED; // change to MMY Profile contact
      await db.setContact(cid, invited);
    }
  } else {
    // Delete invitation
    Contact invitation = await db.getContact(currentUser.uid, cid);
    if (invitation.status == CONTACT_INVITATION) {
      invitation.status = CONTACT_REJECTED; // change to a rejected contact
      await db.setContact(currentUser.uid, invitation);
    }
    // Convert invited contact to rejected contact
    /*Contact invited = await db.getContact(cid, currentUser.uid);
    if (invited.status == CONTACT_INVITED) {
      invited.status = CONTACT_REJECTED; // change to a rejected contact
      await db.setContact(currentUser.uid, invitation);
    }*/
  }
}

// Linking two profile - happens when one invites the second one to an event, they become linked
Future<void> linkProfiles(User currentUser, {required String uid,}) async {
  Database db = FirestoreDB(uid: currentUser.uid);
  Contact contact1 = contactFromProfile((await db.getProfile(uid))!, uid: currentUser.uid);
  Contact contact2 = contactFromProfile((await db.getProfile(currentUser.uid))!, uid: uid);
  await db.setContact(currentUser.uid, contact1);
  await db.setContact(contact1.uid, contact2);
}

Future<List<Contact>> getPhoneContacts(User currentUser) async {
  print('importing');
  List<Contact> phoneContactList = [];
  Iterable<Phone.Contact> phoneContacts;

  if (await Permission.contacts.request().isGranted) {
    // Get all contacts on device
    phoneContacts = await Phone.ContactsService.getContacts();

    for (Phone.Contact phoneContact in phoneContacts) {
      if(phoneContact.displayName != null && (phoneContact.emails!.length>0)) {
        Contact contact = createLocalContact(currentUser);
        contact.displayName = phoneContact.displayName!;
        contact.email = phoneContact.emails!.first.value!;
        if(phoneContact.phones!.length>0)
          contact.phoneNumber = phoneContact.phones!.first.value!;
        contact.countryCode = '';
        phoneContactList.add(contact);
      }
    }
  } else {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.contacts,
    ].request();
    //throw('No access to phone contacts');
  }
  return phoneContactList;
}