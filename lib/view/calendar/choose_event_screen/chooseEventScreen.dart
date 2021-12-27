import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/calendar_event.dart';
import 'package:meetmeyou_app/provider/choose_event_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/shimmer/calendarEventCardShimmer.dart';

class ChooseEventScreen extends StatelessWidget {
  ChooseEventScreen({Key? key}) : super(key: key);
  CalendarDetail calendarDetail = locator<CalendarDetail>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
          backgroundColor: ColorConstants.colorWhite,
          appBar: DialogHelper.appBarWithBack(scaler, context),
          body: BaseView<ChooseEventProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: scaler.getPaddingLTRB(2.8, 0.0, 2.8, 0.0),
                child:
                // provider.eventValue == true ? Expanded(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Center(child: CircularProgressIndicator()),
                //       SizedBox(height: scaler.getHeight(1)),
                //       Text("fetching_event".tr()).mediumText(
                //           ColorConstants.primaryColor,
                //           scaler.getTextSize(10),
                //           TextAlign.left),
                //     ],
                //   ),
                // ) :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("choose_event".tr()).boldText(
                        ColorConstants.colorBlack,
                        scaler.getTextSize(16),
                        TextAlign.left),
                    SizedBox(height: scaler.getHeight(1.5)),
                    eventLists(scaler, provider)
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget eventLists(ScreenScaler scaler, ChooseEventProvider provider) {
    return Expanded(
      child: Container(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: calendarDetail.calendarEventList?.length,
            itemBuilder: (context, index) {
              String currentMonth = DateTimeHelper.getFullMonthByName(
                  calendarDetail.calendarEventList![index].start);
              String month = index == 0
                  ? DateTimeHelper.getFullMonthByName(
                      calendarDetail.calendarEventList![index].start)
                  : DateTimeHelper.getFullMonthByName(
                      calendarDetail.calendarEventList![index - 1].start);
              String currentDay =
                  calendarDetail.calendarEventList![index].start.day.toString();
              String day = index == 0
                  ? calendarDetail.calendarEventList![index].start.day
                      .toString()
                  : calendarDetail.calendarEventList![index - 1].start.day
                      .toString();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  monthHeader(
                      context,
                      scaler,
                      calendarDetail.calendarEventList![index],
                      month,
                      currentMonth,
                      day,
                      currentDay,
                      index,
                      provider),
                  SizedBox(height: scaler.getHeight(1.0))
                ],
              );
            }),
      ),
    );
  }

  monthHeader(
      BuildContext context,
      ScreenScaler scaler,
      CalendarEvent event,
      String month,
      String cMonth,
      String day,
      String cDay,
      int index,
      ChooseEventProvider provider) {
    if (index == 0 ? true : (month != cMonth)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DateTimeHelper.getFullMonthByName(event.start) +
                  "  " +
                  event.start.year.toString())
              .mediumText(ColorConstants.colorBlack, scaler.getTextSize(11.0),
                  TextAlign.center),
          Divider(
              color: ColorConstants.primaryColor, thickness: 1.5, height: 10.0),
          SizedBox(height: scaler.getHeight(0.2)),
          dateAndEventTimeTitle(
              context, scaler, event, day, cDay, index, provider),
        ],
      );
    } else {
      return dateAndEventTimeTitle(
          context, scaler, event, day, cDay, index, provider);
    }
  }

  Widget dateAndEventTimeTitle(
      BuildContext context,
      ScreenScaler scaler,
      CalendarEvent event,
      String day,
      String cDay,
      int index,
      ChooseEventProvider provider) {
    if (index == 0 ? true : (day != cDay)) {
      return Row(
        children: [
          Column(
            children: [
              Text(DateTimeHelper.getMonthByName(event.start)
                      .toString()
                      .toUpperCase())
                  .mediumText(ColorConstants.colorBlack,
                      scaler.getTextSize(9.5), TextAlign.center),
              Text(event.start.day.toString()).mediumText(
                  ColorConstants.colorBlack,
                  scaler.getTextSize(12.0),
                  TextAlign.center),
            ],
          ),
          SizedBox(width: scaler.getWidth(2.0)),
          CommonWidgets.eventTimeTitleCard(scaler, event, isActionOnCard: true,
              actionOnCard: () {
            if(event.meetMeYou){
              provider.calendarDetail.fromCalendarPage = true;
              provider.eventDetail.eid = event.eid;
             // provider.getEvent(_scaffoldKey.currentContext!, event.eid.toString());
              Navigator.pushNamed(context, RoutesConstants.eventDetailScreen).then((value) {
                Navigator.of(context).pop();
              });
            }
          })
        ],
      );
    } else {
      return Row(
        children: [
          SizedBox(width: scaler.getWidth(8.0)),
         CommonWidgets.eventTimeTitleCard(scaler, event, isActionOnCard: true,
              actionOnCard: () {

                if(event.meetMeYou){
                  provider.calendarDetail.fromCalendarPage = true;
                  provider.eventDetail.eid = event.eid;
                //  provider.getEvent(_scaffoldKey.currentContext!, event.eid.toString());
                  Navigator.pushNamed(context, RoutesConstants.eventDetailScreen).then((value) {
                    Navigator.of(context).pop();
                  });
                }
          })
        ],
      );
    }
  }
}
