import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class CommonWidgets {
  static Widget phoneNoAndAddressFun(
      ScreenScaler scaler, String icon, String field, String value,
      {bool countryCode = false, String? cCode}) {
    return Row(
      children: [
        ImageView(path: icon),
        SizedBox(width: scaler.getWidth(4)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field).boldText(ColorConstants.colorBlack,
                  scaler.getTextSize(9.5), TextAlign.left),
              SizedBox(height: scaler.getHeight(0.3)),
              Text(countryCode ? cCode! + " " + value : value).regularText(
                  ColorConstants.colorGray,
                  scaler.getTextSize(9.5),
                  TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        )
      ],
    );
  }

  static Widget userDetails(ScreenScaler scaler,
      {String? profilePic,
      String? firstName,
      String? lastName,
      String? email,
      VoidCallback? actionOnEmail}) {
    return Row(
      children: [
        Container(
          width: scaler.getWidth(22),
          height: scaler.getWidth(22),
          child: ClipRRect(
            borderRadius: scaler.getBorderRadiusCircular(10.0),
            child: profilePic == null || profilePic == ""
                ? Container(
                    color: ColorConstants.primaryColor,
                    width: scaler.getWidth(22),
                    height: scaler.getWidth(22),
                  )
                : ImageView(
                    path: profilePic,
                    width: scaler.getWidth(22),
                    height: scaler.getWidth(22),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        SizedBox(width: scaler.getWidth(2.5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          //  mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(firstName! + " " + lastName!).boldText(
                  ColorConstants.colorBlack,
                  scaler.getTextSize(12),
                  TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: scaler.getHeight(0.5)),
             email == "" ? Container() :  GestureDetector(
                  onTap: actionOnEmail,
                  child: Text(email ?? "").mediumText(ColorConstants.colorBlack,
                      scaler.getTextSize(10), TextAlign.left,
                      maxLines: 1, overflow: TextOverflow.ellipsis))
            ],
          ),
        ),
      ],
    );
  }

  static Widget userContactCard(
      ScreenScaler scaler, String email, String contactName,
      {String? profileImg,
      String? searchStatus,
      bool search = false,
      VoidCallback? addIconTapAction,
      bool invitation = false}) {
    return Column(children: [
      Card(
        color: invitation
            ? ColorConstants.primaryColor
            : ColorConstants.colorWhite,
        elevation: 3.0,
        shadowColor: ColorConstants.colorWhite,
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircular(12)),
        child: Padding(
          padding: scaler.getPaddingAll(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              profileCardImageDesign(scaler, profileImg!),
              SizedBox(width: scaler.getWidth(2.5)),
              profileCardNameAndEmailDesign(scaler, contactName, email,
                  search: true, searchStatus: searchStatus),
              iconStatusCheck(scaler,
                  searchStatus: search ? searchStatus : "",
                  addIconTap: search ? addIconTapAction : () {})
            ],
          ),
        ),
      ),
      SizedBox(height: scaler.getHeight(0.5))
    ]);
  }

  static Widget profileCardImageDesign(ScreenScaler scaler, String profileImg) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
            borderRadius: scaler.getBorderRadiusCircular(10.0),
            child: profileImg == null
                ? Container(
                    color: ColorConstants.primaryColor,
                    width: scaler.getWidth(10),
                    height: scaler.getWidth(10),
                  )
                : Container(
                    width: scaler.getWidth(10),
                    height: scaler.getWidth(10),
                    child: ImageView(
                      path: profileImg,
                      width: scaler.getWidth(10),
                      height: scaler.getWidth(10),
                      fit: BoxFit.cover,
                    ),
                  )),
        Positioned(
            top: 25,
            right: -5,
            child: ImageView(path: ImageConstants.small_logo_icon))
      ],
    );
  }

  static Widget profileCardNameAndEmailDesign(
      ScreenScaler scaler, String contactName, String email,
      {bool search = false, String? searchStatus}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contactName.capitalize()).semiBoldText(ColorConstants.colorBlack,
              scaler.getTextSize(9.8), TextAlign.left,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          SizedBox(height: scaler.getHeight(0.2)),
          Text(emailOrTextStatusCheck(searchStatus ?? "", email)).regularText(
              ColorConstants.colorBlackDown,
              scaler.getTextSize(8.3),
              TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  static Widget iconStatusCheck(ScreenScaler scaler,
      {String? searchStatus, VoidCallback? addIconTap}) {
    if (searchStatus == "Listed profile") {
      return GestureDetector(
        onTap: addIconTap,
        child: CircleAvatar(
            backgroundColor: ColorConstants.colorGray,
            radius: 12,
            child: ImageView(path: ImageConstants.small_add_icon)),
      );
    } else if (searchStatus == "Confirmed contact") {
      return Container();
    } else if (searchStatus == "Invited contact") {
      return GestureDetector(
        onTap: () {},
        child: ImageView(path: ImageConstants.invited_waiting_icon),
      );
    } else {
      return ImageView(path: ImageConstants.contact_arrow_icon);
    }
  }

  static emailOrTextStatusCheck(String searchStatus, String email) {
    if (searchStatus == "Listed profile") {
      return "click_+_to_send_invitation".tr();
    } else if (searchStatus == "Confirmed contact") {
      return "already_a_contact".tr();
    } else if (searchStatus == "Invited contact") {
      return "invitation_waiting_reply".tr();
    } else {
      return email;
    }
  }

  static bottomSheet(
      BuildContext context, ScreenScaler scaler, Widget bottomDesign) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(15),
        ),
        backgroundColor: Colors.transparent,
        barrierColor: Color.fromARGB(1, 245, 245, 245),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CustomShape(
                child: bottomDesign,
                bgColor: Colors.transparent,
                radius: scaler.getBorderRadiusCircular(15.0),
                width: MediaQuery.of(context).size.width,
              )
            ],
          );
        });
  }

  static Widget cancelBtn(ScreenScaler scaler, BuildContext context,
      {Color? color}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Card(
        color: ColorConstants.colorWhite,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: CustomShape(
          child: Center(
            child: Text("cancel".tr()).semiBoldText(
                color ?? ColorConstants.primaryColor,
                scaler.getTextSize(11),
                TextAlign.center),
          ),
          bgColor: Colors.transparent,
          radius: scaler.getBorderRadiusCircular(10),
          width: MediaQuery.of(context).size.width,
          height: scaler.getHeight(5),
        ),
      ),
    );
  }

  static Widget settingsPageCard(
      ScreenScaler scaler, BuildContext context, icon, String txt, bool val,
      {VoidCallback? onTapCard}) {
    return GestureDetector(
      onTap: onTapCard,
      child: Card(
        shadowColor: ColorConstants.colorWhite,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircular(10)),
        child: CustomShape(
          child: Padding(
            padding: scaler.getPaddingAll(9.0),
            child: Row(
              children: [
                ImageView(
                    path: icon,
                    height: 30,
                    width: 30,
                    color: ColorConstants.colorBlack),
                SizedBox(width: scaler.getWidth(2.5)),
                Text(txt).mediumText(ColorConstants.colorBlack,
                    scaler.getTextSize(9.5), TextAlign.left),
                val
                    ? Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: ImageView(
                                path: ImageConstants.small_arrow_icon)))
                    : Container()
              ],
            ),
          ),
          bgColor: ColorConstants.colorWhite,
          radius: scaler.getBorderRadiusCircular(10),
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  static Widget expandedRowButton(BuildContext context, ScreenScaler scaler,
      String btn1Text, String btn2Text,
      {VoidCallback? onTapBtn1, bool btn1 = true, VoidCallback? onTapBtn2}) {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: scaler.getPaddingLTRB(2, 0.0, 2, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: btn1
                      ? () {
                          Navigator.pop(context);
                        }
                      : onTapBtn1,
                  child: CustomShape(
                    child: Center(
                        child: Text(btn1Text).mediumText(
                            ColorConstants.primaryColor,
                            scaler.getTextSize(10),
                            TextAlign.center)),
                    bgColor: ColorConstants.primaryColor.withOpacity(0.2),
                    radius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    width: scaler.getWidth(40),
                    height: scaler.getHeight(4.5),
                  ),
                ),
              ),
              SizedBox(
                width: scaler.getWidth(2),
              ),
              Expanded(
                  child: GestureDetector(
                onTap: onTapBtn2,
                child: CustomShape(
                  child: Center(
                      child: Text(btn2Text).mediumText(
                          ColorConstants.colorWhite,
                          scaler.getTextSize(10),
                          TextAlign.center)),
                  bgColor: ColorConstants.primaryColor,
                  radius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  width: scaler.getWidth(40),
                  height: scaler.getHeight(4.5),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
