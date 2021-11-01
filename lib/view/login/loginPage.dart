import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/constants/validations.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/provider/login_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: BaseView<LoginProvider>(
              /*onModelReady: (provider){

              },*/
              builder: (context,provider,_){
                return Padding(
                  padding: scaler.getPaddingAll(13),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: scaler.getHeight(5),
                          ),
                          ImageView(
                            path: ImageConstants.ic_logo,
                          ),
                          SizedBox(
                            height: scaler.getHeight(5),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text("email".tr()).boldText(Colors.black,
                                scaler.getTextSize(9.5), TextAlign.center),
                          ),
                          SizedBox(
                            height: scaler.getHeight(0.2),
                          ),
                          TextFormField(
                            controller: emailController,
                            style: ViewDecoration.textFieldStyle(
                                scaler.getTextSize(9.5), ColorConstants.colorBlack),
                            decoration: ViewDecoration.inputDecorationWithCurve(
                                "sample@gmail.com",
                                scaler,
                                ColorConstants.primaryColor),
                            onFieldSubmitted: (data) {
                              // FocusScope.of(context).requestFocus(nodes[1]);
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "email_required".tr();
                              } else if (!Validations.emailValidation(
                                  value.trim())) {
                                return "invalid_email".tr();
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: scaler.getHeight(1),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text("password".tr()).boldText(Colors.black,
                                scaler.getTextSize(9.5), TextAlign.center),
                          ),
                          SizedBox(
                            height: scaler.getHeight(0.2),
                          ),
                          TextFormField(
                            controller: passwordController,
                            style: ViewDecoration.textFieldStyle(
                                scaler.getTextSize(9.5), ColorConstants.colorBlack),
                            decoration: ViewDecoration.inputDecorationWithCurve(
                                "", scaler, ColorConstants.primaryColor),
                            onFieldSubmitted: (data) {
                              // FocusScope.of(context).requestFocus(nodes[1]);
                            },
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "password_required".tr();
                              }
                              {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: scaler.getHeight(3),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutesConstants.signUpPage);
                            },
                            child: Padding(
                              padding: scaler.getPaddingAll(3),
                              child: Text("already_an_account".tr()).semiBoldText(
                                  Colors.black,
                                  scaler.getTextSize(9.5),
                                  TextAlign.center),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: scaler.getHeight(20),
                      ),
                      provider.state==ViewState.Idle?GestureDetector(
                        onTap: () {
                          if(_formKey.currentState!.validate()){
                            provider.login(context, emailController.text, passwordController.text);
                          }
                         // Navigator.pushNamed(context, RoutesConstants.verifyPage);
                        },
                        child: CustomShape(
                          child: Center(
                              child: Text("next".tr()).mediumText(
                                  ColorConstants.colorWhite,
                                  scaler.getTextSize(10),
                                  TextAlign.center)),
                          bgColor: ColorConstants.primaryColor,
                          radius: BorderRadius.all(Radius.circular(10)),
                          height: scaler.getHeight(4),
                          width: MediaQuery.of(context).size.width,
                        ),
                      ):CircularProgressIndicator(),
                      SizedBox(
                        height: scaler.getHeight(3),
                      ),
                      Container(
                        width: scaler.getWidth(70),
                        height: scaler.getHeight(0.02),
                        color: ColorConstants.colorGray,
                      ),
                      SizedBox(
                        height: scaler.getHeight(1),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.popUntil(
                            context, (Route<dynamic> route) => route.isFirst);
                        },
                        child: Text("sign_in_different_account".tr()).semiBoldText(
                            ColorConstants.primaryColor,
                            scaler.getTextSize(9.5),
                            TextAlign.center),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
