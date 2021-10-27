import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meetmeyou_app/widgets/introduction_widget.dart';

class LoginOptionProvider extends BaseProvider {
  bool _moreOption = false;

  bool get moreOption => _moreOption;

  void updateMoreOptions(bool value) {
    _moreOption = value;
    notifyListeners();
  }
}
