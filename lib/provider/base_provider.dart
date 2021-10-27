import 'package:flutter/widgets.dart';
import 'package:meetmeyou_app/enum/viewstate.dart';

class BaseProvider extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;
  //Api api = locator<Api>();


  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

}
