import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/chat_screen_provider.dart';
import 'package:meetmeyou_app/view/add_event/event_invite_friends_screen/eventInviteFriendsScreen.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/home/event_discussion_screen/new_event_discussion_screen.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorConstants.colorNewGray,
        // automaticallyImplyLeading: false,
        // leading: Center(child: Row(
        //   children: [
        //     SizedBox(width: scaler.getWidth(3.0)),
        //     Text("edit".tr()).mediumText(Colors.blue, scaler.getTextSize(10.5), TextAlign.center)
        //   ],
        // )),
        title: Text("chats".tr()).mediumText(ColorConstants.colorBlack, scaler.getTextSize(10.5), TextAlign.center),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, RoutesConstants.eventInviteFriendsScreen, arguments: EventInviteFriendsScreen(fromDiscussion: false, discussionId: "", fromChatDiscussion: true));
            },
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.blue,),
                SizedBox(width: scaler.getWidth(3.0)),
              ],
            ),
          )
        ],
      ),
      body: BaseView<ChatScreenProvider>(
        onModelReady: (provider){
          provider.getUserDiscussion(context);
        },
        builder: (context, provider, _){
          return provider.state == ViewState.Busy ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator()),
              SizedBox(height: scaler.getHeight(1)),
              Text("loading_chats".tr()).mediumText(
                  ColorConstants.primaryColor,
                  scaler.getTextSize(10),
                  TextAlign.left),
            ],
          ) : (provider.userDiscussions.length == 0 || provider.userDiscussions.isEmpty) ? Center(
          child: Text("no_chats_found".tr())
              .mediumText(
          ColorConstants.primaryColor,
          scaler.getTextSize(10),
          TextAlign.left),
          ): usersList(context, scaler, provider);
        },
      )
    );
  }

  Widget usersList(BuildContext context, ScreenScaler scaler, ChatScreenProvider provider){
    return ListView.builder(
        itemCount: provider.userDiscussions.length,
        itemBuilder: (context, index){
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
          Navigator.pushNamed(context, RoutesConstants.newEventDiscussionScreen, arguments: NewEventDiscussionScreen(fromContactOrGroup: false, fromChatScreen: true, chatDid: provider.userDiscussions[index].did)).then((value) {
            provider.getUserDiscussion(context);
          });
        },
        child: SwipeTo(
          onLeftSwipe: (){
            DialogHelper.showDialogWithTwoButtons(
                context,
                "leave_discussion".tr(),
                "sure_to_leave_discussion".tr(),
                positiveButtonLabel: "leave".tr(),
                positiveButtonPress: () {
                  Navigator.of(context).pop();
                  provider
                      .leaveDiscussion(context, provider.userDiscussions[index].did).then((value) {
                    Navigator.of(context).pop();
                  });
                });
          },
          child: Column(
            children: <Widget>[
              Container(
                padding: scaler.getPaddingAll(8.0),
                color: provider.userDiscussions[index].unread == true ? ColorConstants.primaryColor.withOpacity(0.2) : ColorConstants.colorWhite,
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: scaler.getBorderRadiusCircular(100.0),
                      child: Container(
                        height: scaler.getHeight(5.0),
                        width: scaler.getWidth(12.0),
                        color: ColorConstants.primaryColor,
                        child: ImageView(
                          path: provider.userDiscussions[index].photoURL,  height: scaler.getHeight(5.0),
                          width: scaler.getWidth(12.0), fit: BoxFit.cover
                        ),
                      ),
                    ),
                    SizedBox(width : scaler.getWidth(1.0)),
                    Expanded(
                      child: Padding(
                        padding: scaler.getPaddingAll(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                               Expanded(
                                 child:  Text(
                                     provider.userDiscussions[index].title).boldText(ColorConstants.colorBlack, scaler.getTextSize(10.5), TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis),
                               ),
                                SizedBox(width : scaler.getWidth(1.0)),
                                // Text(
                                //   "Yesterday").regularText(ColorConstants.colorGray, scaler.getTextSize(10.0), TextAlign.left),
                              ],
                            ),
                            // Padding(
                            //   padding: scaler.getPaddingLTRB(0.0, 0.4, 0.0, 0.0),
                            //   child: Text(
                            //     "Hiiiiiii, i am using meetMeYou ").regularText(ColorConstants.colorGray, scaler.getTextSize(10.0), TextAlign.left),
                            // )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        ),
      );
    });
  }
}
