import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:shimmer/shimmer.dart';

class OrganizedEventCardShimmer extends StatefulWidget {
  final bool showEventRespondBtn;
  const OrganizedEventCardShimmer({Key? key, required this.showEventRespondBtn}) : super(key: key);

  @override
  _OrganizedEventCardShimmerState createState() =>
      _OrganizedEventCardShimmerState();
}

class _OrganizedEventCardShimmerState extends State<OrganizedEventCardShimmer> {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return CarouselSlider.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        return Container(
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
                color: ColorConstants.colorLightGray,
                borderRadius: scaler.getBorderRadiusCircular(8.0)),
            child: Shimmer.fromColors(
                baseColor: ColorConstants.colorWhitishGray,
                highlightColor: ColorConstants.colorLightGray,
                child: eventCard(context, scaler)));
      },
      options: CarouselOptions(
        height: scaler.getHeight(30),
        enableInfiniteScroll: false,
        // aspectRatio: 1.5,
        viewportFraction: 0.9,
      ),
    );
  }

  Widget eventCard(BuildContext context, ScreenScaler scaler) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            ClipRRect(
                borderRadius:
                    scaler.getBorderRadiusCircularLR(10.0, 10.0, 0.0, 0.0),
                child: Container(
                  height: scaler.getHeight(21),
                  width: MediaQuery.of(context).size.width / 1.2,
                  color: ColorConstants.colorWhite,
                )),
          ],
        ),
        Container(
          padding: widget.showEventRespondBtn ?  scaler.getPaddingLTRB(2.0, 0.5, 2.0, 0.7) : scaler.getPaddingLTRB(2.0, 0.5, 7.5, 0.7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: ColorConstants.colorWhite,
                    width: widget.showEventRespondBtn ? scaler.getWidth(40) : scaler.getWidth(55),
                    height: scaler.getHeight(1.5),
                  ),
                  SizedBox(height: scaler.getHeight(1.0)),
                  Container(
                    color: ColorConstants.colorWhite,
                    width: widget.showEventRespondBtn ? scaler.getWidth(52) :  scaler.getWidth(65),
                    height: scaler.getHeight(1.5),
                  ),
                ],
              ),
              widget.showEventRespondBtn
                  ? SizedBox(width: scaler.getWidth(0.5))
                  : SizedBox(width: scaler.getWidth(0)),
              widget.showEventRespondBtn ? eventRespondBtn(scaler) : Container()
            ],
          ),
        )
      ],
    );
  }

  Widget eventRespondBtn(ScreenScaler scaler) {
    return Container(
      decoration: BoxDecoration(
          color: ColorConstants.colorWhite,
          borderRadius: scaler.getBorderRadiusCircular(8.0)),
      width: scaler.getWidth(15),
      height: scaler.getHeight(2.7),
    );
  }
}
