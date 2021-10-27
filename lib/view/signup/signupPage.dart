import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
class SignUpPage extends StatelessWidget {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();

  SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: SingleChildScrollView(
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
                      Container(color: ColorConstants.primaryColor,width: scaler.getWidth(20),height: scaler.getWidth(20),),
                      Positioned(
                        right: 5,
                        top:5,
                        child: CircleAvatar(
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
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: scaler.getHeight(5),
                ),
                Align(alignment: Alignment.bottomLeft,child: Text("name".tr()).boldText(
                    Colors.black, scaler.getTextSize(9.5), TextAlign.center),),
                SizedBox(height: scaler.getHeight(0.2),),
                TextFormField(
                  controller: nameController,
                  style: ViewDecoration.textFieldStyle(scaler.getTextSize(9.5),ColorConstants.colorBlack),
                  decoration: ViewDecoration.inputDecorationWithCurve(
                      "Cody Fisher", scaler, ColorConstants.primaryColor),
                  onFieldSubmitted: (data) {
                    // FocusScope.of(context).requestFocus(nodes[1]);
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {},
                ),

                SizedBox(
                  height: scaler.getHeight(1),
                ),
                Align(alignment: Alignment.bottomLeft,child: Text("email".tr()).boldText(
                    Colors.black, scaler.getTextSize(9.5), TextAlign.center),),
                SizedBox(height: scaler.getHeight(0.2),),
                TextFormField(
                  controller: emailController,
                  style: ViewDecoration.textFieldStyle(scaler.getTextSize(9.5),ColorConstants.colorBlack),
                  decoration: ViewDecoration.inputDecorationWithCurve(
                      "sample@gmail.com", scaler, ColorConstants.primaryColor),
                  onFieldSubmitted: (data) {
                    // FocusScope.of(context).requestFocus(nodes[1]);
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {},
                ),

                SizedBox(
                  height: scaler.getHeight(1),
                ),

                Align(alignment: Alignment.bottomLeft,child: Text("password".tr()).boldText(
                    Colors.black, scaler.getTextSize(9.5), TextAlign.center),),
                SizedBox(height: scaler.getHeight(0.2),),
                TextFormField(
                  controller: passwordController,
                  style: ViewDecoration.textFieldStyle(scaler.getTextSize(9.5),ColorConstants.colorBlack),
                  decoration: ViewDecoration.inputDecorationWithCurve(
                      "", scaler, ColorConstants.primaryColor),
                  onFieldSubmitted: (data) {
                    // FocusScope.of(context).requestFocus(nodes[1]);
                  },
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  validator: (value) {},
                ),

                SizedBox(
                  height: scaler.getHeight(1),
                ),
                Align(alignment: Alignment.bottomLeft,child: Text("phone_number".tr()).boldText(
                    Colors.black, scaler.getTextSize(9.5), TextAlign.center),),
                SizedBox(height: scaler.getHeight(0.2),),
                TextFormField(
                  controller: phoneController,
                  style: ViewDecoration.textFieldStyle(scaler.getTextSize(9.5),ColorConstants.colorBlack),
                  decoration: ViewDecoration.inputDecorationWithCurve(
                      "+917814474403", scaler, ColorConstants.primaryColor),
                  onFieldSubmitted: (data) {
                    // FocusScope.of(context).requestFocus(nodes[1]);
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  validator: (value) {},
                ),


                SizedBox(
                  height: scaler.getHeight(1),
                ),
                Align(alignment: Alignment.bottomLeft,child: Text("address".tr()).boldText(
                    Colors.black, scaler.getTextSize(9.5), TextAlign.center),),
                SizedBox(height: scaler.getHeight(0.2),),
                TextFormField(
                  controller: addressController,
                  style: ViewDecoration.textFieldStyle(scaler.getTextSize(9.5),ColorConstants.colorBlack),
                  decoration: ViewDecoration.inputDecorationWithCurve(
                      "Madison Square Garden", scaler, ColorConstants.primaryColor),
                  onFieldSubmitted: (data) {
                    // FocusScope.of(context).requestFocus(nodes[1]);
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) {},
                ),

                SizedBox(height: scaler.getHeight(5),),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesConstants.verifyPage);
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
                ),
                SizedBox(height: scaler.getHeight(3),),
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
      ),
    );
  }
}
