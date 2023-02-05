import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:shimmer/shimmer.dart';

class UserProfileCardShimmer extends StatelessWidget {
  const UserProfileCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Container(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: ColorConstants.colorWhitishGray,
        highlightColor: ColorConstants.colorLightGray,
        child: Padding(
          padding: scaler.getPaddingAll(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: scaler.getBorderRadiusCircular(10.0),
                  child: Container(
                    color: Colors.white,
                    width: scaler.getWidth(24),
                    height: scaler.getWidth(24),
                  )),
              SizedBox(width: scaler.getWidth(2.5)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white,
                      height: scaler.getWidth(4),
                    ),
                    Padding(padding: scaler.getPaddingByHeight(0.5)),
                    Container(
                      color: Colors.white,
                      height: scaler.getWidth(2),
                    ),
                  ],
                ),
              ),
              Padding(padding: scaler.getPaddingByWidth(0.5)),
              ImageView(path: ImageConstants.arrow_icon)
            ],
          ),
        ),
      ),
    );
  }
}
