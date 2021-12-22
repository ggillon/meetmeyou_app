import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';

class CalendarSettingsScreen extends StatelessWidget {
  const CalendarSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context),
        body: Padding(
          padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 2.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text("calender_settings".tr()).boldText(ColorConstants.colorBlack,
                    scaler.getTextSize(16), TextAlign.left),
              ),
              SizedBox(height: scaler.getHeight(2)),
            ],
          ),
        ),
      ),
    );
  }
}