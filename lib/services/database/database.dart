// Flutter imports

// Service imports


import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/discussion.dart';
import 'package:meetmeyou_app/models/discussion_message.dart';
import 'package:meetmeyou_app/models/event_answer.dart';
import 'package:meetmeyou_app/models/event_chat_message.dart';
import 'package:meetmeyou_app/models/mmy_calendar.dart';
import 'package:meetmeyou_app/models/mmy_notification.dart';
import 'package:meetmeyou_app/models/photo_album.dart';
import 'package:meetmeyou_app/services/mmy/event.dart';
import 'package:meetmeyou_app/services/mmy/idgen.dart';

import '../../models/photo.dart';
import 'firestore_service.dart';
import 'api_path.dart';

//Data models import
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/event.dart';


abstract class Database {

  String get userID;

  // debug message
  void debugMsg(String uid, String text, Map? attachment);

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
  Future<List<Event>> queryEvents({required String field, required String query});

  // Event Message Functions
  Future<void> setMessage(String eid, EventChatMessage message);
  Future<List<EventChatMessage>> getMessages(String eid,);

  // Event Form Functions
  Future<void> setAnswer(String eid, String uid, EventAnswer answer);
  Future<List<EventAnswer>> getAnswers(String eid,);

  // Event MultipleDates Functions
  Future<DateOption> getDateOption(String eid, String did,);
  Future<List<DateOption>> getAllDateOptions(String eid,);
  Future<void> setDateOption(String eid, DateOption date);
  Future<void> deleteDateOption(String eid, String did);

  //Discussion & Message Functions
  Future<Discussion> getDiscussion(String did);
  Future<List<Discussion>> getUserDiscussions(String uid);
  Future<void> setDiscussion(Discussion discussion);
  Future<void> deleteDiscussion(String did);
  Future<List<DiscussionMessage>> getDiscussionMessages(String did);
  Stream<List<DiscussionMessage>> getDiscussionMessagesStream(String did);
  Future<void> setDiscussionMessage(DiscussionMessage message);
  Future<void> deleteDiscussionMessage(String did, String mid);

  // Notifications Functions
  Future<void> setNotification(MMYNotification notification);
  Future<void> setUserToken(String token);
  Future<String> getUserToken(String uid);
  Future<List<MMYNotification>> getUserNotifications(String uid);

  // PhotoAlbum Functions
  Future<void> setPhotoAlbum(MMYPhotoAlbum album);
  Future<MMYPhotoAlbum> getPhotoAlbum(String aid);
  Future<void> setPhoto(MMYPhoto photo);
  Future<void> deletePhoto(String aid, String pid);

