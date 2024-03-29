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
        onModelReady: (provider) {
          provider.startTime = provider.multipleDateOption.multiStartTime;
          provider.endTime = provider.multipleDateOption.multiEndTime;
          if (provider.startTime.hour >= 21) {
            if (provider.startDate
                    .toString()
                    .substring(0, 11)
                    .compareTo(provider.endDate.toString().substring(0, 11)) ==
                0) {
              provider.endDate = provider.endDate.add(Duration(days: 1));
              provider.endTime = provider.startTime.addHour(3);
            }
          }
          provider.startDate = provider.multipleDateOption.startDate.isNotEmpty ? provider.multipleDateOption.startDate.last : DateTime.now().add(Duration(days: 7));
          provider.endDate = provider.multipleDateOption.endDate.isNotEmpty ? provider.multipleDateOption.endDate.last : DateTime.now().add(Duration(days: 7));
        },
        builder: (context, provider, _) {
          return SafeArea(
            child: Padding(
              padding: scaler.getPaddingLTRB(3.0, 0.0, 3.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("choose_date_time".tr()).boldText(
                      ColorConstants.colorBlack,
                      scaler.getTextSize(15),
                      TextAlign.left),
                  SizedBox(height: scaler.getHeight(2.5)),
                  Text("choose_start_date".tr()).boldText(
                      ColorConstants.colorBlack,
                      scaler.getTextSize(10.5),
                      TextAlign.center),
                  SizedBox(height: scaler.getHeight(0.6)),
                  chooseStartDate(context, scaler, provider),
                  SizedBox(height: scaler.getHeight(2.0)),
                  Text("start_time".tr()).boldText(ColorConstants.colorBlack,
                      scaler.getTextSize(10.5), TextAlign.center),
                  SizedBox(height: scaler.getHeight(0.6)),
                  chooseStartTime(context, scaler, provider),
                  SizedBox(height: scaler.getHeight(2.0)),
                  provider.addEndDate == true
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            provider.addEndDate = true;
                            provider.setState(ViewState.Busy);
                          },
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                children: [
                                  Icon(Icons.add,
                                      color: ColorConstants.primaryColor,
                                      size: 16),
                                  Text("add_end_date_time".tr()).mediumText(
                                      ColorConstants.primaryColor,
                                      scaler.getTextSize(10.8),
                                      TextAlign.center)
                                ],
                              )),
                        ),
                  provider.addEndDate == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("choose_end_date".tr()).boldText(
                                ColorConstants.colorBlack,
                                scaler.getTextSize(10.5),
                                TextAlign.center),
                            SizedBox(height: scaler.getHeight(0.6)),
                            chooseEndDate(context, scaler, provider),
                            SizedBox(height: scaler.getHeight(2.0)),
                            Text("end_time".tr()).boldText(
                                ColorConstants.colorBlack,
                                scaler.getTextSize(10.5),
                                TextAlign.center),
                            SizedBox(height: scaler.getHeight(0.6)),
                            chooseEndTime(context, scaler, provider),
                          ],
                        )
                      : Container(),
                  provider.addDate == true
                      ? Expanded(
                          child: Center(child: Container(
                            alignment: Alignment.bottomCenter,
                              child: CircularProgressIndicator())),
                        )
                      : Expanded(
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              child: CommonWidgets.commonBtn(
                                  scaler,
                                  context,
                                  "add_date_to_event".tr(),
                                  ColorConstants.primaryColor,
                                  ColorConstants.colorWhite, onTapFun: () {
                                provider.multipleDateOption.multiStartTime =
                                    provider.startTime;
                                provider.multipleDateOption.multiEndTime =
                                    provider.endTime;
                                if (provider.multipleDateOption.startDate
                                        .any((element) {
                                      return element
                                              .toString()
                                              .substring(0, 11) ==
                                          provider.startDate
                                              .toString()
                                              .substring(0, 11);
                                    }) &&
                                    provider.multipleDateOption.endDate
                                        .any((element) {
                                      return element
                                              .toString()
                                              .substring(0, 11) ==
                                          provider.endDate
                                              .toString()
                                              .substring(0, 11);
                                    }) &&
                                    provider.multipleDateOption.startTime
                                        .contains(provider.startTime) &&
                                    provider.multipleDateOption.endTime
                                        .contains(provider.endTime)) {
                                  // if(provider.multipleDateOption.startDate.any((element) { return element.toString().substring(0,11) == provider.startDate.toString().substring(0,11);})){
                                  DialogHelper.showMessage(context,
                                      "Previous added date and time can't added again.");
                                } else {
                                  if (provider.eventDetail.editEvent == true) {
                                    DateTime start =
                                        DateTimeHelper.dateTimeFormat(
                                            provider.startDate,
                                            provider.startTime);
                                    DateTime end =
                                        DateTimeHelper.dateTimeFormat(
                                            provider.endDate, provider.endTime);
                                    provider
                                        .addDateToEvent(
                                            context,
                                            provider.eventDetail.eid.toString(),
                                            start,
                                            end)
                                        .then((value) {
                                      Navigator.of(context).pop();
                                    });
                                  } else {
                                    provider.multipleDateOption.startDate
                                        .add(provider.startDate);
                                    provider.multipleDateOption.endDate
                                        .add(provider.endDate);
                                    provider.multipleDateOption.startTime
                                        .add(provider.startTime);
                                    provider.multipleDateOption.endTime
                                        .add(provider.endTime);
                                    provider.multipleDateOption.startDateTime
                                        .add(DateTimeHelper.dateTimeFormat(
                                            provider.startDate,
                                            provider.startTime));
                                    provider.multipleDateOption.endDateTime.add(
                                        DateTimeHelper.dateTimeFormat(
                                            provider.startDate,
                                            provider.endTime));
                                    provider.setState(ViewState.Busy);
                                    Navigator.of(context).pop();
                                  }
                                }
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

  Widget chooseStartDate(BuildContext context, ScreenScaler scaler,
      MultipleDateTimeProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.pickDateDialog(context, true);
      },
      child: Container(
          height: scaler.getHeight(5),
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
            child: Text(DateTimeHelper.dateConversion(provider.startDate))
                .regularText(ColorConstants.colorBlackDown,
                    scaler.getTextSize(10.5), TextAlign.center),
          )),
    );
  }

  Widget chooseEndDate(BuildContext context, ScreenScaler scaler,
      MultipleDateTimeProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.pickDateDialog(context, false);
      },
      child: Container(
          height: scaler.getHeight(5),
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
            child: Text(DateTimeHelper.dateConversion(provider.endDate))
                .regularText(ColorConstants.colorBlackDown,
                    scaler.getTextSize(10.5), TextAlign.center),
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
          height: scaler.getHeight(5),
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
                    scaler.getTextSize(10.5), TextAlign.center),
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
          height: scaler.getHeight(5),
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
                    scaler.getTextSize(10.5), TextAlign.center),
          )),
    );
  }
}
