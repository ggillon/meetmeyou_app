
import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/models/constants.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event_answer.dart';
import 'package:meetmeyou_app/models/event_chat_message.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/calendar_event.dart';
import 'package:meetmeyou_app/services/database/database.dart';
import 'package:meetmeyou_app/services/email/email.dart';
import 'dart:io';
import '../../models/discussion.dart';
import '../../models/discussion_message.dart';
import '../../models/mmy_notification.dart';
import '../../models/search_result.dart';
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


abstract class MMYEngine {

  /// PROFILE ///

  /// Get the user profile or create new one
  Future<Profile> getUserProfile({bool user = true, String? uid});
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
  /// Set a parameter
  Future<Profile> setUserParameter(String param, dynamic value);

  /// CONTACT ///

  /// Get a contact, invitation or group from DB
  Future<Contact> getContact(String cid);
  /// Get a contact from a profile reference;
  Future<Contact?> getContactFromProfile(String uid);
  /// Delete contact
  Future<void> deleteContact(String cid);
  /// Get all contacts from contact list
  Future<List<Contact>> getContacts({bool confirmedContacts=false, bool groups=false, bool invitedContacts=false, bool invitations=false, bool rejectedContacts=false});
  /// Get all groups from contact list
  Future<List<String>> getContactIDs({bool confirmedContacts=false, bool groups=false, bool invitedContacts=false, bool invitations=false, bool rejectedContacts=false});
  /// Invite a Profile from DB
  Future<void> inviteProfile(String uid);
  /// Accept an invitation
  Future<void> respondInvitation(String cid, bool accept);
  /// Number of unresponded invites
  Future<int> unrespondedInvites();
  /// Create a Group of contacts
  Future<Contact> newGroupContact(String name, {String photoURL, String about, File? photoFile});
  /// Update a Group of contacts
  Future<Contact> updateGroupContact(String cid, {String? displayName, String? photoURL, File? photoFile, String? about});
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

  /// EVENT ///

  /// Get all Events where user is invited or organiser
  Future<List<Event>> getUserEvents({List<String>? filters});
  /// Get all Events where user is organiser
  Future<List<Event>> getOrganisedEvents();
  /// Get a particular Event
  Future<Event> getEvent(String eid);
  /// Create an event
  Future<Event> createEvent({required String title, required String location, required String description, required String photoURL, File? photoFile, DateTime? start, DateTime? end, List<DateTime>? startDateOptions, List<DateTime>? endDateOptions});
  /// Update an event
  Future<Event> updateEvent(String eid, {String? title, String? location, String? description, String? photoURL, File? photoFile, DateTime? start, DateTime? end, List<DateOption>? multipleDates});
  /// Get status of user
  Future<String> eventUserStatus(String eid);
  /// Cancel an event
  Future<Event> cancelEvent(String eid);
  /// Delete an event
  Future<void> deleteEvent(String eid);
  /// Get even link
  String getEventLink(String eid);
  /// Get even text
  String getEventText(String eid);
  /// Handle Link Event
  Future<void>inviteURL(String eid);
  /// Invite contact to event
  Future<Event> inviteContactsToEvent(String eid, {required List<String> CIDs});
  /// Invite group to event
  Future<Event> inviteGroupsToEvent(String eid, {required List<String> CIDs});
  /// Remove contact from event
  Future<Event> removeContactsFromEvent(String eid, {required List<String> CIDs});
  /// Invite group to event
  Future<Event> removeGroupsFromEvent(String eid, {required List<String> CIDs});
  /// Check if all Group members are invited
  Future<bool> isGroupInvited(String eid, String cid);
  /// Reply to event
  Future<void> replyToEvent(String eid, {required String response});
  /// Number of unresponded events
  Future<int> unrespondedEvents();


  /// Add a date option to event
  Future<String> addDateToEvent(String eid, {required DateTime start, required DateTime end});
  /// Remove a date from an event
  Future<void> removeDateFromEvent(String eid, String did);
  /// Get all dates options from an event (in date start order)
  Future<List<DateOption>> getDateOptionsFromEvent(String eid);
  /// Answer a date attendance for an event
  Future<Event> answerDateOption(String eid, String did, bool attend);
  /// Get status of dateOption for an event date
  Future<bool> dateOptionStatus(String eid, String did);
  /// Get list of dates selected
  Future<List<String>> listDateSelected(String eid);
  /// Select final date for an event
  Future<Event> selectFinalDate(String eid, String did);

