import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/constants/validations.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/edit_Contact_Provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/imagePickerDialog.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/widgets/organizedEventsCard.dart';

class EditContactScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  EditContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context),
        body: BaseView<EditContactProvider>(
          builder: (builder, provider, _) {
            return SingleChildScrollView(
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
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Stack(
                                  children: [
                                    provider.image != null
                                        ? ImageView(
                                            file: provider.image,
                                            width: scaler.getWidth(20),
                                            fit: BoxFit.cover,
                                            height: scaler.getWidth(20),
                                          )
                                        : Container(
                                            color: ColorConstants.primaryColor,
                                            width: scaler.getWidth(20),
                                            height: scaler.getWidth(20),
                                          ),
                                    Positioned(
                                        right: 5,
                                        top: 5,
                                        child: CircleAvatar(
                                          radius: scaler.getWidth(2),
                                          child: ClipOval(
                                            child: Container(
                                              color: ColorConstants.colorWhite,
                                              width: scaler.getWidth(5),
                                              height: scaler.getHeight(5),
                                              child: Center(
                                                child: ImageView(
                                                  color:
                                                      ColorConstants.colorBlack,
                                                  path: ImageConstants.ic_edit,
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
                            child: Text("name".tr()).boldText(Colors.black,
                                scaler.getTextSize(9.5), TextAlign.center),
                          ),
                          SizedBox(
                            height: scaler.getHeight(0.2),
                          ),
                          TextFormField(
                            //   enabled: signUpType!=StringConstants.social,
                            textCapitalization: TextCapitalization.sentences,
                            controller: nameController,
                            style: ViewDecoration.textFieldStyle(
                                scaler.getTextSize(9.5),
                                ColorConstants.colorBlack),
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
                            child: Text("email".tr()).boldText(Colors.black,
                                scaler.getTextSize(9.5), TextAlign.center),
                          ),
                          SizedBox(
                            height: scaler.getHeight(0.2),
                          ),
                          TextFormField(
                            //   enabled: signUpType!=StringConstants.social,
                            controller: emailController,
                            style: ViewDecoration.textFieldStyle(
                                scaler.getTextSize(9.5),
                                ColorConstants.colorBlack),
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
                            child: Text("phone_number".tr()).boldText(
                                Colors.black,
                                scaler.getTextSize(9.5),
                                TextAlign.center),
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
                                  padding: scaler.getPaddingAll(0.0),
                                  textStyle: TextStyle(
                                    fontSize: scaler.getTextSize(9.5),
                                    color: ColorConstants.colorBlack,
                                  ),
                                  onChanged: (value) {
                                    // provider.countryCode = value.dialCode;
                                  },
                                  initialSelection: "US",
                                  favorite: ['+91', 'IND'],
                                  showFlag: false,
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
                              onFieldSubmitted: (data) {
                                // FocusScope.of(context).requestFocus(nodes[1]);
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.streetAddress,
                              validator: (value) {},
                            ),
                          ),
                          SizedBox(height: scaler.getHeight(3)),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("organized_events".tr()).boldText(
                                ColorConstants.colorBlack,
                                scaler.getTextSize(10),
                                TextAlign.left),
                          ),
                          SizedBox(height: scaler.getHeight(1.5)),
                        ],
                      ),
                    ),
                    // OrganizedEventsCard(
                    //   showEventRespondBtn: false, showEventScreen: false
                    // ),
                    SizedBox(height: scaler.getHeight(1)),
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
                                    child: Text("discard".tr()).mediumText(
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
                              child: GestureDetector(
                            onTap: () {},
                            child: CustomShape(
                              child: Center(
                                  child: Text("save_changes".tr()).mediumText(
                                      ColorConstants.colorWhite,
                                      scaler.getTextSize(10),
                                      TextAlign.center)),
                              bgColor: ColorConstants.primaryColor,
                              radius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              width: scaler.getWidth(40),
                              height: scaler.getHeight(4.5),
                            ),
                          )),
                        ],
                      ),
                    )
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
