import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_used.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/discussion.dart';
import 'package:meetmeyou_app/models/discussion_message.dart';
import 'package:meetmeyou_app/provider/new_event_discussion_provider.dart';
import 'package:meetmeyou_app/view/add_event/event_invite_friends_screen/eventInviteFriendsScreen.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/home/view_image_screen/view_image_screen.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/imagePickerDialog.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/widgets/reply_image_widget.dart';
import 'package:meetmeyou_app/widgets/reply_message_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:video_player/video_player.dart';

class NewEventDiscussionScreen extends StatelessWidget {
  NewEventDiscussionScreen({Key? key, required this.fromContactOrGroup, required this.fromChatScreen, required this.chatDid})
      : super(key: key);
  bool fromContactOrGroup;
  bool fromChatScreen;
  String chatDid;
  NewEventDiscussionProvider provider = NewEventDiscussionProvider();
  TextEditingController messageController = TextEditingController();
  var messageFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool jump = true;
  final titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return BaseView<NewEventDiscussionProvider>(
      onModelReady: (provider) {
        this.provider = provider;
        if(fromChatScreen == true){
          provider.getDiscussion(context, chatDid, fromChatScreen: fromChatScreen).then((value) {
            jump = false;
          });
         // const milliSecTime = const Duration(milliseconds: 500);

          // provider.clockTimer = Timer.periodic(milliSecTime, (Timer t) {
          //   jump = false;
          //   provider.getDiscussion(context, chatDid, jump: false);
          // });
        } else{
          fromContactOrGroup == true
              ? provider.startContactDiscussion(context).then((value) {
            jump = false;
          })
              : provider.getEventDiscussion(context, true).then((value) {
                jump = false;
          });

         // provider.getMessagesList();

          // const milliSecTime = const Duration(milliseconds: 500);

          // provider.clockTimer = Timer.periodic(milliSecTime, (Timer t) {
          //   jump = false;
          //   fromContactOrGroup == true
          //       ? provider.getDiscussion(context, provider.discussion!.did, jump: false)
          //       : provider.getEventDiscussion(context, false, jump: false);
          // });
        }
      },
      builder: (context, provider, _) {
        return  (provider.state == ViewState.Busy ||
                provider.startDiscussion == true)
            ? Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                    SizedBox(height: scaler.getHeight(1)),
                    Text("loading_discussion".tr()).mediumText(
                        ColorConstants.primaryColor,
                        scaler.getTextSize(11),
                        TextAlign.left),
                  ],
                ),
              )
            : GestureDetector(
                onTap: () {
                  hideKeyboard(context);
                },
                child: Scaffold(
                  key: _scaffoldKey,
                    resizeToAvoidBottomInset: true,
                    backgroundColor: ColorConstants.colorWhite,
                    appBar: AppBar(
                      backgroundColor: ColorConstants.colorWhite,
                      centerTitle: false,
                      title: Row(
                        children: [
                          GestureDetector(
                            onTap: (provider.eventDiscussion?.type == DISCUSSION_TYPE_GROUP && provider.eventDiscussion?.isOrganiser == true) ? () async {
                              if (await Permission.storage.request().isGranted) {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialog(
                                          cameraClick: () {
                                            provider.changeGroupImage(
                                                _scaffoldKey.currentContext!, 1, fromChatScreen, chatDid);
                                          },
                                          galleryClick: () {
                                            provider.changeGroupImage(
                                                _scaffoldKey.currentContext!, 2, fromChatScreen, chatDid).catchError((e){
                                              CommonWidgets.errorDialog(context, "enable_storage_permission".tr());
                                            });
                                          },
                                          cancelClick: () {
                                            Navigator.of(context).pop();
                                          },
                                        ));
                              } else if(await Permission.storage.request().isDenied){
                                Map<Permission, PermissionStatus> statuses = await [
                                  Permission.storage,
                                ].request();
                              } else if(await Permission.storage.request().isPermanentlyDenied){
                                CommonWidgets.errorDialog(context, "enable_storage_permission".tr());
                              }
                              // var value =
                              // await provider.permissionCheck();
                              // if (value) {
                              //   showDialog(
                              //       barrierDismissible: false,
                              //       context: context,
                              //       builder: (BuildContext context) =>
                              //           CustomDialog(
                              //             cameraClick: () {
                              //               provider.changeGroupImage(
                              //                   _scaffoldKey.currentContext!, 1, fromChatScreen, chatDid);
                              //             },
                              //             galleryClick: () {
                              //               provider.changeGroupImage(
                              //                   _scaffoldKey.currentContext!, 2, fromChatScreen, chatDid);
                              //             },
                              //             cancelClick: () {
                              //               Navigator.of(context).pop();
                              //             },
                              //           ));
                              // }
                            } : (){},
                            child: ClipRRect(
                              borderRadius: scaler.getBorderRadiusCircular(100),
                              child: Container(
                                height: scaler.getHeight(5.0),
                                width: scaler.getWidth(11),
                                child: ImageView(
                                  path: fromContactOrGroup == true
                                     // ? provider.discussionDetail.photoUrl
                                      ? provider.discussion!.photoURL
                                      : (provider.eventDiscussion?.photoURL == null || provider.eventDiscussion?.photoURL == "") ? provider.eventDetail.photoUrlEvent : provider.eventDiscussion!.photoURL,
                                  fit: BoxFit.cover,
                                  height: scaler.getHeight(5.0),
                                  width: scaler.getWidth(11),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: scaler.getWidth(2.0)),
                         GestureDetector(
                           behavior: HitTestBehavior.translucent,
                           onTap: (){
                              provider.calendarDetail.fromAnotherPage = true;
                              provider.eventDetail.eid = provider.eventDiscussion?.did;
                              titleController.text = fromContactOrGroup == true
                                  ? provider.discussion!.title.toString()
                                  : provider.eventDiscussion!.title.toString();

                           //  (fromChatScreen == true ? Navigator.pushNamed(context, RoutesConstants.eventDetailScreen) :  Navigator.of(context).pop())
                             provider.eventDiscussion?.type == DISCUSSION_TYPE_EVENT ?  (fromChatScreen == true ? Navigator.pushNamed(context, RoutesConstants.eventDetailScreen) :  Navigator.of(context).pop()) : ((provider.eventDiscussion?.type == DISCUSSION_TYPE_GROUP && provider.eventDiscussion?.isOrganiser == true) ? alertForChangeGroupTitle(context, scaler) : ((provider.eventDiscussion?.type == DISCUSSION_TYPE_GROUP && provider.eventDiscussion?.isOrganiser == false) ? Navigator.pushNamed(context, RoutesConstants.eventAttendingScreen) : Container()));
                           },
                           child: Column(
                             children: [
                               Container(
                                 width: scaler.getWidth(45),
                                 child:  Text(fromContactOrGroup == true
                                     ? (provider.discussion?.title == "" || provider.discussion?.title == null)  ?  provider.discussionDetail.title.toString() : provider.discussion!.title
                                     : (provider.eventDiscussion?.title == null || provider.eventDiscussion?.title == "") ? provider.eventDetail.eventName.toString() : provider.eventDiscussion!.title)
                                     .mediumText(ColorConstants.colorBlack,
                                     scaler.getTextSize(11.5), TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis),
                               ),
                               SizedBox(height: scaler.getHeight(0.2)),
                               Container(
                                 width: scaler.getWidth(45),
                                 child:  Text(provider.eventDiscussion?.type == DISCUSSION_TYPE_EVENT
                                     ? "click_to_go_to_event".tr()
                                     : (provider.eventDiscussion?.type == DISCUSSION_TYPE_PRIVATE ? "private_discussion".tr() : (provider.eventDiscussion?.isOrganiser == true ? "group_discussion_organiser".tr() : "group_discussion".tr())))
                                     .regularText(ColorConstants.colorGray,
                                     scaler.getTextSize(9.8), TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis),
                               ),
                             ],
                           ),
                         )
                        ],
                      ),
                      actions: [
                   //     ((fromContactOrGroup == true || fromChatScreen == true) && ((provider.eventDiscussion?.participants.length ?? 0) > 2 && provider.eventDiscussion?.isOrganiser == true) && provider.eventDiscussion?.type != DISCUSSION_TYPE_EVENT) || provider.eventDiscussion?.type == DISCUSSION_TYPE_PRIVATE
                        (provider.eventDiscussion?.type == DISCUSSION_TYPE_PRIVATE || (provider.eventDiscussion?.type == DISCUSSION_TYPE_GROUP && provider.eventDiscussion?.isOrganiser == true))
                            ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                            onTap: () {
                          provider.eventDetail.contactCIDs = provider.eventDetail.attendingProfileKeys!;
                          Navigator.pushNamed(context, RoutesConstants.eventInviteFriendsScreen, arguments: EventInviteFriendsScreen(fromDiscussion: true, discussionId: fromChatScreen == true ? chatDid : (fromContactOrGroup == true ? provider.discussion!.did : provider.eventDetail.eid), fromChatDiscussion: false)).then((value) {
                           // fromChatScreen == true ?  provider.getDiscussion(context, chatDid, fromChatScreen: fromChatScreen) : provider.startContactDiscussion(context);
                            //here we set fromchatscreen to true to load data on back
                            provider.getDiscussion(context, fromChatScreen == true ? chatDid : (fromContactOrGroup == true ? provider.discussion!.did : provider.eventDetail.eid.toString()), fromChatScreen: true);
                          });
                            },
                        child: Icon(Icons.people))
                            : GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  DialogHelper.showDialogWithTwoButtons(
                                      context,
                                      "leave_discussion".tr(),
                                      "sure_to_leave_discussion".tr(),
                                      positiveButtonLabel: "leave".tr(),
                                      positiveButtonPress: () async {
                                  await provider.leaveDiscussion(context, fromChatScreen, chatDid)
                                        .then((value) {
                                    Future.delayed(Duration(milliseconds: 200), () {
                                      Navigator.of(context).pop();
                                    });
                                    });
                                  });
                                },
                                child: Icon(Icons.logout)),
                        SizedBox(width: scaler.getWidth(2.0)),
                      ],
                    ),
                    body: SafeArea(
                      child: Padding(
                        padding: scaler.getPaddingLTRB(3.5, 1.0, 3.0, 0.5),
                        child: Column(
                          children: [
                            Expanded(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (scrollNotification) {

                                  if (provider.scrollController.position
                                          .userScrollDirection ==
                                      ScrollDirection.reverse) {
                                    provider.isJump = false;
                                  } else if (provider.scrollController.position
                                          .userScrollDirection ==
                                      ScrollDirection.forward) {
                                    provider.isJump = false;
                                  } else if (provider.scrollController.position
                                          .userScrollDirection ==
                                      ScrollDirection.idle) {
                                    provider.isJump = false;
                                  }
                                  return true;
                                },
                                child: messageListView(scaler),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: provider.isRightSwipe == true
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      provider.isRightSwipe == true
                                          ? replySwipe(context, provider.replyMessage)
                                          : Container(),
                                      writeSomethingTextField(
                                          context, scaler, provider),
                                    ],
                                  ),
                                ),
                                SizedBox(width: scaler.getWidth(1.5)),
                                GestureDetector(
                                    onTap: () async {
                                      if (await Permission.storage.request().isGranted) {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CustomDialog(
                                                  cameraClick: () {
                                                    provider.getImage(
                                                        _scaffoldKey.currentContext!, 1, fromContactOrGroup, fromChatScreen, chatDid);
                                                  },
                                                  galleryClick: () {
                                                    provider.getImage(
                                                        _scaffoldKey.currentContext!, 2, fromContactOrGroup, fromChatScreen, chatDid).catchError((e){
                                                      CommonWidgets.errorDialog(_scaffoldKey.currentContext!, "enable_storage_permission".tr());
                                                    });
                                                  },
                                                  videoClick: (){
                                                    provider.getImage(
                                                        _scaffoldKey.currentContext!, 3, fromContactOrGroup, fromChatScreen, chatDid).catchError((e){
                                                      CommonWidgets.errorDialog(_scaffoldKey.currentContext!, "enable_storage_permission".tr());
                                                    });
                                                  },
                                                  videoSelection: true,
                                                  cancelClick: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ));
                                      } else if(await Permission.storage.request().isDenied){
                                        Map<Permission, PermissionStatus> statuses = await [
                                          Permission.storage,
                                        ].request();
                                      } else if(await Permission.storage.request().isPermanentlyDenied){
                                        CommonWidgets.errorDialog(context, "enable_storage_permission".tr());
                                      }
                                      // var value =
                                      //     await provider.permissionCheck();
                                      // if (value) {
                                      //   showDialog(
                                      //       barrierDismissible: false,
                                      //       context: context,
                                      //       builder: (BuildContext context) =>
                                      //           CustomDialog(
                                      //             cameraClick: () {
                                      //               provider.getImage(
                                      //                   _scaffoldKey.currentContext!, 1, fromContactOrGroup, fromChatScreen, chatDid);
                                      //             },
                                      //             galleryClick: () {
                                      //               provider.getImage(
                                      //                   _scaffoldKey.currentContext!, 2, fromContactOrGroup, fromChatScreen, chatDid);
                                      //             },
                                      //             cancelClick: () {
                                      //               Navigator.of(context).pop();
                                      //             },
                                      //           ));
                                      // }
                                    },
                                    child: Icon(Icons.camera_alt_outlined,
                                        color: ColorConstants.primaryColor,
                                        size: 28))
                              ],
                            )
                          ],
                        ),
                      ),
                    )));
      },
    );
  }

  Widget writeSomethingTextField(BuildContext context, ScreenScaler scaler,
      NewEventDiscussionProvider provider) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: messageController,
      focusNode: messageFocusNode,
      style: ViewDecoration.textFieldStyle(
          scaler.getTextSize(11), ColorConstants.colorBlack),
      decoration: ViewDecoration.inputDecorationWithCurve(
          "write_something".tr(), scaler, ColorConstants.primaryColor),
      onFieldSubmitted: (data) {
        if(data.trim() != ""){
          messageController.text.isEmpty
              ? Container()
              : provider.postDiscussionMessage(context, TEXT_MESSAGE,
              data.trim(), messageController, fromContactOrGroup, fromChatScreen, chatDid,
              replyMid: provider.replyMid);
        } else{
          messageController.clear();
        }
      },
      textInputAction: TextInputAction.send,
      keyboardType: TextInputType.text,
    );
  }


  Widget messageListView(ScreenScaler scaler) {
    return ListView.builder(
        controller: provider.scrollController,
        shrinkWrap: true,
        itemCount:
        provider.eventDiscussionList.length,
        itemBuilder: (context, index) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.scrollController.hasClients) {
              jump == true ?
              provider.scrollController.jumpTo(provider.scrollController.position.maxScrollExtent)
                  : provider.scrollListener();
            }
          });
          provider.userName = provider.eventDiscussionList[index].contactUid == provider.auth.currentUser?.uid ? "you".tr() : provider.eventDiscussionList[index].contactDisplayName;
          String currentHeader = provider.eventDiscussionList[index].createdTimeStamp.toLocal().toString().substring(0, 11);
          String header = index == 0
              ? provider.eventDiscussionList[index].createdTimeStamp.toLocal().toString().substring(0, 11)
              : provider.eventDiscussionList[index-1].createdTimeStamp.toLocal().toString().substring(0, 11);
          return dateHeader(context, scaler, index, header, currentHeader);
        });
  }

  dateHeader(BuildContext context,  ScreenScaler scaler, int index, String header, String cHeader) {
    if (index == 0 ? true : (header != cHeader)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomShape(
            child: Center(
                child:Text(DateTimeHelper.chatHeaderDateFormat(provider.eventDiscussionList[index].createdTimeStamp.toLocal(),
                    provider.eventDiscussionList[index].createdTimeStamp.toLocal().toString().substring(0, 4) == DateTime.now().toLocal().toString().substring(0, 4) ? true : false ))
                    .semiBoldText(
                    ColorConstants.colorBlackDown,
                    scaler.getTextSize(10.5),
                    TextAlign.center)),
            bgColor: ColorConstants.colorNewGray,
            radius: BorderRadius.all(
              Radius.circular(12),
            ),
            width: scaler.getWidth(provider.eventDiscussionList[index].createdTimeStamp.toLocal().toString().substring(0, 4) == DateTime.now().toLocal().toString().substring(0, 4) ? 21 : 25),
            height: scaler.getHeight(2.2),
          ),
          // SizedBox(height: scaler.getHeight(1.0)),
          chat(context, scaler, index)
        ],
      );
    } else {
      return chat(context, scaler, index);
    }
  }

  Widget chat(BuildContext context, ScreenScaler scaler, int index){
    return (provider.eventDiscussionList[index].contactUid) != provider.auth.currentUser!.uid
        ? Column(
      children: [
        SwipeTo(
          child: ChatBubble(
            clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
            backGroundColor:
            ColorConstants.colorWhite,
            margin: EdgeInsets.only(
                top: 20),
            child: Container(
              constraints:
              BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: (provider.eventDiscussionList[index].isReply == true && provider.eventDiscussionList[index].replyMid != "")
                  ? Column(
                crossAxisAlignment : CrossAxisAlignment.start,
                children: [
                  sendReplySwipe(provider.eventDiscussionList.any((element){
                    provider.replyMessageImageUrl = element.attachmentURL;
                    provider.replyMessageText = element.text;
                    return element.mid == provider.eventDiscussionList[index].replyMid;
                  }) ? provider.replyMessageText : ""),
                  SizedBox(height: scaler.getHeight(0.1)),
                  Row(
                    children: [
                      SizedBox(width: scaler.getWidth(0.5)),
                      Text(provider.eventDiscussionList[index].text).regularText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(11),
                          TextAlign.left,
                          isHeight: true),
                    ],
                  ),
                ],
              )
                  :
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(provider.eventDiscussionList[index].contactDisplayName).boldText(ColorConstants.colorRed, scaler.getTextSize(11.0), TextAlign.left),
                  (provider.eventDiscussionList[index].attachmentURL == "" || provider.eventDiscussionList[index].attachmentURL == null) ?
                  Text(provider.eventDiscussionList[index].text).regularText(ColorConstants.colorBlack, scaler.getTextSize(11), TextAlign.left, isHeight: true) :
                 ( provider.eventDiscussionList[index].type == PHOTO_MESSAGE ? InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, RoutesConstants.viewImageScreen, arguments: ViewImageData(imageUrl: provider.eventDiscussionList[index].attachmentURL));
                    },
                    child: ClipRRect(
                      borderRadius: scaler.getBorderRadiusCircular(7.5),
                      child: Container(
                        color: ColorConstants.primaryColor,
                        height: scaler.getHeight(30.0),
                        width: scaler.getWidth(70.0),
                        child: ImageView(path: provider.eventDiscussionList[index].attachmentURL, fit: BoxFit.cover,),
                      ),
                    ),
                  ) : InkWell(
                    onTap: (){
                    },
                    child: ClipRRect(
                      borderRadius: scaler.getBorderRadiusCircular(7.5),
                      child: Container(
                        color: ColorConstants.primaryColor,
                        height: scaler.getHeight(30.0),
                        width: scaler.getWidth(70.0),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
          onRightSwipe: () {
            provider.isRightSwipe = true;
            FocusScope.of(context).requestFocus(messageFocusNode);
            provider.replyMessage = provider.eventDiscussionList[index].text;
            provider.replyMid = provider.eventDiscussionList[index].mid;
            provider.imageUrl = provider.eventDiscussionList[index].attachmentURL;
            // provider.userName ="you".tr();
            provider.updateSwipe(true);
          },
        ),
        SizedBox(
            height:
            scaler.getHeight(0.5)),
      ],
    )
        : Column(
      children: [
        SwipeTo(
          child: ChatBubble(
            elevation : (provider.eventDiscussionList[index].isReply == true && provider.eventDiscussionList[index].replyMid != "") ? 0.0 : 2,
            clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 20),
            backGroundColor: (provider.eventDiscussionList[index].isReply == true && provider.eventDiscussionList[index].replyMid != "") ?
            ColorConstants.primaryColor.withOpacity(0.2) : ColorConstants.primaryColor,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7,),
              child: (provider.eventDiscussionList[index].isReply == true && provider.eventDiscussionList[index].replyMid != "")
                  ? Column(
                crossAxisAlignment : CrossAxisAlignment.start,
                children: [
                  sendReplySwipe(provider.eventDiscussionList.any((element){
                    provider.replyMessageText = element.text;
                    provider.replyMessageImageUrl = element.attachmentURL;
                    return element.mid == provider.eventDiscussionList[index].replyMid;
                  }) ? provider.replyMessageText: ""),
                  SizedBox(height: scaler.getHeight(0.1)),
                  Row(
                    children: [
                      SizedBox(width: scaler.getWidth(0.5)),
                      Text(provider.eventDiscussionList[index].text).regularText(
                          ColorConstants.colorBlack, scaler.getTextSize(11), TextAlign.left,
                          isHeight: true),
                    ],
                  ),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("you".tr()).boldText(
                  //     Colors
                  //         .limeAccent,
                  //     scaler.getTextSize(
                  //         10.0),
                  //     TextAlign
                  //         .left),
                  (provider.eventDiscussionList[index].attachmentURL == "" || provider.eventDiscussionList[index].attachmentURL == null) ?
                  Text(provider.eventDiscussionList[index].text)
                      .regularText(
                      ColorConstants.colorWhite, scaler.getTextSize(11), TextAlign.left, isHeight: true) :
                  (provider.eventDiscussionList[index].type == PHOTO_MESSAGE ? InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, RoutesConstants.viewImageScreen, arguments: ViewImageData(imageUrl: provider.eventDiscussionList[index].attachmentURL));
                    },
                    child: ClipRRect(
                      borderRadius: scaler.getBorderRadiusCircular(7.5),
                      child: Container(
                        color: ColorConstants.primaryColor,
                        height: scaler.getHeight(30.0),
                        width: scaler.getWidth(70.0),
                        child: ImageView(path: provider.eventDiscussionList[index].attachmentURL, fit: BoxFit.cover,),
                      ),
                    ),
                  ) : InkWell(
                    onTap: (){},
                    child: ClipRRect(
                      borderRadius: scaler.getBorderRadiusCircular(7.5),
                      child: Container(
                        color: ColorConstants.primaryColor,
                        height: scaler.getHeight(30.0),
                        width: scaler.getWidth(70.0),
                      //  child: VideoPlayer(provider.eventDiscussionList[index].attachmentURL),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
          onRightSwipe: () {
            provider.isRightSwipe = true;
            FocusScope.of(context).requestFocus(messageFocusNode);
            provider.replyMessage = provider.eventDiscussionList[index].text;
            provider.replyMid = provider.eventDiscussionList[index].mid;
            provider.imageUrl = provider.eventDiscussionList[index].attachmentURL;
            // provider.userName = "you".tr();
            provider.updateSwipe(true);
          },
        ),
        SizedBox(height: scaler.getHeight(0.5)),
      ],
    );
  }

  static final inputTopRadius = Radius.circular(12);
  static final inputBottomRadius = Radius.circular(24);

  Widget sendReplySwipe(String message) => Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.all(inputTopRadius),
        ),
        child: message == "" ? ReplyImageWidget(
          message: message,
          userName: provider.userName,
          isUserName: true,
          imageUrl: provider.replyMessageImageUrl,
          onCancelReply: () {},
          showCloseIcon: false,
        )  : ReplyMessageWidget(
          message: message,
          userName: provider.userName,
          isUserName: true,
          imageUrl: provider.imageUrl,
          onCancelReply: () {},
          showCloseIcon: false,
        ),
      );

  Widget replySwipe(BuildContext context, String replyMessage) => Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.all(inputTopRadius),
          // borderRadius: BorderRadius.only(
          //   topLeft: inputTopRadius,
          //   topRight: inputTopRadius,
          // ),
        ),
        child: provider.imageUrl != "" ? ReplyImageWidget(
          message: replyMessage,
          userName: provider.userName,
          isUserName: false,
          imageUrl: provider.imageUrl,
          onCancelReply: () {
            provider.isRightSwipe = false;
            provider.imageUrl = "";
            hideKeyboard(context);
            provider.updateSwipe(true);
          },
          showCloseIcon: true,
        ) : ReplyMessageWidget(
          message: replyMessage,
          userName: provider.userName,
          isUserName: false,
          imageUrl: provider.imageUrl,
          onCancelReply: () {
            provider.isRightSwipe = false;
            provider.imageUrl = "";
            hideKeyboard(context);
            provider.updateSwipe(true);
          },
          showCloseIcon: true,
        ),
      );

  alertForChangeGroupTitle(BuildContext context, ScreenScaler scaler){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 50.0),
       //   insetPadding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 24.0),
          title: Text("Change Group Discussion title").semiBoldText(ColorConstants.colorBlack, 15.5, TextAlign.center),
          content: Form(
            key: _formKey,
              child: groupTitleTextField(scaler)),
          actions: [
          provider.titleAndPhoto == true ? Center(child: CircularProgressIndicator()) : GestureDetector(
              onTap: (){
                if(fromChatScreen == true){
                  provider.updateDiscussionTitle(context, chatDid, fromChatScreen, title: titleController.text);
                } else{
                  provider.updateDiscussionTitle(context, provider.discussion!.did, fromChatScreen, title: titleController.text);
                }
              },
                child: CommonWidgets.commonBtn(scaler, context, "Update", ColorConstants.primaryColor, ColorConstants.colorWhite))
          ],
        );
      }
      );
  }

  Widget groupTitleTextField(ScreenScaler scaler){
    return  TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: titleController,
      style: ViewDecoration.textFieldStyle(
          scaler.getTextSize(10.5), ColorConstants.colorBlack),
      decoration: ViewDecoration.inputDecorationWithCurve(
          "Cody", scaler, ColorConstants.primaryColor),
      onFieldSubmitted: (data) {
        // FocusScope.of(context).requestFocus(nodes[1]);
      },
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "group_name_required".tr();
        }
        {
          return null;
        }
      },
    );
  }
}
