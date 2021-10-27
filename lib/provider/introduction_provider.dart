import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meetmeyou_app/widgets/introduction_widget.dart';

class IntroductionProvider extends BaseProvider{
  List<Widget> introWidgetsList = [];
  var buttonText="next".tr();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  void pageChange(int currentPage) {
    if(currentPage==introWidgetsList.length-1){
      buttonText="getStarted".tr();
    }else{
      buttonText="next".tr();
    }
    notifyListeners();
  }

  void setUpList(){
    introWidgetsList=<Widget>[
      IntroductionWidget(
          image: ImageConstants.introduction1,
          title: StringConstants.createEvents,
          subText: StringConstants.introductionSubText1),
      IntroductionWidget(
          image: ImageConstants.introduction2,
          title: StringConstants.inviteYourFriends,
          subText: StringConstants.introductionSubText2),
      IntroductionWidget(
          image: ImageConstants.introduction3,
          title: StringConstants.findEvents,
          subText: StringConstants.introductionSubText2),
    ];
  }
}