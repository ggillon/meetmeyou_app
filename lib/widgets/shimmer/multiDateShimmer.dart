import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:shimmer/shimmer.dart';

class MultiDateShimmer extends StatefulWidget {
  const MultiDateShimmer({Key? key}) : super(key: key);

  @override
  _MultiDateShimmerState createState() => _MultiDateShimmerState();
}

class _MultiDateShimmerState extends State<MultiDateShimmer> {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Container(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: ColorConstants.colorWhitishGray,
        highlightColor: ColorConstants.colorLightGray,
        child: Column(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: scaler.getWidth(35),
                height: scaler.getHeight(1.5),
                color: ColorConstants.colorWhite,
              ),
            ),
            SizedBox(
                height: scaler.getHeight(0.5)),
            optionsDesign(scaler),
            SizedBox(
                height: scaler.getHeight(0.5)),
            multipleDateCardListView(
                context, scaler),
          ],
        ),
      ),
    );
  }


  Widget optionsDesign(ScreenScaler scaler) {
    return Row(
      children: [
        Icon(Icons.calendar_today),
        SizedBox(width: scaler.getWidth(1.5)),
        Container(
          width: scaler.getWidth(15),
          height: scaler.getHeight(1.5),
          color: ColorConstants.colorWhite,
        ),
        Expanded(
            child: Container(
                alignment: Alignment.centerRight,
                child: ImageView(
                  path: ImageConstants.small_arrow_icon,
                  color: ColorConstants.colorGray,
                  height: scaler.getHeight(1.5),
                )))
      ],
    );
  }

  Widget multipleDateCardListView(
      BuildContext context, ScreenScaler scaler ){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        // color: Colors.red,
        height: scaler.getHeight(14.5),
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 12,
            itemBuilder: (context, index) {
              return multiDateCardDesign(scaler);
            }),
      ),
    );
  }

  Widget multiDateCardDesign(ScreenScaler scaler) {
    return Container(
      margin: scaler.getMarginLTRB(0.5, 0.5, 1.0, 0.5),
      padding: scaler.getPaddingLTRB(1.5, 1.0, 1.5, 1.0),
      width: scaler.getWidth(25),
      decoration: BoxDecoration(
          color: ColorConstants.colorLightGray,
          borderRadius: scaler.getBorderRadiusCircular(12.0),
          boxShadow: [
            BoxShadow(color: ColorConstants.colorWhitishGray, spreadRadius: 1)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: scaler.getWidth(20),
            height: scaler.getHeight(1.0),
            color: ColorConstants.colorWhite,
          ),
        ],
      ),
    );
  }
}
