import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:meetmeyou_app/helper/common_used.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class DialogHelper {
  static final border = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
  );

  static Future showDialogWithTwoButtons(
    BuildContext context,
    String title,
    String content, {
    String positiveButtonLabel = "Yes",
    VoidCallback? positiveButtonPress,
    String negativeButtonLabel = "Cancel",
    VoidCallback? negativeButtonPress,
    barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center),
          content: Text(content, textAlign: TextAlign.center),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(negativeButtonLabel).mediumText(
                  ColorConstants.primaryColor, 18, TextAlign.center),
              onPressed: () {
                if (negativeButtonPress != null) {
                  negativeButtonPress();
                } else {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
            ),
            TextButton(
              child: Text(positiveButtonLabel).mediumText(
                  ColorConstants.primaryColor, 18, TextAlign.center),
              onPressed: () {
                if (positiveButtonPress != null) {
                  positiveButtonPress();
                } else {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
            )
          ],
        );
      },
    );
  }

  static Future showDialogWithOneButton(
    BuildContext context,
    String title,
    String content, {
    String positiveButtonLabel = "Ok",
    VoidCallback? positiveButtonPress,
    barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center)
              .semiBoldText(ColorConstants.colorBlack, 18, TextAlign.center),
          content: Text(content)
              .regularText(ColorConstants.colorBlack, 16, TextAlign.center),
          shape: border,
          actions: <Widget>[
            TextButton(
              child: Text(positiveButtonLabel).mediumText(
                  ColorConstants.primaryColor, 18, TextAlign.center),
              onPressed: () {
                if (positiveButtonPress != null) {
                  positiveButtonPress();
                } else {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
            )
          ],
        );
      },
    );
  }

  static showMessage(BuildContext context, String message) {
    Flushbar(
      message: message,
      backgroundColor: ColorConstants.primaryColor,
      duration: Duration(seconds: 2),
    )..show(context);
  }

  static PreferredSizeWidget appBarWithBack(
      ScreenScaler scaler, BuildContext context,
      {showEdit = false, VoidCallback? editClick, bool message = false, VoidCallback? messageIconClick, bool back = true, VoidCallback? backIconClick}) {
    return AppBar(
      elevation: 0,
      backgroundColor: ColorConstants.colorWhite,
      leadingWidth: 100,
      leading: InkWell(
        onTap: back == true ? () {
          hideKeyboard(context);
         Navigator.pop(context);
        } : backIconClick,
        child: Padding(
          padding: scaler.getPaddingLTRB(2.5, 0.0, 0.0, 0.0),
          child: Row(
            children: <Widget>[
              ImageView(path: ImageConstants.ic_back_arrow),
              SizedBox(width: scaler.getWidth(0.8)),
              Text("back".tr()).regularText(ColorConstants.primaryColor,
                  scaler.getTextSize(11.5), TextAlign.left),
            ],
          ),
        ),
      ),
      actions: [
        showEdit
            ? GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: message == true
                    ? messageIconClick!
                    : editClick!,
            child: Padding(
                        padding: scaler.getPaddingLTRB(0.0, 0.0, 2.5, 0.0),
                        child: message == true
                            ? Icon(Icons.message,
                            color: ColorConstants.primaryColor, size: 28)
                            : ImageView(
                            width: scaler.getWidth(6.0),
                            height: scaler.getWidth(6.0),
                            path: ImageConstants.ic_edit),
                      ))
            : Container(),
      ],
    );
  }

  static Widget btnWidget(
      ScreenScaler scaler, BuildContext context, String txt, Color color,
      {Color? txtColor, VoidCallback? funOnTap}) {
    return GestureDetector(
      onTap: funOnTap,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: CustomShape(
          child: Center(
            child: Text(txt).mediumText(txtColor ?? ColorConstants.colorWhite,
                scaler.getTextSize(11.2), TextAlign.center),
          ),
          bgColor: color,
          radius: scaler.getBorderRadiusCircular(10),
          width: MediaQuery.of(context).size.width,
          height: scaler.getHeight(6.2),
        ),
      ),
    );
  }
}
