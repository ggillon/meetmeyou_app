import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/services/email/email.dart';
import 'package:meetmeyou_app/services/mmy/event.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:provider/provider.dart';

class EventTest extends StatefulWidget {
  const EventTest({Key? key}) : super(key: key);

  @override
  _EventTestState createState() => _EventTestState();
}

class _EventTestState extends State<EventTest> {

  String _page = 'Menu';

  void setPage(String page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_page == "Menu")
      return EventMenu(context, setPage);

    if (_page == "Event List")
      return TestEventList(context, setPage);

    if (_page == "Create Event")
      return TestSearchProfile(context, setPage); //TestProfileSearch(context, setPage);

    if (_page == "Invite all contacts to event")
      return TestImportContacts(context, setPage);

    return Container();
  }
}

Widget EventMenu(BuildContext context, Function setPage) {

  final auth = Provider.of<AuthBase>(context, listen: false);

  return Scaffold(
    appBar: AppBar(),
    body:Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 5,),
        Text('Event Test Menu for ${auth.currentUser!.displayName}: ${auth.currentUser!.uid}', style: TextStyle(fontSize: 18),),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: () => setPage("Event List"), child: Text("Event List")),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: () => setPage("Search Profile"), child: Text("Search Profile")),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: () => setPage("Invite Contacts"), child: Text("Invite Contacts")),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: () => auth.signOut(), child: Text("Sign Out")),
        SizedBox(height: 10,),
      ],
    ),
  );
}

void toggleGroup(BuildContext context, bool create, Function setPage) {

  final mmy = Provider.of<MMYEngine>(context, listen: false);

  if (create) {
    mmy.newGroupContact('Test Group', about: "Test Group");
  }
  else {

  }

  setPage("Contact List");

}

Widget TestSearchProfile(BuildContext context, Function setPage) {
  final auth = Provider.of<AuthBase>(context, listen: false);

  return Provider<MMYEngine>(
      create: (_) => MMY(auth.currentUser!),
      builder: (context,_) {

        final mmy = Provider.of<MMYEngine>(context, listen: false);
        List<Contact> emptyList = [];
        
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              SizedBox(height:10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 100,
                        child: FutureBuilder<List<Contact>>(
                            future: mmy.searchProfiles('Choupy'),
                            initialData: emptyList,
                            builder: (context, contactList) => ListView.builder(
                              itemCount: contactList.data!.length,
                              itemBuilder: (context, item) => Text('${contactList.data![item].displayName}: ${contactList.data![item].uid}')
                              ,)),
                      ),
                    ),
                ),
              ),
            ],
          ),
        );
      },
  );
  
}

Widget TestImportContacts(BuildContext context, Function setPage) {
  final auth = Provider.of<AuthBase>(context, listen: false);

  return Provider<MMYEngine>(
    create: (_) => MMY(auth.currentUser!),
    builder: (context,_) {

      final mmy = Provider.of<MMYEngine>(context, listen: false);
      List<Contact> emptyList = [];

      return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            SizedBox(height:10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: FutureBuilder<List<Contact>>(
                        future: mmy.getPhoneContacts(),
                        initialData: emptyList,
                        builder: (context, contactList) => ListView.builder(
                          itemCount: contactList.data!.length,
                          itemBuilder: (context, item) => Text('${contactList.data![item].displayName}: ${contactList.data![item].email}')
                          ,)),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

}

Future<String> createTestEvent(BuildContext context, {bool organiser=true}) async {
  final auth = Provider.of<AuthBase>(context, listen: false);
  MMY mmy = MMY(auth.currentUser!);
  Event event = createLocalEvent(await mmy.getUserProfile());
  if (organiser==false) {
    event.organiserID = 'RFn7rxxXlah33OyFi2wcuDASXMG2';
    event.admins = {'RFn7rxxXlah33OyFi2wcuDASXMG2': EVENT_ORGANISER};
    event.invitedContacts = {'RFn7rxxXlah33OyFi2wcuDASXMG2': EVENT_ORGANISER};
    event.organiserName = 'Test User';
    event.title = 'Random Created Event ${Random().nextInt(1000)}';
    createEvent(auth.currentUser!, event);
  }
  event.title = 'Random Created Event ${Random().nextInt(1000)}';
  event = await mmy.createEvent(title: 'Random Created Event ${Random().nextInt(1000)}',
      location: '',
      description: '',
      photoURL: event.photoURL,
      start: event.start,
      end: event.end);
  return event.eid;
}

Widget TestEventList(BuildContext context, Function setPage) {

  final auth = Provider.of<AuthBase>(context, listen: false);

  return Provider<MMYEngine>(
      create: (_) => MMY(auth.currentUser!),
      builder: (context,_) {

        final mmy = Provider.of<MMYEngine>(context, listen: false);

        List<Event> emptyList = [];

        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              SizedBox(height:10),
              Text('Event', style: TextStyle(fontSize: 18)),
              SizedBox(height:5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: FutureBuilder<List<Event>>(
                        future: mmy.getUserEvents(),
                          initialData: emptyList,
                          builder: (context, eventList) => ListView.builder(
                              itemCount: eventList.data!.length,
                              itemBuilder: (context, item) => Text('${eventList.data![item].title}: ${eventList.data![item].invitedContacts[auth.currentUser!.uid]}')
                      ,)),
                    ),
                  ),
                ),
              ),
              ElevatedButton(child: Text('Create Event as organiser'),
                onPressed: () async {
                  createTestEvent(context, organiser: true);
                  setPage("Event List");
                },
              ),
              ElevatedButton(child: Text('Create Event and invite yourself'),
                onPressed: () async {
                  final eid = await createTestEvent(context, organiser: false);
                  mmy.inviteContactsToEvent(eid, CIDs: [auth.currentUser!.uid]);
                  setPage("Event List");
                },
              ),
              ElevatedButton(child: Text('Attend / Not Attend Events'),
                  onPressed: () async {
                 final eventList = await mmy.getUserEvents(filters: [EVENT_INVITED, EVENT_ATTENDING, EVENT_NOT_ATTENDING]);
                 for(Event event in eventList) {
                   if(event.invitedContacts[auth.currentUser!.uid] == EVENT_ATTENDING)
                     mmy.replyToEvent(event.eid, response: EVENT_NOT_ATTENDING);
                   else
                     mmy.replyToEvent(event.eid, response: EVENT_ATTENDING);
                 }
                 setPage("Event List");

                  },
              ),
              ElevatedButton(child: Text('Refresh'),
                onPressed: () async {
                  setPage("Event List");
                },
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () => auth.signOut(), child: Text("Sign Out")),
              SizedBox(height: 10,),
            ]
          ),
        );
      }
  );

}