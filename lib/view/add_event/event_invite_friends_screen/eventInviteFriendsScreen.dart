import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/provider/event_invite_friends_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/animated_toggle.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class EventInviteFriendsScreen extends StatefulWidget {
  EventInviteFriendsScreen({Key? key, required this.fromDiscussion, this.discussionId, required this.fromChatDiscussion}) : super(key: key);
  bool fromDiscussion;
  bool fromChatDiscussion;
  String? discussionId;
  @override
  State<EventInviteFriendsScreen> createState() =>
      _EventInviteFriendsScreenState();
}

class _EventInviteFriendsScreenState extends State<EventInviteFriendsScreen> {
  final searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: DialogHelper.appBarWithBack(scaler, context),
      body: BaseView<EventInviteFriendsProvider>(
        onModelReady: (provider) {
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
                          scaler.getTextSize(16),
                          TextAlign.left)) : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("invite_friends".tr()).boldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(16),
                          TextAlign.left),
                      ImageView(path: ImageConstants.share_icon)
                    ],
                  ),
                  SizedBox(height: scaler.getHeight(1)),
                  searchBar(scaler, provider),
                  SizedBox(height: scaler.getHeight(1)),
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
                                      scaler.getTextSize(10),
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
                                            scaler.getTextSize(10),
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
                                      scaler.getTextSize(10),
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
                                            scaler.getTextSize(10),
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
               Container(
                 child: DialogHelper.btnWidget(
                     scaler,
                     context,
                     "invite_to_group_discussion".tr(),
                     ColorConstants.primaryColor, funOnTap: () {
                   if (provider.eventDetail.contactCIDs.isNotEmpty ||
                       provider.eventDetail.groupIndexList.isNotEmpty) {
                     Navigator.of(context).pop();
                   } else {
                     DialogHelper.showMessage(
                         context, "Please select contacts to Invite");
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
            ),
          );
        },
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
            scaler.getTextSize(12), ColorConstants.colorBlack),
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
            return (widget.fromDiscussion == true || widget.fromChatDiscussion == true)? addRemoveUserToDiscussionCard(context, scaler, cList, index, provider) : inviteContactProfileCard(
                context, scaler, cList, index, provider);
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
                scaler.getTextSize(9.8), TextAlign.left),
          ),
          (widget.fromDiscussion == true || widget.fromChatDiscussion == true) ? addRemoveUserToDiscussionCard(context, scaler, cList, index, provider) : inviteContactProfileCard(context, scaler, cList, index, provider),
        ],
      );
    } else {
      return (widget.fromDiscussion == true || widget.fromChatDiscussion == true) ? addRemoveUserToDiscussionCard(context, scaler, cList, index, provider) : inviteContactProfileCard(context, scaler, cList, index, provider);
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
}
