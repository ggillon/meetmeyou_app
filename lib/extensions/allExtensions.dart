import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';

extension ExtendPedding on Widget {
  addAllSidePadding(EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

/*addPaddingHorizontal(double padding) {
    return Padding(
      padding: EdgeInsets.only(left: padding, right: padding),
      child: this,
    );
  }

  dynamicPaddingAllSide(double left, double right, double top, double bottom) {
    return Padding(
      padding:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: this,
    );
  }

  addPaddingVertial(double padding) {
    return Padding(
      padding: EdgeInsets.only(top: padding, bottom: padding),
      child: this,
    );
  }

  addPaddingTop(double padding) {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(padding)),
      child: this,
    );
  }

  addPaddingBottom(double padding) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: this,
    );
  }*/
}

extension ExtendText on Text {
  regularText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow, bool underline = false, bool isHeight = false}) {
    return Text(
      this.data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.spProDisplay,
          fontWeight: FontWeight.w400,
          fontSize: textSize,
          decoration:
              underline ? TextDecoration.underline : TextDecoration.none,
          height: isHeight == true ? 1.2 : 1.0),
    );
  }

  mediumText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow}) {
    return Text(
      this.data!,
      maxLines: maxLines,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.spProDisplay,
          fontWeight: FontWeight.w500,
          fontSize: textSize),
    );
  }

  semiBoldText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow}) {
    return Text(
      this.data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.spProDisplay,
          fontWeight: FontWeight.w600,
          fontSize: textSize),
    );
  }

  boldText(Color color, double textSize, TextAlign alignment,
      {maxLines, overflow}) {
    return Text(
      this.data!,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignment,
      style: TextStyle(
          color: color,
          fontFamily: StringConstants.spProDisplay,
          fontWeight: FontWeight.w700,
          fontSize: textSize),
    );
  }
}

extension Decoration on Widget {
/*  Widget boxDecoration(
      {double topRight=0,
      double topLeft=0,
      double bottomRight=0,
      double bottomLeft=0,
      Color color}) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setHeight(topLeft)),
              topRight: Radius.circular(ScreenUtil().setHeight(topRight)),
              bottomLeft: Radius.circular(ScreenUtil().setHeight(bottomLeft)),
              bottomRight: Radius.circular(ScreenUtil().setHeight(bottomRight)))),
    );
  }*/

}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int isCompareTo(TimeOfDay other) {
    // if (hour < other.hour + 3) return 1;
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (hour < other.hour) {
      if (minute > other.minute) return -1;
    } else {
      if (minute > other.minute) return 1;
    }
    if (minute < other.minute) return -1;
    return 0;
  }

  TimeOfDay addHour(int hour) {
    if (this.hour == 21) {
      return this.replacing(hour: 00, minute: this.minute);
    } else if (this.hour == 22) {
      return this.replacing(hour: 01, minute: this.minute);
    } else if (this.hour == 23) {
      return this.replacing(hour: 02, minute: this.minute);
    }
    // else if (this.hour == 00) {
    //   return this.replacing(hour: 03, minute: this.minute);
    // }
    else {
      return this.replacing(hour: this.hour + hour, minute: this.minute);
    }
    //return this.replacing(hour: this.hour + hour, minute: this.minute);
  }
}

extension on List {
  bool equals(List list) {
    if (this.length != list.length) return false;
    return this.every((item) => list.contains(item));
  }
}
