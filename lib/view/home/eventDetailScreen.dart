import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  imageView(context, scaler),
                  Positioned(
                    bottom: -50,
                    child: titleDateLocationCard(scaler),
                  )
                ],
              ),
              SizedBox(height: scaler.getHeight(5)),
              Padding(
                padding: scaler.getPaddingLTRB(3, 0.0, 3, 1.0),
                child: Column(
                  children: [
                    CommonWidgets.commonBtn(
                        scaler,
                        context,
                        "Going",
                        ColorConstants.primaryColor.withOpacity(0.2),
                        ColorConstants.primaryColor),
                    SizedBox(height: scaler.getHeight(1)),
                    organiserCard(scaler),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageView(BuildContext context, ScreenScaler scaler) {
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
                  child: event.photoURL == null || event.photoURL == ""
                      ? Container(
                          color: ColorConstants.primaryColor,
                          height: scaler.getHeight(30),
                          width: double.infinity,
                        )
                      : ImageView(
                          path: event.photoURL,
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

  Widget titleDateLocationCard(ScreenScaler scaler) {
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
                dateCard(scaler),
                SizedBox(width: scaler.getWidth(1.8)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: scaler.getWidth(55),
                      child: Text(event.title).boldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(10),
                          TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(height: scaler.getHeight(0.3)),
                    Row(
                      children: [
                        ImageView(path: ImageConstants.event_clock_icon),
                        SizedBox(width: scaler.getWidth(1)),
                        Container(
                          width: scaler.getWidth(50),
                          child: Text(DateTimeHelper.getWeekDay(event.start) +
                                  " - " +
                                  DateTimeHelper.convertEventDateToTimeFormat(
                                      event.start) +
                                  " to " +
                                  DateTimeHelper.convertEventDateToTimeFormat(
                                      event.end))
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
                          child: Text(event.location).regularText(
                              ColorConstants.colorGray,
                              scaler.getTextSize(9.5),
                              TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
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

  Widget dateCard(ScreenScaler scaler) {
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
            Text(DateTimeHelper.getMonthByName(event.start)).regularText(
                ColorConstants.primaryColor,
                scaler.getTextSize(11),
                TextAlign.center),
            Text(event.start.day <= 9
                    ? "0" + event.start.day.toString()
                    : event.start.day.toString())
                .boldText(ColorConstants.primaryColor, scaler.getTextSize(14),
                    TextAlign.center)
          ],
        ),
      ),
    );
  }

  Widget organiserCard(ScreenScaler scaler){
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(10)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: scaler.getBorderRadiusCircular(15.0),
            child: Container(
              color: ColorConstants.primaryColor,
              height: scaler.getHeight(1),
              width: scaler.getWidth(4),
            ),
          )
        ],
      ),
    );
  }
}
