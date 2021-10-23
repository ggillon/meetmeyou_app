
import 'package:flutter/material.dart';

import 'package:meetmeyou_app/models/profile.dart';

import 'package:meetmeyou_app/services/mmy/profile.dart';
import 'package:provider/provider.dart';

// services
import 'package:meetmeyou_app/services/auth/auth.dart';

Widget TestShowProfile(BuildContext context) {

  final auth = Provider.of<AuthBase>(context, listen: false);


  return Scaffold(
    appBar: AppBar(),
    body: FutureBuilder<Profile>(
      future: getUserProfile(auth: auth),
      initialData: createNoDBProfile(uid: 'uid'),
      builder: (context, profile) => Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text('AuthUser Display Name: ${auth.currentUser!.displayName}'),
            Text('AuthUser Email: ${auth.currentUser!.email}'),
            Text('AuthUser UID: ${auth.currentUser!.uid}'),
            SizedBox(height: 10),
            Text('Profile Display Name: ${profile.data!.displayName}'),
            Text('AuthUser Email: ${profile.data!.email}'),
            Text('AuthUser UID: ${profile.data!.uid}'),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => auth.signOut(),
                child: Text('Sign-out')),
          ],
        ),
      ),
    ),
  );

}

Widget TestShowSignIn(BuildContext context) {

  final auth = Provider.of<AuthBase>(context, listen: false);

  return Scaffold(
    appBar: AppBar(),
    body: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => auth.signInWithGoogle(),
                child: Text('Sign-in with Google')),
            ElevatedButton(
                onPressed: () => auth.signInWithFacebook(),
                child: Text('Sign-in with Facebook')),
            ElevatedButton(
                onPressed: () => auth.signInWithApple(),
                child: Text('Sign-in with Apple')),
            ElevatedButton(
                onPressed: () => auth.signInTestUser(),
                child: Text('Sign-in with TestUser email')),
          ],
        ),
      ],
    ),
  );

}