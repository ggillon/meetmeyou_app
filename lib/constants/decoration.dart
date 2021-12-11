import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';

import 'color_constants.dart';


class ViewDecoration{
  static InputDecoration inputDecorationWithCurve(
      String fieldName, ScreenScaler scaler,Color color,{IconData? icon}) {
    return InputDecoration(
        suffixIcon: icon==null?null:Icon(
          icon,
          size: scaler.getTextSize(12),
          color: ColorConstants.colorBlack,
        ),

        hintText: fieldName,
        hintStyle: textFieldStyle(scaler.getTextSize(9.5),ColorConstants.colorGray),
        filled: true,
        isDense: true,
        errorMaxLines: 3,
        contentPadding: icon==null?scaler.getPaddingLTRB(1, 1,1, 1):scaler.getPaddingLTRB(1, 0.1, 0.1, 0.1),
        fillColor: ColorConstants.colorLightGray,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.colorLightGray, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.colorLightGray, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: color, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))));
  }


  static InputDecoration inputDecorationBottomLine(
      String fieldName, ScreenScaler scaler,Color color,{IconData? icon}) {
    return InputDecoration(
        prefixIcon: icon==null?null:Icon(
          icon,
          size: scaler.getTextSize(12),
          color: color,
        ),

        hintText: fieldName,
        filled: true,
        isDense: true,
        contentPadding: icon==null?scaler.getPaddingLTRB(1, 0.5, 0.5, 1):scaler.getPaddingLTRB(0.1, 0.1, 0.1, 0.1),
        fillColor: ColorConstants.colorWhite,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))));
  }

  static TextStyle textFieldStyle(double size,Color color) {
    return TextStyle(
        color: color,
        fontFamily: StringConstants.spProDisplay,
        fontWeight: FontWeight.w400,
        fontSize: size);
  }

}