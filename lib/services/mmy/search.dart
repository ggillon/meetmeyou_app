import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/search_result.dart';
import 'contact.dart' as contactLib;

import '../../models/contact.dart';
import '../../models/event.dart';
import '../../models/profile.dart';
import '../database/database.dart';
import 'contact.dart';

const FIELD_ALL = ['displayName', 'firstName', 'lastName', 'email', 'phoneNumber'];
const FIELD_DISPLAY_NAME = 'displayName';
const FIELD_FIRST_NAME = 'firstName';
const FIELD_LAST_NAME = 'lastName';
const FIELD_EMAIL = 'email';
const FIELD_PHONE_NUMBER = 'phoneNumber';

const EVENT_FIELD_ALL = ['title', 'organiser', 'location', 'description',];


Future<SearchResult> search(User currentUser, String searchText) async {
  SearchResult result = SearchResult();
  result.contacts = await searchProfiles(currentUser, searchText: searchText);
  List<Event> eventList = await searchEvents(currentUser, searchText);
  for(Event event in eventList) {
    if (event.eventType == EVENT_TYPE_PUBLIC) {
      result.events.add(event);
    } else {
      if (event.invitedContacts.containsKey(currentUser.uid)) {
        result.events.add(event);
      }
    }
  }
  return result;
}

Future<List<Event>> searchEvents(User currentUser, String searchText) async {
  List<Event> results = [];
  if (searchText.length < 4) // empty search for basic 3 letter words
    return results;
  Database db = await FirestoreDB(uid: currentUser.uid);
  final searchWords = searchText.split(" ");
  final searchFields = EVENT_FIELD_ALL;
  for (String field in searchFields) {
    for (var value in searchWords) {
      if (value.isNotEmpty) {
        final queryList = await db.queryEvents(field: field, query: value);
        results = results + queryList;
      }
    }
  }
  return results;
}

Future<List<Contact>> searchProfiles(User currentUser, {required String searchText, List<String> searchFields = FIELD_ALL, bool split=true }) async {
  List<Contact> results = [];
  List<Profile> profiles = [];
  Database db = await FirestoreDB(uid: currentUser.uid);
  final searchWords = split ? searchText.split(" ") : [searchText];

  List<String> confirmedList = [];
  List<String> invitedList = [];
  for(Contact contact in await getContacts(currentUser)) {
    if(contact.status == CONTACT_CONFIRMED) confirmedList.add(contact.cid);
    if(contact.status == CONTACT_INVITED) invitedList.add(contact.cid);
  }

  for (String field in searchFields) {
    for (var value in searchWords) {
      if (value.isNotEmpty) {
        final queryList = await db.queryProfiles(field: field, query: value);
        profiles = profiles + queryList;
      }
    }
  }
  for (Profile profile in profiles) {
    if(profile.uid != currentUser.uid) {
      Contact contact = contactLib.contactFromProfile(profile, uid: profile.uid);
      if (confirmedList.contains(contact.cid)) contact.status = CONTACT_CONFIRMED;
      if (invitedList.contains(contact.cid)) contact.status = CONTACT_INVITED;
      results.add(contact);
    }
  }
  return results;
}

Future<List<Contact>> searchContactMatch(User currentUser, Contact contact) async {
  List<Contact> results = [];
  results.addAll(await searchProfiles(currentUser, searchText: contact.email, searchFields: [FIELD_EMAIL], split: false));
  results.addAll(await searchProfiles(currentUser, searchText: contact.phoneNumber, searchFields: [FIELD_PHONE_NUMBER], split: false));
  results.addAll(await searchProfiles(currentUser, searchText: contact.displayName, searchFields: [FIELD_LAST_NAME], split: true));
  return results;
}

Future<List<Contact>> matchContactsToDBProfiles(User currentUser, List<Contact> contacts) async {
  List<Contact> results = [];
  List<Contact> searchList = [];
  final futureGroup = FutureGroup<List<Contact>>();
  for(Contact contact in contacts) {
    futureGroup.add(searchContactMatch(currentUser, contact));
  }
  futureGroup.close();
  for(List<Contact> listResult in (await futureGroup.future)) {
    searchList.addAll(listResult);
  }
  List<String> UIDs = [];
  for(Contact contact in searchList) {
    if (contact.cid != currentUser.uid) {
      if (!UIDs.contains(contact.cid)) {
        results.add(contact);
        UIDs.add(contact.cid);
      }
    };
  }
  return results;
}

