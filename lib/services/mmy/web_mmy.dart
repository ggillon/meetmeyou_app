import 'package:firebase_auth/firebase_auth.dart';

import 'mmy.dart';

class WebMMY extends MMY {
  WebMMY() : super(FirebaseAuth.instance.currentUser!);
}