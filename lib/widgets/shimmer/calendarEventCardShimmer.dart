import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:shimmer/shimmer.dart';

class CalendarEventCardShimmer extends StatefulWidget {
  const CalendarEventCardShimmer({Key? key}) : super(key: key);

  @override
  _CalendarEventCardShimmerState createState() =>
      _CalendarEventCardShimmerState();
}

class _CalendarEventCardShimmerState extends State<CalendarEventCardShimmer> {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: ColorConstants.colorLightGray,
            borderRadius: scaler.getBorderRadiusCircular(8.0)),
        // width: scaler.getWidth(70.0),
        child: Shimmer.fromColors(
            baseColor: ColorConstants.colorWhitishGray,
            highlightColor: ColorConstants.colorLightGray,
            child: Padding(
              padding: scaler.getPaddingLTRB(1.5, 1.0, 1.5, 1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: scaler.getWidth(70.0),
                    height: scaler.getHeight(1.8),
                    color: ColorConstants.colorWhite,
                  ),
                  SizedBox(height: scaler.getHeight(0.3)),
                  Container(
                    width: scaler.getWidth(70.0),
                    height: scaler.getHeight(1.4),
                    color: ColorConstants.colorWhite,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
