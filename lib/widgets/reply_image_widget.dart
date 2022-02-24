import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class ReplyImageWidget extends StatelessWidget {
  final String message;
  final String userName;
  final bool isUserName;
  final String imageUrl;
  final VoidCallback onCancelReply;
  final bool showCloseIcon;

  const ReplyImageWidget({
    required this.message,
    required this.userName,
    required this.isUserName,
    required this.imageUrl,
    required this.onCancelReply,
    required this.showCloseIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            color: ColorConstants.primaryColor,
            width: 4,
          ),
          const SizedBox(width: 8),
          Expanded(child: buildReplyMessage(scaler)),
        ],
      ),
    );
  }

  Widget buildReplyMessage(ScreenScaler scaler) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child:  Text(isUserName == true ? userName : "you".tr()).boldText(ColorConstants.primaryColor, scaler.getTextSize(10.0), TextAlign.left)),
              showCloseIcon == true ?
              GestureDetector(
                child: Icon(Icons.close, size: 16),
                onTap: onCancelReply,
              ) : Container()
            ],
          ),
          ClipRRect(
            borderRadius: scaler.getBorderRadiusCircular(7.5),
            child: Container(
              height: scaler.getHeight(12.0),
              width: scaler.getWidth(35.0),
              color: ColorConstants.primaryColor,
              child: ImageView(path: imageUrl, fit: BoxFit.cover, height: scaler.getHeight(10.0),
                  width: scaler.getWidth(35.0)),
            ),
          )
        ],
      ),
      const SizedBox(height: 5),
    ],
  );
}
