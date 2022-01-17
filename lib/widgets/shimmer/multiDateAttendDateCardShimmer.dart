import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:shimmer/shimmer.dart';

class MultiDateAttendDateCardShimmer extends StatefulWidget {
  const MultiDateAttendDateCardShimmer({Key? key}) : super(key: key);

  @override
  _MultiDateAttendDateCardShimmerState createState() => _MultiDateAttendDateCardShimmerState();
}

class _MultiDateAttendDateCardShimmerState extends State<MultiDateAttendDateCardShimmer> {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Container(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: ColorConstants.colorWhitishGray,
        highlightColor: ColorConstants.colorLightGray,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: scaler.getHeight(1.5),
              width: scaler.getWidth(55),
              color: ColorConstants.colorWhite,
            ),
            SizedBox(height: scaler.getHeight(2)),
            Container(
              margin: scaler.getMargin(0.0, 5.0),
              width: scaler.getWidth(100),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 3.0),
                itemBuilder: (context, index) {
                  return attendDateCard(context, scaler, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget attendDateCard(BuildContext context, ScreenScaler scaler, int index){
    return  Row(
      children: [
        Container(
          height: scaler.getHeight(7.5),
          width: scaler.getWidth(15),
          padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
          decoration: BoxDecoration(
              color: ColorConstants.colorWhite,
              borderRadius: scaler.getBorderRadiusCircular(8.0)
          ),
        ),
        SizedBox(width: scaler.getWidth(2.0))
      ],
    );
  }
}
