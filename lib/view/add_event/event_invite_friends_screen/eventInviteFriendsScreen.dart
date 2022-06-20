import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/provider/event_invite_friends_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/dashboard/dashboardPage.dart';
import 'package:meetmeyou_app/view/home/event_discussion_screen/new_event_discussion_screen.dart';
import 'package:meetmeyou_app/widgets/animated_toggle.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:share_plus/share_plus.dart';

class EventInviteFriendsScreen extends StatefulWidget {
  EventInviteFriendsScreen({Key? key, required this.fromDiscussion, this.discussionId, required this.fromChatDiscussion}) : super(key: key);
  bool fromDiscussion;
  bool fromChatDiscussion;
  String? discussionId;
  @override
  State<EventInviteFriendsScreen> createState() =>
      _EventInviteFriendsScreenState();
}

class _EventInviteFriendsScreenState extends State<EventInviteFriendsScreen> with TickerProviderStateMixin<EventInviteFriendsScreen>{
  final searchBarController = TextEditingController();
  EventInviteFriendsProvider provider = EventInviteFriendsProvider();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return WillPopScope(
      onWillPop:  widget.fromDiscussion == true ? () async{
        if (provider.eventDetail.contactCIDs.isNotEmpty ||
            provider.eventDetail.groupIndexList.isNotEmpty) {
          if(provider.eventDetail.contactCIDs.length == 1){
            if(provider.eventDetail.contactCIDs[0] == provider.auth.currentUser!.uid){
              DialogHelper.showDialogWithTwoButtons(context, "un_invite_users".tr(), "un_invite_all_users".tr(), positiveButtonPress: (){
                Navigator.of(context).pushNamedAndRemoveUntil(
                    RoutesConstants.dashboardPage, (route) => false, arguments: DashboardPage(isFromLogin: false));
              });
            }
          } else{
            Navigator.of(context).pop();
          }
        } else {
          DialogHelper.showDialogWithTwoButtons(context, "un_invite_users".tr(), "un_invite_all_users".tr());
        }
        return false;
      } : ()async{
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context, back: false, backIconClick: widget.fromDiscussion == true ? (){
          if (provider.eventDetail.contactCIDs.isNotEmpty ||
              provider.eventDetail.groupIndexList.isNotEmpty) {
            if(provider.eventDetail.contactCIDs.length == 1){
              if(provider.eventDetail.contactCIDs[0] == provider.auth.currentUser!.uid){
                DialogHelper.showDialogWithTwoButtons(context, "un_invite_users".tr(), "un_invite_all_users".tr(), positiveButtonPress: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      RoutesConstants.dashboardPage, (route) => false, arguments: DashboardPage(isFromLogin: false));
                });
              }
            } else{
              Navigator.of(context).pop();
            }
          } else {
            DialogHelper.showDialogWithTwoButtons(context, "un_invite_users".tr(), "un_invite_all_users".tr());
          }
        } : (){
          Navigator.pop(context);
        } ),
        body: BaseView<EventInviteFriendsProvider>(
          onModelReady: (provider) {
            this.provider = provider;
            provider.tabController = TabController(length: 2, vsync: this);
            provider.tabChangeEvent(context);
            provider.getConfirmedContactsList(context);
            provider.contactsKeys.addAll(provider.eventDetail.contactCIDs);
          },
          builder: (context, provider, _) {
            return SafeArea(
              child: Padding(
                padding: scaler.getPaddingLTRB(2.5, 0, 2.5, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  widget.fromChatDiscussion == true ?
                    Align(
                      alignment: Alignment.centerLeft,
                        child: Text("new_discussion".tr()).boldText(
                            ColorConstants.colorBlack,
                            scaler.getTextSize(17),
                            TextAlign.left)) : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("invite_friends".tr()).boldText(
                            ColorConstants.colorBlack,
                            scaler.getTextSize(17),
                            TextAlign.left),
                        //ImageView(path: ImageConstants.share_icon)
                      ],
                    ),
                    (widget.fromChatDiscussion == true || widget.fromDiscussion == true)
                        ? Container()
                        : SizedBox(height: scaler.getHeight(3.0)),
                    (widget.fromChatDiscussion == true || widget.fromDiscussion == true)
                        ? Container()
                        : TabBar(
                      controller: provider.tabController,
                      tabs: [
                        Text("mmy_contacts".tr()).boldText(
                            ColorConstants.colorBlack,
                            scaler.getTextSize(12),
                            TextAlign.left),
                        Text("phone_contacts".tr()).boldText(
                            ColorConstants.colorBlack,
                            scaler.getTextSize(12),
                            TextAlign.left)
                      ],
                      labelPadding: scaler.getPaddingLTRB(0.0, 0.0, 0.0, 1.0),
                    ),
                    SizedBox(height: scaler.getHeight(2.2)),
                    Expanded(
                      child: TabBarView(
                        controller: provider.tabController,
                          children: [
                       Column(
                         children: [
                           searchBar(scaler, provider),
                           SizedBox(height: scaler.getHeight(1.2)),
                           AnimatedToggle(
                             values: ['all'.tr(), 'groups'.tr()],
                             onToggleCallback: (value) {
                               provider.toggle = value;
                               if (value == 0) {
                                 provider.contactsKeys =
                                     provider.eventDetail.contactCIDs;
                                 provider.getConfirmedContactsList(context);
                               } else {
                                 provider.contactsKeys =
                                     provider.eventDetail.contactCIDs;
                                 provider.getGroupList(context);
                               }
                               provider.updateToggleValue(true);
                             },
                             buttonColor: ColorConstants.colorWhite,
                             backgroundColor: ColorConstants.colorMediumGray,
                           ),
                           SizedBox(height: scaler.getHeight(1)),
                           provider.toggle == 0
                               ? provider.state == ViewState.Busy
                               ? Expanded(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Center(child: CircularProgressIndicator()),
                                 SizedBox(height: scaler.getHeight(1)),
                                 Text("loading_contacts".tr()).mediumText(
                                     ColorConstants.primaryColor,
                                     scaler.getTextSize(11),
                                     TextAlign.left),
                               ],
                             ),
                           )
                               : provider.confirmContactList.length == 0
                               ? Expanded(
                             child: Center(
                               child: Text("sorry_no_contacts_found".tr())
                                   .mediumText(
                                   ColorConstants.primaryColor,
                                   scaler.getTextSize(11),
                                   TextAlign.left),
                             ),
                           )
                               : Expanded(
                             child: SingleChildScrollView(
                               child: Column(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 children: [
                                   SizedBox(height: scaler.getHeight(1)),
                                   provider.confirmContactList.length == 0
                                       ? Container()
                                       : confirmContactOrGroupList(
                                       scaler,
                                       provider.confirmContactList,
                                       provider)
                                 ],
                               ),
                             ),
                           )
                               : provider.state == ViewState.Busy
                               ? Expanded(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 Center(child: CircularProgressIndicator()),
                                 SizedBox(height: scaler.getHeight(1)),
                                 Text("loading_groups".tr()).mediumText(
                                     ColorConstants.primaryColor,
                                     scaler.getTextSize(11),
                                     TextAlign.left),
                               ],
                             ),
                           )
                               : provider.groupList.length == 0
                               ? Expanded(
                             child: Center(
                               child: Text("sorry_no_group_found".tr())
                                   .mediumText(
                                   ColorConstants.primaryColor,
                                   scaler.getTextSize(11),
                                   TextAlign.left),
                             ),
                           )
                               : Expanded(
                             child: SingleChildScrollView(
                               child: Column(
                                 crossAxisAlignment:
                                 CrossAxisAlignment.start,
                                 children: [
                                   SizedBox(height: scaler.getHeight(1)),
                                   confirmContactOrGroupList(scaler,
                                       provider.groupList, provider),
                                 ],
                               ),
                             ),
                           ),
                           SizedBox(height: scaler.getHeight(1)),
                           widget.fromChatDiscussion == true ?
                           provider.startGroup == true ? Center(
                             child: CircularProgressIndicator(),
                           ) : Container(
                             child: DialogHelper.btnWidget(
                                 scaler,
                                 context,
                                 "invite_to_group_discussion".tr(),
                                 ColorConstants.primaryColor, funOnTap: () {
                               if (provider.eventDetail.contactCIDs.isNotEmpty) {
                                 provider.startGroupDiscussion(context, provider.eventDetail.contactCIDs).then((value) {
                                   provider.eventDetail.contactCIDs.clear();
                                   // Navigator.of(context).pop();
                                 });
                               } else {
                                 DialogHelper.showMessage(
                                     context, "Please select contacts to Invite");
                               }
                             }),
                           ) : widget.fromDiscussion == true ?  Container(
                             child: DialogHelper.btnWidget(
                                 scaler,
                                 context,
                                 "update_discussion".tr(),
                                 ColorConstants.primaryColor, funOnTap: () {
                               if (provider.eventDetail.contactCIDs.isNotEmpty ||
                                   provider.eventDetail.groupIndexList.isNotEmpty) {
                                 if(provider.eventDetail.contactCIDs.length == 1){
                                   if(provider.eventDetail.contactCIDs[0] == provider.auth.currentUser!.uid){
                                     DialogHelper.showDialogWithTwoButtons(context, "un_invite_users".tr(), "un_invite_all_users".tr(), positiveButtonPress: (){
                                       Navigator.of(context).pushNamedAndRemoveUntil(
                                           RoutesConstants.dashboardPage, (route) => false, arguments: DashboardPage(isFromLogin: false));
                                     });
                                   }
                                 } else{
                                   Navigator.of(context).pop();
                                 }
                               } else {
                                 DialogHelper.showDialogWithTwoButtons(context, "un_invite_users".tr(), "un_invite_all_users".tr());
                               }
                             }),
                           ) : Container(
                             child: DialogHelper.btnWidget(
                                 scaler,
                                 context,
                                 "invite_friends".tr(),
                                 ColorConstants.primaryColor, funOnTap: () {
                               if (provider.eventDetail.contactCIDs.isNotEmpty ||
                                   provider.eventDetail.groupIndexList.isNotEmpty) {
                                 Navigator.of(context).pop();
                               } else {
                                 DialogHelper.showMessage(
                                     context, "Please select contacts to Invite");
                               }
                             }),
                           ),
                           SizedBox(height: scaler.getHeight(1)),
                         ],
                       ),
                       Column(
                         children: [
                           eventShareLinkRow(scaler)
                         ],
                       )
                      ]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget searchBar(ScreenScaler scaler, EventInviteFriendsProvider provider) {
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

  Widget confirmContactOrGroupList(ScreenScaler scaler, List<Contact> cList,
      EventInviteFriendsProvider provider) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: cList.length,
        itemBuilder: (context, index) {
          String currentHeader =
              cList[index].displayName.capitalize().substring(0, 1);
          String header = index == 0
              ? cList[index].displayName.capitalize().substring(0, 1)
              : cList[index - 1].displayName.capitalize().substring(0, 1);
          if (searchBarController.text.isEmpty) {
            return aToZHeader(
                context, currentHeader, header, index, scaler, cList, provider);
          } else if (cList[index]
              .displayName
              .toLowerCase()
              .contains(searchBarController.text)) {
            return widget.fromChatDiscussion == true ? createGroupDiscussion(context, scaler, cList, index, provider) : (widget.fromDiscussion == true ? addRemoveUserToDiscussionCard(context, scaler, cList, index, provider) : inviteContactProfileCard(context, scaler, cList, index, provider));

          } else {
            return Container();
          }
        });
  }

  aToZHeader(BuildContext context, String cHeader, String header, int index,
      scaler, List<Contact> cList, EventInviteFriendsProvider provider) {
    if (index == 0 ? true : (header != cHeader)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(cHeader).semiBoldText(ColorConstants.colorBlack,
                scaler.getTextSize(10.8), TextAlign.left),
          ),
          widget.fromChatDiscussion == true ? createGroupDiscussion(context, scaler, cList, index, provider) : (widget.fromDiscussion == true ? addRemoveUserToDiscussionCard(context, scaler, cList, index, provider) : inviteContactProfileCard(context, scaler, cList, index, provider)),
        ],
      );
    } else {
    return  widget.fromChatDiscussion == true ? createGroupDiscussion(context, scaler, cList, index, provider) : (widget.fromDiscussion == true ? addRemoveUserToDiscussionCard(context, scaler, cList, index, provider) : inviteContactProfileCard(context, scaler, cList, index, provider));
    }
  }

  Widget inviteContactProfileCard(
      BuildContext context,
      ScreenScaler scaler,
      List<Contact> contactOrGroupList,
      int index,
      EventInviteFriendsProvider provider) {
    return Column(
      children: [
        Card(
          elevation: 3.0,
          shadowColor: ColorConstants.colorWhite,
          shape: RoundedRectangleBorder(
              borderRadius: scaler.getBorderRadiusCircular(12)),
          child: Padding(
            padding: scaler.getPaddingAll(10.0),
            child: Row(
              children: [
                CommonWidgets.profileCardImageDesign(
                    scaler, contactOrGroupList[index].photoURL),
                SizedBox(width: scaler.getWidth(2.5)),
                CommonWidgets.profileCardNameAndEmailDesign(
                    scaler,
                    contactOrGroupList[index].displayName,
                    provider.toggle == 0
                        ? contactOrGroupList[index].email
                        : contactOrGroupList[index].group.length.toString() +
                            " " +
                            "members".tr()),
                provider.toggle == 0
                    ? Container(
                        width: scaler.getWidth(8),
                        height: scaler.getHeight(3.5),
                        alignment: Alignment.center,
                        child: provider.value[index] == true
                            ? Container(
                                height: scaler.getHeight(2),
                                width: scaler.getWidth(4.5),
                                child: CircularProgressIndicator())
                            : Checkbox(
                                value: provider.contactCheckIsSelected(
                                    provider.confirmContactList[index]),
                                onChanged: (bool? value) {
                                  if (value!) {
                                    provider.inviteContactToEvent(
                                        context,
                                        provider.confirmContactList[index].cid,
                                        index);
                                  } else {
                                    provider.removeContactFromEvent(
                                        context,
                                        provider.confirmContactList[index].cid,
                                        index);
                                  }
                                },
                              ),
                      )
                    : Container(
                        width: scaler.getWidth(8),
                        height: scaler.getHeight(3.5),
                        alignment: Alignment.center,
                        child: provider.value[index] == true
                            ? Container(
                                height: scaler.getHeight(2),
                                width: scaler.getWidth(4.5),
                                child: CircularProgressIndicator())
                            : Checkbox(
                                value: provider.eventDetail.editEvent == true
                                    ? provider.groupCheck(
                                        contactOrGroupList[index], index)
                                    : provider.groupCheckIsSelected(index),
                                onChanged: (bool? value) {
                                  if (value!) {
                                    List<String> keysList = [];
                                    for (var key in provider
                                        .groupList[index].group.keys) {
                                      keysList.add(key);
                                    }

                                    provider.inviteGroupToEvent(
                                        context,
                                        keysList,
                                        index,
                                        provider.groupList[index]);
                                  } else {
                                    List<String> keysList = [];
                                    for (var key in provider
                                        .groupList[index].group.keys) {
                                      keysList.add(key);
                                    }

                                    provider.removeGroupFromEvent(
                                        context,
                                        keysList,
                                        index,
                                        provider.groupList[index]);
                                  }
                                },
                              )),
              ],
            ),
          ),
        ),
        SizedBox(height: scaler.getHeight(0.5)),
      ],
    );
  }

  Widget addRemoveUserToDiscussionCard(
      BuildContext context,
      ScreenScaler scaler,
      List<Contact> contactOrGroupList,
      int index,
      EventInviteFriendsProvider provider) {
    return Column(
      children: [
        Card(
          elevation: 3.0,
          shadowColor: ColorConstants.colorWhite,
          shape: RoundedRectangleBorder(
              borderRadius: scaler.getBorderRadiusCircular(12)),
          child: Padding(
            padding: scaler.getPaddingAll(10.0),
            child: Row(
              children: [
                CommonWidgets.profileCardImageDesign(
                    scaler, contactOrGroupList[index].photoURL),
                SizedBox(width: scaler.getWidth(2.5)),
                CommonWidgets.profileCardNameAndEmailDesign(
                    scaler,
                    contactOrGroupList[index].displayName,
                    provider.toggle == 0
                        ? contactOrGroupList[index].email
                        : contactOrGroupList[index].group.length.toString() +
                        " " +
                        "members".tr()),
                provider.toggle == 0
                    ? Container(
                  width: scaler.getWidth(8),
                  height: scaler.getHeight(3.5),
                  alignment: Alignment.center,
                  child: provider.addRemoveUser[index] == true
                      ? Container(
                      height: scaler.getHeight(2),
                      width: scaler.getWidth(4.5),
                      child: CircularProgressIndicator())
                      : Checkbox(
                    value: provider.contactCheckIsSelected(
                        provider.confirmContactList[index]),
                    onChanged: (bool? value) {
                      if (value!) {
                       provider.addContactToDiscussion(context, widget.discussionId!, index, cid: provider.confirmContactList[index].cid);
                      } else {
                        provider.removeContactFromDiscussion(context, widget.discussionId!, index, cid: provider.confirmContactList[index].cid);
                      }
                    },
                  ),
                )
                    : Container()
              ],
            ),
          ),
        ),
        SizedBox(height: scaler.getHeight(0.5)),
      ],
    );
  }

  Widget createGroupDiscussion(
      BuildContext context,
      ScreenScaler scaler,
      List<Contact> contactOrGroupList,
      int index,
      EventInviteFriendsProvider provider) {
    return Column(
      children: [
        Card(
          elevation: 3.0,
          shadowColor: ColorConstants.colorWhite,
          shape: RoundedRectangleBorder(
              borderRadius: scaler.getBorderRadiusCircular(12)),
          child: Padding(
            padding: scaler.getPaddingAll(10.0),
            child: Row(
              children: [
                CommonWidgets.profileCardImageDesign(
                    scaler, contactOrGroupList[index].photoURL),
                SizedBox(width: scaler.getWidth(2.5)),
                CommonWidgets.profileCardNameAndEmailDesign(
                    scaler,
                    contactOrGroupList[index].displayName,
                    provider.toggle == 0
                        ? contactOrGroupList[index].email
                        : contactOrGroupList[index].group.length.toString() +
                        " " +
                        "members".tr()),
                provider.toggle == 0
                    ? Checkbox(
                  value: provider.contactCheckIsSelected(contactOrGroupList[index]),
                  onChanged: (bool? value) {
                    if(value!){
                      provider.eventDetail.contactCIDs.add(contactOrGroupList[index].cid);
                      provider.updateAddContactToGroupValue(true, index);
                   //   provider.userKeysToInviteInGroup.add(contactOrGroupList[index].uid);
                    } else{
                      var idIndex = provider.eventDetail.contactCIDs.indexWhere((element) => element == contactOrGroupList[index].cid);
                      provider.eventDetail.contactCIDs.removeAt(idIndex);
                      provider.updateAddContactToGroupValue(false, index);
                    }
                  },
                )
                    : Checkbox(
                  value: provider.groupCheckIsSelected(index),
                  onChanged: (bool? value) {
                    if(value!){
                    //  List<String> keysList = [];
                      for (var key in provider
                          .groupList[index].group.keys) {
                        provider.eventDetail.contactCIDs.add(key);
                      }
                   //   print(provider.eventDetail.contactCIDs);
                     // provider.eventDetail.contactCIDs.add();
                      provider.eventDetail.groupIndexList.add(index.toString());
                      provider.updateAddContactGroupToGroupValue(true, index);
                    } else{
                      for (var key in provider
                          .groupList[index].group.keys) {
                        provider.eventDetail.contactCIDs.remove(key);
                      }
                    //  print(provider.eventDetail.contactCIDs);
                      provider.removeContactFromGroupCidList(index, contactOrGroupList[index]);

                    }
                  },
                )
              ],
            ),
          ),
        ),
        SizedBox(height: scaler.getHeight(0.5)),
      ],
    );
  }

  Widget eventShareLinkRow(ScreenScaler scaler){
    return Row(
      children: [
        Text("event_link".tr())
            .mediumText(
            ColorConstants.colorBlack,
            scaler.getTextSize(12.0),
            TextAlign.left),
        SizedBox(width: scaler.getWidth(2.0)),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: scaler.getPadding(0.0, 0.5),
            height: scaler.getHeight(3.5),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
            ),
            child: Text("https://meetmeyou.com/event?eid=${provider.eventDetail.eid}").regularText(ColorConstants.colorBlack, 12.0, TextAlign.left, maxLines: 1,
            overflow: TextOverflow.ellipsis)
          ),
        ),
        SizedBox(width: scaler.getWidth(2.0)),
        GestureDetector(
            onTap: (){
              Clipboard.setData(ClipboardData(text: "https://meetmeyou.com/event?eid=${provider.eventDetail.eid}")).then((value) {
                DialogHelper.showMessage(context, "copy_to_clipboard".tr());
              });
            },
            child: Icon(Icons.copy)),
        SizedBox(width: scaler.getWidth(2.0)),
        GestureDetector(
          onTap: (){
            Share.share("Please find link to the event I’m organising: https://meetmeyou.com/event?eid=${provider.eventDetail.eid}");
          },
            child: ImageView(path: ImageConstants.share_icon))
      ],
    );
  }
}
