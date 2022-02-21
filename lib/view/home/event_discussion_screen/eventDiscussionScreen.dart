import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_used.dart';
import 'package:meetmeyou_app/provider/event_discussion_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class EventDiscussionScreen extends StatelessWidget {
  EventDiscussionScreen({Key? key}) : super(key: key);
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorConstants.colorWhite,
        body: BaseView<EventDiscussionProvider>(
          onModelReady: (provider) async {
            // provider.getEventChatMessages(context);
            // const milliSecTime = const Duration(milliseconds: 500);
            //
            // provider.clockTimer = Timer.periodic(milliSecTime, (Timer t) {
            //   //   provider.eventChatList.clear();
            //   provider.getEventChatMessages(context, load: false, jump: false);
            // });
          },
          builder: (context, provider, _) {
            return SafeArea(
              child: Padding(
                padding: scaler.getPaddingLTRB(3.5, 1.0, 3.0, 0.5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding:
                                  scaler.getPaddingLTRB(1.5, 0.0, 3.0, 0.0),
                              child: ImageView(
                                  path: ImageConstants.discussion_back_arrow),
                            )),
                        Text("discussion".tr()).boldText(
                            ColorConstants.colorBlack,
                            scaler.getTextSize(16),
                            TextAlign.left),
                      ],
                    ),
                    SizedBox(height: scaler.getHeight(2)),
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
                        : eventMessageList(scaler, provider),
                    writeSomethingTextField(context, scaler, provider)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget eventMessageList(
      ScreenScaler scaler, EventDiscussionProvider provider) {
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (provider.scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
           // print("HELLO reverse");
            provider.isJump = false;
          } else if (provider.scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
           // print("HELLO forward");
            provider.isJump = false;
          } else if (provider.scrollController.position.userScrollDirection ==
              ScrollDirection.idle) {
          //  print("HELLO idle");
            provider.isJump = false;
          }
          return true;
        },
        child: ListView.builder(
            controller: provider.scrollController,
            shrinkWrap: true,
            itemCount: provider.eventChatList.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment:
                    provider.userDetail.cid == provider.eventChatList[index].uid
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      provider.userDetail.cid == provider.eventChatList[index].uid ? Container() : discussionUserNameAndImage(scaler, provider, index),
                      provider.userDetail.cid == provider.eventChatList[index].uid ? Container() : SizedBox(width: scaler.getWidth(1.0)),
                      Container(
                     //   height: scaler.getHeight(44.6),
                        child: Expanded(
                          child: Column(
                       //   mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              provider.userDetail.cid == provider.eventChatList[index].uid ? Container() : Container(
                                width: scaler.getWidth(20),
                                child: Text(provider.eventChatList[index].displayName == null
                                    ? ""
                                    : "${provider.eventChatList[index].displayName} :")
                                    .semiBoldText(ColorConstants.colorBlack, scaler.getTextSize(7.7),
                                    TextAlign.left,
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                              Container(
                                width: scaler.getWidth(72),
                                padding: scaler.getPaddingLTRB(2.0, 0.8, 2.0, 0.8),
                                decoration: BoxDecoration(
                                    color: provider.userDetail.cid ==
                                            provider.eventChatList[index].uid
                                        ? ColorConstants.primaryColor
                                        : ColorConstants.colorLightGray,
                                    borderRadius:
                                        scaler.getBorderRadiusCircular(8.0)),
                                child: Text(provider.eventChatList[index].text)
                                    .regularText(
                                        provider.userDetail.cid ==
                                                provider.eventChatList[index].uid
                                            ? ColorConstants.colorWhite
                                            : ColorConstants.colorBlack,
                                        10.0,
                                        TextAlign.left,
                                        isHeight: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                     provider.userDetail.cid == provider.eventChatList[index].uid ? SizedBox(width: scaler.getWidth(1.5)) : Container(),
                      provider.userDetail.cid == provider.eventChatList[index].uid ? discussionUserNameAndImage(scaler, provider, index) : Container(),
                    ],
                  ),
                  SizedBox(height: scaler.getHeight(2))
                ],
              );
            }),
      ),
    );
  }

  Widget writeSomethingTextField(BuildContext context, ScreenScaler scaler,
      EventDiscussionProvider provider) {
    return Container(
      height: scaler.getHeight(4.5),
      alignment: Alignment.bottomCenter,
      child: TextFormField(
        onTap: () {
          // WidgetsBinding.instance!.addPostFrameCallback((_) {
          //   if (provider.scrollController.hasClients) {
          //     provider.scrollController
          //         .jumpTo(provider.scrollController.position.maxScrollExtent + 1000);
          //   }
          // });
        },
        textCapitalization: TextCapitalization.sentences,
        controller: messageController,
        style: ViewDecoration.textFieldStyle(
            scaler.getTextSize(10), ColorConstants.colorBlack),
        decoration: ViewDecoration.inputDecorationWithCurve(
            "write_something".tr(), scaler, ColorConstants.primaryColor),
        onFieldSubmitted: (data) {
          // FocusScope.of(context).requestFocus(nodes[1]);
          messageController.text.isEmpty
              ? Container()
              : provider.postEventChatMessage(
                  context, messageController.text, messageController);
        },
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget discussionUserNameAndImage(
      ScreenScaler scaler, EventDiscussionProvider provider, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        provider.userDetail.cid == provider.eventChatList[index].uid ? Container() : SizedBox(height: scaler.getHeight(0.5)),
        Container(
          width: scaler.getWidth(8.5),
          height: scaler.getWidth(8.5),
          child: ClipRRect(
            borderRadius: scaler.getBorderRadiusCircular(10.0),
            child: provider.eventChatList[index].photoURL == null
                ? Container(
                    width: scaler.getWidth(8.5),
                    height: scaler.getWidth(8.5),
                    color: ColorConstants.primaryColor,
                  )
                : ImageView(
                    path: provider.eventChatList[index].photoURL,
                    width: scaler.getWidth(8.5),
                    height: scaler.getWidth(8.5),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        SizedBox(height: scaler.getHeight(0.2)),
        provider.userDetail.cid != provider.eventChatList[index].uid ? Container() : Container(
          width: provider.userDetail.cid == provider.eventChatList[index].uid ? scaler.getWidth(10) : scaler.getWidth(11),
          child: Text(provider.eventChatList[index].displayName == null
                  ? ""
                  : provider.eventChatList[index].displayName)
              .semiBoldText(ColorConstants.colorBlack, scaler.getTextSize(7.7),
                  TextAlign.left,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
        )
      ],
    );
  }
}
