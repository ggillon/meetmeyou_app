import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/constants.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event_answer.dart';
import 'package:meetmeyou_app/models/event_chat_message.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/calendar_event.dart';
import 'package:meetmeyou_app/services/database/database.dart';
import 'dart:io';
import '../../models/discussion.dart';
import '../../models/discussion_message.dart';
import '../../models/mmy_notification.dart';
import '../../models/photo_album.dart';
import '../../models/search_result.dart';
import 'mmy_admin.dart';
import 'mmy_creator.dart';
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
import 'photo_album.dart' as albumLib;
import 'announcement.dart' as announcementLib;

const USER_TYPE_NORMAL = "Normal User";
const USER_TYPE_PRO = "Pro User";
const USER_TYPE_ADMIN = "Admin User";

abstract class MMYEngine {

  /// DEBUG MESSAGE
  void debugMsg(String text, {Map? attachment});

  /// PROFILE ///

  /// Get the user profile or create new one
  Future<Profile> getUserProfile();
  /// Update the user profile
  Future<Profile> updateProfile({String? firstName, String? lastName, String? email, String? countryCode, String? phoneNumber, String? photoUrl, String? homeAddress, String? about, Map? other, Map? parameters});
  /// Get the user profile or create new one, leveraging the Auth user info
  Future<Profile> createUserProfile();
  /// Checks if profile exists
  Future<bool> isNew();
  /// Apple Sign in profile creation
  Future<Profile> appleFirstSignIn();
  /// Apple Sign in profile creation
  Future<bool> filledProfile();
  /// Update the profile Profile
  Future<Profile> updateProfilePicture(File file);
  /// Delete User - Cautious
  Future<void> deleteUser();
  /// Set a parameter
  Future<Profile> setUserParameter(String param, dynamic value);
  /// Get a parameter
  Future<dynamic> getUserParameter(String param,);

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
  /// Get phone Contacts for invite
  Future<List<Contact>> getInvitePhoneContacts();
  /// Invite phone Contacts
  Future<void> invitePhoneContacts(List<Contact> contacts);

  /// EVENT ///

  /// Get all Events where user is invited or organiser
  Future<List<Event>> getUserEvents({List<String>? filters});
  /// Get all past Event where user was invited
  Future<List<Event>> getPastEvents();
  /// Get all Events where user is organiser
  Future<List<Event>> getOrganisedEvents();
  /// Get a particular Event
  Future<Event> getEvent(String eid);
  /// Create an event
  Future<Event> createEvent({required String title, required String location, required String description, required String photoURL, DateTime? start, DateTime? end, List<DateTime>? startDateOptions, List<DateTime>? endDateOptions});
  /// Update an event
  Future<Event> updateEvent(String eid, {String? title, String? location, String? description, String? photoURL, DateTime? start, DateTime? end, List<DateOption>? multipleDates});
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
  /// Set event parameter
  Future<Event> setEventParam(String eid, {required String param, required dynamic value});
  /// Get event parameter
  Future<dynamic> getEventParam(String eid, {required String param, });
  /// Create an Announcement
  Future<Event> createAnnouncement({required String title, String? location, required String description, required String photoURL, DateTime? start, DateTime? end,});
  /// Update an Announcement
  Future<Event> updateAnnouncement(String eid, {String? title, String? location, String? description, String? photoURL, DateTime? start, DateTime? end, });


  /// Add a date option to event
  Future<String> addDateToEvent(String eid, {required DateTime start, required DateTime end});
  /// Remove a date from an event
  Future<void> removeDateFromEvent(String eid, String did);
  /// Get all dates options from an event (in date start order)
  Future<List<DateOption>> getDateOptionsFromEvent(String eid);
  /// Answer a date attendance for an event
  Future<Event> answerDateOption(String eid, String did, bool attend);
  /// Answer dates attendance for an event
  Future<Event> answerDatesOption(String eid, List<String> DIDs, bool attend);
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
  ///  Get reply to form to an event
  Future<EventAnswer> getAnswerEventForm(String eid, String uid);
  ///  Get reply to form to an event
  Future<List<EventAnswer>> getAnswersEventForm(String eid);
  ///  List answers to form
  Future<List<EventAnswer>> emailEventAnswers(String eid);

  /// CALENDAR FUNCTIONS
  /// Get the CalendarEvents from mobile or web calendar
  Future<List<CalendarEvent>> getCalendarEvents();
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
  Future<void> postDiscussionMessage(String did, {String type=TEXT_MESSAGE, required String text, String? photoURL, String? replyMid});
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
  /// Change title or photo of discussion
  Future<Discussion> updateDiscussion(String did, {String? title, String? photoURL});
  /// Change title of discussion
  Future<int> updatedDiscussions();

