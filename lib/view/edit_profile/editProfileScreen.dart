import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/constants/validations.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_used.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/edit_profile_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/imagePickerDialog.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/widgets/organizedEventsCard.dart';

class EditProfileScreen extends StatelessWidget {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  EditProfileProvider? provider;
  UserDetail userDetail = locator<UserDetail>();

  EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: DialogHelper.appBarWithBack(scaler, context),
      body: BaseView<EditProfileProvider>(
        onModelReady: (provider) {
          this.provider = provider;
          provider.setUserDetail(firstNameController, lastNameController,
              emailController, phoneNumberController, addressController);
        },
        builder: (context, provider, _) {
          return provider.state == ViewState.Busy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: scaler.getPaddingLTRB(2.5, 1, 2.5, 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      var value =
                                          await provider.permissionCheck();
                                      if (value) {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CustomDialog(
                                                  cameraClick: () {
                                                    provider.getImage(
                                                        context, 1);
                                                  },
                                                  galleryClick: () {
                                                    provider.getImage(
                                                        context, 2);
                                                  },
                                                  cancelClick: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ));
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Stack(
                                        children: [
                                          provider.image == null
                                              ? provider.imageUrl != null
                                                  ? Container(
                                                      width:
                                                          scaler.getWidth(20),
                                                      height:
                                                          scaler.getWidth(20),
                                                      child: ImageView(
                                                        path: provider.imageUrl,
                                                        width:
                                                            scaler.getWidth(20),
                                                        fit: BoxFit.cover,
                                                        height:
                                                            scaler.getWidth(20),
                                                      ),
                                                    )
                                                  : Container(
                                                      color: ColorConstants
                                                          .primaryColor,
                                                      width:
                                                          scaler.getWidth(20),
                                                      height:
                                                          scaler.getWidth(20),
                                                    )
                                              : provider.image != null
                                                  ? Container(
                                                      width:
                                                          scaler.getWidth(20),
                                                      height:
                                                          scaler.getWidth(20),
                                                      child: ImageView(
                                                        file: provider.image,
                                                        width:
                                                            scaler.getWidth(20),
                                                        fit: BoxFit.cover,
                                                        height:
                                                            scaler.getWidth(20),
                                                      ),
                                                    )
                                                  : Container(
                                                      color: ColorConstants
                                                          .primaryColor,
                                                      width:
                                                          scaler.getWidth(20),
                                                      height:
                                                          scaler.getWidth(20),
                                                    ),
                                          Positioned(
                                              right: 5,
                                              top: 5,
                                              child: CircleAvatar(
                                                radius: scaler.getWidth(2),
                                                child: ClipOval(
                                                  child: Container(
                                                    color: ColorConstants
                                                        .colorWhite,
                                                    width: scaler.getWidth(5),
                                                    height: scaler.getHeight(5),
                                                    child: Center(
                                                      child: ImageView(
                                                        color: ColorConstants
                                                            .colorBlack,
                                                        path: ImageConstants
                                                            .ic_edit,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: scaler.getHeight(2),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text("first_name".tr()).boldText(
                                      Colors.black,
                                      scaler.getTextSize(9.5),
                                      TextAlign.center),
                                ),
                                SizedBox(
                                  height: scaler.getHeight(0.2),
                                ),
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: firstNameController,
                                  style: ViewDecoration.textFieldStyle(
                                      scaler.getTextSize(9.5),
                                      ColorConstants.colorBlack),
                                  decoration:
                                      ViewDecoration.inputDecorationWithCurve(
                                          "Cody",
                                          scaler,
                                          ColorConstants.primaryColor),
                                  onFieldSubmitted: (data) {},
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
                                  child: Text("last_name".tr()).boldText(
                                      Colors.black,
                                      scaler.getTextSize(9.5),
                                      TextAlign.center),
                                ),
                                SizedBox(
                                  height: scaler.getHeight(0.2),
                                ),
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: lastNameController,
                                  style: ViewDecoration.textFieldStyle(
                                      scaler.getTextSize(9.5),
                                      ColorConstants.colorBlack),
                                  decoration:
                                      ViewDecoration.inputDecorationWithCurve(
                                          "Fisher",
                                          scaler,
                                          ColorConstants.primaryColor),
                                  onFieldSubmitted: (data) {},
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
                                  child: Text("email".tr()).boldText(
                                      Colors.black,
                                      scaler.getTextSize(9.5),
                                      TextAlign.center),
                                ),
                                SizedBox(
                                  height: scaler.getHeight(0.2),
                                ),
                                TextFormField(
                                  controller: emailController,
                                  style: ViewDecoration.textFieldStyle(
                                      scaler.getTextSize(9.5),
                                      ColorConstants.colorBlack),
                                  decoration:
                                      ViewDecoration.inputDecorationWithCurve(
                                          "sample@gmail.com",
                                          scaler,
                                          ColorConstants.primaryColor),
                                  onFieldSubmitted: (data) {},
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
                                  child: Text("phone_number".tr()).boldText(
                                      Colors.black,
                                      scaler.getTextSize(9.5),
                                      TextAlign.center),
                                ),
                                SizedBox(
                                  height: scaler.getHeight(0.2),
                                ),
                                Container(
                                  child: TextFormField(
                                    inputFormatters: <TextInputFormatter>[
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
                                          provider.countryCode = value.dialCode;
                                        },
                                        padding: scaler.getPaddingLTRB(
                                            0.0, 0.0, 0.0, 0.1),
                                        textStyle:
                                            ViewDecoration.textFieldStyle(
                                                scaler.getTextSize(9.5),
                                                ColorConstants.colorBlack),
                                        initialSelection:
                                            provider.countryCode == ""
                                                ? "US"
                                                : provider.countryCode,
                                        favorite: ['US', 'GB', 'BE', 'FR', 'LU', 'AN', '+49'],
                                        showFlag: false,
                                        showFlagDialog: true,
                                        showCountryOnly: false,
                                        showOnlyCountryWhenClosed: false,
                                        alignLeft: false,
                                      ),
                                    ),
                                    onFieldSubmitted: (data) {},
                                    textInputAction: TextInputAction.done,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: true, decimal: false),
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return "phone_no_cannot_empty".tr();
                                      }
                                      // else if (!Validations.validateMobile(
                                      //     value.trim())) {
                                      //   return "invalid_phone_number".tr();
                                      // }
                                      else {
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
                                  child: Text("address".tr()).boldText(
                                      Colors.black,
                                      scaler.getTextSize(9.5),
                                      TextAlign.center),
                                ),
                                SizedBox(
                                  height: scaler.getHeight(0.2),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.pushNamed(context,
                                            RoutesConstants.autoComplete)
                                        .then((value) {
                                      if (value != null) {
                                        Map<String, String> detail =
                                            value as Map<String, String>;
                                        final lat = value["latitude"];
                                        final lng = value["longitude"];
                                        final selectedAddress =
                                            detail["address"];
                                        addressController.text =
                                            selectedAddress != null
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
                                    decoration:
                                        ViewDecoration.inputDecorationWithCurve(
                                            "Madison square garden",
                                            scaler,
                                            ColorConstants.primaryColor,
                                            icon: Icons.map),
                                    onFieldSubmitted: (data) {},
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.streetAddress,
                                    validator: (value) {},
                                  ),
                                ),
                                SizedBox(height: scaler.getHeight(3)),
                                // Container(
                                //   alignment: Alignment.centerLeft,
                                //   child: Text("organized_events".tr()).boldText(
                                //       ColorConstants.colorBlack,
                                //       scaler.getTextSize(10),
                                //       TextAlign.left),
                                // ),
                                // SizedBox(height: scaler.getHeight(1.5)),
                              ],
                            ),
                          ),
                          OrganizedEventsCard(
                            showEventRespondBtn: false,
                          ),
                          provider.eventDetail.eventListLength!.toInt() > 0
                              ? SizedBox(height: scaler.getHeight(1))
                              : SizedBox(height: scaler.getHeight(9)),
                          Padding(
                            padding: scaler.getPaddingLTRB(2, 0.0, 2, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: CustomShape(
                                      child: Center(
                                          child: Text("discard".tr())
                                              .mediumText(
                                                  ColorConstants.primaryColor,
                                                  scaler.getTextSize(10),
                                                  TextAlign.center)),
                                      bgColor: ColorConstants.primaryColor
                                          .withOpacity(0.2),
                                      radius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      width: scaler.getWidth(40),
                                      height: scaler.getHeight(4.5),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: scaler.getWidth(2),
                                ),
                                Expanded(
                                    child: provider.isLoading == false
                                        ? GestureDetector(
                                            onTap: () {
                                              hideKeyboard(context);
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                String? countryCode;
                                                if (phoneNumberController
                                                    .text.isNotEmpty) {
                                                  countryCode = provider
                                                              .countryCode
                                                              .toString() ==
                                                          ""
                                                      ? "+1"
                                                      : provider.countryCode
                                                          .toString();
                                                } else {
                                                  countryCode = "";
                                                }
                                                provider
                                                    .updateUserProfilePicture(
                                                        context,
                                                        firstNameController
                                                            .text,
                                                        lastNameController.text,
                                                        emailController.text,
                                                        phoneNumberController
                                                            .text,
                                                        countryCode,
                                                        addressController.text);
                                              }
                                            },
                                            child: CustomShape(
                                              child: Center(
                                                  child: Text(
                                                          "save_changes".tr())
                                                      .mediumText(
                                                          ColorConstants
                                                              .colorWhite,
                                                          scaler
                                                              .getTextSize(10),
                                                          TextAlign.center)),
                                              bgColor:
                                                  ColorConstants.primaryColor,
                                              radius: BorderRadius.all(
                                                Radius.circular(12),
                                              ),
                                              width: scaler.getWidth(40),
                                              height: scaler.getHeight(4.5),
                                            ),
                                          )
                                        : Center(
                                            child: CircularProgressIndicator(),
                                          )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
