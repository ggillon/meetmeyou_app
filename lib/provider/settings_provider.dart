import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class SettingsProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void updateLoadingStatus(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getUserDetail(BuildContext context) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var userProfile = await mmyEngine!.getUserProfile().catchError((e) {
      setState(ViewState.Busy);
      DialogHelper.showMessage(context, e.message);
    });

    userDetail.firstName = userProfile.firstName ?? "";
    userDetail.lastName = userProfile.lastName ?? "";
    userDetail.email = userProfile.email ?? "";
    userDetail.phone = userProfile.phoneNumber ?? "";
    userDetail.address = userProfile.addresses!['Home'];
    userDetail.profileUrl = userProfile.photoURL ?? "";

    setState(ViewState.Idle);
    notifyListeners();
  }

}
