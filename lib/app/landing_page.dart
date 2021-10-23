import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetmeyou_app/tests/login_test.dart';
import 'package:provider/provider.dart';

// services
import 'package:meetmeyou_app/services/auth/auth.dart';

// models

// pages


// widgets


class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        initialData: auth.currentUser,
        builder: (context, snapshot) {
          if (snapshot.data != null)
            return TestShowProfile(context);
          else
            try {
            TestShowSignIn(context);
          } catch(e) {print(e);}
          return TestShowSignIn(context);
        });
  }




}

