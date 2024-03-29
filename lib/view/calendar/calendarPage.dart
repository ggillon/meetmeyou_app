import 'package:device_calendar/device_calendar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/models/calendar_event.dart';
import 'package:meetmeyou_app/provider/calendarProvider.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/services/mmy/event.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/calendar/calendar_event_card/calendar_event_card_screen.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  CalendarPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return BaseView<CalendarProvider>(
          onModelReady: (provider) async {
           await provider.getCalendarEvents(context);
           },
          builder: (context, provider, _) {
            return SafeArea(
              child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: provider.userDetail.userType == USER_TYPE_PRO ? ColorConstants.colorLightCyan : (provider.userDetail.userType == USER_TYPE_ADMIN ? ColorConstants.colorLightRed :ColorConstants.colorWhite),
                body: Padding(
                  padding: scaler.getPaddingLTRB(3.8, 1.0, 3.8, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // provider.eventValue == true
                      //     ? Container()
                      //     :
                      Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("calendar".tr()).boldText(
                                    ColorConstants.colorBlack,
                                    scaler.getTextSize(16.5),
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
                                            path: ImageConstants
                                                .calendar_event_icon,
                                          )
                                        : ImageView(
                                            path: ImageConstants
                                                .calendar_listEvent_icon,
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
                                          scaler.getTextSize(11),
                                          TextAlign.left),
                                    ],
                                  ),
                                )
                              // : provider.eventValue == true
                              //     ? Expanded(
                              //         child: Column(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.center,
                              //           children: [
                              //             Center(
                              //                 child: CircularProgressIndicator()),
                              //             SizedBox(height: scaler.getHeight(1)),
                              //             Text("fetching_event".tr()).mediumText(
                              //                 ColorConstants.primaryColor,
                              //                 scaler.getTextSize(10),
                              //                 TextAlign.left),
                              //           ],
                              //         ),
                              //       )
                                  : Expanded(
                                      child: PagedVerticalCalendar(
                                        minDate: DateTime(2000),
                                        maxDate:(DateTime.now().add(Duration(days: 365))),
                                        initialDate: DateTime.now(),
                                        // startDate: DateTime(2022),
                                        // endDate: (DateTime.now().add(Duration(days: 365))),
                                        addAutomaticKeepAlives: true,
                                        monthBuilder: (context, month, year) {
                                          return Column(
                                            children: [
                                              Padding(
                                                  padding: scaler.getPaddingLTRB(
                                                      0.0, 1.0, 0.0, 1.0),
                                                  child: Text(
                                                    DateFormat('MMMM yyyy')
                                                        .format(DateTime(
                                                            year, month)),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                          color: ColorConstants
                                                              .colorBlack,
                                                        ),
                                                  ).semiBoldText(
                                                      ColorConstants.colorBlack,
                                                      scaler.getTextSize(11.5),
                                                      TextAlign.center)),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                          // if (date.toString().substring(0, 11) ==
                                          //     DateTime.now()
                                          //         .toString()
                                          //         .substring(0, 11)) {
                                          //   final text = DateFormat('d').format(date);
                                          //
                                          //   return Padding(
                                          //     padding: scaler.getPaddingLTRB(
                                          //         0.0, 0.0, 0.0, 1.0),
                                          //     child: Container(
                                          //         decoration: BoxDecoration(
                                          //           color:
                                          //               Colors.blue,
                                          //           shape: BoxShape.circle,
                                          //         ),
                                          //         child: Center(
                                          //           child: Text(
                                          //             text,
                                          //           ).regularText(
                                          //               ColorConstants.colorBlack,
                                          //               scaler.getTextSize(11.0),
                                          //               TextAlign.center),
                                          //         )),
                                          //   );
                                          // } else
                                          if (provider.deviceCalendarEvent
                                              .any((element) {
                                            return (date
                                                        .toString()
                                                        .substring(0, 11) ==
                                                    element.start
                                                        .toString()
                                                        .substring(0, 11)) &&
                                                (element.meetMeYou);
                                          })) {
                                            final text =
                                                DateFormat('d').format(date);
                                            return Padding(
                                              padding: scaler.getPaddingLTRB(
                                                  0.0, 0.0, 0.0, 1.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  List<CalendarEvent> eventsList =
                                                      [];
                                                  for (int i = 0;
                                                      i <
                                                          provider
                                                              .deviceCalendarEvent
                                                              .length;
                                                      i++) {
                                                    if (provider
                                                            .deviceCalendarEvent[
                                                                i]
                                                            .start
                                                            .toString()
                                                            .substring(0, 11) ==
                                                        date
                                                            .toString()
                                                            .substring(0, 11)) {
                                                      eventsList.add(provider
                                                          .deviceCalendarEvent[i]);
                                                    }
                                                    provider.calendarDetail
                                                            .calendarEventList =
                                                        eventsList;
                                                  }
                                                  // print(provider.calendarDetail.calendarEventList);
                                                  if ((provider
                                                              .calendarDetail
                                                              .calendarEventList
                                                              ?.length ??
                                                          0) >
                                                      1) {
                                                    Navigator.pushNamed(
                                                            context,
                                                            RoutesConstants
                                                                .chooseEventScreen)
                                                        .then((value) {
                                                      provider.getCalendarEvents(
                                                          context);
                                                      provider.unRespondedEventsApi(context);
                                                    });
                                                  } else {
                                                    provider.calendarDetail.fromAnotherPage = true;
                                                    provider.eventDetail.eid =       provider
                                                        .calendarDetail
                                                        .calendarEventList![0]
                                                        .eid
                                                        .toString();
                                                    // provider.getEvent(
                                                    //     _scaffoldKey
                                                    //         .currentContext!,
                                                    //     provider
                                                    //         .calendarDetail
                                                    //         .calendarEventList![0]
                                                    //         .eid
                                                    //         .toString());
                                                    Navigator.pushNamed(context, RoutesConstants.eventDetailScreen)
                                                        .then((value) {
                                                      provider.deviceCalendarEvent = [];
                                                      provider.getCalendarEvents(context);
                                                      provider.unRespondedEventsApi(context);
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: ColorConstants
                                                          .primaryColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        text,
                                                      ).regularText(
                                                          ColorConstants
                                                              .colorBlack,
                                                          scaler
                                                              .getTextSize(12.0),
                                                          TextAlign.center),
                                                    )),
                                              ),
                                            );
                                          } else if (provider.deviceCalendarEvent
                                              .any((element) {
                                            return (date
                                                        .toString()
                                                        .substring(0, 11) ==
                                                    element.start
                                                        .toString()
                                                        .substring(0, 11)) &&
                                                (!element.meetMeYou);
                                          })) {
                                            final text =
                                                DateFormat('d').format(date);
                                            return Padding(
                                              padding: scaler.getPaddingLTRB(
                                                  0.0, 0.0, 0.0, 1.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: ColorConstants
                                                        .primaryColor
                                                        .withOpacity(0.2),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      text,
                                                    ).regularText(
                                                        ColorConstants.colorBlack,
                                                        scaler.getTextSize(12.0),
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
                                                          ColorConstants
                                                              .colorBlack,
                                                          scaler
                                                              .getTextSize(12.0),
                                                          TextAlign.center)),
                                            );
                                          }
                                        },
                                      ),
                                    )
                          : Expanded(
                              child: CalendarEventCardScreen(deviceCalendarEvent: provider.deviceCalendarEvent,),
                            )
                    ],
                  ),
                ),
              ),
            );
          },
        );
  }

  Widget weekText(ScreenScaler scaler, String text) {
    return Padding(
        padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 1.0),
        child: Text(
          text,
        ).semiBoldText(ColorConstants.colorCalender, scaler.getTextSize(8.6),
            TextAlign.center));
  }

}
