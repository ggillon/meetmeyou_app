import 'package:device_calendar/device_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/models/calendar_event.dart';
import 'package:meetmeyou_app/provider/calendarProvider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorConstants.colorWhite,
          body: BaseView<CalendarProvider>(
            onModelReady: (provider) {
              provider.getCalendarEvents(context);
            },
            builder: (context, provider, _) {
              return Padding(
                padding: scaler.getPaddingLTRB(2.8, 1.0, 2.8, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("calendar".tr()).boldText(
                            ColorConstants.colorBlack,
                            scaler.getTextSize(16),
                            TextAlign.left),
                        GestureDetector(
                            onTap: () {
                              provider.deviceCalendarEvent.isNotEmpty
                                  ? provider.calendar = !provider.calendar
                                  : () {};
                              provider.updateIconValue(true);
                            },
                            child: provider.calendar == true
                                ? ImageView(
                                    path: ImageConstants.calendar_event_icon,
                                  )
                                : ImageView(
                                    path:
                                        ImageConstants.calendar_listEvent_icon,
                                  ))
                      ],
                    ),
                    SizedBox(height: scaler.getHeight(2.0)),
                    provider.calendar == true
                        ? provider.state == ViewState.Busy
                            ? Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: CircularProgressIndicator()),
                                    SizedBox(height: scaler.getHeight(1)),
                                    Text("loading_your_events".tr()).mediumText(
                                        ColorConstants.primaryColor,
                                        scaler.getTextSize(10),
                                        TextAlign.left),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: PagedVerticalCalendar(
                                  startDate: DateTime(2021, 12, 1),
                                  endDate: DateTime(2024, 12, 31),
                                  addAutomaticKeepAlives: true,
                                  monthBuilder: (context, month, year) {
                                    return Column(
                                      children: [
                                        Padding(
                                            padding: scaler.getPaddingLTRB(
                                                0.0, 1.0, 0.0, 1.0),
                                            child: Text(
                                              DateFormat('MMMM yyyy').format(
                                                  DateTime(year, month)),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                    color: ColorConstants
                                                        .colorBlack,
                                                  ),
                                            ).semiBoldText(
                                                ColorConstants.colorBlack,
                                                scaler.getTextSize(11.0),
                                                TextAlign.center)),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            weekText(scaler, 'MON'),
                                            weekText(scaler, 'TUE'),
                                            weekText(scaler, 'WED'),
                                            weekText(scaler, 'THU'),
                                            weekText(scaler, 'FRI'),
                                            weekText(scaler, 'SAT'),
                                            weekText(scaler, 'SUN'),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  dayBuilder: (context, date) {
                                    if (date.toString().substring(0, 11) ==
                                        DateTime.now()
                                            .toString()
                                            .substring(0, 11)) {
                                      final text = DateFormat('d').format(date);

                                      return Padding(
                                        padding: scaler.getPaddingLTRB(
                                            0.0, 0.0, 0.0, 1.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  ColorConstants.primaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                text,
                                              ).regularText(
                                                  ColorConstants.colorBlack,
                                                  scaler.getTextSize(11.0),
                                                  TextAlign.center),
                                            )),
                                      );
                                    } else if (provider.deviceCalendarEvent
                                        .any((element) {
                                      return date.toString().substring(0, 11) ==
                                          element.end
                                              .toString()
                                              .substring(0, 11);
                                    })) {
                                      final text = DateFormat('d').format(date);
                                      return Padding(
                                        padding: scaler.getPaddingLTRB(
                                            0.0, 0.0, 0.0, 1.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: ColorConstants.primaryColor
                                                  .withOpacity(0.2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                text,
                                              ).regularText(
                                                  ColorConstants.colorBlack,
                                                  scaler.getTextSize(11.0),
                                                  TextAlign.center),
                                            )),
                                      );
                                    } else {
                                      return Padding(
                                        padding: scaler.getPaddingLTRB(
                                            0.0, 0.0, 0.0, 1.0),
                                        child: Center(
                                            child: Text(DateFormat('d')
                                                    .format(date))
                                                .regularText(
                                                    ColorConstants.colorBlack,
                                                    scaler.getTextSize(11.0),
                                                    TextAlign.center)),
                                      );
                                    }
                                  },
                                ),
                              )
                        : Expanded(
                            child: Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      provider.deviceCalendarEvent.length,
                                  itemBuilder: (context, index) {
                                    String currentMonth =
                                        DateTimeHelper.getFullMonthByName(
                                            provider.deviceCalendarEvent[index]
                                                .end);
                                    String month = index == 0
                                        ? DateTimeHelper.getFullMonthByName(
                                            provider
                                                .deviceCalendarEvent[index].end)
                                        : DateTimeHelper.getFullMonthByName(
                                            provider
                                                .deviceCalendarEvent[index - 1]
                                                .end);
                                    String currentDay = provider
                                        .deviceCalendarEvent[index].end.day
                                        .toString();
                                    String day = index == 0
                                        ? provider
                                            .deviceCalendarEvent[index].end.day
                                            .toString()
                                        : provider
                                            .deviceCalendarEvent[index - 1]
                                            .end
                                            .day
                                            .toString();
                                    String currentTitle = provider
                                        .deviceCalendarEvent[index].title;
                                    String title = index == 0
                                        ? provider
                                            .deviceCalendarEvent[index].title
                                        : provider
                                            .deviceCalendarEvent[index - 1]
                                            .title;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        monthHeader(
                                            context,
                                            scaler,
                                            month,
                                            currentMonth,
                                            index,
                                            provider
                                                .deviceCalendarEvent[index].end,
                                            provider.deviceCalendarEvent[index],
                                            day,
                                            currentDay,
                                            title,
                                            currentTitle),
                                        SizedBox(height: scaler.getHeight(1.0))
                                      ],
                                    );
                                  }),
                            ),
                          )
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget weekText(ScreenScaler scaler, String text) {
    return Padding(
        padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 1.0),
        child: Text(
          text,
        ).semiBoldText(ColorConstants.colorCalender, scaler.getTextSize(8.0),
            TextAlign.center));
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
      String cDay,
      String title,
      String cTitle) {
    if (index == 0 ? true : (month != cMonth)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cMonth + "  " + event.end.year.toString()).mediumText(
              ColorConstants.colorBlack,
              scaler.getTextSize(11.0),
              TextAlign.center),
          Divider(
              color: ColorConstants.primaryColor, thickness: 1.5, height: 10.0),
          SizedBox(height: scaler.getHeight(0.2)),
          dateAndEventTimeTitle(
              scaler, date, event, index, day, cDay, title, cTitle),
        ],
      );
    } else {
      return dateAndEventTimeTitle(
          scaler, date, event, index, day, cDay, title, cTitle);
    }
  }

  Widget dateAndEventTimeTitle(
      ScreenScaler scaler,
      DateTime date,
      CalendarEvent event,
      int index,
      String day,
      String cDay,
      String title,
      String cTitle) {
    if (index == 0 ? true : (day != cDay)) {
      return Row(
        children: [
          Column(
            children: [
              Text(DateTimeHelper.getMonthByName(date).toString().toUpperCase())
                  .mediumText(ColorConstants.colorBlack,
                      scaler.getTextSize(9.5), TextAlign.center),
              Text(date.day.toString()).mediumText(ColorConstants.colorBlack,
                  scaler.getTextSize(12.0), TextAlign.center),
            ],
          ),
          SizedBox(width: scaler.getWidth(2.0)),
          eventTimeTitleCard(scaler, event)
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
          eventTimeTitleCard(scaler, event),
        ],
      );
    }
  }

  Widget eventTimeTitleCard(ScreenScaler scaler, CalendarEvent event) {
    return Expanded(
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(8.0),
        ),
        child: Padding(
          padding: scaler.getPaddingLTRB(1.5, 1.4, 1.5, 1.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: scaler.getWidth(70.0),
                child: Text(event.title).semiBoldText(ColorConstants.colorBlack,
                    scaler.getTextSize(9.5), TextAlign.left,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              SizedBox(height: scaler.getHeight(0.1)),
              Text(event.end.toString().substring(0, 11)).regularText(
                  ColorConstants.colorBlack,
                  scaler.getTextSize(9.5),
                  TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
