import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/provider/verify_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class VerifyScreen extends StatelessWidget {
  StreamController<ErrorAnimationType>? errorController =
      StreamController<ErrorAnimationType>();
  final textEditingController = TextEditingController();

  VerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: BaseView<VerifyProvider>(
          onModelReady: (provider) {},
          builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: scaler.getPaddingAll(13),
                child: Column(
                  children: [
                    SizedBox(
                      height: scaler.getHeight(5),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageView(
                          path: ImageConstants.ic_logo,
                          width: scaler.getHeight(8),
                          height: scaler.getHeight(8),
                        ),
                        SizedBox(
                          width: scaler.getWidth(2),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("verify_identity".tr()).semiBoldText(
                                  ColorConstants.colorBlack,
                                  scaler.getTextSize(14),
                                  TextAlign.start),
                              Text("enter_code_email_address".tr())
                                  .regularText(ColorConstants.colorBlack,
                                      scaler.getTextSize(10), TextAlign.start)
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: scaler.getHeight(20),
                    ),
                    Container(
                      width: scaler.getWidth(65),
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 4,
                        obscuringCharacter: '*',
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                            activeColor: provider.correctOtp
                                ? ColorConstants.colorLightGray
                                : ColorConstants.colorRed,
                            disabledColor: ColorConstants.colorLightGray,
                            inactiveFillColor: ColorConstants.colorLightGray,
                            inactiveColor: ColorConstants.colorLightGray,
                            selectedColor: ColorConstants.primaryColor,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: scaler.getHeight(4),
                            fieldWidth: scaler.getHeight(4),
                            errorBorderColor: ColorConstants.colorRed,
                            activeFillColor: ColorConstants.colorLightGray,
                            selectedFillColor: ColorConstants.colorLightGray),
                        cursorColor: Colors.black,
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: true,
                        errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        boxShadows: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: ColorConstants.colorLightGray,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (v) {
                          provider.updateOtpStatus(false);
                        },
                        onChanged: (value) {},
                        beforeTextPaste: (text) {
                          return true;
                        },
                      ),
                    ),
                    provider.correctOtp
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageView(
                                path: ImageConstants.ic_error,
                              ),
                              SizedBox(
                                width: scaler.getWidth(1),
                              ),
                              Text("incorrect_verification".tr()).regularText(
                                  ColorConstants.colorRed,
                                  scaler.getTextSize(8),
                                  TextAlign.center)
                            ],
                          ),
                    SizedBox(
                      height: scaler.getHeight(1),
                    ),
                    Text("not_receive_code".tr()).semiBoldText(
                        ColorConstants.colorBlack,
                        scaler.getTextSize(9.5),
                        TextAlign.center),
                    SizedBox(
                      height: scaler.getHeight(25),
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
                      child: Text("sign_in_different_account".tr())
                          .semiBoldText(ColorConstants.primaryColor,
                              scaler.getTextSize(9.5), TextAlign.center),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
