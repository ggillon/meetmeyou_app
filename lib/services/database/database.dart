// Flutter imports

// Service imports


import 'package:meetmeyou_app/models/event_answer.dart';
import 'package:meetmeyou_app/models/event_chat_message.dart';

import 'firestore_service.dart';
import 'api_path.dart';

//Data models import
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/event.dart';


abstract class Database {

  String get userID;

  // Profile DB Functions
  Future<void> setProfile(Profile profile);
  Future<Profile?> getProfile(String uid);
  Future<void> deleteProfile(String uid);
  Future<List<Profile>> queryProfiles({required String field, required String query});

  // Contact DB Functions
  Future<void> setContact(String uid, Contact contact);
  Future<Contact> getContact(String uid, String cid);
  Future<void> deleteContact(String uid, String cid);
  Future<List<Contact>> getContacts(String uid);

  // Event DB Functions
  Future<void> setEvent(Event event);
  Future<Event> getEvent(String eid);
  Future<void> deleteEvent(String eid);
  Future<List<Event>> getUserEvents(String uid);

  // Event Message Functions
  Future<void> setMessage(String eid, EventChatMessage message);
  Future<List<EventChatMessage>> getMessages(String eid,);

  // Event Message Functions
  Future<void> setAnswer(String eid, String uid, EventAnswer answer);
  Future<List<EventAnswer>> getAnswers(String eid,);
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
    return await _service.getData(
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
  Future<void> setContact(String uid, Contact contact) async {
    _service.setData(
      path: APIPath.userContact(uid, contact.cid),
      data: contact.toMap(),
    );
  }

  Future<Contact> getContact(String uid, String cid) async {
    return _service.getData(
      path: APIPath.userContact(uid, cid),
      builder: (data) {return Contact.fromMap(data);},
    );
  }

  Future<List<Contact>> getContacts(String uid,) {
    return _service.getListData(
        path: APIPath.userContacts(uid),
        builder: (data) => Contact.fromMap(data)
    );
  }

  Future<void> deleteContact(String uid, String cid) async {
    _service.deleteData(path: APIPath.userContact(uid, cid));
  }

  // EVENT METHODS
  Future<void> setEvent(Event event) async {
    _service.setData(
      path: APIPath.event(event.eid),
      data: event.toMap(),
    );
  }

  Future<Event> getEvent(String eid) async {
    return await _service.getData(
      path: APIPath.event(eid),
      builder: (data) {return Event.fromMap(data);},
    );
  }

  Future<void> deleteEvent(String eid,) async {
    _service.deleteData(path: APIPath.event(eid));
  }

  Future<List<Event>> getUserEvents(String uid) async {
    return _service.collectionStreamWhereFieldPresent(
        path: APIPath.events(),
        field: 'invitedContacts.$uid',
        builder: (data) {
          return Event.fromMap(data);
        }).first;
    /*return await _service.getListDataWhere(
      path: APIPath.events(),
      field: 'invitedContacts.$eid',
      value: 'query',
      builder: (data) {
        return Profile.fromMap(data);
      },
    );*/
  }

  @override
  Future<List<EventChatMessage>> getMessages(String eid) {
    return _service.getListData(
        path: APIPath.userContacts(uid),
        builder: (data) => EventChatMessage.fromMap(data),
    );
  }

  @override
  Future<void> setMessage(String eid, EventChatMessage message) async {
    _service.setData(
      path: APIPath.message(eid, message.mid),
      data: message.toMap(),
    );
  }

  @override
  Future<List<EventAnswer>> getAnswers(String eid) {
    return _service.getListData(
      path: APIPath.answers(eid),
      builder: (data) => EventAnswer.fromMap(data),
    );
  }

  @override
  Future<void> setAnswer(String eid, String uid, EventAnswer answer) async {
    _service.setData(
      path: APIPath.answer(eid, uid),
      data: answer.toMap(),
    );
  }


}
