import 'dart:async';
import 'dart:io';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

class DeepLinking{
  Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      print(initialLink);
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
      print("Exception!!!!!!!!!~~~~~~~");
    }
  }

  StreamSubscription? _sub;

  Future<void> initUniLinks1() async {
    // ... check initialLink

    // Attach a listener to the stream
    _sub = linkStream.listen((String? link) {
      // Parse the link and warn the user, if it is not correct
      print(link);
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      print("Exception!!!!!!!!!~~~~~~~");
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }
}