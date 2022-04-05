import 'package:firebase_auth/firebase_auth.dart';

abstract class MMYCreatorEngine {

}

class MMYCreator implements MMYCreatorEngine {
  MMYCreator(this._currentUser);
  final User _currentUser;
}