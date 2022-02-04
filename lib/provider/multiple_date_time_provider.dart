import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/multiple_date_option.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class MultipleDateTimeProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  DateTime startDate = DateTime.now().add(Duration(days: 7));
  DateTime endDate = DateTime.now().add(Duration(days: 7));
  TimeOfDay startTime = TimeOfDay(hour: 19, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 19, minute: 0).addHour(3);
  MultipleDateOption multipleDateOption = locator<MultipleDateOption>();
  EventDetail eventDetail = locator<EventDetail>();
  bool addEndDate = false;
  // late DateTime startDate;

  //Method for showing the date picker
  void pickDateDialog(BuildContext context, bool checkDate) {
    showDatePicker(
            context: context,
            initialDate: checkDate == true ? startDate : endDate,
            firstDate:  checkDate == true ? DateTime.now().add(Duration(days: 7)) : DateTime(startDate.year, startDate.month, startDate.day),
            lastDate: DateTime(2100))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      //for rebuilding the ui
      if (checkDate == true) {
        startDate = pickedDate;
        if (startDate.isAfter(endDate)) {
          endDate = startDate;
          // if(startTime.hour >= 21){
          //   endDate = endDate.add(Duration(days: 1));
          // }
          // DialogHelper.showMessage(
          //     context, "Start date cannot greater than End date.");
          startTimeFun();
          notifyListeners();
          return;
        }
        startTimeFun();
      } else {
        endDate = pickedDate;
        endTimeFun(context);
      }
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

    if (startTimeHour >= 21) {
      if (startDate
          .toString()
          .substring(0, 11)
          .compareTo(endDate.toString().substring(0, 11)) ==
          0){
        endDate = endDate.add(Duration(days: 1));
        endTime = startTime.addHour(3);
      }else{
        if ((endDate.day.toInt() - startDate.day.toInt()) == 1) {
          endTime = startTime.addHour(3);
        }

      }
      // if ((endDate.day.toInt() - startDate.day.toInt()) > 1) {
      //   endDate = endDate.subtract(Duration(days: 1));
      // }
    }

    if (startDate
        .toString()
        .substring(0, 11)
        .compareTo(endDate.toString().substring(0, 11)) ==
        0) {
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
  }

  endTimeFun(BuildContext context) {
    // for end time
    int startTimeHour = startTime.hour;
    int endTimeHour = endTime.hour;

    if (startTime.hour >= 21) {
      if (startDate
          .toString()
          .substring(0, 11)
          .compareTo(endDate.toString().substring(0, 11)) ==
          0) {
        endDate = startDate.add(Duration(days: 1));
        endTime = startTime.addHour(3);
        DialogHelper.showMessage(
            context, "End time should 3 hours greater than Start time.");
      } else{
        if ((endDate.day.toInt() - startDate.day.toInt()) == 1) {
          endTime = startTime.addHour(3);
          DialogHelper.showMessage(
              context, "End time should 3 hours greater than Start time.");
        }
      }
    }

    if (startDate
            .toString()
            .substring(0, 11)
            .compareTo(endDate.toString().substring(0, 11)) ==
        0) {
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

 // Future<String> addDateToEvent(String eid, {required DateTime start, required DateTime end});

  bool addDate = false;

  updateDate(bool val){
    addDate = val;
    notifyListeners();
  }
 Future addDateToEvent(BuildContext context, String eid, DateTime start, DateTime end) async{
  updateDate(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine?.addDateToEvent(eid, start: start, end: end).catchError((e) {
      updateDate(false);
      DialogHelper.showMessage(context, e.message);
    });

  updateDate(false);
 }

}
