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


  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

}