  ///  Add/Update a form to an event
  //Future<Event> updateFormToEvent(String eid, {required String formText, required Map form});
  ///  Add a question to an event (does not save the event)
  Future<Event> addQuestionToEvent(Event event, {required questionNum, required String text});
  ///  Reply to form to an event
  Future<EventAnswer> answerEventForm(String eid, {required Map answers});
  ///  List answers to form
  Future<List<EventAnswer>> emailEventAnswers(String eid);

  /// CALENDAR FUNCTIONS
  /// Get the CalendarEvents from mobile or web calendar
  Future<List<CalendarEvent>> getCalendarEvents(BuildContext context);
  /// Set the parameters for calender
  Future<void> setCalendarParams({required bool sync, required bool display});
  /// Get the parameters for calendar
  Future<Map<String, dynamic>> getCalendarParams();

  /// Event Message functions
  /// Get all the chat messages from Event
  Future<List<EventChatMessage>> getEventChatMessages(String eid);
  /// Post a new mchat message to Event
  Future<EventChatMessage> postEventChatMessage(String eid, {required String text});

  /// Discussion Functions
  /// Retreive an discussion you're part of
  Future<Discussion> getDiscussion(String did);
  /// Access Discussion of Event (retreive or join it)
  Future<Discussion> getEventDiscussion(String eid);
  /// Post a message in a discussion
  Future<void> postDiscussionMessage(String did, {String type=TEXT_MESSAGE, required String text, File? photoFile, String? replyMid});
  /// Get List of discussion
  Future<List<Discussion>> getUserDiscussions();
  /// Start Discussion between contacts or a groups
  Future<Discussion> startContactDiscussion(String cid);
  /// Start Discussion between contacts or a groups
  Future<Discussion> startGroupDiscussion(List<String> CIDs);
  /// Leave a discussion
  Future<void> leaveDiscussion(String did);
  /// Add user to discussion
  Future<void> addContactToDiscussion(String did, {required String cid});
  /// Remove user from discussion
  Future<void> removeContactFromDiscussion(String did, {required String cid});
  /// Change title of discussion
  Future<Discussion> updateDiscussion(String did, {String? title, File? photo});
  /// Change title of discussion
  Future<int> updatedDiscussions();

  /// Search
  Future<SearchResult> search(String searchText);

  /// NOTIFICATION
  Future<List<MMYNotification>> getUserNotification();

}

class MMY implements MMYEngine {
  /// Creates a MMYEngine class with access to features

  MMY(this._currentUser);
  final User _currentUser;

