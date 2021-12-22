import 'package:device_calendar/device_calendar.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_event.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  List<CalendarEvent> deviceCalendarEvent = [];
  DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();
  bool calendar = true;

  bool iconValue = false;

  void updateIconValue(bool value) {
    iconValue = value;
    notifyListeners();
  }

  Future getCalendarEvents(BuildContext context) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getCalendarEvents(context).catchError((e) {
      setState(ViewState.Idle);
    //  DialogHelper.showMessage(context, "enable_calendar_permission".tr());
      CommonWidgets.errorDialog(context, "enable_calendar_permission".tr());
    });
    if (value != null) {
      deviceCalendarEvent = value;
      deviceCalendarEvent.sort((a, b) {
        return a.end.compareTo(b.end);
      });
      setState(ViewState.Idle);
    }
  }
}

