import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:provider/provider.dart';
import 'app/test_landing_page.dart';
import 'test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  test();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Provider<AuthBase>(
        create: (_) => Auth(),
        child: MaterialApp(
          title: 'MeetMeYou',
          home: LandingPage(),
        ),
      );
  }
}
