import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/helper/shared_pref.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/provider/login_option_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/dashboard/dashboardPage.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/full_screen_loader.dart';
import 'package:meetmeyou_app/widgets/login_option_widget.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginOptions extends StatelessWidget {
  const LoginOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return BaseView<LoginOptionProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: scaler.getPaddingAll(13),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: scaler.getHeight(10),
                        ),
                        Text("welcome".tr()).semiBoldText(
                            ColorConstants.colorBlack,
                            scaler.getTextSize(16.5),
                            TextAlign.center),
                        Text("find_events_connect".tr()).regularText(
                            ColorConstants.colorBlack,
                            scaler.getTextSize(11),
                            TextAlign.center)
                      ],
                    ),
                    Column(
                      children: [
                        provider.moreOption
                            ? Column(
                                children: [
                                  Platform.isIOS
                                      ? GestureDetector(
                                          onTap: () {
                                            provider.userDetail.loginAfterDeepLink = false;
                                            provider.signInWithFb(context);
                                          },
                                          child: CustomShape(
                                            child: Center(
                                                child: LoginOptionWidget(
                                              title: "continue_fb".tr(),
                                              imagePath: ImageConstants.ic_fb,
                                            )),
                                            bgColor: Colors.transparent,
                                            strokeColor:
                                                ColorConstants.colorBlack,
                                            radius: BorderRadius.all(
                                                Radius.circular(10)),
                                            height: scaler.getHeight(5),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: scaler.getHeight(1.8),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      provider.userDetail.loginAfterDeepLink = false;
                                      Navigator.pushNamed(
                                          context, RoutesConstants.login);
                                    },
                                    child: CustomShape(
                                      child: Center(
                                          child: Center(
                                              child: LoginOptionWidget(
                                        title: "continue_email".tr(),
                                        imagePath: ImageConstants.ic_mail,
                                      ))),
                                      bgColor: Colors.transparent,
                                      strokeColor: ColorConstants.colorBlack,
                                      radius:
                                          BorderRadius.all(Radius.circular(10)),
                                      height: scaler.getHeight(5),
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      provider.userDetail.loginAfterDeepLink = false;
                                      provider.state == ViewState.Busy
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : provider.signInWithGoogle(context);
                                    },
                                    child: CustomShape(
                                      child: Center(
                                          child: LoginOptionWidget(
                                        title: "continue_google".tr(),
                                        imagePath: ImageConstants.ic_google,
                                      )),
                                      bgColor: Colors.transparent,
                                      strokeColor: ColorConstants.colorBlack,
                                      radius:
                                          BorderRadius.all(Radius.circular(10)),
                                      height: scaler.getHeight(5),
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                  SizedBox(
                                    height: scaler.getHeight(1.8),
                                  ),
                                  Platform.isIOS
                                      ? GestureDetector(
                                          onTap: () {
                                            provider.userDetail.loginAfterDeepLink = false;
                                            signInWithApple(context, provider);
                                          },
                                          child: CustomShape(
                                            child: Center(
                                                child: Center(
                                                    child: LoginOptionWidget(
                                              title: "continue_apple".tr(),
                                              imagePath:
                                                  ImageConstants.ic_apple,
                                            ))),
                                            bgColor: Colors.transparent,
                                            strokeColor:
                                                ColorConstants.colorBlack,
                                            radius: BorderRadius.all(
                                                Radius.circular(10)),
                                            height: scaler.getHeight(5),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            provider.userDetail.loginAfterDeepLink = false;
                                            provider.state == ViewState.Busy
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : provider
                                                    .signInWithFb(context);
                                          },
                                          child: CustomShape(
                                            child: Center(
                                                child: LoginOptionWidget(
                                              title: "continue_fb".tr(),
                                              imagePath: ImageConstants.ic_fb,
                                            )),
                                            bgColor: Colors.transparent,
                                            strokeColor:
                                                ColorConstants.colorBlack,
                                            radius: BorderRadius.all(
                                                Radius.circular(10)),
                                            height: scaler.getHeight(5),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                        ),
                                ],
                              ),
                        SizedBox(
                          height: scaler.getHeight(1.8),
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.userDetail.loginAfterDeepLink = false;
                            provider.updateMoreOptions(!provider.moreOption);
                          },
                          child: CustomShape(
                            child: Center(
                                child: Text(provider.moreOption
                                        ? "back".tr()
                                        : "more_options".tr())
                                    .mediumText(
                                        ColorConstants.primaryColor,
                                        scaler.getTextSize(11),
                                        TextAlign.center)),
                            bgColor:
                                ColorConstants.primaryColor.withOpacity(0.2),
                            radius: BorderRadius.all(Radius.circular(10)),
                            height: scaler.getHeight(5.5),
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: scaler.getHeight(2),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              provider.state == ViewState.Idle
                  ? Container()
                  : FullScreenLoader()
            ],
          ),
        ),
      );
    });
  }

  Future<void> signInWithApple(BuildContext context, LoginOptionProvider provider) async {
  //  initiateSignInWithApple(context);
    var user = await provider.auth.signInWithApple().catchError((e) {
      provider.setState(ViewState.Idle);
      DialogHelper.showDialogWithOneButton(context, "error".tr(), e.message);
    });
    if (user != null) {
      provider.setState(ViewState.Busy);
      provider.mmyEngine = locator<MMYEngine>(param1: provider.auth.currentUser);
      var value = await provider.mmyEngine!.isNew();
      if (value) {
        var userProfile = await provider.mmyEngine!.createUserProfile();
        provider.userDetail.email = userProfile.email;
        provider.userDetail.firstName = userProfile.firstName;
        provider.userDetail.lastName = userProfile.lastName;
        provider.userDetail.profileUrl = userProfile.photoURL;
      //   provider.setState(ViewState.Idle);
      //   Navigator.pushNamed(context, RoutesConstants.signUpPage,
      //       arguments: StringConstants.social);
      // } else {
        await provider.mmyEngine!.appleFirstSignIn();
        provider.userDetail.appleSignUpType = true;
        provider.setState(ViewState.Idle);
        SharedPref.prefs?.setBool(SharedPref.IS_USER_LOGIN, true);
        Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesConstants.dashboardPage, (route) => false, arguments: DashboardPage(isFromLogin: true));
      } else {
        provider.userDetail.appleSignUpType = true;
        provider.setState(ViewState.Idle);
        SharedPref.prefs?.setBool(SharedPref.IS_USER_LOGIN, true);
        Navigator.of(context).pushNamedAndRemoveUntil(
            RoutesConstants.dashboardPage, (route) => false, arguments: DashboardPage(isFromLogin: true));
      }
    }
  }

  void initiateSignInWithApple(BuildContext context) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ]);
    }catch (error) {
      print("error with apple sign in");
    }
  }

}
