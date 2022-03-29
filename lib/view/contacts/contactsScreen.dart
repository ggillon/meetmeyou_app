import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/contacts_provider.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/contacts/contact_description/contactDescriptionScreen.dart';
import 'package:meetmeyou_app/widgets/animated_toggle.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatelessWidget {
  ContactsScreen({Key? key}) : super(key: key);
  final searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dashBoardProvider = Provider.of<DashboardProvider>(context, listen: false);
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: BaseView<ContactsProvider>(
          onModelReady: (provider) {
            provider.getConfirmedContactsAndInvitationsList(context);
          },
          builder: (context, provider, _) {
            return Padding(
              padding: scaler.getPaddingLTRB(2.5, 0.7, 2.5, 2.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("contacts".tr()).semiBoldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(16),
                          TextAlign.left),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                          onTap: () {
                            bottomSheet(context, scaler, provider);
                          },
                          child: Padding(
                            padding: scaler.getPaddingLTRB(0.0, 0.0, 1.5, 0.0),
                            child: ImageView(path: ImageConstants.small_add_icon, height: scaler.getHeight(3.0), width: scaler.getWidth(10.0)),
                          )),
                    ],
                  ),
                  SizedBox(height: scaler.getHeight(1)),
                  AnimatedToggle(
                    values: ['all'.tr(), 'groups'.tr()],
                    onToggleCallback: (value) {
                      provider.toggle = value;
                      if (value == 0) {
                        provider
                            .getConfirmedContactsAndInvitationsList(context);
                      } else {
                        provider.getGroupList(context);
                      }
                      provider.updateValue(true);
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
                          : provider.invitationContactList.length == 0 &&
                                  provider.confirmContactList.length == 0
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
                                        provider.invitationContactList.length ==
                                                0
                                            ? Container()
                                            : Text("invitations".tr())
                                                .semiBoldText(
                                                    ColorConstants.colorBlack,
                                                    scaler.getTextSize(9.8),
                                                    TextAlign.left),
                                        SizedBox(height: scaler.getHeight(1)),
                                        provider.invitationContactList.length ==
                                                0
                                            ? Container()
                                            : invitationContactList(
                                                scaler,
                                                provider.invitationContactList,
                                                provider, dashBoardProvider),
                                        provider.invitationContactList.length ==
                                                0
                                            ? Container()
                                            : SizedBox(
                                                height: scaler.getHeight(2.5)),
                                        provider.confirmContactList.length == 0
                                            ? Container()
                                            : confirmContactGroupList(
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
                                        confirmContactGroupList(scaler,
                                            provider.groupList, provider),
                                      ],
                                    ),
                                  ),
                                ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget searchBar(ScreenScaler scaler, ContactsProvider provider) {
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
        onFieldSubmitted: (data) {},
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.name,
        onChanged: (value) {
          provider.updateValue(true);
        },
      ),
    );
  }

  Widget invitationContactList(
      ScreenScaler scaler, List<Contact> iList, ContactsProvider provider, DashboardProvider dashboardProvider) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: iList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                provider.setContactsValue(iList[index], true, iList[index].cid);
                Navigator.pushNamed(
                  context,
                  RoutesConstants.contactDescription, arguments: ContactDescriptionScreen(showEventScreen: true, isFromNotification: false, contactId: "")
                ).then((value) {
                  provider.getConfirmedContactsAndInvitationsList(context);
                  provider.unRespondedInvites(context, dashboardProvider);
                });
              },
              child: CommonWidgets.userContactCard(scaler,
                  "click_to_reply_to_invitation".tr(), iList[index].displayName,
                  invitation: true, profileImg: iList[index].photoURL));
        });
  }

  Widget confirmContactGroupList(
      ScreenScaler scaler, List<Contact> cList, ContactsProvider provider) {
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
            return contactProfileCard(context, scaler, cList, index, provider);
          } else {
            return Container();
          }
        });
  }

  aToZHeader(BuildContext context, String cHeader, String header, int index,
      scaler, List<Contact> cList, ContactsProvider provider) {
    if (index == 0 ? true : (header != cHeader)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(cHeader).semiBoldText(ColorConstants.colorBlack,
                scaler.getTextSize(9.8), TextAlign.left),
          ),
          contactProfileCard(context, scaler, cList, index, provider),
        ],
      );
    } else {
      return contactProfileCard(context, scaler, cList, index, provider);
    }
  }

  Widget contactProfileCard(BuildContext context, ScreenScaler scaler,
      List<Contact> cList, int index, ContactsProvider provider) {
    return provider.toggle == 0
        ? GestureDetector(
            onTap: () {
              provider.setContactsValue(cList[index], false, "");
              provider.discussionDetail.userId = cList[index].cid;
              Navigator.pushNamed(
                context,
                RoutesConstants.contactDescription, arguments: ContactDescriptionScreen(showEventScreen: true, isFromNotification: false, contactId: "")
              ).then((value) {
                provider.getConfirmedContactsAndInvitationsList(context);
              });
            },
            child: CommonWidgets.userContactCard(
                scaler, cList[index].email, cList[index].displayName,
                profileImg: cList[index].photoURL))
        : GestureDetector(
            onTap: () {
              provider.setGroupValue(cList[index]);
              Navigator.pushNamed(
                context,
                RoutesConstants.groupDescriptionScreen,
              ).then((value) {
                provider.getGroupList(context);
              });
            },
            child: CommonWidgets.userContactCard(
                scaler,
                cList[index].group.length.toString() + " " + "members".tr(),
                cList[index].displayName,
                profileImg: cList[index].photoURL));
  }

  bottomSheet(
      BuildContext context, ScreenScaler scaler, ContactsProvider provider) {
    return showModalBottomSheet(
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircularLR(25.0, 25.0, 0.0, 0.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: scaler.getHeight(0.5)),
                Container(
                  decoration: BoxDecoration(
                      color: ColorConstants.colorMediumGray,
                      borderRadius: scaler.getBorderRadiusCircular(10.0)),
                  height: scaler.getHeight(0.4),
                  width: scaler.getWidth(12),
                ),
                Column(
                  children: [
                    SizedBox(height: scaler.getHeight(2)),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(
                                context, RoutesConstants.searchProfileScreen)
                            .then((value) {
                          provider
                              .getConfirmedContactsAndInvitationsList(context);
                        });
                      },
                      child: Text("search_for_contact".tr()).regularText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(11),
                          TextAlign.center),
                    ),
                    SizedBox(height: scaler.getHeight(0.9)),
                    Divider(),
                    SizedBox(height: scaler.getHeight(0.9)),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(
                                context, RoutesConstants.createEditGroupScreen)
                            .then((value) {
                          provider.getGroupList(context);
                        });
                      },
                      child: Text("create_group_of_contacts".tr()).regularText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(11),
                          TextAlign.center),
                    ),
                    SizedBox(height: scaler.getHeight(2)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Text("cancel".tr()).semiBoldText(
                        ColorConstants.colorRed,
                        scaler.getTextSize(11),
                        TextAlign.center),
                  ),
                ),
                SizedBox(height: scaler.getHeight(1)),
              ],
            ),
          );
        });
  }
}
