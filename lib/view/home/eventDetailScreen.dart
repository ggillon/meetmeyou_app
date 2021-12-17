import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:image_stack/image_stack.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/provider/event_detail_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/dashboard/dashboardPage.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final dashBoardProvider = Provider.of<DashboardProvider>(context, listen: false);
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        body: BaseView<EventDetailProvider>(
          onModelReady: (provider) {
            provider.eventGoingLength();
            provider.getUsersProfileUrl(context);
            provider.getOrganiserProfileUrl(context, event.organiserID);
          },
          builder: (context, provider, _) {
            return SingleChildScrollView(
                child: Column(children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  imageView(context, scaler, provider),
                  Positioned(
                    bottom: -50,
                    child: titleDateLocationCard(scaler, provider),
                  )
                ],
              ),
              SizedBox(height: scaler.getHeight(6)),
              Padding(
                padding: scaler.getPaddingLTRB(3, 1.0, 3, 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    provider.replyEventValue == true
                        ? Center(child: CircularProgressIndicator())
                        : CommonWidgets.commonBtn(
                            scaler,
                            context,
                            provider.eventDetail.eventBtnStatus!.tr(),
                            provider.eventDetail.btnBGColor!,
                            provider.eventDetail.textColor!, onTapFun: () {
                            if (provider.eventDetail.eventBtnStatus ==
                                "respond") {
                              CommonWidgets.respondToEventBottomSheet(
                                  context, scaler, going: () {
                                Navigator.of(context).pop();
                                provider.dashboardProvider
                                    .updateEventNotificationCount();
                                provider.replyToEvent(
                                    context, event.eid, EVENT_ATTENDING);
                              }, notGoing: () {
                                Navigator.of(context).pop();
                                provider.dashboardProvider
                                    .updateEventNotificationCount();
                                provider.replyToEvent(
                                    context, event.eid, EVENT_NOT_ATTENDING);
                              }, hide: () {
                                Navigator.of(context).pop();
                                provider.dashboardProvider
                                    .updateEventNotificationCount();
                                provider.replyToEvent(
                                    context, event.eid, EVENT_NOT_INTERESTED);
                              });
                            } else if (provider.eventDetail.eventBtnStatus ==
                                "edit") {
                              // provider.setEventValuesForEdit(event);
                              Navigator.pushNamed(context,
                                      RoutesConstants.createEventScreen)
                                  .then((value) {
                                provider.updateValue(true);
                              });
                            } else if (provider.eventDetail.eventBtnStatus ==
                                "cancelled") {
                              CommonWidgets.eventCancelBottomSheet(
                                  context, scaler, delete: () {
                                Navigator.of(context).pop();
                                provider.deleteEvent(context,
                                    provider.eventDetail.eid.toString());
                              });
                            } else {
                              Container();
                            }
                          }),
                    SizedBox(height: scaler.getHeight(1)),
                    organiserCard(scaler, provider),
                    SizedBox(height: scaler.getHeight(1)),
                    provider.eventAttendingLength == 0
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              provider.eventDetail.attendingProfileKeys =
                                  provider.eventAttendingKeysList;
                              Navigator.pushNamed(context,
                                      RoutesConstants.eventAttendingScreen)
                                  .then((value) {
                                provider.eventAttendingLength = (provider
                                        .eventDetail
                                        .attendingProfileKeys
                                        ?.length ??
                                    0);
                                provider.updateValue(true);
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.centerRight,
                                    clipBehavior: Clip.none,
                                    children: [
                                      ImageStack(
                                        imageList: provider
                                            .eventAttendingPhotoUrlLists,
                                        totalCount: provider
                                            .eventAttendingPhotoUrlLists.length,
                                        imageRadius: 25,
                                        imageCount: provider.imageStackLength(
                                            provider.eventAttendingPhotoUrlLists
                                                .length),
                                        imageBorderColor:
                                            ColorConstants.colorWhite,
                                        backgroundColor:
                                            ColorConstants.primaryColor,
                                        imageBorderWidth: 1,
                                        extraCountTextStyle: TextStyle(
                                            fontSize: 7.7,
                                            color: ColorConstants.colorWhite,
                                            fontWeight: FontWeight.w500),
                                        showTotalCount: false,
                                      ),
                                      Positioned(
                                        right: -22,
                                        child: provider
                                                    .eventAttendingPhotoUrlLists
                                                    .length <=
                                                6
                                            ? Container()
                                            : ClipRRect(
                                                borderRadius: scaler
                                                    .getBorderRadiusCircular(
                                                        15.0),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  color: ColorConstants
                                                      .primaryColor,
                                                  height: scaler.getHeight(2.0),
                                                  width: scaler.getWidth(6),
                                                  child: Text((provider
                                                                  .eventAttendingPhotoUrlLists
                                                                  .length -
                                                              6)
                                                          .toString())
                                                      .mediumText(
                                                          ColorConstants
                                                              .colorWhite,
                                                          scaler
                                                              .getTextSize(7.7),
                                                          TextAlign.center),
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                  provider.eventAttendingPhotoUrlLists.length <=
                                          6
                                      ? SizedBox(width: scaler.getWidth(1))
                                      : SizedBox(width: scaler.getWidth(6)),
                                  Text("going".tr()).regularText(
                                      ColorConstants.colorGray,
                                      scaler.getTextSize(8),
                                      TextAlign.center),
                                ],
                              ),
                            ),
                          ),
                    SizedBox(height: scaler.getHeight(1)),
                    Text("event_description".tr()).boldText(
                        ColorConstants.colorBlack,
                        scaler.getTextSize(9.5),
                        TextAlign.left),
                    SizedBox(height: scaler.getHeight(2)),
                    Text(provider.eventDetail.eventDescription ?? "")
                        .regularText(ColorConstants.colorBlack,
                            scaler.getTextSize(10), TextAlign.left),
                    SizedBox(height: scaler.getHeight(2.5)),
                    eventDiscussionCard(scaler)
                  ],
                ),
              )
            ]));
          },
        ),
      ),
    );
  }

  Widget imageView(
      BuildContext context, ScreenScaler scaler, EventDetailProvider provider) {
    return Card(
      margin: scaler.getMarginAll(0.0),
      shadowColor: ColorConstants.colorWhite,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircularLR(0.0, 0.0, 15, 15)),
      color: ColorConstants.colorLightGray,
      child: Container(
        height: scaler.getHeight(30),
        width: double.infinity,
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      scaler.getBorderRadiusCircularLR(0.0, 0.0, 15, 15),
                  child: provider.eventDetail.photoUrlEvent == null ||
                          provider.eventDetail.photoUrlEvent == ""
                      ? Container(
                          color: ColorConstants.primaryColor,
                          height: scaler.getHeight(30),
                          width: double.infinity,
                        )
                      : ImageView(
                          path: provider.eventDetail.photoUrlEvent,
                          fit: BoxFit.cover,
                          height: scaler.getHeight(30),
                          width: double.infinity,
                        ),
                ),
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        padding: scaler.getPaddingLTRB(3.0, 2, 3.0, 0.0),
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ImageView(
                                path: ImageConstants.back,
                                color: ColorConstants.colorWhite),
                            ImageView(
                                path: ImageConstants.close_icon,
                                color: ColorConstants.colorWhite),
                          ],
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bool showText = true;

  Widget titleDateLocationCard(
      ScreenScaler scaler, EventDetailProvider provider) {
    return Padding(
      padding: scaler.getPaddingLTRB(3.0, 0.0, 3.0, 0.0),
      child: Card(
          shadowColor: ColorConstants.colorWhite,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
              borderRadius: scaler.getBorderRadiusCircular(10)),
          child: Padding(
            padding: scaler.getPaddingLTRB(2.5, 1.0, 2.0, 1.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                dateCard(scaler, provider),
                SizedBox(width: scaler.getWidth(1.8)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: scaler.getWidth(55),
                      child: Text(provider.eventDetail.eventName ?? "")
                          .boldText(ColorConstants.colorBlack,
                              scaler.getTextSize(10), TextAlign.left,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(height: scaler.getHeight(0.3)),
                    Row(
                      children: [
                        ImageView(path: ImageConstants.event_clock_icon),
                        SizedBox(width: scaler.getWidth(1)),
                        Container(
                          width: scaler.getWidth(50),
                          child: Text(DateTimeHelper.getWeekDay(
                                      provider.eventDetail.startDateAndTime ??
                                          DateTime.now()) +
                                  " - " +
                                  DateTimeHelper.convertEventDateToTimeFormat(
                                      provider.eventDetail.startDateAndTime ??
                                          DateTime.now()) +
                                  " to " +
                                  DateTimeHelper.convertEventDateToTimeFormat(
                                      provider.eventDetail.endDateAndTime ??
                                          DateTime.now()))
                              .regularText(ColorConstants.colorGray,
                                  scaler.getTextSize(9.5), TextAlign.left,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                    SizedBox(height: scaler.getHeight(0.3)),
                    Row(
                      children: [
                        ImageView(path: ImageConstants.map),
                        SizedBox(width: scaler.getWidth(1)),
                        Container(
                          width: scaler.getWidth(50),
                          child: Text(provider.eventDetail.eventLocation ?? "")
                              .regularText(ColorConstants.colorGray,
                                  scaler.getTextSize(9.5), TextAlign.left,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget dateCard(ScreenScaler scaler, EventDetailProvider provider) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(8)),
      child: Container(
        decoration: BoxDecoration(
            color: ColorConstants.primaryColor.withOpacity(0.2),
            borderRadius: scaler.getBorderRadiusCircular(
                8.0) // use instead of BorderRadius.all(Radius.circular(20))
            ),
        padding: scaler.getPaddingLTRB(3.0, 0.3, 3.0, 0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateTimeHelper.getMonthByName(
                    provider.eventDetail.startDateAndTime ?? DateTime.now()))
                .regularText(ColorConstants.primaryColor,
                    scaler.getTextSize(11), TextAlign.center),
            Text(provider.eventDetail.startDateAndTime!.day <= 9
                    ? "0" +
                        provider.eventDetail.startDateAndTime!.day.toString()
                    : provider.eventDetail.startDateAndTime!.day.toString())
                .boldText(ColorConstants.primaryColor, scaler.getTextSize(14),
                    TextAlign.center)
          ],
        ),
      ),
    );
  }

  Widget organiserCard(ScreenScaler scaler, EventDetailProvider provider) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(8)),
      child: Padding(
        padding: scaler.getPaddingLTRB(2.0, 0.7, 2.0, 0.7),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: scaler.getBorderRadiusCircular(15.0),
                child: provider.userDetail.profileUrl == null
                    ? Container(
                        color: ColorConstants.primaryColor,
                        height: scaler.getHeight(2.8),
                        width: scaler.getWidth(9),
                      )
                    : Container(
                        height: scaler.getHeight(2.8),
                        width: scaler.getWidth(9),
                        child: ImageView(
                            path: provider.userDetail.profileUrl,
                            height: scaler.getHeight(2.8),
                            width: scaler.getWidth(9),
                            fit: BoxFit.cover),
                      )),
            SizedBox(width: scaler.getWidth(2)),
            Expanded(
                child: Container(
              alignment: Alignment.centerLeft,
              child: Text(event.organiserName + " " + "(${"organiser".tr()})")
                  .semiBoldText(ColorConstants.colorBlack,
                      scaler.getTextSize(9.8), TextAlign.left,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
            )),
            SizedBox(width: scaler.getWidth(2)),
            ImageView(
              path: ImageConstants.event_arrow_icon,
            )
          ],
        ),
      ),
    );
  }

  Widget eventDiscussionCard(ScreenScaler scaler) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(8)),
      child: Padding(
        padding: scaler.getPaddingLTRB(2.0, 0.7, 2.0, 0.7),
        child: Row(
          children: [
            ImageView(path: ImageConstants.event_chat_icon),
            SizedBox(width: scaler.getWidth(2)),
            Expanded(
                child: Container(
              alignment: Alignment.centerLeft,
              child: Text("event_discussion".tr()).mediumText(
                  ColorConstants.colorBlack,
                  scaler.getTextSize(9.5),
                  TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            )),
            SizedBox(width: scaler.getWidth(2)),
            ImageView(
              path: ImageConstants.small_arrow_icon,
            )
          ],
        ),
      ),
    );
  }
}
