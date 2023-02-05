import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/models/calendar_event.dart';
import 'package:meetmeyou_app/provider/calendarProvider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CalendarEventCardScreen extends StatefulWidget {
  CalendarEventCardScreen({Key? key, required this.deviceCalendarEvent}) : super(key: key);
  List<CalendarEvent> deviceCalendarEvent = [];

  @override
  State<CalendarEventCardScreen> createState() => _CalendarEventCardScreenState();
}

class _CalendarEventCardScreenState extends State<CalendarEventCardScreen> {

  final ScrollController _controller = ScrollController();
  List<CalendarEvent> deviceCalendarEvent = [];

  final scrollDirection = Axis.vertical;

  late AutoScrollController controller;

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return BaseView<CalendarProvider>(
        onModelReady: (provider) async {

          int index = 0;
          for(int i = 0; i < widget.deviceCalendarEvent.length ; i++){
            if(widget.deviceCalendarEvent[i].start.toString().substring(0,10) ==
            DateTime.now().toString().substring(0, 10)){
             index = i+1;
              break;
            }
          }

          controller = AutoScrollController(
              viewportBoundaryGetter: () =>
                  Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
              axis: scrollDirection);

          await controller.scrollToIndex(index,
              preferPosition: AutoScrollPosition.begin);
          controller.highlight(index);

        },
        builder: (context, provider, _){
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              controller: controller,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),

                  shrinkWrap: true,
                  itemCount:
                  widget.deviceCalendarEvent.length,
                  itemBuilder: (context, index) {

                    String currentMonth =
                    DateTimeHelper.getFullMonthByName(
                        widget.deviceCalendarEvent[index]
                            .start);
                    String month = index == 0
                        ? DateTimeHelper.getFullMonthByName(
                        widget.deviceCalendarEvent[index]
                            .start)
                        : DateTimeHelper.getFullMonthByName(
                        widget.deviceCalendarEvent[index - 1]
                            .start);
                    String currentDay =
                    widget.deviceCalendarEvent[index]
                        .start.day
                        .toString();
                    String day = index == 0 ?
                    widget.deviceCalendarEvent[index]
                        .start.day
                        .toString()
                        : widget.deviceCalendarEvent[index - 1]
                        .start
                        .day
                        .toString();
                    return AutoScrollTag(
                      key: ValueKey(index),
                      controller: controller,
                      index: index,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          monthHeader(
                              context,
                              scaler,
                              month,
                              currentMonth,
                              index,
                              widget.deviceCalendarEvent[index]
                                  .start,
                              widget.deviceCalendarEvent[index],
                              day,
                              currentDay),
                          SizedBox(height: scaler.getHeight(1.5))
                        ],
                      ),
                    );
                  }),
            ),
          );
        },
    );
  }

  monthHeader(
      BuildContext context,
      ScreenScaler scaler,
      String month,
      String cMonth,
      int index,
      DateTime date,
      CalendarEvent event,
      String day,
      String cDay) {
    if (index == 0 ? true : (month != cMonth)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cMonth + "  " + event.start.year.toString()).mediumText(
              ColorConstants.colorBlack,
              scaler.getTextSize(11.5),
              TextAlign.center),
          Divider(
              color: ColorConstants.primaryColor, thickness: 1.5, height: 10.0),
          SizedBox(height: scaler.getHeight(0.2)),
          dateAndEventTimeTitle(scaler, date, event, index, day, cDay, month, cMonth),
        ],
      );
    } else {
      return dateAndEventTimeTitle(scaler, date, event, index, day, cDay, month, cMonth);
    }
  }

  Widget dateAndEventTimeTitle(ScreenScaler scaler, DateTime date,
      CalendarEvent event, int index, String day, String cDay, String month,
      String cMonth) {
    if (index == 0 ? true : ((day != cDay) || (month != cMonth))) {
      return Row(
        children: [
          Column(
            children: [

              date.toString().substring(0, 10) == DateTime.now().toString().substring(0,10) ?
              Text(DateTimeHelper.getMonthByName(date).toString().toUpperCase())
                  .boldText(ColorConstants.colorBlack,
                  scaler.getTextSize(10.0), TextAlign.center)
                  : Text(DateTimeHelper.getMonthByName(date).toString().toUpperCase())
                  .mediumText(ColorConstants.colorBlack,
                  scaler.getTextSize(10.0), TextAlign.center),

              date.toString().substring(0, 10) == DateTime.now().toString().substring(0,10) ?
              Text(date.day.toString()).boldText(ColorConstants.colorBlack,
                  scaler.getTextSize(12.5), TextAlign.center)
                  : Text(date.day.toString()).mediumText(ColorConstants.colorBlack,
                  scaler.getTextSize(12.5), TextAlign.center),
            ],
          ),
          SizedBox(width: scaler.getWidth(2.0)),
          CommonWidgets.eventTimeTitleCard(scaler, event)
        ],
      );
    }
    // else if (index == 0 ? true : (title != cTitle)) {
    //   return Row(
    //     children: [
    //       SizedBox(width: scaler.getWidth(8.0)),
    //       eventTimeTitleCard(scaler, event),
    //     ],
    //   );
    // }
    else {
      return Row(
        children: [
          SizedBox(width: scaler.getWidth(8.0)),
          CommonWidgets.eventTimeTitleCard(scaler, event)
        ],
      );
    }
  }
}
