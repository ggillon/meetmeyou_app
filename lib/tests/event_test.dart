import 'package:flutter/material.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/services/email/email.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:provider/provider.dart';

class ContactTest extends StatefulWidget {
  const ContactTest({Key? key}) : super(key: key);

  @override
  _ContactTestState createState() => _ContactTestState();
}

class _ContactTestState extends State<ContactTest> {

  String _page = 'Menu';

  void setPage(String page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_page == "Menu")
      return ContactMenu(context, setPage);

    if (_page == "Event List")
      return TestEventList(context, setPage);

    if (_page == "Create Event")
      return TestSearchProfile(context, setPage); //TestProfileSearch(context, setPage);

    if (_page == "Invite Contacts to event")
      return TestImportContacts(context, setPage);

    return Container();
  }
}

Widget ContactMenu(BuildContext context, Function setPage) {

  final auth = Provider.of<AuthBase>(context, listen: false);

  return Scaffold(
    appBar: AppBar(),
    body:Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 5,),
        Text('Contact Test Menu for ${auth.currentUser!.displayName}: ${auth.currentUser!.uid}', style: TextStyle(fontSize: 18),),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: () => setPage("Contact List"), child: Text("Contact List")),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: () => setPage("Search Profile"), child: Text("Search Profile")),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: () => setPage("Invite Contacts"), child: Text("Invite Contacts")),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: () => auth.signOut(), child: Text("Sign Out")),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: () => deleteUser(context), child: Text("Delete User")),
        SizedBox(height: 10,),
      ],
    ),
  );
}

Future<void> deleteUser(BuildContext context) async {
  final mmy = MMY(Provider.of<AuthBase>(context, listen: false).currentUser!);
  await mmy.deleteUser();
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

Widget TestEventList(BuildContext context, Function setPage) {

  final auth = Provider.of<AuthBase>(context, listen: false);

  bool groupCreated = false;
  String testGroupCid = "";
  String invitationCID = "";

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
                          builder: (context, contactList) => ListView.builder(
                              itemCount: contactList.data!.length,
                              itemBuilder: (context, item) => Text(contactList.data![item].title)
                      ,)),
                    ),
                  ),
                ),
              ),
              ElevatedButton(child: Text('Attend / No Attend Events'),
                  onPressed: () async {

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