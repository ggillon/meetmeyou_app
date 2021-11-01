import 'package:flutter/material.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
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
    print(page);
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
      return Container(); //TestProfileSearch(context, setPage);

    return Container();
  }
}

Widget ContactMenu(BuildContext context, Function setPage) {

  final auth = Provider.of<AuthBase>(context, listen: false);


  return Scaffold(
    appBar: AppBar(),
    body:Column(
      children: [
        ElevatedButton(onPressed: () => setPage("Contact List"), child: Text("Contact List")),
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


Widget TestContactList(BuildContext context, Function setPage) {

  final auth = Provider.of<AuthBase>(context, listen: false);

  return Provider<MMYEngine>(
      create: (_) => MMY(auth.currentUser!),
      builder: (context,_) {

        final mmy = Provider.of<MMYEngine>(context, listen: false);

        List<Contact> emptyList = [];

        bool testInvite = false;
        bool groupCreated = false;

        return FutureBuilder<List<Contact>>(
                future: mmy.getContacts(),
                  initialData: emptyList,
                  builder: (context, contactList) => Scaffold(
                    appBar: AppBar(),
                    body: Column(
                      children: [
                        SizedBox(
                          height: 400,
                          width: 400,
                          child: ListView.builder(
                              itemCount: contactList.data!.length,
                              itemBuilder: (context, item) {
                                  if(contactList.data![item].displayName == 'Test Group')
                                    groupCreated = true;
                                  return Text(contactList.data![item].displayName ?? 'No Name');
                                },
                          ),
                        ),
                        SizedBox(height: 10,),
                        groupCreated
                        ? ElevatedButton(onPressed: () => toggleGroup(context, false, setPage), child: Text("Delete Test Group"))
                        : ElevatedButton(onPressed: () => toggleGroup(context, true, setPage), child: Text("Create Test Group")),
                        testInvite
                        ? ElevatedButton(onPressed: () => setPage("Menu"), child: Text("Accept Invite"))
                        : ElevatedButton(onPressed: () => setPage("Menu"), child: Text("Reset Invite")),
                        SizedBox(height: 10,),
                        ElevatedButton(onPressed: () => setPage("Menu"), child: Text("Menu")),
                      ],
                    ),
                  ),
        );
      }
  );

}