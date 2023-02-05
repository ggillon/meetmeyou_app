import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/discussion.dart';
import 'package:meetmeyou_app/provider/chat_screen_provider.dart';
import 'package:meetmeyou_app/view/add_event/event_invite_friends_screen/eventInviteFriendsScreen.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/home/event_discussion_screen/new_event_discussion_screen.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:swipe_to/swipe_to.dart';

class ChatsScreen extends StatelessWidget {
   ChatsScreen({Key? key}) : super(key: key);

  final searchBarController = TextEditingController();
  ChatScreenProvider provider = ChatScreenProvider();
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
        title: Text("chats".tr()).mediumText(ColorConstants.colorBlack, scaler.getTextSize(11.5), TextAlign.center),
        actions: [
          GestureDetector(
            onTap: (){
              provider.eventDetail.contactCIDs.clear();
              Navigator.pushNamed(context, RoutesConstants.eventInviteFriendsScreen, arguments: EventInviteFriendsScreen(fromDiscussion: false, discussionId: "", fromChatDiscussion: true)).then((value) {
               provider.eventDetail.contactCIDs.clear();
               provider.eventDetail.groupIndexList.clear();
               provider.getUserDiscussion(context);
              });
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
          this.provider = provider;
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
                  scaler.getTextSize(11),
                  TextAlign.left),
            ],
          ) : (provider.userDiscussions.length == 0 || provider.userDiscussions.isEmpty) ? Center(
          child: Text("no_chats_found".tr())
              .mediumText(
          ColorConstants.primaryColor,
          scaler.getTextSize(11),
          TextAlign.left),
          ): (provider.userDiscussions.length >= 10) ? Column(
            children: [
              SizedBox(height: scaler.getHeight(1.0)),
              searchBar(scaler, provider),
              SizedBox(height: scaler.getHeight(1.0)),
              usersList(context, scaler, provider),
            ],
          ) : usersListWithoutSearchBar(context, scaler, provider);
        },
      )
    );
  }

  Widget searchBar(ScreenScaler scaler, ChatScreenProvider provider) {
    return Card(
      color: ColorConstants.colorWhite,
      elevation: 3.0,
      shadowColor: ColorConstants.colorWhite,
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(11)),
      child: TextFormField(
        controller: searchBarController,
        style: ViewDecoration.textFieldStyle(
            scaler.getTextSize(13), ColorConstants.colorBlack),
        decoration: ViewDecoration.inputDecorationForSearchBox(
            "search_field_name".tr(), scaler),
        onFieldSubmitted: (data) {
          // FocusScope.of(context).requestFocus(nodes[1]);
        },
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.name,
        onChanged: (value) {
          provider.updateSearchValue(true);
        },
      ),
    );
  }


   Widget usersListWithoutSearchBar(BuildContext context, ScreenScaler scaler, ChatScreenProvider provider){
     return ListView.builder(
         itemCount: provider.userDiscussions.length,
         shrinkWrap: true,
         itemBuilder: (context, index){
           return usersListCard(context, scaler, provider, index);
         });
   }

  Widget usersList(BuildContext context, ScreenScaler scaler, ChatScreenProvider provider){
    return Expanded(
      child: ListView.builder(
          itemCount: provider.userDiscussions.length,
          shrinkWrap: true,
          itemBuilder: (context, index){
            if (searchBarController.text.isEmpty) {
              return usersListCard(context, scaler, provider, index);
            } else if (provider.userDiscussions[index]
                .title
                .toLowerCase()
                .contains(searchBarController.text)) {
              return usersListCard(context, scaler, provider, index);
            } else {
              return Container();
            }
      }),
    );
  }

  Widget usersListCard(BuildContext context, ScreenScaler scaler, ChatScreenProvider provider, int index){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        Navigator.pushNamed(context, RoutesConstants.newEventDiscussionScreen, arguments: NewEventDiscussionScreen(fromContactOrGroup: false, fromChatScreen: true, chatDid: provider.userDiscussions[index].did)).then((value) async {
          await provider.getUserDiscussion(context);
          provider.updateSearchValue(true);
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
                      height: scaler.getHeight(6.0),
                      width: scaler.getWidth(13.0),
                      color: ColorConstants.primaryColor,
                      child: ImageView(
                          path: provider.userDiscussions[index].photoURL,  height: scaler.getHeight(6.0),
                          width: scaler.getWidth(13.0), fit: BoxFit.cover
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
                                    provider.userDiscussions[index].title).boldText(ColorConstants.colorBlack, scaler.getTextSize(11.8), TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                              SizedBox(width : scaler.getWidth(1.0)),
                              // Text(
                              //   "Yesterday").regularText(ColorConstants.colorGray, scaler.getTextSize(10.0), TextAlign.left),
                            ],
                          ),
                          Padding(
                            padding: scaler.getPaddingLTRB(0.0, 0.5, 0.0, 0.0),
                            child: Text(
                                provider.userDiscussions[index].type == DISCUSSION_TYPE_PRIVATE ? "private_discussion".tr() : (provider.userDiscussions[index].type == DISCUSSION_TYPE_EVENT) ? DISCUSSION_TYPE_EVENT : "group_discussion".tr()).regularText(ColorConstants.colorGray, scaler.getTextSize(11.0), TextAlign.left),
                          )
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
  }
}