  /// Search
  Future<SearchResult> search(String searchText);

  /// NOTIFICATION
  Future<List<MMYNotification>> getUserNotification();

  /// User Mode
  Future<String> getUserType();
  /// get Creator object if user allowed
  Future<MMYCreator> getCreator();
  /// get Creator object if user allowed
  Future<MMYAdmin> getAdmin();

  /// PHOTO ALBUM FUNCTIONS

  /// Create an album for event
  Future<MMYPhotoAlbum> createEventAlbum(String eid);
  /// Get photo Album
  Future<MMYPhotoAlbum> getPhotoAlbum(String aid);
  /// Post photo
  Future<void> postPhoto(String aid, String photoURL);
  /// Delete photo
  Future<void> deletePhoto(String aid, String pid);

}

class MMY implements MMYEngine {
  /// Creates a MMYEngine class with access to features

  MMY(this._currentUser);
  final User _currentUser;

  @override
  void debugMsg(String text, {Map? attachment}) {
    final db = FirestoreDB(uid: _currentUser.uid);
    db.debugMsg(_currentUser.uid, text, attachment);
  }

  @override
  Future<Profile> getUserProfile() async {
    Profile profile = await profileLib.getUserProfile(_currentUser);
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
  Future<dynamic?> getUserParameter(String param,) async {
    Profile user = await profileLib.getUserProfile(_currentUser);
    return user.parameters[param];
  }

  @override
  Future<Contact> newGroupContact(String name, {String photoURL = contactLib.GROUP_PHOTOURL, String about = ''}) async {
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
  Future<Contact> updateGroupContact(String cid, {String? displayName, String? photoURL, String? about}) async {
    Contact contact = await contactLib.updateGroupContact(_currentUser, cid, displayName: displayName, photoURL: photoURL, about: about);
    discussionLib.updateLinkedDiscussion(_currentUser, cid, title: displayName, photoURL: photoURL);
    return contact;
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
  Future<List<Contact>> getInvitePhoneContacts() async {
    return await contactLib.getInvitePhoneContacts(_currentUser);
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
  Future<List<Event>> getPastEvents() {
    return eventLib.getPastEvents(_currentUser,);
  }

  @override
  Future<List<Event>> getOrganisedEvents() {
    return eventLib.getUserEvents(_currentUser, filters: [EVENT_ORGANISER]);
  }

  @override
  Future<Event> createEvent({required String title, required String location, required String description, required String photoURL, DateTime? start, DateTime? end, List<DateTime>? startDateOptions, List<DateTime>? endDateOptions}) async {
    Event event = await eventLib.updateEvent(_currentUser, null, title: title, location: location, description: description, photoURL: photoURL, start: start ?? startDateOptions!.first, end: end ?? endDateOptions!.last);
    if(startDateOptions != null && endDateOptions != null) {
      for(int i=0; i<startDateOptions.length; i++) {
        await dateLib.addDateToEvent(_currentUser, event.eid, startDateOptions[i], endDateOptions[i]);
      }
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
    contactLib.linkEvent(_currentUser, eid: eid);
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
  Future<Event> updateEvent(String eid, {String? title, String? location, String? description, String? photoURL, DateTime? start, DateTime? end, List<DateOption>? multipleDates}) async {
    if(multipleDates != null)
      dateLib.setEventDateOptions(_currentUser, eid, multipleDates);
    discussionLib.updateLinkedDiscussion(_currentUser, eid, title: title, photoURL: photoURL);
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
  Future<List<CalendarEvent>> getCalendarEvents() async {
    Profile profile = await getUserProfile();
    return calendarLib.getCalendarEvents(_currentUser.uid, display: profile.parameters['calendar_display']);
  }

  @override
  Future<void> setCalendarParams({required bool sync, required bool display}) async {
    await profileLib.setProfileParameter(_currentUser, param: 'calendar_sync', value: sync);
    await profileLib.setProfileParameter(_currentUser, param: 'calendar_display', value: display);
  }

  @override
  Future<Map<String, dynamic>> getCalendarParams() async {
    Map<String, dynamic> params = EMPTY_MAP;
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
  Future<EventAnswer> getAnswerEventForm(String eid, String uid) async {
    return answerLib.getAnswerEventForm(_currentUser, eid, uid);
  }

  @override
  Future<List<EventAnswer>> emailEventAnswers(String eid) async {
    return answerLib.emailEventAnswers(eid, _currentUser,);
  }

  @override
  Future<List<EventAnswer>> getAnswersEventForm(String eid) {
    return answerLib.getAnswersEventForm(_currentUser, eid);
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
  Future<Event> answerDatesOption(String eid, List<String> DIDs, bool attend) async {
    List<DateOption> dates = await getDateOptionsFromEvent(eid);
    for(String did in DIDs)
      await dateLib.answerDateOption(_currentUser, eid, did, attend);
    for(DateOption date in dates) {
      if(DIDs.contains(date.did))
        await dateLib.answerDateOption(_currentUser, eid, date.did, !attend);
    }
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
    return discussionLib.getDiscussion(_currentUser, eid, isEvent: true);
  }

  @override
  Future<List<Discussion>> getUserDiscussions() async {
    return discussionLib.getUserDiscussions(_currentUser);
  }

  @override
  Future<void> postDiscussionMessage(String did, {String type=TEXT_MESSAGE, required String text, String? photoURL, String? replyMid}) async {
    discussionLib.postMessage(_currentUser, did, type, text, photoURL, replyMid);
    notificationLib.notifyDiscussionMessage(_currentUser, did);
  }

  @override
  Future<Discussion> startContactDiscussion(String cid) async {
    return await discussionLib.startContactDiscussion(_currentUser, cid: cid,);
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
  Future<Discussion> updateDiscussion(String did, {String? title, String? photoURL}) async {
    return await discussionLib.updateDiscussion(_currentUser, did, title: title, photoURL: photoURL);
  }

  @override
  Future<int> updatedDiscussions() async {
    int count=0;
    for (Discussion discussion in (await getUserDiscussions())) if (discussion.unread) count++;
    return count;
  }

  @override
  Future<SearchResult> search(String searchText) async {
    return searchLib.search(_currentUser, searchText);
  }

  @override
  Future<Discussion> startGroupDiscussion(List<String> CIDs) {
    return discussionLib.startGroupDiscussion(_currentUser, CIDs: CIDs);
  }

  @override
  Future<List<MMYNotification>> getUserNotification() {
    return notificationLib.getUserNotifications(_currentUser);
  }

  @override
  Future<MMYAdmin> getAdmin() async {
    String userType = await getUserType();
    if(userType == USER_TYPE_ADMIN) {
      return MMYAdmin(_currentUser);
    } else {
      throw Error();
    }
  }

  @override
  Future<MMYCreator> getCreator() async {
    String userType = await getUserType();
    if(userType == USER_TYPE_ADMIN || userType == USER_TYPE_PRO) {
      return MMYCreator(_currentUser);
    } else {
      throw Error();
    }
  }

  @override
  Future<String> getUserType() async {
    String? userType = await getUserParameter('UserType');
    if(userType == null)
      userType = USER_TYPE_NORMAL;
    return userType;
  }

  @override
  Future<Profile> appleFirstSignIn() {
    return profileLib.createAnonProfileFromUser(_currentUser);
  }

  @override
  Future<bool> filledProfile() async {
    bool output;
    output = !((await profileLib.getUserProfile(_currentUser)).parameters['Anon']);
    return output ?? true;
  }

  @override
  Future<MMYPhotoAlbum> createEventAlbum(String eid) async {
    return await albumLib.createEventAlbum(_currentUser, eid);
  }

  @override
  Future<void> deletePhoto(String aid, String pid) async {
    albumLib.deletePhoto(_currentUser, aid, pid);
  }

  @override
  Future<MMYPhotoAlbum> getPhotoAlbum(String aid) async {
    return await albumLib.getAlbum(_currentUser, aid);
  }

  @override
  Future<void> postPhoto(String aid, String photoURL) async {
    await albumLib.postPhoto(_currentUser, aid, photoURL);
  }

  @override
  Future<dynamic> getEventParam(String eid, {required String param}) async {
    return await eventLib.getParam(_currentUser, eid, param);
  }

  @override
  Future<Event> setEventParam(String eid, {required String param, required value}) async {
    return await eventLib.setParam(_currentUser, eid, param, value);
  }

  @override
  Future<Event> createAnnouncement({required String title, String? location, required String description, required String photoURL, DateTime? start, DateTime? end,}) {
    return announcementLib.updateAnnouncement(_currentUser, null, title: title, location: location, description: description, photoURL: photoURL, start: start, end: end);
  }

  @override
  Future<Event> updateAnnouncement(String eid, {String? title, String? location, String? description, String? photoURL, DateTime? start, DateTime? end,}) {
    return announcementLib.updateAnnouncement(_currentUser, eid, title: title, location: location, description: description, photoURL: photoURL, start: start, end: end);
  }

}

