import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/multiple_date_time_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';

class MultipleDateTmeScreen extends StatelessWidget {
  const MultipleDateTmeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      appBar: DialogHelper.appBarWithBack(scaler, context),
      backgroundColor: ColorConstants.colorWhite,
      body: BaseView<MultipleDateTimeProvider>(
        builder: (context, provider, _) {
          return SafeArea(
            child: Padding(
              padding: scaler.getPaddingLTRB(3.0, 0.0, 3.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("choose_date_time".tr()).boldText(
                      ColorConstants.colorBlack,
                      scaler.getTextSize(14),
                      TextAlign.left),
                  SizedBox(height: scaler.getHeight(2.5)),
                  Text("choose_date".tr()).boldText(ColorConstants.colorBlack,
                      scaler.getTextSize(9.5), TextAlign.center),
                  SizedBox(height: scaler.getHeight(0.5)),
                  chooseDate(context, scaler, provider),
                  SizedBox(height: scaler.getHeight(1.5)),
                  Text("start_time".tr()).boldText(ColorConstants.colorBlack,
                      scaler.getTextSize(9.5), TextAlign.center),
                  SizedBox(height: scaler.getHeight(0.5)),
                  chooseStartTime(context, scaler, provider),
                  SizedBox(height: scaler.getHeight(1.5)),
                  Text("end_time".tr()).boldText(ColorConstants.colorBlack,
                      scaler.getTextSize(9.5), TextAlign.center),
                  SizedBox(height: scaler.getHeight(0.5)),
                  chooseEndTime(context, scaler, provider),
                  Expanded(
                      child: Container(
                          alignment: Alignment.bottomCenter,
                          child: CommonWidgets.commonBtn(
                              scaler,
                              context,
                              "add_date_to_event".tr(),
                              ColorConstants.primaryColor,
                              ColorConstants.colorWhite, onTapFun: (){
                                  provider.multipleDateOption.date.add(provider.date);
                                provider.multipleDateOption.startTime.add(provider.startTime);
                                provider.multipleDateOption.endTime.add(provider.endTime);
                                provider.setState(ViewState.Busy);
                                Navigator.of(context).pop();
                          }))),
                  SizedBox(height: scaler.getHeight(0.5)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget chooseDate(BuildContext context, ScreenScaler scaler,
      MultipleDateTimeProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.pickDateDialog(context, true);
      },
      child: Container(
          height: scaler.getHeight(4),
          width: double.infinity,
          decoration: BoxDecoration(
              color: ColorConstants.colorLightGray,
              border: Border.all(
                color: ColorConstants.colorLightGray,
              ),
              borderRadius: scaler.getBorderRadiusCircular(8.0)),
          child: Container(
            padding: scaler.getPaddingLTRB(1.5, 0.0, 1.5, 0.0),
            alignment: Alignment.centerLeft,
            child: Text(DateTimeHelper.dateConversion(provider.date))
                .regularText(ColorConstants.colorBlackDown,
                    scaler.getTextSize(9.5), TextAlign.center),
          )),
    );
  }

  Widget chooseStartTime(BuildContext context, ScreenScaler scaler,
      MultipleDateTimeProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.selectTimeDialog(context, true);
      },
      child: Container(
          height: scaler.getHeight(4),
          width: double.infinity,
          decoration: BoxDecoration(
              color: ColorConstants.colorLightGray,
              border: Border.all(
                color: ColorConstants.colorLightGray,
              ),
              borderRadius: scaler.getBorderRadiusCircular(8.0)),
          child: Container(
            padding: scaler.getPaddingLTRB(1.5, 0.0, 1.5, 0.0),
            alignment: Alignment.centerLeft,
            child: Text(DateTimeHelper.timeConversion(provider.startTime))
                .regularText(ColorConstants.colorBlackDown,
                    scaler.getTextSize(9.5), TextAlign.center),
          )),
    );
  }

  Widget chooseEndTime(BuildContext context, ScreenScaler scaler,
      MultipleDateTimeProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.selectTimeDialog(context, false);
      },
      child: Container(
          height: scaler.getHeight(4),
          width: double.infinity,
          decoration: BoxDecoration(
              color: ColorConstants.colorLightGray,
              border: Border.all(
                color: ColorConstants.colorLightGray,
              ),
              borderRadius: scaler.getBorderRadiusCircular(8.0)),
          child: Container(
            padding: scaler.getPaddingLTRB(1.5, 0.0, 1.5, 0.0),
            alignment: Alignment.centerLeft,
            child: Text(DateTimeHelper.timeConversion(provider.endTime))
                .regularText(ColorConstants.colorBlackDown,
                    scaler.getTextSize(9.5), TextAlign.center),
          )),
    );
  }
}
