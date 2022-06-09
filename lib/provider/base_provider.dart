import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:permission_handler/permission_handler.dart';

class BaseProvider extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;
  AuthBase auth = locator<AuthBase>();
  //Api api = locator<Api>();
  bool _disposed = false;

  void setState(ViewState viewState) {
    _state = viewState;
    if (!_disposed) {
      notifyListeners();
    }
  }

  StreamSubscription? eventsNotifyEvent;
  StreamSubscription? messageNotifyEvent;
  StreamSubscription? ContactInvitationNotifyEvent;

  // this is used for deep link
  StreamSubscription? sub;

  // this is when user comes from deeplink
  StreamSubscription? eventInviteFromLink;

  @override
  void dispose() {
    eventsNotifyEvent?.cancel();
    messageNotifyEvent?.cancel();
    ContactInvitationNotifyEvent?.cancel();
    eventInviteFromLink?.cancel();
    sub?.cancel();
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}

