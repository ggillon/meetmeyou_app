import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/services/mmy/profile.dart';

String eidGenerator() {
  final charList = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String eid = '';

  for(int i=0; i<4; i++) {
    int randomNumber = Random().nextInt(52);
    eid = eid + charList.substring(randomNumber, randomNumber+1);
  }
  eid = eid + '-';
  for(int i=0; i<4; i++) {
    int randomNumber = Random().nextInt(52);
    eid = eid + charList.substring(randomNumber, randomNumber+1);
  }
  return eid;
}

Event createLocalEvent(Profile organiser) {
  return Event(
    title: '',
    eid: eidGenerator(),
    timeStamp: DateTime.now(),
    organiserID: organiser.uid,
    organiserName: organiser.displayName,
    multipleDates: false,
    admins: { '${organiser.uid}': 'Organiser' },
    invitedContacts: { '${organiser.uid}': 'Organiser' },
    start: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour).add(Duration(hours: 1)),
    end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour).add(Duration(hours: 4)),
  );
}

/*Future<Event> createEvent(User currentUser, {required String title, }) async {
  Event event = Event(
    eid: eidGenerator(),
    organiserID: currentUser.uid,
    organiserName: (await getUserProfile(currentUser)).displayName,
    timeStamp: DateTime.now(),
    title: title,


  )
}*/