  @override
  Future<Profile> getUserProfile({bool user = true, String? uid}) async{
    Profile profile = await profileLib.getUserProfile(_currentUser, user: user, uid: uid);
    await notificationLib.setToken(_currentUser); // set token for notification
    return profile;
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
  Future<Profile> setUserParameter(String param, dynamic value) async {
    return await profileLib.setProfileParameter(_currentUser, param: param, value: value);
  }

  @override
  Future<Contact> newGroupContact(String name, {String photoURL = contactLib.GROUP_PHOTOURL, File? photoFile, String about = ''}) async {
    if (photoFile!=null)
      photoURL = await storageLib.storeProfilePicture(photoFile, uid: _currentUser.uid);
    final contact =  await contactLib.createNewGroupContact(_currentUser, displayName: name);
    return contactLib.updateGroupContact(_currentUser, contact.cid,photoURL: photoURL, about: about);
  }

  @override
  Future<Contact> getContact(String cid) async {
     return contactLib.getContact(_currentUser, cid: cid);
  }

  @override
  Future<Contact?> getContactFromProfile(String uid) {
    return contactLib.getContactFromProfile(_currentUser, uid: uid);
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
  Future<void> inviteProfile(String uid) async {
    contactLib.inviteProfile(_currentUser, uid: uid);
    notificationLib.notifyContactInvite(_currentUser, uid);
  }

  @override
  Future<Contact> updateGroupContact(String cid, {String? displayName, String? photoURL, File? photoFile, String? about}) async {
    if (photoFile!=null)
      photoURL = await storageLib.storeProfilePicture(photoFile, uid: _currentUser.uid);
    return contactLib.updateGroupContact(_currentUser, cid, displayName: displayName, photoURL: photoURL, about: about);
  }

  @override
  Future<void> respondInvitation(String cid, bool accept) {
    return contactLib.respondProfile(_currentUser, cid: cid, accept: accept);
  }

  @override
  Future<int> unrespondedInvites() async {
    int i=0;
    for (Contact contact in await contactLib.getContacts(_currentUser)) {
      if(contact.status == CONTACT_INVITATION) i++; }
    return i;
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
    List<Contact> searchList = [];
    List<String> contactListID = await getContactIDs(confirmedContacts: true);
    List<String> invitedListID = await getContactIDs(invitedContacts: true);
    for(Profile profile in await profileLib.searchProfiles(_currentUser, searchText: searchText)) {
      if(profile.uid != _currentUser.uid) {
        Contact contact = contactLib.contactFromProfile(profile, uid: profile.uid);
        if (contactListID.contains(contact.cid)) contact.status = CONTACT_CONFIRMED;
        if (invitedListID.contains(contact.cid)) contact.status = CONTACT_INVITED;
        searchList.add(contact);
      }
    }
    return searchList;
  }

  @override
  Future<List<Contact>> getPhoneContacts() async {
    List<Contact> phoneContacts = await contactLib.getPhoneContacts(_currentUser);
    return searchLib.matchContactsToDBProfiles(_currentUser, phoneContacts);
  }

  @override
  Future<void> invitePhoneContacts(List<Contact> contacts) async {
    for(Contact contact in contacts) inviteProfile(contact.cid);
  }

  @override
  Future<List<Event>> getUserEvents({List<String>? filters}) {
    return eventLib.getUserEvents(_currentUser, filters: filters);
  }

  @override
  Future<List<Event>> getOrganisedEvents() {
    return eventLib.getUserEvents(_currentUser, filters: [EVENT_ORGANISER]);
  }

  @override
  Future<Event> createEvent({required String title, required String location, required String description, required String photoURL, File? photoFile, DateTime? start, DateTime? end, List<DateTime>? startDateOptions, List<DateTime>? endDateOptions}) async {
    Event event = await eventLib.updateEvent(_currentUser, null, title: title, location: location, description: description, photoURL: photoURL, start: start ?? startDateOptions!.first, end: end ?? endDateOptions!.last);
    if(startDateOptions != null && endDateOptions != null) {
      for(int i=0; i<startDateOptions.length; i++) {
        await dateLib.addDateToEvent(_currentUser, event.eid, startDateOptions[i], endDateOptions[i]);
      }
    }
    if (photoFile!=null) {
      photoURL = await storageLib.storeEventPicture(photoFile, eid: event.eid);
      event = await updateEvent(event.eid, photoURL: photoURL);
    }
    return event;
  }

  @override
  Future<Event> cancelEvent(String eid) async {
    notificationLib.notifyEventCanceled(_currentUser, eid);
    return await eventLib.cancelEvent(_currentUser, eid);
  }

  @override
  Future<void> deleteEvent(String eid) async {
    await eventLib.deleteEvent(_currentUser, eid);
  }

  @override
  Future<Event> getEvent(String eid) async {
    return await eventLib.getEvent(_currentUser, eid);
  }

  @override
  Future<String> eventUserStatus(String eid) async {
     return (await eventLib.getEvent(_currentUser, eid)).invitedContacts[_currentUser.uid];
  }

  @override
  Future<Event> inviteContactsToEvent(String eid, {required List<String> CIDs}) async {
    for(String cid in CIDs) notificationLib.notifyEventInvite(_currentUser, eid, cid);
    return await eventLib.updateInvitations(_currentUser, eid,
        eventLib.Invitations(CIDs: CIDs, inviteStatus: EVENT_INVITED));
  }

  @override
  Future<Event> inviteGroupsToEvent(String eid, {required List<String> CIDs}) async {
    for(String cid in CIDs) {
      (await contactLib.getContact(_currentUser, cid: cid)).group.forEach((key, value) async {
        notificationLib.notifyEventInvite(_currentUser, eid, key);
        await eventLib.updateInvitations(_currentUser, eid,
            eventLib.Invitations(CIDs: [key], inviteStatus: EVENT_INVITED));
      });
    }
    return eventLib.getEvent(_currentUser, eid);
  }

  @override
  Future<Event> removeContactsFromEvent(String eid, {required List<String> CIDs}) async {
    return await eventLib.removeInvitations(_currentUser, eid, CIDs);
  }

  @override
  Future<Event> removeGroupsFromEvent(String eid, {required List<String> CIDs}) async {
    for(String cid in CIDs) {
      (await contactLib.getContact(_currentUser, cid: cid)).group.forEach((key, value) async {
        await eventLib.removeInvitations(_currentUser, eid, [key]);
      });
    }
    return eventLib.getEvent(_currentUser, eid);
  }

  @override
  Future<bool> isGroupInvited(String eid, String cid) async {
    Event event = await eventLib.getEvent(_currentUser, eid);
    Contact group = await contactLib.getContact(_currentUser, cid: cid);
    for(String cid in group.group.keys) {
      if (!event.invitedContacts.containsKey(cid))
        return false;
    }
    return true;
  }

  @override
  Future<Event> replyToEvent(String eid, {required String response}) async {
    return await eventLib.updateInvitations(_currentUser, eid,
        eventLib.Invitations(CIDs: [_currentUser.uid], inviteStatus: response));
  }

  @override
  Future<int> unrespondedEvents() async {
    int i=0;
    for (Event event in await eventLib.getUserEvents(_currentUser)) {
      if(event.invitedContacts[_currentUser.uid] == EVENT_INVITED) i++; }
    return i;
  }

  @override
  Future<Event> updateEvent(String eid, {String? title, String? location, String? description, String? photoURL, File? photoFile, DateTime? start, DateTime? end, List<DateOption>? multipleDates}) async {
    if (photoFile!=null) {
      photoURL = await storageLib.storeEventPicture(photoFile, eid: eid);
      await discussionLib.changePictureOfDiscussion(_currentUser, eid, photoURL);
    }
    if(multipleDates != null)
      dateLib.setEventDateOptions(_currentUser, eid, multipleDates);
    if(title != null) {
      try { // Discussion might not exist
        await discussionLib.changeTitleOfDiscussion(_currentUser, eid, title);
      } catch (e) {}
    }
    Event result = await eventLib.updateEvent(_currentUser, eid, title: title, location: location, description: description, photoURL: photoURL, start: start, end: end);;
    notificationLib.notifyEventModified(_currentUser, result.eid,);
    return result;
  }

  @override
  String getEventLink(String eid) {
    return 'http://event.meetmeyou.com/?eid=$eid';
  }

  @override
  String getEventText(String eid) {
    return 'Please find invite to my Event: http://event.meetmeyou.com/?eid=$eid';
  }

  @override
  Future<void>inviteURL(String eid) async {
    Event event = await eventLib.getEvent(_currentUser, eid);
    await contactLib.linkProfiles(_currentUser, uid: event.organiserID); // ensure both user and organiser are friends
    await inviteContactsToEvent(eid, CIDs: [_currentUser.uid]);
  }

  @override
  Future<List<CalendarEvent>> getCalendarEvents(BuildContext context) async {
    Profile profile = await getUserProfile();
    return calendarLib.getCalendarEvents(context, _currentUser.uid, display: profile.parameters['calendar_display'] == null ? true : profile.parameters['calendar_display']);
  }

  @override
  Future<void> setCalendarParams({required bool sync, required bool display}) async {
    await profileLib.setProfileParameter(_currentUser, param: 'calendar_sync', value: sync);
    await profileLib.setProfileParameter(_currentUser, param: 'calendar_display', value: display);
  }

  @override
  Future<Map<String, dynamic>> getCalendarParams() async {
    Map<String, dynamic> params = Map<String, dynamic>();
    Profile profile = await profileLib.getUserProfile(_currentUser);
    params['calendar_sync'] = profile.parameters['calendar_sync'] ?? true;
    params['calendar_display'] = profile.parameters['calendar_display'] ?? true;
    return params;
  }

  @override
  Future<List<EventChatMessage>> getEventChatMessages(String eid) async {
    return messageLib.getEventChatMessages(_currentUser, eid);
  }

  @override
  Future<EventChatMessage> postEventChatMessage(String eid, {required String text}) {
    return messageLib.postEventChatMessages(_currentUser, eid, text);
  }

  @override
  Future<EventAnswer> answerEventForm(String eid, {required Map answers}) async {
    return answerLib.answerEventForm(eid, _currentUser, answers);
  }

  @override
  Future<List<EventAnswer>> emailEventAnswers(String eid) async {
    return answerLib.emailEventAnswers(eid, _currentUser,);
  }

  @override
  Future<Event> addQuestionToEvent(Event event, {required questionNum, required String text}) async {
    Map<String, dynamic> question = {'$questionNum. text': text};
    event.form.addAll(question);
    return eventLib.createEvent(_currentUser, event);
  }

  @override
  Future<String> addDateToEvent(String eid, {required DateTime start, required DateTime end}) async {
    return dateLib.addDateToEvent(_currentUser, eid, start, end);
  }

  @override
  Future<Event> answerDateOption(String eid, String did, bool attend) async {
    await dateLib.answerDateOption(_currentUser, eid, did, attend);
    return await dateLib.updateEventStatus(_currentUser, eid,);
  }

  @override
  Future<bool> dateOptionStatus(String eid, String did) async {
    return dateLib.dateOptionStatus(_currentUser, eid, did);
  }

  @override
  Future<List<String>> listDateSelected(String eid) async {
    return dateLib.listDateSelected(_currentUser, eid);
  }

  @override
  Future<void> removeDateFromEvent(String eid, String did) async {
    dateLib.removeDateFromEvent(_currentUser, eid, did);
  }

  @override
  Future<Event> selectFinalDate(String eid, String did) async {
    return dateLib.selectFinalDate(_currentUser, eid, did);
  }

  @override
  Future<List<DateOption>> getDateOptionsFromEvent(String eid) async {
    return dateLib.getDateOptionsFromEvent(_currentUser, eid);
  }

  @override
  Future<Discussion> getDiscussion(String did) async {
    return discussionLib.getDiscussion(_currentUser, did);
  }

  @override
  Future<Discussion> getEventDiscussion(String eid) async {
    Discussion discussion;
    try{
      discussion = await discussionLib.getDiscussion(_currentUser, eid);
    } catch(e) { // For old events
      discussion = await discussionLib.createDiscussion(_currentUser, (await eventLib.getEvent(_currentUser, eid)).title, eid: eid);
    }
    if(!discussion.participants.containsKey(_currentUser.uid)) {
      discussionLib.inviteUserToDiscussion(_currentUser, _currentUser.uid, eid);
    }
    return discussion;
  }

  @override
  Future<List<Discussion>> getUserDiscussions() async {
    return discussionLib.getUserDiscussions(_currentUser);
  }

  @override
  Future<void> postDiscussionMessage(String did, {String type=TEXT_MESSAGE, required String text, File? photoFile, String? replyMid}) async {
    String? URL;
    if (photoFile != null) URL = await storageLib.messagePicture(photoFile, did: did);
    discussionLib.postMessage(_currentUser, did, type, text, URL, replyMid);
    notificationLib.notifyDiscussionMessage(_currentUser, did);
  }

  @override
  Future<Discussion> startContactDiscussion(String cid) async {
    return await discussionLib.startContactDiscussion(_currentUser, cid);
  }

  @override
  Future<void> leaveDiscussion(String did) async {
    discussionLib.removeUserFromDiscussion(_currentUser, did, _currentUser.uid);
  }

  @override
  Future<void> addContactToDiscussion(String did, {required String cid}) async {
    await discussionLib.inviteUserToDiscussion(_currentUser, cid, did);
  }

  @override
  Future<void> removeContactFromDiscussion(String did, {required String cid}) async {
    discussionLib.removeUserFromDiscussion(_currentUser, did, cid);
  }

  @override
  Future<Discussion> updateDiscussion(String did, {String? title, File? photo}) async {
    Discussion result = await getDiscussion(did);
    if(title != null) result = await discussionLib.changeTitleOfDiscussion(_currentUser, did, title);
    if(photo != null) result = await discussionLib.setDiscussionPhoto(_currentUser, did, photo);
    print(result);
    return result;
  }

  @override
  Future<int> updatedDiscussions() async {
    int count=0;
    List<Discussion> discussions = await getUserDiscussions();
    for (Discussion discussion in discussions) if (discussion.unread) count++;
    return count;
  }

  @override
  Future<SearchResult> search(String searchText) async {
    return searchLib.search(_currentUser, searchText);
  }

  @override
  Future<Discussion> startGroupDiscussion(List<String> CIDs) {
    return discussionLib.startGroupDiscussion(_currentUser, CIDs);
  }

  @override
  Future<List<MMYNotification>> getUserNotification() {
    return notificationLib.getUserNotifications(_currentUser);
  }


}