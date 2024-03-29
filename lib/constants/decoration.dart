import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

import 'color_constants.dart';

class ViewDecoration {
  static InputDecoration inputDecorationWithCurve(
      String fieldName, ScreenScaler scaler, Color color,
      {IconData? icon,
      Widget? prefixIcon,
      double? textSize,
      Color? fillColor,
      double? radius,
      bool imageView = false,
      String? path,
      Color? textFiledColor}) {
    return InputDecoration(
        prefixIcon: prefixIcon == null ? null : prefixIcon,
        suffixIcon: icon == null
            ? null
            : imageView
                ? Container(
                    height: scaler.getHeight(1),
                    child: ImageView(
                      path: path,
                      height: scaler.getHeight(1),
                    ))
                : Icon(
                    icon,
                    size: scaler.getTextSize(12),
                    color: ColorConstants.colorBlack,
                  ),
        hintText: fieldName,
        hintStyle: textFieldStyle(
            scaler.getTextSize(textSize ?? 10.5), textFiledColor ?? ColorConstants.colorGray),
        filled: true,
        isDense: true,
        errorMaxLines: 3,
        contentPadding: icon == null
            ? scaler.getPaddingLTRB(1.5, 1.5, 1.5, 1.5)
            : scaler.getPaddingLTRB(1, 0.1, 0.1, 0.1),
        fillColor: fillColor ?? ColorConstants.colorLightGray,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: fillColor ?? ColorConstants.colorLightGray, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 8))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: fillColor ?? ColorConstants.colorLightGray, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 8))),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 8))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8))));
  }

  static InputDecoration inputDecorationBottomLine(
      String fieldName, ScreenScaler scaler, Color color,
      {IconData? icon}) {
    return InputDecoration(
        prefixIcon: icon == null
            ? null
            : Icon(
                icon,
                size: scaler.getTextSize(12),
                color: color,
              ),
        hintText: fieldName,
        filled: true,
        isDense: true,
        contentPadding: icon == null
            ? scaler.getPaddingLTRB(1, 0.5, 0.5, 1)
            : scaler.getPaddingLTRB(0.1, 0.1, 0.1, 0.1),
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

  static InputDecoration inputDecorationForSearchBox(
      String fieldName, ScreenScaler scaler) {
    return InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          size: scaler.getTextSize(15),
          color: ColorConstants.colorBlack,
        ),
        hintText: fieldName,
        hintStyle:
            textFieldStyle(scaler.getTextSize(12), ColorConstants.colorGray),
        filled: true,
        isDense: true,
        contentPadding: scaler.getPaddingLTRB(1, 1.5, 1, 1.5),
        fillColor: Colors.transparent,
        border: InputBorder.none);
  }

  static TextStyle textFieldStyle(double size, Color color) {
    return TextStyle(
        color: color,
        fontFamily: StringConstants.spProDisplay,
        fontWeight: FontWeight.w400,
        fontSize: size);
  }
}
