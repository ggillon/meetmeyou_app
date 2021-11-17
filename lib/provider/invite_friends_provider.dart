import 'package:meetmeyou_app/provider/base_provider.dart';

class InviteFriendsProvider extends BaseProvider {
  bool _value= false;

  bool get value => _value;

  void updateValue(bool value) {
    _value = value;
    notifyListeners();
  }

  late List<bool> _isChecked;

  List<bool> get isChecked => _isChecked;

  set isChecked(List<bool> value) {
    _isChecked = value;
  }

  setCheckBoxValue(bool value, int index) {
    _isChecked[index] = value;
    notifyListeners();
  }

  List<String> _myContactListName = [
    'jenny wilson',
    'Robert fox',
    'Elenor pena',
    "Bessie cooper",
    "Danny bill",
    "sachin kalra",
    "Rohit kumar",
    "Bhavneet",
    "Pardeep",
    "Sahil",
    "Chetan",
    "Tarun",
    "Sagar",
    "Kanwar Sharma",
    "Mohit",
    "Divesh",
    "Lucky",
    "Sandeep",
    "vikas",
    "Annie",
    "shivam",
    "justin"
  ];

  List<String> get myContactListName => _myContactListName;

  List<String> sortContactList() {
    _myContactListName = _myContactListName
        .map((_myContactListName) => _myContactListName.toLowerCase())
        .toList();
    _myContactListName.sort();
    return _myContactListName;
  }
}
