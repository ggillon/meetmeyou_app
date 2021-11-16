import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class MyAccountProvider extends BaseProvider {
  UserDetail userDetail = locator<UserDetail>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void updateLoadingStatus(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? address;
  String? userProfilePic;

  Future<void> getUserDetail() async {
    firstName = userDetail.firstName ?? "";
    lastName = userDetail.lastName ?? "";
    email = userDetail.email ?? "";
    phoneNumber = userDetail.phone ?? "";
    address = userDetail.address ?? "";
    userProfilePic = userDetail.profileUrl ?? "";

    notifyListeners();
  }
}
