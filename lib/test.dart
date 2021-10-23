import 'package:meetmeyou_app/services/mmy/profile.dart';

import 'models/profile.dart';
import 'services/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/mmy/profile.dart';

// File with several test function for Services

void test() async {
}

void testGoogleSignIn() async {
  AuthBase auth = Auth();
  User? user = await auth.signInWithGoogle();
  if (user != null) {
    Profile profile = await getUserProfile(auth: auth);
    print(profile.displayName);
  } else {
    print('error');
  }
}

void testFacebookSignIn() async {
  AuthBase auth = Auth();
  User? user = await auth.signInWithFacebook();
  if (user != null) {
    Profile profile = await getUserProfile(auth: auth);
    print(profile.displayName);
  } else {
    print('error');
  }
}

void testAppleSignIn() async {
  AuthBase auth = Auth();
  User? user = await auth.signInWithApple();
  if (user != null) {
    Profile profile = await getUserProfile(auth: auth);
    print(profile.displayName);
  } else {
    print('error');
  }
}

