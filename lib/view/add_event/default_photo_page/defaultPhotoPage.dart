import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/services/storage/templates.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class DefaultPhotoPage extends StatelessWidget {
  DefaultPhotoPage({Key? key}) : super(key: key);

  List<String> defaultImages = [
    EVENT_PHOTO_DINER,
    EVENT_PHOTO_PARTY,
    EVENT_PHOTO_SPORTS,
    EVENT_PHOTO_WEDDING,
    EVENT_PHOTO_BIRTHDAY,
    EVENT_PHOTO_WORK,
    EVENT_PHOTO_CHILL,
    EVENT_PHOTO_BBQ,
  //  EVENT_PHOTO_POOL
  ];

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorWhitishGray,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: scaler.getHeight(75),
              padding: scaler.getPaddingLTRB(3.0, 7.0, 3.0, 2.0),
              child: GridView.builder(
                itemCount: defaultImages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(defaultImages[index]);
                    },
                    child: ClipRRect(
                        borderRadius: scaler.getBorderRadiusCircular(12.0),
                        child: ImageView(
                            path: defaultImages[index], fit: BoxFit.cover)),
                  );
                },
              ),
            ),
            Container(
              padding: scaler.getPaddingLTRB(3.0, 0.0, 3.0, 0.0),
                child: CommonWidgets.cancelBtn(scaler, context, 5.5)),
            SizedBox(height: scaler.getHeight(0.5)),
          ],
        ),
      ),
    );
  }
}
