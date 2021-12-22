import 'dart:io';

import 'package:device_calendar/device_calendar.dart' as device;
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/models/calendar_event.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<CalendarEvent>> getCalendarEvents(BuildContext context) async {
  List<CalendarEvent> returnList = [];
  var calendarsResult;
  device.DeviceCalendarPlugin plugin = device.DeviceCalendarPlugin();
  calendarsResult = await plugin.retrieveCalendars();
  var permissionsGranted;
  if (Platform.isIOS) {
    permissionsGranted = await plugin.hasPermissions();
    if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
      permissionsGranted = await plugin.requestPermissions();
      calendarsResult = await plugin.retrieveCalendars();
      if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
        CommonWidgets.errorDialog(context, "enable_calendar_permission".tr());
      }
    }
  }
  if ((calendarsResult.isSuccess || permissionsGranted.isSuccess) &&
      calendarsResult.data != null) {
    final calendars = calendarsResult.data!.toList();
    for (device.Calendar cal in calendars) {
      device.RetrieveEventsParams retrieveEventsParams =
          device.RetrieveEventsParams(
              startDate: DateTime.now(),
              endDate: (DateTime.now().add(Duration(days: 365))));
      final result = await plugin.retrieveEvents(cal.id, retrieveEventsParams);
      if (result.isSuccess && result.data != null) {
        final events = result.data!.toList();
        for (device.Event e in events) {
          CalendarEvent entry = CalendarEvent(
            title: e.title ?? 'Untitled Event',
            start: DateTime.fromMicrosecondsSinceEpoch(
                e.start!.millisecondsSinceEpoch,
                isUtc: true),
            end: DateTime.fromMillisecondsSinceEpoch(
                e.end!.millisecondsSinceEpoch,
                isUtc: true),
            meetMeYou: (cal.name == 'MeetMeYou'),
            description: e.description ?? '',
          );
          returnList.add(entry);
        }
      }
    }
  }
  // else if (Platform.isAndroid) {
  //   if (!calendarsResult.isSuccess) {
  //     CommonWidgets.errorDialog(context, "enable_calendar_permission".tr());
  //   }
  // }
  return returnList;
}
