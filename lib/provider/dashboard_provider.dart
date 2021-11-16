import 'package:meetmeyou_app/provider/base_provider.dart';

class DashboardProvider extends BaseProvider {
  int _selectedIndex = 0;

  set selectedIndex(int value) {
    _selectedIndex = value;
  }

  int get selectedIndex => _selectedIndex;

  void onItemTapped(int index) {
    _selectedIndex = index;

    notifyListeners();
  }


}