  // MMYCalendar
  Future<void> setCalendar(MMYCalendar calendar);
  Future<MMYCalendar> getCalendar(String uid);
  Future<void> deleteCalendar(String uid);
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
    return _service.getListDataWhereFieldIsPresent(
        path: APIPath.events(),
        field: 'invitedContacts.$uid',
        builder: (data) {
          return Event.fromMap(data);
        });
  }

  Future<List<Event>> queryEvents({required String field, required String query}) async {
    return await _service.getListDataWhere(
      path: APIPath.events(),
      field: field,
      value: query,
      builder: (data) {
        return Event.fromMap(data);
      },
    );
  }

  @override
  Future<List<EventChatMessage>> getMessages(String eid) {
    return _service.getListData(
      path: APIPath.messages(eid),
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

  @override
  Future<List<DateOption>> getAllDateOptions(String eid) {
    return _service.getListData(
      path: APIPath.eventDates(eid),
      builder: (data) => DateOption.fromMap(data),
    );
  }

  @override
  Future<DateOption> getDateOption(String eid, String did) async {
    return _service.getData(
      path: APIPath.eventDate(eid, did),
      builder: (data) {return DateOption.fromMap(data);},
    );
  }

  @override
  Future<void> setDateOption(String eid, DateOption date) async {
    _service.setData(
      path: APIPath.eventDate(eid, date.did),
      data: date.toMap(),
    );
  }

  @override
  Future<void> deleteDateOption(String eid, String did) async {
    _service.deleteData(
      path: APIPath.eventDate(eid, did),
    );
  }

  @override
  Future<void> deleteDiscussion(String did) async {
    _service.deleteData(
      path: APIPath.discussion(did),
    );
  }

  @override
  Future<void> deleteDiscussionMessage(String did, String mid) async {
    _service.deleteData(
      path: APIPath.discussionMessage(did, mid),
    );
  }

  @override
  Future<Discussion> getDiscussion(String did) {
    return _service.getData(
      path: APIPath.discussion(did),
      builder: (data) {return Discussion.fromMap(data);},
    );
  }

  @override
  Future<List<DiscussionMessage>> getDiscussionMessages(String did) {
    return _service.getListData(
      path: APIPath.discussionMessages(did),
      builder: (data) => DiscussionMessage.fromMap(data),
    );
  }

  @override
  Stream<List<DiscussionMessage>> getDiscussionMessagesStream(String did) {
    return _service.collectionStream(
        path: APIPath.discussionMessages(did),
        builder: (data) => DiscussionMessage.fromMap(data));
  }

  @override
  Future<void> setDiscussion(Discussion discussion) async {
    _service.setData(
      path: APIPath.discussion(discussion.did,),
      data: discussion.toMap(),
    );
  }

  @override
  Future<void> setDiscussionMessage(DiscussionMessage message) async {
    _service.setData(
      path: APIPath.discussionMessage(message.did, message.mid,),
      data: message.toMap(),
    );
  }

  @override
  Future<List<Discussion>> getUserDiscussions(String uid) {
    return _service.getListDataWhereFieldIsPresent(
        path: APIPath.discussions(),
        field: 'participants.$uid',
        builder: (data) {
          return Discussion.fromMap(data);
        });
  }

  @override
  Future<void> setNotification(MMYNotification notification) async {
    _service.setData(
      path: APIPath.notification(notification.nid),
      data: notification.toMap(),
    );
  }

  @override
  Future<String> getUserToken(String uid) async {
    String token = '';
    Profile? profile = await getProfile(uid);
    if(profile!.parameters.containsKey('token')) {
      token = profile.parameters['token'];
    }
    return token;
  }

  @override
  Future<void> setUserToken(String token) async {
    Profile? profile = await getProfile(uid);
    profile!.parameters['token'] = token;
    await setProfile(profile);
  }

  @override
  Future<List<MMYNotification>> getUserNotifications(String uid) {
    return _service.getListDataWhere(
        path: APIPath.notifications(),
        field: 'uid',
        value: uid,
        builder: (data) {
          return MMYNotification.fromMap(data);
        });
  }

  @override
  void debugMsg(String uid, String text, Map? attachment) {
    String did = idGenerator();
    Map<String, dynamic> data = {
      'uid': uid, 'did': did, 'timeStamp': DateTime.now(), 'message': text, 'attachment': attachment
    };
    _service.setData(path: '/debug/$uid/messages/$did/', data: data);
  }

  @override
  Future<void> deletePhoto(String aid, String pid) async {
    _service.deleteData(
      path: APIPath.photo(aid, pid),
    );
  }

  @override
  Future<MMYPhotoAlbum> getPhotoAlbum(String aid) async {
    MMYPhotoAlbum album = await _service.getData(
      path: APIPath.photoAlbum(aid),
      builder: (data) {return MMYPhotoAlbum.fromMap(data);},
    );
    album.photos =  await _service.getListData(
        path: APIPath.photos(aid),
        builder: (data) {return MMYPhoto.fromMap(data);});
    return album;
  }

  @override
  Future<void> setPhoto(MMYPhoto photo) async {
    _service.setData(path: APIPath.photo(photo.aid, photo.pid), data: photo.toMap());
  }

  @override
  Future<void> setPhotoAlbum(MMYPhotoAlbum album) async {
    _service.setData(path: APIPath.photoAlbum(album.aid), data: album.toMap());
  }

  @override
  Future<void> deleteCalendar(String uid) async {
    _service.deleteData(path: APIPath.calendar(uid));
  }

  @override
  Future<MMYCalendar> getCalendar(String uid) async {
    return _service.getData(path: APIPath.calendar(uid), builder: (data) {return MMYCalendar.fromMap(data);});
  }

  @override
  Future<void> setCalendar(MMYCalendar calendar) async {
    _service.setData(path: APIPath.calendar(uid), data: calendar.toMap());
  }

}
