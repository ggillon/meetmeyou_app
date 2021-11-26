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
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/animated_toggle.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ContactsScreen extends StatelessWidget {
  ContactsScreen({Key? key}) : super(key: key);
  final searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                          onTap: () {
                            // CommonWidgets.bottomSheet(context, scaler,
                            //     bottomDesign(scaler, context, provider));
                            bottomSheet(context, scaler, provider);
                          },
                          child: Padding(
                            padding: scaler.getPaddingLTRB(0.0, 0.0, 1.0, 0.0),
                            child: ImageView(path: ImageConstants.more_icon),
                          )),
                    ],
                  ),
                  SizedBox(height: scaler.getHeight(1)),
                  // searchBar(scaler, provider),
                  // SizedBox(height: scaler.getHeight(1)),
                  //  allGroupsToggleSwitch(scaler, provider),
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
                                                provider),
                                        provider.invitationContactList.length ==
                                                0
                                            ? Container()
                                            : SizedBox(
                                                height: scaler.getHeight(2.5)),
                                        provider.confirmContactList.length == 0
                                            ? Container()
                                            : confirmContactList(
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
                                        confirmContactList(scaler,
                                            provider.groupList, provider),
                                      ],
                                    ),
                                  ),
                                )
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
      elevation: 3.0,
      shadowColor: ColorConstants.colorWhite,
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(15)),
      child: TextFormField(
        controller: searchBarController,
        style: ViewDecoration.textFieldStyle(
            scaler.getTextSize(9.5), ColorConstants.colorBlack),
        decoration: ViewDecoration.inputDecorationWithCurve(
            "Cooper", scaler, ColorConstants.primaryColor,
            prefixIcon: Icon(
              Icons.search,
              size: scaler.getTextSize(15),
              color: ColorConstants.colorBlack,
            ),
            textSize: 12,
            fillColor: ColorConstants.colorWhite,
            radius: 15.0),
        onFieldSubmitted: (data) {
          // FocusScope.of(context).requestFocus(nodes[1]);
        },
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.name,
        onChanged: (value) {
          //provider.updateValue(true);
        },
      ),
    );
  }

  Widget allGroupsToggleSwitch(ScreenScaler scaler, ContactsProvider provider) {
    return Padding(
      padding: scaler.getPaddingLTRB(1.8, 0.0, 1.8, 0.0),
      child: ToggleSwitch(
        minHeight: scaler.getHeight(2.8),
        minWidth: scaler.getWidth(38),
        borderColor: [
          ColorConstants.colorMediumGray,
          ColorConstants.colorMediumGray
        ],
        borderWidth: scaler.getWidth(0.2),
        cornerRadius: 20.0,
        activeBgColors: [
          [ColorConstants.colorWhite],
          [ColorConstants.colorWhite]
        ],
        activeFgColor: ColorConstants.colorBlack,
        inactiveBgColor: ColorConstants.colorMediumGray,
        inactiveFgColor: ColorConstants.colorBlack,
        // initialLabelIndex: toggle ? 1 : 0,
        totalSwitches: 2,
        labels: ["All", "Groups"],
        customTextStyles: [
          TextStyle(
              color: ColorConstants.colorBlack,
              fontFamily: StringConstants.spProDisplay,
              fontWeight: FontWeight.w600,
              fontSize: scaler.getTextSize(8.5)),
          TextStyle(
              color: ColorConstants.colorBlack,
              fontFamily: StringConstants.spProDisplay,
              fontWeight: FontWeight.w500,
              fontSize: scaler.getTextSize(8.5))
        ],
        radiusStyle: true,
        onToggle: (index) {},
      ),
    );
  }

  Widget invitationContactList(
      ScreenScaler scaler, List<Contact> iList, ContactsProvider provider) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: iList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RoutesConstants.contactDescription,
                        arguments: UserDetail(
                            firstName: iList[index].displayName,
                            email: iList[index].email,
                            value: true,
                            cid: iList[index].cid,
                            profileUrl: iList[index].photoURL,
                            phone: iList[index].phoneNumber,
                            address: iList[index].addresses['Home']))
                    .then((value) {
                  provider.getConfirmedContactsAndInvitationsList(context);
                });
              },
              child: CommonWidgets.userContactCard(scaler,
                  "click_to_reply_to_invitation".tr(), iList[index].displayName,
                  invitation: true, profileImg: iList[index].photoURL));
        });
  }

  Widget confirmContactList(
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
              Navigator.pushNamed(context, RoutesConstants.contactDescription,
                      arguments: UserDetail(
                          firstName: cList[index].displayName,
                          email: cList[index].email,
                          value: false,
                          profileUrl: cList[index].photoURL,
                          phone: cList[index].phoneNumber,
                          address: cList[index].addresses['Home']))
                  .then((value) {
                provider.getConfirmedContactsAndInvitationsList(context);
              });
            },
            child: CommonWidgets.userContactCard(
                scaler, cList[index].email, cList[index].displayName,
                profileImg: cList[index].photoURL))
        : GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                      context, RoutesConstants.groupDescriptionScreen,
                      arguments: UserDetail(
                          firstName: cList[index].displayName,
                          profileUrl: cList[index].photoURL,
                          about: cList[index].about,
                          membersLength: cList[index].group.length.toString(),
                          group: cList[index].group))
                  .then((value) {
                provider.getGroupList(context);
              });
            },
            child: CommonWidgets.userContactCard(
                scaler,
                cList[index].group.length.toString() + " " + "members".tr(),
                cList[index].displayName,
                profileImg: cList[index].photoURL));
  }

  // Widget bottomDesign(
  //     ScreenScaler scaler, BuildContext context, ContactsProvider provider) {
  //   return Column(
  //     children: [
  //       Card(
  //         color: ColorConstants.colorWhite.withOpacity(0.7),
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
  //         child: Column(
  //           children: [
  //             SizedBox(height: scaler.getHeight(1.5)),
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.of(context).pop();
  //                 Navigator.pushNamed(
  //                         context, RoutesConstants.searchProfileScreen)
  //                     .then((value) {
  //                   provider.getConfirmedContactsAndInvitationsList(context);
  //                 });
  //               },
  //               child: Text("search_for_contact".tr()).regularText(
  //                   ColorConstants.primaryColor,
  //                   scaler.getTextSize(11),
  //                   TextAlign.center),
  //             ),
  //             SizedBox(height: scaler.getHeight(0.9)),
  //             Divider(),
  //             SizedBox(height: scaler.getHeight(0.9)),
  //             GestureDetector(
  //               onTap: () {
  //                 Navigator.of(context).pop();
  //                 Navigator.pushNamed(
  //                     context, RoutesConstants.createEditGroupScreen);
  //               },
  //               child: Text("create_group_of_contacts".tr()).regularText(
  //                   ColorConstants.primaryColor,
  //                   scaler.getTextSize(11),
  //                   TextAlign.center),
  //             ),
  //             SizedBox(height: scaler.getHeight(1.5)),
  //           ],
  //         ),
  //       ),
  //       CommonWidgets.cancelBtn(scaler, context),
  //       SizedBox(height: scaler.getHeight(1)),
  //     ],
  //   );
  // }

  bottomSheet(
      BuildContext context, ScreenScaler scaler, ContactsProvider provider) {
    return showModalBottomSheet(
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircularLR(25.0, 25.0, 0.0, 0.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return Column(
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
          );
        });
  }
}
