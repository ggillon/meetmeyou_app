import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'dart:io';
import 'profile.dart' as profileLib;
import 'contact.dart' as contactLib;
import 'event.dart' as eventLib;
import 'event_answer.dart' as answerLib;
import 'package:meetmeyou_app/services/calendar/calendar.dart' as calendarLib;
import 'package:meetmeyou_app/services/storage/storage.dart' as storageLib;
import 'event_chat_message.dart' as messageLib;
import 'date_option.dart' as dateLib;
import 'discussion.dart' as discussionLib;
import 'search.dart' as searchLib;
import 'notification.dart' as notificationLib;

abstract class MMYCreatorEngine {

  /// Create a Public Event
  Future<Event> createPublicEvent({required String title, required String location, required String description, String? photoURL, File? photoFile, String? website, required DateTime start, DateTime? end,});
  /// Update a Public Event
  Future<Event> updatePublicEvent(String eid, {String? title, String? location, String? description, String? photoURL, String? website, File? photoFile, DateTime? start, DateTime? end,});
  /// Create a Public Event
  Future<Event> createLocationEvent({required String title, required String location, required String description, String? photoURL, File? photoFile, String? website, DateTime? start, DateTime? end,});
  /// Update a Location Event
  Future<Event> updateLocationEvent(String eid, {String? title, String? location, String? description, String? photoURL, String? website, File? photoFile, DateTime? start, DateTime? end,});
  /// Get Public Events of User
  Future<List<Event>> getUserPublicEvents();
  /// Get Public Events of User
  Future<List<Event>> getUserLocationEvents();

}

class MMYCreator implements MMYCreatorEngine {
  MMYCreator(this._currentUser);
  final User _currentUser;

  @override
  Future<Event> createPublicEvent({required String title, required String location, required String description, String? photoURL, File? photoFile, String? website, required DateTime start, DateTime? end,}) async {
    Event event = await eventLib.updateEvent(_currentUser, null, title: title, location: location, description: description, photoURL: photoURL, start: start, end: end, website: website, eventType: EVENT_TYPE_PUBLIC);
    if (photoFile!=null) {
      photoURL = await storageLib.storeEventPicture(photoFile, eid: event.eid);
      event = await updatePublicEvent(event.eid, photoURL: photoURL);
    }
    return event;
  }

  @override
  Future<Event> updatePublicEvent(String eid, {String? title, String? location, String? description, String? photoURL, String? website, File? photoFile, DateTime? start, DateTime? end,}) async {
    if(photoFile!=null)
      photoURL = await storageLib.storeEventPicture(photoFile, eid: eid);
    Event result = await eventLib.updateEvent(_currentUser, eid, title: title, location: location, description: description, photoURL: photoURL, start: start, end: end, website: website, eventType: EVENT_TYPE_PUBLIC);;
    notificationLib.notifyEventModified(_currentUser, result.eid,);
    return result;
  }

  @override
  Future<Event> createLocationEvent({required String title, required String location, required String description, String? photoURL, File? photoFile, String? website, DateTime? start, DateTime? end,}) async {
    Event event = await eventLib.updateEvent(_currentUser, null, title: title, location: location, description: description, photoURL: photoURL, start: start, end: end, website: website, eventType: EVENT_TYPE_LOCATION);
    if (photoFile!=null) {
      photoURL = await storageLib.storeEventPicture(photoFile, eid: event.eid);
      event = await updatePublicEvent(event.eid, photoURL: photoURL);
    }
    return event;
  }

  @override
  Future<Event> updateLocationEvent(String eid, {String? title, String? location, String? description, String? photoURL, String? website, File? photoFile, DateTime? start, DateTime? end,}) async {
    if(photoFile!=null)
      photoURL = await storageLib.storeEventPicture(photoFile, eid: eid);
    Event result = await eventLib.updateEvent(_currentUser, eid, title: title, location: location, description: description, photoURL: photoURL, start: start, end: end, website: website, eventType: EVENT_TYPE_LOCATION);;
    notificationLib.notifyEventModified(_currentUser, result.eid,);
    return result;
  }

  @override
  Future<List<Event>> getUserPublicEvents() async {
    List<Event> events = await eventLib.getUserEvents(_currentUser, filters: null);
    events.retainWhere((element) => element.eventType == EVENT_TYPE_PUBLIC);
    return events;
  }

  @override
  Future<List<Event>> getUserLocationEvents() async {
    List<Event> events = await eventLib.getUserEvents(_currentUser, filters: null);
    events.retainWhere((element) => element.eventType == EVENT_TYPE_LOCATION);
    return events;
  }

}