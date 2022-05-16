class APIPath {

  static String debug(String uid, String did) => '/users/$uid/debug/$did';
  static String debugLog(String uid, ) => '/users/$uid/debug/';

  static String event(String eid,) => '/events/$eid/';
  static String events() => '/events/';

  static String comment(String eid, String mid) => '/events/$eid/comments/$mid';
  static String comments(String eid) => '/events/$eid/comments/';

  static String message(String eid, String mid) => '/events/$eid/messages/$mid';
  static String messages(String eid) => '/events/$eid/messages/';

  static String eventInvitation(String uid, String eventID) => '/users/$uid/eventInvitations/$eventID';
  static String eventInvitations(String uid) => '/users/$uid/eventInvitations/';

  static String eventDate(String eid, String did) => '/events/$eid/dates/$did';
  static String eventDates(String eid) => '/events/$eid/dates/';

  static String answer(String eid, String uid) => '/events/$eid/answer/$uid';
  static String answers(String eid) => '/events/$eid/answer/';

  //static String contact(String cid,) => '/contacts/$cid/';
  //static String contacts() => '/contacts/';

  static String profile(String uid,) => '/users/$uid/';
  static String profiles() => '/users/';

  static String userContact(String uid, String cid,) => '/users/$uid/contacts/$cid/';
  static String userContacts(String uid) => '/users/$uid/contacts/';

  static String invitedContact(String eid, String cid,) => '/events/$eid/invitedContacts/$cid/';
  static String invitedContacts(String eid) => '/events/$eid/invitedContacts/';

  static String discussion(String did,) => '/discussions/$did/';
  static String discussions() => '/discussions/';

  static String discussionMessage(String did, String mid)  => '/discussions/$did/messages/$mid/';
  static String discussionMessages(String did)  => '/discussions/$did/messages/';

  static String notification(String nid,) => '/notifications/$nid/';
  static String notifications() => '/notifications/';

  static String photoAlbum(String aid,) => '/photoAlbums/$aid';

  static String photo(String aid, String pid) => '/photoAlbums/$aid/photos/$pid';
  static String photos(String aid,) => '/photoAlbums/$aid/photos/';

}