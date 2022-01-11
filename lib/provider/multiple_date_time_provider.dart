import 'package:flutter/material.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/multiple_date_option.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class MultipleDateTimeProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  DateTime date = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now().addHour(3);
  MultipleDateOption multipleDateOption = locator<MultipleDateOption>();

 // late DateTime startDate;

  //Method for showing the date picker
  void pickDateDialog(BuildContext context, bool checkDate) {
    showDatePicker(
            context: context,
            initialDate: checkDate ? date : DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      //for rebuilding the ui
      date = pickedDate;
    //  startDate = date;
      notifyListeners();
    });
  }

  Future<Null> selectTimeDialog(
      BuildContext context, bool checkOrEndStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: checkOrEndStartTime ? startTime : endTime,
    );
    if (pickedTime == null) {
      return;
    }
    if (checkOrEndStartTime == true) {
      startTime = pickedTime;
      startTimeFun();
    } else {
      endTime = pickedTime;
      endTimeFun(context);
    }

    notifyListeners();
  }

  startTimeFun() {
    // start time
    int startTimeHour = startTime.hour;
    int endTimeHour = endTime.hour;

    // if (startTimeHour >= 21) {
    //   date = date.add(Duration(days: 1));
    //   if ((date.day.toInt() - startDate.day.toInt()) > 1) {
    //     date = date.subtract(Duration(days: 1));
    //   }
    // } else {
    //   date = date;
    // }

    if (startTimeHour > endTimeHour) {
      endTime = startTime.addHour(3);
    } else if (startTimeHour == endTimeHour) {
      if (startTime.minute <= endTime.minute ||
          startTime.minute >= endTime.minute) {
        endTime = startTime.addHour(3);
      }
    } else if ((endTimeHour.toInt() - startTimeHour.toInt()) < 3) {
      endTime = startTime.addHour(3);
    } else if ((endTimeHour.toInt() - startTimeHour.toInt()) == 3) {
      if (startTime.minute > endTime.minute) {
        endTime = startTime.addHour(3);
      }
    }
  }

  endTimeFun(BuildContext context) {
    // for end time
    int startTimeHour = startTime.hour;
    int endTimeHour = endTime.hour;

    if (endTimeHour < startTimeHour + 3) {
      endTime = startTime.addHour(3);
      DialogHelper.showMessage(
          context, "End time should 3 hours greater than Start time.");
    } else if (endTimeHour == startTimeHour + 3) {
      if (endTime.minute < startTime.minute) {
        endTime = startTime.addHour(3);
        DialogHelper.showMessage(
            context, "End time should 3 hours greater than Start time.");
      }
    }
  }
}
