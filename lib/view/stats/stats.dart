import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorLightCyan,
      body: SafeArea(
        child: Padding(
          padding: scaler.getPaddingLTRB(2.5, 1.0, 2.5, 0),
          child: Column(
            children: [
              Text("stats".tr()).boldText(ColorConstants.colorBlack,
                  scaler.getTextSize(16), TextAlign.left),
            ],
          ),
        ),
      ),
    );
  }
}
