import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';


import 'custom_shape.dart';
import 'image_view.dart';

class LoginOptionWidget extends StatelessWidget {
  final String? title;
  final String? imagePath;

  LoginOptionWidget({Key? key, this.title, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return CustomShape(
      child: Center(
          child: Row(
        children: [
          SizedBox(
            width: scaler.getWidth(5),
          ),
          ImageView(path: imagePath,width: scaler.getHeight(2),height: scaler.getHeight(2),),
          SizedBox(
            width: scaler.getWidth(5),
          ),
          Text(title!).semiBoldText(ColorConstants.colorBlack,
              scaler.getTextSize(11), TextAlign.center)
        ],
      )),
      bgColor: Colors.transparent,
      strokeColor: ColorConstants.colorBlack,
      radius: BorderRadius.all(Radius.circular(10)),
      height: scaler.getHeight(4),
      width: MediaQuery.of(context).size.width,
    );
  }
}
