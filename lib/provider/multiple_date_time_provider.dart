import 'package:flutter/material.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
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
    //  startTimeFun();
    } else {
      endTime = pickedTime;
    //  endTimeFun(context);
    }

    notifyListeners();
  }
}
