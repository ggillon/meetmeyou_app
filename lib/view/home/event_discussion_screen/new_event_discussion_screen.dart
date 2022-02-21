import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_used.dart';
import 'package:meetmeyou_app/models/discussion_message.dart';
import 'package:meetmeyou_app/provider/new_event_discussion_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/imagePickerDialog.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/widgets/reply_message_widget.dart';
import 'package:swipe_to/swipe_to.dart';

class NewEventDiscussionScreen extends StatelessWidget {
   NewEventDiscussionScreen({Key? key}) : super(key: key);
   NewEventDiscussionProvider provider = NewEventDiscussionProvider();
   TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return GestureDetector(
      onTap: (){
        hideKeyboard(context);
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: ColorConstants.colorWhite,
        appBar: AppBar(
          backgroundColor: ColorConstants.colorWhite,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: Row(
            children: [
              ClipRRect(
                borderRadius:
                scaler.getBorderRadiusCircular(100),
                child:  Container(
                  height: scaler.getHeight(4.0),
                  width: scaler.getWidth(10),
               child:  ImageView(
                  path: provider.eventDetail.photoUrlEvent,
                  fit: BoxFit.cover,
                  height: scaler.getHeight(4.0),
                  width: scaler.getWidth(10),
                ),),
              ),
              SizedBox(width: scaler.getWidth(2.0)),
              Text(provider.eventDetail.eventName.toString()).mediumText(ColorConstants.colorBlack, scaler.getTextSize(11), TextAlign.center),
            ],
          ),
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                Navigator.of(context).pop();
              },
                child: Icon(Icons.arrow_forward_ios)),
            SizedBox(width: scaler.getWidth(2.0)),
          ],
        ),
        body: BaseView<NewEventDiscussionProvider>(
          onModelReady: (provider){
            this.provider = provider;
            provider.getEventDiscussion(context, true);
            // const milliSecTime = const Duration(milliseconds: 500);
            //
            // provider.clockTimer = Timer.periodic(milliSecTime, (Timer t) {
            //   provider.getEventDiscussion(context, false);
            // });
          },
          builder: (context, provider, _){
            return SafeArea(
              child: Padding(
                padding: scaler.getPaddingLTRB(3.5, 1.0, 3.0, 0.5),
                child: Column(
                  children: [
                 //  SizedBox(height: scaler.getHeight(1)),
                    provider.state == ViewState.Busy
                        ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                          SizedBox(height: scaler.getHeight(1)),
                          Text("loading_discussion".tr()).mediumText(
                              ColorConstants.primaryColor,
                              scaler.getTextSize(10),
                              TextAlign.left),
                        ],
                      ),
                    )
                      //  : eventMessageList(scaler, provider),
                   : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SwipeTo(
                              child: ChatBubble(
                                clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(top: 20),
                                backGroundColor: ColorConstants.primaryColor,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(provider.eventDiscussion!.adminDisplayName).boldText(Colors.limeAccent, scaler.getTextSize(10.0), TextAlign.left),
                                      Text(
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
                                              " sed do eiusmod tempor incididunt ut labore et dolore magna aliqua").regularText(ColorConstants.colorWhite, scaler.getTextSize(10), TextAlign.left, isHeight: true),
                                    ],
                                  ),
                                  ),
                                ),
                              onRightSwipe: () {
                                provider.isRightSwipe = true;
                                provider.updateSwipe(true);
                              },
                            ),
                            // SwipeTo(
                            //   child: ChatBubble(
                            //     clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
                            //     backGroundColor: ColorConstants.colorWhite,
                            //     margin: EdgeInsets.only(top: 20),
                            //     child: Container(
                            //       constraints: BoxConstraints(
                            //         maxWidth: MediaQuery.of(context).size.width * 0.7,
                            //       ),
                            //       child:  Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           Text("Danny Bill").boldText(ColorConstants.colorRed, scaler.getTextSize(10.0), TextAlign.left),
                            //           Text(
                            //               "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat").regularText(ColorConstants.colorBlack, scaler.getTextSize(10), TextAlign.left, isHeight: true),
                            //         ],
                            //       ),
                            //
                            //     ),
                            //   ),
                            //   onRightSwipe: () {
                            //    provider.isRightSwipe = true;
                            //    provider.updateSwipe(true);
                            //   },
                            // ),
                            // SwipeTo(
                            //   child: ChatBubble(
                            //     elevation: 0.0,
                            //     clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
                            //     alignment: Alignment.topRight,
                            //     margin: EdgeInsets.only(top: 20),
                            //     backGroundColor: ColorConstants.primaryColor.withOpacity(0.2),
                            //     child: Container(
                            //       constraints: BoxConstraints(
                            //         maxWidth: MediaQuery.of(context).size.width * 0.7,
                            //       ),
                            //       child: Column(
                            //         children: [
                            //           sendReplySwipe(),
                            //           Text(
                            //               "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat").regularText(ColorConstants.colorBlack, scaler.getTextSize(10), TextAlign.left, isHeight: true),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // SwipeTo(
                            //   child: ChatBubble(
                            //     clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
                            //     backGroundColor: ColorConstants.colorWhite,
                            //     margin: EdgeInsets.only(top: 20),
                            //     child: Container(
                            //       constraints: BoxConstraints(
                            //         maxWidth: MediaQuery.of(context).size.width * 0.7,
                            //       ),
                            //       child: Column(
                            //         children: [
                            //           sendReplySwipe(),
                            //           Text(
                            //               "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat").regularText(ColorConstants.colorBlack, scaler.getTextSize(10), TextAlign.left, isHeight: true),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: provider.isRightSwipe == true ? CrossAxisAlignment.end : CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                             provider.isRightSwipe == true ? replySwipe() : Container(),
                              writeSomethingTextField(context, scaler, provider),
                            ],
                          ),
                        ),
                        SizedBox(width: scaler.getWidth(1.5)),
                        GestureDetector(
                          onTap: () async {
                            var value =
                                await provider.permissionCheck();
                            if (value) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CustomDialog(
                                        cameraClick: () {
                                          provider.getImage(
                                              context, 1);
                                        },
                                        galleryClick: () {
                                          provider.getImage(
                                              context, 2);
                                        },
                                        cancelClick: () {
                                          Navigator.of(context).pop();
                                        },
                                      ));
                            }
                          },
                            child: Icon(Icons.camera_alt_outlined, color: ColorConstants.primaryColor, size: 28))
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        )
      ),
    );
  }

   Widget writeSomethingTextField(BuildContext context, ScreenScaler scaler,
       NewEventDiscussionProvider provider) {
     return TextFormField(
       textCapitalization: TextCapitalization.sentences,
       controller: messageController,
       style: ViewDecoration.textFieldStyle(
           scaler.getTextSize(10), ColorConstants.colorBlack),
       decoration: ViewDecoration.inputDecorationWithCurve(
           "write_something".tr(), scaler, ColorConstants.primaryColor),
       onFieldSubmitted: (data) {
         messageController.text.isEmpty
             ? Container()
             : provider.postDiscussionMessage(context, TEXT_MESSAGE, messageController.text, messageController);
       },
       textInputAction: TextInputAction.send,
       keyboardType: TextInputType.text,
     );
   }

   static final inputTopRadius = Radius.circular(12);
   static final inputBottomRadius = Radius.circular(24);

   Widget sendReplySwipe() => Container(
     padding: EdgeInsets.all(8),
     decoration: BoxDecoration(
       color: Colors.grey.withOpacity(0.1),
       borderRadius: BorderRadius.all(inputTopRadius),
     ),
     child: ReplyMessageWidget(
      // message: widget.replyMessage,
       onCancelReply: (){},
       showCloseIcon: false,
     ),
   );

   Widget replySwipe() => Container(
     padding: EdgeInsets.all(8),
     decoration: BoxDecoration(
       color: Colors.grey.withOpacity(0.1),
       borderRadius: BorderRadius.all(inputTopRadius),
       // borderRadius: BorderRadius.only(
       //   topLeft: inputTopRadius,
       //   topRight: inputTopRadius,
       // ),
     ),
     child: ReplyMessageWidget(
       // message: widget.replyMessage,
       onCancelReply: (){
         provider.isRightSwipe = false;
         provider.updateSwipe(true);
       },
       showCloseIcon: true,
     ),
   );
}
