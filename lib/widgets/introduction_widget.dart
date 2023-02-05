import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';

class IntroductionWidget extends StatelessWidget {
  final image;
  final String? subText;
  final String? title;
   IntroductionWidget(
      {Key? key,
        this.image,
        this.title,
        this.subText})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageView(
          path: image,
        ),
        SizedBox(height: scaler.getHeight(2),),
        Text(title!).semiBoldText(ColorConstants.colorBlack,
            scaler.getTextSize(16.5), TextAlign.center),
        SizedBox(height: scaler.getHeight(0.4),),
        Text(subText!).regularText(ColorConstants.colorGray,
            scaler.getTextSize(11), TextAlign.center)
      ],
    );
  }
}
