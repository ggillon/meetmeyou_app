import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/provider/calendar_settings_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';

class CalendarSettingsScreen extends StatelessWidget {
  const CalendarSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context),
        body: BaseView<CalendarSettingsProvider>(
          onModelReady: (provider){
          //  provider.getCalendarParams(context);
          },
          builder: (context, provider, _){
            return  Padding(
              padding: scaler.getPaddingLTRB(3.0, 0.0, 3.5, 2.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("calender_settings".tr()).boldText(
                        ColorConstants.colorBlack,
                        scaler.getTextSize(16),
                        TextAlign.left),
                  ),
                  SizedBox(height: scaler.getHeight(2)),
                  synchroniseWithLocalCalendarToggle(context, scaler, provider),
                  SizedBox(height: scaler.getHeight(1.5)),
                  displayNonMeetMeYouEventToggle(context, scaler, provider),
                ],
              ),
            );
          },
        )
      ),
    );
  }

  Widget synchroniseWithLocalCalendarToggle(BuildContext context, ScreenScaler scaler, CalendarSettingsProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("synchronise_with_local_calendar".tr()).regularText(
            ColorConstants.colorBlack, scaler.getTextSize(10), TextAlign.left),
        FlutterSwitch(
          activeColor: ColorConstants.primaryColor,
          width: scaler.getWidth(10.5),
          height: scaler.getHeight(2.3),
          toggleSize: scaler.getHeight(1.8),
          value: provider.calendarDetail.calendarSync!,
          borderRadius: 30.0,
          padding: 2.0,
          showOnOff: false,
          onToggle: (val) {
            provider.calendarDetail.calendarSync = val;
            provider.setCalendarParams(context, provider.calendarDetail.calendarSync!, provider.calendarDetail.calendarDisplay!);
           // provider.updateLoadingStatus(true);
          },
        ),
      ],
    );
  }

  Widget displayNonMeetMeYouEventToggle(BuildContext context, ScreenScaler scaler, CalendarSettingsProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("display_non_MeetMeYou_events".tr()).regularText(
            ColorConstants.colorBlack, scaler.getTextSize(10), TextAlign.left),
        FlutterSwitch(
          activeColor: ColorConstants.primaryColor,
          width: scaler.getWidth(10.5),
          height: scaler.getHeight(2.3),
          toggleSize: scaler.getHeight(1.8),
          value: provider.calendarDetail.calendarDisplay!,
          borderRadius: 30.0,
          padding: 2.0,
          showOnOff: false,
          onToggle: (val) {
            provider.calendarDetail.calendarDisplay = val;
            provider.setCalendarParams(context, provider.calendarDetail.calendarSync!, provider.calendarDetail.calendarDisplay!);
          },
        ),
      ],
    );
  }
}
