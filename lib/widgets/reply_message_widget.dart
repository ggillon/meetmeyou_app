import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/models/discussion_message.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class ReplyMessageWidget extends StatelessWidget {
  final String message;
  final String userName;
  final bool isUserName;
  final String imageUrl;
  final VoidCallback onCancelReply;
  final bool showCloseIcon;

  const ReplyMessageWidget({
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
                Expanded(child:  Text(isUserName == true ? userName : "you".tr()).boldText(ColorConstants.primaryColor, scaler.getTextSize(10.5), TextAlign.left)),
                  showCloseIcon == true ?
                  GestureDetector(
                    child: Icon(Icons.close, size: 16),
                    onTap: onCancelReply,
                  ) : Container()
                ],
              ),
              Text(message)
                  .regularText(ColorConstants.colorGray,
                      scaler.getTextSize(11), TextAlign.left,
                      isHeight: true),
            ],
          ),
          const SizedBox(height: 5),
          //Text("message.message", style: TextStyle(color: Colors.black54)),
        ],
      );
}
