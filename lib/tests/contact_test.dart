import 'package:flutter/material.dart';
import 'package:meetmeyou_app/models/contact.dart';
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

    if (_page == "Contact List")
      return TestContactList(context, setPage);

    if (_page == "Search Profile")
      return TestSearchProfile(context, setPage); //TestProfileSearch(context, setPage);

    if (_page == "Invite Contacts")
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

Widget TestContactList(BuildContext context, Function setPage) {

  final auth = Provider.of<AuthBase>(context, listen: false);

  bool groupCreated = false;
  String testGroupCid = "";
  String invitationCID = "";

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
              Text('Confirmed Contacts', style: TextStyle(fontSize: 18)),
              SizedBox(height:5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: FutureBuilder<List<Contact>>(
                        future: mmy.getContacts(),
                          initialData: emptyList,
                          builder: (context, contactList) => ListView.builder(
                              itemCount: contactList.data!.length,
                              itemBuilder: (context, item) => Text(contactList.data![item].displayName)
                      ,)),
                    ),
                  ),
                ),
              ),
              SizedBox(height:10),
              Text('Groups', style: TextStyle(fontSize: 18)),
              SizedBox(height:5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: FutureBuilder<List<Contact>>(
                          future: mmy.getContacts(groups: true),
                          initialData: emptyList,
                          builder: (context, contactList) => ListView.builder(
                            itemCount: contactList.data!.length,
                            itemBuilder: (context, item) {
                              if(contactList.data![item].displayName == 'Test Group') {
                                groupCreated = true;
                                testGroupCid = contactList.data![item].cid;
                              }
                              return Text('${contactList.data![item].displayName} : ${contactList.data![item].group}');
                            },)),
                    ),
                  ),
                ),
              ),
              SizedBox(height:10),
              Text('Invitations', style: TextStyle(fontSize: 18)),
              SizedBox(height:5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: FutureBuilder<List<Contact>>(
                          future: mmy.getContacts(invitations: true),
                          initialData: emptyList,
                          builder: (context, contactList) => ListView.builder(
                            itemCount: contactList.data!.length,
                            itemBuilder: (context, item) {invitationCID = contactList.data![item].cid; return Text(contactList.data![item].displayName);},
                      )),
                    ),
                  ),
                ),
              ),
              Text('Invited', style: TextStyle(fontSize: 18)),
              SizedBox(height:5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: FutureBuilder<List<Contact>>(
                          future: mmy.getContacts(invitedContacts: true),
                          initialData: emptyList,
                          builder: (context, contactList) => ListView.builder(
                            itemCount: contactList.data!.length,
                            itemBuilder: (context, item) => Text(contactList.data![item].displayName),
                          ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(child: Text('Group Select'),
                  onPressed: () async {
                    if(groupCreated) {
                      print('Deleting Group');
                      groupCreated = false;
                      await mmy.deleteContact(testGroupCid);
                      setPage("Contact List");
                    } else {
                      print('Creating Group');
                      groupCreated = true;
                      Contact group = await mmy.newGroupContact('Test Group');
                      await mmy.addContactsToGroup(group.cid, contactCID: "RFn7rxxXlah33OyFi2wcuDASXMG2");
                      setPage("Contact List");
                    }
                  },
              ),
              Row(
                children: [
                  ElevatedButton(child: Text('Invite'),
                    onPressed: () async {
                    if((await mmy.getUserProfile()).uid != "TTwnAAS1Sta37XDBN2GE3eDfqDB2") {
                      print('Invite TTwnAAS1Sta37XDBN2GE3eDfqDB2');
                      await mmy.inviteProfile("TTwnAAS1Sta37XDBN2GE3eDfqDB2");
                      await setPage("Contact List");
                    } else {
                      print("You are Choupy");
                    }
                    },
                  ),
                  ElevatedButton(child: Text('Delete'),
                    onPressed: () async {
                      if ((await mmy.getUserProfile()).uid != "TTwnAAS1Sta37XDBN2GE3eDfqDB2") {
                        print('Delete ChoupyThePoet');
                        mmy.deleteContact("TTwnAAS1Sta37XDBN2GE3eDfqDB2");
                        await setPage("Contact List");
                      } else {
                        print("You are Choupy");
                      }
                    },
                  ),
                  ElevatedButton(child: Text('Accept'),
                    onPressed: () async {
                      if ((await mmy.getUserProfile()).uid == "TTwnAAS1Sta37XDBN2GE3eDfqDB2") {
                        print('Accepting invitation');
                        await mmy.respondInvitation(invitationCID, true);
                        await setPage("Contact List");
                      } else {
                        print("You are not Choupy");
                      }
                    },
                  ),
                  ElevatedButton(child: Text('Reject'),
                    onPressed: () async {
                      if ((await mmy.getUserProfile()).uid == "TTwnAAS1Sta37XDBN2GE3eDfqDB2") {
                        print('Accepting invitation');
                        await mmy.respondInvitation(invitationCID, false);
                        await setPage("Contact List");
                      } else {
                        print("You are not Choupy");
                      }
                    },
                  ),
                ],
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