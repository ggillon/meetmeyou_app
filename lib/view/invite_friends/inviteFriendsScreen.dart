import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/invite_friends_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class InviteFriendsScreen extends StatelessWidget {
  InviteFriendsScreen({Key? key}) : super(key: key);

  final searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context),
        // floatingActionButton: Padding(
        //   padding: scaler.getPaddingAll(10.0),
        //   child: DialogHelper.btnWidget(
        //       scaler, context, "invite".tr(), ColorConstants.primaryColor),
        // ),
        // floatingActionButtonLocation:  FloatingActionButtonLocation.centerFloat,
        body: BaseView<InviteFriendsProvider>(
          onModelReady: (provider) {
            provider.sortContactList();
            provider.getPhoneContacts(context);
            // provider.isChecked =
            //     List<bool>.filled(provider.contactList.length, false);
          },
          builder: (context, provider, _) {
            return Padding(
              padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("invite_friends".tr()).boldText(
                        ColorConstants.colorBlack,
                        scaler.getTextSize(16),
                        TextAlign.left),
                  ),
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
                                  scaler.getTextSize(10),
                                  TextAlign.left),
                            ],
                          ),
                        )
                      : provider.contactList.length == 0
                          ? Expanded(
                              child: Center(
                                child: Text("sorry_no_contacts_found".tr())
                                    .mediumText(ColorConstants.primaryColor,
                                        scaler.getTextSize(11), TextAlign.left),
                              ),
                            )
                          : inviteFriendList(scaler, provider),
                  Container(
                    child: DialogHelper.btnWidget(scaler, context,
                        "invite".tr(), ColorConstants.primaryColor),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget searchBar(ScreenScaler scaler, InviteFriendsProvider provider) {
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
            radius: 15),
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
              String currentHeader = provider.contactList[index].displayName!
                  .capitalize()
                  .substring(0, 1);
              String header = index == 0
                  ? provider.contactList[index].displayName!
                      .capitalize()
                      .substring(0, 1)
                  : provider.contactList[index - 1].displayName!
                      .capitalize()
                      .substring(0, 1);
              if (searchBarController.text.isEmpty) {
                return aToZHeader(
                    provider, currentHeader, header, index, scaler);
              } else if (provider.contactList[index].displayName!
                  .toLowerCase()
                  .contains(searchBarController.text)) {
                return inviteFriendProfileCard(scaler, provider, index);
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  aToZHeader(InviteFriendsProvider provider, String cHeader, String header,
      int index, scaler) {
    if (index == 0 ? true : (header != cHeader)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(cHeader).semiBoldText(ColorConstants.colorBlack,
                scaler.getTextSize(9.8), TextAlign.left),
          ),
          inviteFriendProfileCard(scaler, provider, index),
        ],
      );
    } else {
      return inviteFriendProfileCard(scaler, provider, index);
    }
  }

  Widget inviteFriendProfileCard(
      ScreenScaler scaler, InviteFriendsProvider provider, int index) {
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
                ClipRRect(
                    borderRadius: scaler.getBorderRadiusCircular(10.0),
                    child: provider.contactList[index].photoURL == null
                        ? Container(
                            color: ColorConstants.primaryColor,
                            width: scaler.getWidth(10),
                            height: scaler.getWidth(10),
                          )
                        : ImageView(
                            color: ColorConstants.primaryColor,
                            path: provider.contactList[index].photoURL,
                            width: scaler.getWidth(10),
                            height: scaler.getWidth(10))),
                SizedBox(width: scaler.getWidth(2.5)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(provider.contactList[index].displayName!
                              .capitalize())
                          .semiBoldText(ColorConstants.colorBlack,
                              scaler.getTextSize(9.8), TextAlign.left,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                      SizedBox(height: scaler.getHeight(0.2)),
                      Text(provider.contactList[index].email!).regularText(
                          ColorConstants.colorGray,
                          scaler.getTextSize(8.3),
                          TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Checkbox(
                  value: provider.isChecked[index],
                  onChanged: (bool? value) {
                    provider.setCheckBoxValue(value!, index);
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: scaler.getHeight(0.5)),
      ],
    );
  }
}
