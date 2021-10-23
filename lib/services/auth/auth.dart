import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';

abstract class AuthBase {
  User? get currentUser;
  Future<User?> signInTestUser();
  Future<User?> signInEmailUser(String email, String password);
  Future<User?> createEmailUser(String email, String password);
  Future<void> recoverEmailUser(String email,);
  Future<User?> signInWithGoogle();
  Future<User?> signInWithFacebook();
  Future<User?> signInWithApple();
  Future<void> signOut();
  Stream<User?> authStateChanges();
  Future<void> deleteUser(User user);

}

class Auth implements AuthBase {

  final _auth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<User?> signInTestUser() async {
    final userCred = await _auth.signInWithEmailAndPassword(email: 'test@test.com', password: 'gaspard');
    return userCred.user;
  }

  @override
  Future<User?> signInEmailUser(String email, String password) async {
    final userCred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return userCred.user;
  }

  @override
  Future<User?> createEmailUser(String email, String password) async {
    final userCred = await _auth.createUserWithEmailAndPassword(email: email, password: password,);
    userCred.user?.sendEmailVerification();
    return userCred.user;
  }

  @override
  Future<void> recoverEmailUser(String email,) async {
    await _auth.sendPasswordResetEmail(email: email,);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _auth.currentUser?.delete();
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      UserCredential userCredential;
      OAuthCredential googleAuthCredential;
      GoogleSignInAuthentication googleAuth;

      if(kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        googleAuth = await googleUser!.authentication;
        googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }
      return userCredential.user!;
    } catch(e) {
      print(e);
      throw FirebaseAuthException(
          message: 'Google Sign-in error', code: 'ERROR_GOOGLE_SIGN_IN');
    }
  }


  @override
  Future<User?> signInWithFacebook() async {

    if(kIsWeb) {
      // Create a new provider
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();
      facebookProvider.addScope('email');
      facebookProvider.setCustomParameters({'display': 'popup',});

      // Once signed in, return the UserCredential
      try {
        UserCredential userCred = await FirebaseAuth.instance.signInWithPopup(facebookProvider);
        return userCred.user;
      } catch(e) {
        print(e);
        throw FirebaseAuthException(message: 'Facebook sign in failed', code: 'ERROR_FB_SIGN_IN');
      }

    } else {
      // Trigger the sign-in flow
      final LoginResult? loginResult = await FacebookAuth.instance.login();

      if (loginResult != null) {
        // Create a credential from the access token
        final OAuthCredential? facebookAuthCredential = FacebookAuthProvider
            .credential(loginResult.accessToken!.token);

        if (facebookAuthCredential != null) {
          // Once signed in, return the UserCredential
          final userCred = await _auth.signInWithCredential(
              facebookAuthCredential);
          return userCred.user;
        } else {
          throw FirebaseAuthException(message: 'Facebook FB ID missing', code: 'ERROR_FB_SIGN_IN');
        }
      } else {
        throw FirebaseAuthException(message: 'Facebook sign in failed', code: 'ERROR_FB_SIGN_IN');
      }
    }
  }

  @override
  Future<User?> signInWithApple() async {
    try {
      final result = await FirebaseAuthOAuth().openSignInFlow(
          'apple.com', ['email', 'fullName'], {"locale": "en"});
      return result;
    } catch (error) {
      print(error);
      throw FirebaseAuthException(
          message: 'Apple sign in failed', code: 'ERROR_APPLE_SIGN_IN');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    /*final googleSignIn = GoogleSignIn();
    if (googleSignIn != null)
      await googleSignIn.signOut();
    final fbSignIn = FacebookAuth.instance;
    if (fbSignIn != null)
      await fbSignIn.logOut();*/
  }


}

/*
  Future<User> signInWithApple() async {
    if(await AppleSignIn.isAvailable()) {
      final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]
      );
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleCred = result.credential;
          final credential = OAuthProvider('apple.com').credential(
            idToken: result.credential.identityToken.toString(),
            accessToken: result.credential.authorizationCode.toString(),
          );
          final authResult = await _auth.signInWithCredential(credential);
          return authResult.user;
        case AuthorizationStatus.error:
          throw FirebaseAuthException(
              message: 'Apple Sign error', code: 'ERROR_APPLEID_SIGN_IN');
        case AuthorizationStatus.cancelled:
          throw FirebaseAuthException(
              message: 'Apple Sign cancelled', code: 'ERROR_APPLEID_SIGN_IN');
      }
    } else {
      throw FirebaseAuthException(
          message: 'Apple Sign in not available', code: 'ERROR_APPLEID_SIGN_IN');
    }

  }*/