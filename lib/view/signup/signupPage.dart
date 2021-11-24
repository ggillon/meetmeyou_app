import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/constants/validations.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/common_used.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/signup_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/imagePickerDialog.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:google_maps_webservice/places.dart';

class SignUpPage extends StatelessWidget {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final String? signUpType;

  SignUpPage({Key? key, @required this.signUpType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: BaseView<SignUpProvider>(
          onModelReady: (provider) {
            if (signUpType == StringConstants.social) {
              firstNameController.text = provider.userDetail.firstName ?? '';
              lastNameController.text = provider.userDetail.lastName ?? '';
              emailController.text = provider.userDetail.email ?? '';
            }
          },
          builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: scaler.getPaddingAll(13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: scaler.getHeight(5),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Stack(
                          children: [
                            GestureDetector(
                              child: provider.image == null &&
                                      signUpType != StringConstants.social
                                  ? Container(
                                      color: ColorConstants.primaryColor,
                                      width: scaler.getWidth(20),
                                      height: scaler.getWidth(20),
                                    )
                                  : provider.userDetail.profileUrl != null
                                      ? ImageView(
                                          path: provider.userDetail.profileUrl,
                                          width: scaler.getWidth(20),
                                          fit: BoxFit.cover,
                                          height: scaler.getWidth(20),
                                        )
                                      : provider.image == null
                                          ? Container(
                                              color:
                                                  ColorConstants.primaryColor,
                                              width: scaler.getWidth(20),
                                              height: scaler.getWidth(20),
                                            )
                                          : ImageView(
                                              file: provider.image,
                                              width: scaler.getWidth(20),
                                              fit: BoxFit.cover,
                                              height: scaler.getWidth(20),
                                            ),
                              onTap: () async {
                                if (provider.userDetail.profileUrl == null) {
                                  var value = await provider.permissionCheck();
                                  if (value) {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialog(
                                              cameraClick: () {
                                                provider.getImage(context, 1);
                                              },
                                              galleryClick: () {
                                                provider.getImage(context, 2);
                                              },
                                              cancelClick: () {
                                                Navigator.of(context).pop();
                                              },
                                            ));
                                  }
                                }
                              },
                            ),
                            Positioned(
                              right: 5,
                              top: 5,
                              child: provider.userDetail.profileUrl == null
                                  ? CircleAvatar(
                                      radius: scaler.getWidth(2),
                                      child: ClipOval(
                                        child: Container(
                                          color: ColorConstants.colorWhite,
                                          width: scaler.getWidth(5),
                                          height: scaler.getHeight(5),
                                          child: Center(
                                            child: ImageView(
                                              color: ColorConstants.colorBlack,
                                              path: ImageConstants.ic_edit,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: scaler.getHeight(5),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text("first_name".tr()).boldText(Colors.black,
                            scaler.getTextSize(9.5), TextAlign.center),
                      ),
                      SizedBox(
                        height: scaler.getHeight(0.2),
                      ),
                      TextFormField(
                        enabled: signUpType!=StringConstants.social,
                        textCapitalization: TextCapitalization.sentences,
                        controller: firstNameController,
                        style: ViewDecoration.textFieldStyle(
                            scaler.getTextSize(9.5), ColorConstants.colorBlack),
                        decoration: ViewDecoration.inputDecorationWithCurve(
                            "Cody", scaler, ColorConstants.primaryColor),
                        onFieldSubmitted: (data) {
                          // FocusScope.of(context).requestFocus(nodes[1]);
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "first_name_required".tr();
                          }
                          {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: scaler.getHeight(1),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text("last_name".tr()).boldText(Colors.black,
                            scaler.getTextSize(9.5), TextAlign.center),
                      ),
                      SizedBox(
                        height: scaler.getHeight(0.2),
                      ),
                      TextFormField(
                        enabled: signUpType!=StringConstants.social,
                        textCapitalization: TextCapitalization.sentences,
                        controller: lastNameController,
                        style: ViewDecoration.textFieldStyle(
                            scaler.getTextSize(9.5), ColorConstants.colorBlack),
                        decoration: ViewDecoration.inputDecorationWithCurve(
                            "Fisher", scaler, ColorConstants.primaryColor),
                        onFieldSubmitted: (data) {
                          // FocusScope.of(context).requestFocus(nodes[1]);
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "last_name_required".tr();
                          }
                          {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: scaler.getHeight(1),
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
                        enabled: signUpType!=StringConstants.social,
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
                      signUpType==StringConstants.social?Container():Column(children: [
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
                          onFieldSubmitted: (data) {},
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "password_required".tr();
                            } else if (!Validations.validateStructure(value)) {
                              return "invalid_password_format".tr();
                            }
                            {
                              return null;
                            }
                          },
                        )
                      ],),
                      SizedBox(
                        height: scaler.getHeight(1),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text("phone_number".tr()).boldText(Colors.black,
                            scaler.getTextSize(9.5), TextAlign.center),
                      ),
                      SizedBox(
                        height: scaler.getHeight(0.2),
                      ),
                      Container(
                        height: scaler.getHeight(3.8),
                        child: TextFormField(
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: phoneNumberController,
                          style: ViewDecoration.textFieldStyle(
                              scaler.getTextSize(9.5),
                              ColorConstants.colorBlack),
                          decoration:
                          ViewDecoration.inputDecorationWithCurve(
                            "",
                            scaler,
                            ColorConstants.primaryColor,
                            prefixIcon: CountryCodePicker(
                              onChanged: (value) {
                                provider.countryCode = value.dialCode!;
                              },
                              padding: scaler.getPaddingAll(0.0),
                              textStyle: TextStyle(
                                fontSize: scaler.getTextSize(9.5),
                                color: ColorConstants.colorBlack,
                              ),
                              initialSelection: "US",
                              favorite: ['+91', 'IND'],
                              showFlag: true,
                              showFlagDialog: true,
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                            ),
                          ),
                          onFieldSubmitted: (data) {
                            // FocusScope.of(context).requestFocus(nodes[1]);
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return null;
                            } else if (!Validations.validateMobile(
                                value.trim())) {
                              return "invalid_phone_number".tr();
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: scaler.getHeight(1),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text("address".tr()).boldText(Colors.black,
                            scaler.getTextSize(9.5), TextAlign.center),
                      ),
                      SizedBox(
                        height: scaler.getHeight(0.2),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.pushNamed(
                                  context, RoutesConstants.autoComplete)
                              .then((value) {
                            if (value != null) {
                              Map<String, String> detail =
                                  value as Map<String, String>;
                              final lat = value["latitude"];
                              final lng = value["longitude"];
                              final selectedAddress = detail["address"];
                              addressController.text = selectedAddress != null
                                  ? selectedAddress
                                  : "";
                            }
                          });
                        },
                        child: TextFormField(
                          enabled: false,
                          controller: addressController,
                          style: ViewDecoration.textFieldStyle(
                              scaler.getTextSize(9.5),
                              ColorConstants.colorBlack),
                          decoration: ViewDecoration.inputDecorationWithCurve(
                              "enter_address".tr(),
                              scaler,
                              ColorConstants.primaryColor,
                              icon: Icons.map),
                          onFieldSubmitted: (data) {
                            // FocusScope.of(context).requestFocus(nodes[1]);
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.streetAddress,
                          validator: (value) {},
                        ),
                      ),
                      SizedBox(
                        height: scaler.getHeight(5),
                      ),
                      provider.state == ViewState.Idle
                          ? GestureDetector(
                              onTap: () {
                                hideKeyboard(context);
                                if (_formKey.currentState!.validate()) {
                                  if(signUpType==StringConstants.social){
                                    provider.updateProfile(context, firstNameController.text, lastNameController.text, emailController.text, provider.countryCode, provider.phone, addressController.text);
                                  }else{
                                    var userDetail = UserDetail();
                                    userDetail.email = emailController.text;
                                    userDetail.firstName =
                                        firstNameController.text;
                                    userDetail.lastName = lastNameController.text;
                                    userDetail.countryCode = provider.countryCode;
                                    userDetail.phone = phoneNumberController.text;
                                    userDetail.password = passwordController.text;
                                    userDetail.profileFile = provider.image;
                                    userDetail.address = addressController.text;
                                    provider.sendOtpToMail(
                                        emailController.text.toString());
                                    Navigator.pushNamed(
                                        context, RoutesConstants.verifyPage,
                                        arguments: userDetail);
                                  }
                                }
                                //var user=User();
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
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
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
                        child: Text("sign_in_different_account".tr())
                            .semiBoldText(ColorConstants.primaryColor,
                                scaler.getTextSize(9.5), TextAlign.center),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
