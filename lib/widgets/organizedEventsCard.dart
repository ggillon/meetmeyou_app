import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class OrganizedEventsCard extends StatelessWidget {
  final bool showAttendBtn;

  const OrganizedEventsCard({Key? key, required this.showAttendBtn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Container(
     // height: scaler.getHeight(28),
      child: CarouselSlider.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          return Card(
            shadowColor: ColorConstants.colorWhite,
            elevation: 3.0,
            shape: RoundedRectangleBorder(
                borderRadius: scaler.getBorderRadiusCircular(10)),
            child: CustomShape(
                child: eventCard(scaler, context),
                bgColor: ColorConstants.colorWhite,
                radius: scaler.getBorderRadiusCircular(10),
                width: MediaQuery.of(context).size.width / 1.2
            ),
          );
        },
        options: CarouselOptions(
          height: scaler.getHeight(30),
          enableInfiniteScroll: false,
         // aspectRatio: 1.5,
          viewportFraction: 0.9,
        ),
      ),
    );
  }

  Widget eventCard(ScreenScaler scaler, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: scaler.getBorderRadiusCircularLR(10.0, 10.0, 0.0, 0.0),
              child: ImageView(
                path: ImageConstants.beach_dummy,
                fit: BoxFit.fill,
                height: scaler.getHeight(21),
                width: MediaQuery.of(context).size.width / 1.2,
              ),
            ),
            Positioned(
                top: scaler.getHeight(1),
                left: scaler.getHeight(1.5),
                child: dateCard(scaler))
          ],
        ),
        Padding(
          padding: scaler.getPaddingLTRB(2.0, 0.5, 2.0, 0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Love Fest").boldText(ColorConstants.colorBlack,
                        scaler.getTextSize(10), TextAlign.left,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    SizedBox(height: scaler.getHeight(0.2)),
                    Text("Visit your favourite places and festivals everywhere.")
                        .regularText(ColorConstants.colorGray,
                            scaler.getTextSize(8.5), TextAlign.left,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              showAttendBtn
                  ? SizedBox(width: scaler.getWidth(1))
                  : SizedBox(width: scaler.getWidth(0)),
              showAttendBtn ? attendBtn(scaler) : Container()
            ],
          ),
        )
      ],
    );
  }

  Widget dateCard(ScreenScaler scaler) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(8)),
      child: CustomShape(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Feb").regularText(ColorConstants.colorBlack,
                scaler.getTextSize(8.5), TextAlign.center),
            Text("04").boldText(ColorConstants.colorBlack,
                scaler.getTextSize(11), TextAlign.center)
          ],
        ),
        bgColor: ColorConstants.colorWhite,
        radius: scaler.getBorderRadiusCircular(8),
        width: scaler.getWidth(10),
        height: scaler.getHeight(4),
      ),
    );
  }

  Widget attendBtn(ScreenScaler scaler) {
    return CustomShape(
      child: Center(
          child: Text("attend".tr()).semiBoldText(ColorConstants.primaryColor,
              scaler.getTextSize(9.5), TextAlign.center)),
      bgColor: ColorConstants.primaryColor.withOpacity(0.2),
      radius: BorderRadius.all(
        Radius.circular(12),
      ),
      width: scaler.getWidth(20),
      height: scaler.getHeight(3.5),
    );
  }
}
