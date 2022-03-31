import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/models/calendar_event.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:permission_handler/permission_handler.dart';

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
              email == ""
                  ? Container()
                  : GestureDetector(
                      onTap: actionOnEmail,
                      child: Text(email ?? "").mediumText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(10),
                          TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis))
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
      VoidCallback? deleteIconTapAction,
      bool invitation = false, bool currentUser = false}) {
    return Column(children: [
      Card(
        color: invitation
            ? ColorConstants.primaryColor
            :  currentUser == true ? ColorConstants.colorNewGray.withOpacity(0.3) : ColorConstants.colorWhite,
        elevation: 3.0,
        shadowColor: currentUser == true ? ColorConstants.colorNewGray.withOpacity(0.1) : ColorConstants.colorWhite,
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
              currentUser == true ? Container() : iconStatusCheck(scaler,
                  searchStatus: search ? searchStatus : "",
                  addIconTap: search ? addIconTapAction : () {},
                  deleteIconTap: search ? deleteIconTapAction ?? () {} : () {})
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
                     // fit: BoxFit.contain,
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
      {String? searchStatus,
      VoidCallback? addIconTap,
      VoidCallback? deleteIconTap}) {
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
    } else if (searchStatus == "Event Edit") {
      return GestureDetector(
       // onTap: deleteIconTap,
        child: ImageView(path: ImageConstants.contact_arrow_icon)
        //ImageView(path: ImageConstants.event_remove_icon),
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

  // static bottomSheet(
  //     BuildContext context, ScreenScaler scaler, Widget bottomDesign) {
  //   return showModalBottomSheet(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: scaler.getBorderRadiusCircular(15),
  //       ),
  //       backgroundColor: Colors.transparent,
  //       barrierColor: Color.fromARGB(1, 245, 245, 245),
  //       context: context,
  //       builder: (context) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             CustomShape(
  //               child: bottomDesign,
  //               bgColor: Colors.transparent,
  //               radius: scaler.getBorderRadiusCircular(15.0),
  //               width: MediaQuery.of(context).size.width,
  //             )
  //           ],
  //         );
  //       });
  // }

  static Widget cancelBtn(
      ScreenScaler scaler, BuildContext context, double size,
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
          height: scaler.getHeight(size),
        ),
      ),
    );
  }

  static Widget commonBtn(ScreenScaler scaler, BuildContext context, String txt,
      Color bgColor, Color txtColor,
      {VoidCallback? onTapFun}) {
    return GestureDetector(
      onTap: onTapFun,
      child: CustomShape(
        child: Center(
          child: Text(txt)
              .mediumText(txtColor, scaler.getTextSize(10), TextAlign.center),
        ),
        bgColor: bgColor,
        radius: scaler.getBorderRadiusCircular(10),
        width: MediaQuery.of(context).size.width,
        height: scaler.getHeight(5),
      ),
    );
  }

  static Widget settingsPageCard(
      ScreenScaler scaler, BuildContext context, icon, String txt, bool val,
      {VoidCallback? onTapCard, bool isIcon = true}) {
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
              isIcon == true ? ImageView(
                    path: icon,
                    height: 30,
                    width: 30,
                    color: ColorConstants.colorBlack) : Icon(Icons.person_outline, size: 30),
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
    return Container(
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
                    child: Text(btn2Text).mediumText(ColorConstants.colorWhite,
                        scaler.getTextSize(10), TextAlign.center)),
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
    );
  }

  static respondToEventBottomSheet(BuildContext context, ScreenScaler scaler,
      {bool? multipleDate, VoidCallback? multiDate, VoidCallback? going, VoidCallback? notGoing, VoidCallback? hide}) {
    return showModalBottomSheet(
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircularLR(25.0, 25.0, 0.0, 0.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: scaler.getHeight(0.5)),
                Container(
                  decoration: BoxDecoration(
                      color: ColorConstants.colorMediumGray,
                      borderRadius: scaler.getBorderRadiusCircular(10.0)),
                  height: scaler.getHeight(0.4),
                  width: scaler.getWidth(12),
                ),
                Column(
                  children: [
                    SizedBox(height: scaler.getHeight(2)),
                    GestureDetector(
                      onTap: multipleDate == true ? multiDate : going,
                      child: Text(multipleDate == true ? "multi_date_select_which_work".tr() : "going_to_event".tr()).regularText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(11),
                          TextAlign.center),
                    ),
                    SizedBox(height: scaler.getHeight(0.9)),
                    Divider(),
                    SizedBox(height: scaler.getHeight(0.9)),
                    GestureDetector(
                      onTap: notGoing,
                      child: Text("not_going_to_event".tr()).regularText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(11),
                          TextAlign.center),
                    ),
                    SizedBox(height: scaler.getHeight(0.9)),
                    Divider(),
                    SizedBox(height: scaler.getHeight(0.9)),
                    GestureDetector(
                      onTap: hide,
                      child: Text("hide_event".tr()).regularText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(11),
                          TextAlign.center),
                    ),
                    SizedBox(height: scaler.getHeight(2)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Text("cancel".tr()).semiBoldText(
                        ColorConstants.colorRed,
                        scaler.getTextSize(11),
                        TextAlign.center),
                  ),
                ),
                SizedBox(height: scaler.getHeight(0.5)),
              ],
            ),
          );
        });
  }

 static eventCancelBottomSheet(BuildContext context, ScreenScaler scaler,
      {VoidCallback? delete}) {
    return showModalBottomSheet(
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircularLR(25.0, 25.0, 0.0, 0.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: scaler.getHeight(0.5)),
              Container(
                decoration: BoxDecoration(
                    color: ColorConstants.colorMediumGray,
                    borderRadius: scaler.getBorderRadiusCircular(10.0)),
                height: scaler.getHeight(0.4),
                width: scaler.getWidth(12),
              ),
              Column(
                children: [
                  SizedBox(height: scaler.getHeight(0.9)),
                  GestureDetector(
                    onTap: delete,
                    child: Text("delete_event".tr()).regularText(
                        ColorConstants.primaryColor,
                        scaler.getTextSize(11),
                        TextAlign.center),
                  ),
                  SizedBox(height: scaler.getHeight(2)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text("cancel".tr()).semiBoldText(
                      ColorConstants.colorRed,
                      scaler.getTextSize(11),
                      TextAlign.center),
                ),
              ),
              SizedBox(height: scaler.getHeight(1)),
            ],
          );
        });
  }

  static Widget notificationBadge(ScreenScaler scaler, int count) {
    return Positioned(
            right: -3,
            child: Container(
              alignment: Alignment.center,
              padding: scaler.getPaddingAll(1.5),
              decoration: BoxDecoration(
                color: count == 0 ? Colors.transparent : ColorConstants.colorRed,
                borderRadius: scaler.getBorderRadiusCircular(10.0),
              ),
              constraints: BoxConstraints(
                minWidth: 15,
                minHeight: 15,
              ),
              child: Text(count.toString()).semiBoldText(
                count == 0 ? Colors.transparent :  ColorConstants.colorWhite,
                scaler.getTextSize(6.8),
                TextAlign.center,
              ),
            ),
          );
  }

 static errorDialog(BuildContext context, String content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('Permissions error'),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                }
            )
          ],
        ));
  }

 static Widget eventTimeTitleCard(ScreenScaler scaler, CalendarEvent event,{VoidCallback? actionOnCard, bool? isActionOnCard = false}) {
    return Expanded(
      child: GestureDetector(
        onTap : isActionOnCard == true? actionOnCard : (){},
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircular(8.0),
          ),
          child: Padding(
            padding: scaler.getPaddingLTRB(1.5, 1.4, 1.5, 1.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: scaler.getWidth(70.0),
                  child: Text(event.title).semiBoldText(ColorConstants.colorBlack,
                      scaler.getTextSize(9.5), TextAlign.left,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ),
                SizedBox(height: scaler.getHeight(0.1)),
                Text(
                    event.meetMeYou
                    ?
                (event.start.toString().substring(0, 11) ==
                    event.end.toString().substring(0, 11)
                    ? event.start.toString().substring(11, 16) +
                    " : " +
                    event.end.toString().substring(11, 16)
                    : event.start.toString().substring(11, 16) +
                    " : " +
                    (DateTimeHelper.dateConversion(event.end,
                        date: false) +
                        "(${DateTimeHelper.convertEventDateToTimeFormat(event.end)})"))
                    : event.start.toString().substring(0, 11)
                )
                    .regularText(ColorConstants.colorBlack,
                    scaler.getTextSize(9.5), TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }


  static gridViewOfMultiDateAlertDialog(ScreenScaler scaler, List<DateOption> multiDate, int index, {int? selectedIndex}){
    return  Container(
      margin: scaler.getMarginLTRB(1.0, 0.5, 1.0, 0.5),
      padding: scaler.getPaddingLTRB(1.5, 0.8, 1.5, 0.5),
      decoration: BoxDecoration(
          color: ColorConstants.colorLightGray,
          borderRadius:
          scaler.getBorderRadiusCircular(12.0),
          boxShadow: [
            BoxShadow(
                color: selectedIndex == index ? ColorConstants.primaryColor : ColorConstants.colorWhitishGray,
                spreadRadius: 1)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              "${DateTimeHelper.getMonthByName(multiDate[index].start)} "
                  " ${multiDate[index].start.year}")
              .semiBoldText(Colors.deepOrangeAccent, 11,
              TextAlign.center),
          SizedBox(height: scaler.getHeight(0.2)),
          Text(multiDate[index].start.day
              .toString())
              .boldText(ColorConstants.colorBlack, 24.0,
              TextAlign.center),
          // SizedBox(height: scaler.getHeight(0.2)),
          // Text(DateTimeHelper.getWeekDay(multiDate[index].start))
          //     .mediumText(ColorConstants.colorBlack, 10,
          //     TextAlign.center),
          // SizedBox(height: scaler.getHeight(0.1)),
          // Container(
          //   width: scaler.getWidth(20),
          //   child: Text((multiDate[index].start
          //       .toString()
          //       .substring(0, 11)) ==
          //       (multiDate[index].end
          //           .toString()
          //           .substring(0, 11))
          //       ? "${DateTimeHelper.timeConversion(TimeOfDay.fromDateTime(multiDate[index].start))} - ${DateTimeHelper.timeConversion(TimeOfDay.fromDateTime(multiDate[index].end))}"
          //       : "${DateTimeHelper.timeConversion(TimeOfDay.fromDateTime(multiDate[index].start))} - ${DateTimeHelper.timeConversion(TimeOfDay.fromDateTime(multiDate[index].end))} (${DateTimeHelper.dateConversion(multiDate[index].end, date: false)})")
          //       .regularText(ColorConstants.colorGray,
          //       8.5, TextAlign.center,
          //       maxLines: 2,
          //       overflow: TextOverflow.ellipsis),
          // )
        ],
      ),
    );
  }

  static answerMultiDateAlertTitle(BuildContext context, ScreenScaler scaler){
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: ImageView(
              path: ImageConstants.eventFinalDateAlert_close,
              height: scaler.getHeight(1.0),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text("which_days_could_you_attend".tr())
              .boldText(ColorConstants.colorBlack, 12.5,
              TextAlign.center),
        ),
      ],
    );
  }

  static notificationImage(ScreenScaler scaler, String photoUrl){
  return  ClipRRect(
        borderRadius: scaler.getBorderRadiusCircular(10.0),
        child: photoUrl == null || photoUrl == ""
            ? Container(
          color: ColorConstants.primaryColor,
          width: scaler.getWidth(12.5),
          height: scaler.getWidth(12.5),
        )
            : Container(
          width: scaler.getWidth(12.5),
          height: scaler.getWidth(12.5),
          child: ImageView(
            path: photoUrl,
            width: scaler.getWidth(12.5),
            height: scaler.getWidth(12.5),
             fit: BoxFit.cover,
          ),
        ));
  }
}
