import 'package:contacts_service/contacts_service.dart';
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
import 'package:meetmeyou_app/provider/invite_friends_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class InviteFriendsScreen extends StatefulWidget {
  const InviteFriendsScreen({Key? key}) : super(key: key);

  @override
  _InviteFriendsScreenState createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen>  with TickerProviderStateMixin<InviteFriendsScreen> {
  final searchBarController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
    key: _scaffoldKey,
    backgroundColor: ColorConstants.colorWhite,
    appBar: DialogHelper.appBarWithBack(scaler, context),
    body: BaseView<InviteFriendsProvider>(
      onModelReady: (provider) {
        provider.tabController = TabController(length: 2, vsync: this);
        provider.getPhoneContacts(_scaffoldKey.currentContext!);
        provider.tabChangeEvent(context);
      },
      builder: (context, provider, _) {
        return SafeArea(
          child: Padding(
            padding: scaler.getPaddingLTRB(3.0, 0.0, 3.0, 0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("invite_friends".tr()).boldText(
                      ColorConstants.colorBlack,
                      scaler.getTextSize(17),
                      TextAlign.left),
                ),
                SizedBox(height: scaler.getHeight(3.0)),
                TabBar(
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
                Expanded(
                  child: TabBarView(
                    controller: provider.tabController,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           SizedBox(height: scaler.getHeight(1)),
                           searchBar(scaler, provider),
                          SizedBox(height: scaler.getHeight(1)),
                          provider.state == ViewState.Busy
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
                              : provider.contactList.length == 0
                              ? Expanded(
                            child: Center(
                              child: Text("sorry_no_contacts_found".tr())
                                  .mediumText(ColorConstants.primaryColor,
                                  scaler.getTextSize(12), TextAlign.left),
                            ),
                          )
                              : inviteFriendList(scaler, provider),
                          Container(
                            child: DialogHelper.btnWidget(
                                scaler,
                                context,
                                "save_event".tr(),
                                ColorConstants.primaryColor, funOnTap: () {
                              if (provider.checkedContactList.length != 0) {
                               // provider.onTapInviteBtn(context);
                              }
                            }),
                          )
                        ],
                      ),
                     Container()
                    ],
                  ),
                ),

              ],
            ),
          ),
        );
      },
    ),
    );
  }

  Widget searchBar(ScreenScaler scaler, InviteFriendsProvider provider) {
    return Card(
      color: ColorConstants.colorWhite,
      elevation: 3.0,
      shadowColor: ColorConstants.colorWhite,
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(11)),
      child: TextFormField(
        controller: searchBarController,
        style: ViewDecoration.textFieldStyle(
            scaler.getTextSize(12.5), ColorConstants.colorBlack),
        decoration: ViewDecoration.inputDecorationForSearchBox(
            "search_field_name".tr(), scaler),
        onFieldSubmitted: (data) {
          // FocusScope.of(context).requestFocus(nodes[1]);
        },
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.name,
        onChanged: (value) {
          provider.updateValue(true);
        },
      ),
    );
  }

  Widget inviteFriendList(ScreenScaler scaler, InviteFriendsProvider provider) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.contactList.length,
            itemBuilder: (context, index) {
              String currentHeader = provider.contactList[index].displayName
                  .capitalize()
                  .substring(0, 1);
              String header = index == 0
                  ? provider.contactList[index].displayName
                      .capitalize()
                      .substring(0, 1)
                  : provider.contactList[index - 1].displayName
                      .capitalize()
                      .substring(0, 1);
              if (searchBarController.text.isEmpty) {
                return aToZHeader(context,
                    provider, currentHeader, header, index, scaler);
              } else if (provider.contactList[index].displayName
                  .toLowerCase()
                  .contains(searchBarController.text)) {
                return inviteFriendProfileCard(context, scaler, provider, index);
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  aToZHeader(BuildContext context, InviteFriendsProvider provider, String cHeader, String header,
      int index, scaler) {
    if (index == 0 ? true : (header != cHeader)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(cHeader).semiBoldText(ColorConstants.colorBlack,
                scaler.getTextSize(10.8), TextAlign.left),
          ),
          inviteFriendProfileCard(context, scaler, provider, index),
        ],
      );
    } else {
      return inviteFriendProfileCard(context, scaler, provider, index);
    }
  }

  Widget inviteFriendProfileCard(BuildContext context,
      ScreenScaler scaler, InviteFriendsProvider provider, int index) {
    return CommonWidgets.userContactCard(
        scaler,
        provider.contactList[index].email,
        provider.contactList[index].displayName,
        profileImg: provider.contactList[index].photoURL,
        searchStatus: provider.contactList[index].status,
        search: true,
        addIconTapAction: () {
          provider.onTapInviteBtn(context, [provider.contactList[index]]);
   }
    );
    // return Column(
    //   children: [
    //     Card(
    //       elevation: 3.0,
    //       shadowColor: ColorConstants.colorWhite,
    //       shape: RoundedRectangleBorder(
    //           borderRadius: scaler.getBorderRadiusCircular(12)),
    //       child: Padding(
    //         padding: scaler.getPaddingAll(10.0),
    //         child: Row(
    //           children: [
    //             CommonWidgets.profileCardImageDesign(
    //                 scaler, provider.contactList[index].photoURL),
    //             SizedBox(width: scaler.getWidth(2.5)),
    //             CommonWidgets.profileCardNameAndEmailDesign(
    //                 scaler,
    //                 provider.contactList[index].displayName,
    //                 provider.contactList[index].email),
    //             Checkbox(
    //               value: provider.isChecked[index],
    //               onChanged: (bool? value) {
    //                 provider.setCheckBoxValue(value!, index);
    //                 if (value) {
    //                   provider.checkedContactList
    //                       .add(provider.contactList[index]);
    //                 } else {
    //                   provider.checkedContactList
    //                       .remove(provider.contactList[index]);
    //                 }
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     SizedBox(height: scaler.getHeight(0.5)),
    //   ],
    // );
  }
}
