import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
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
        floatingActionButton: Padding(
          padding: scaler.getPaddingAll(10.0),
          child: DialogHelper.btnWidget(
              scaler, context, "invite".tr(), ColorConstants.primaryColor),
        ),
        floatingActionButtonLocation:  FloatingActionButtonLocation.centerFloat,
        body: BaseView<InviteFriendsProvider>(
          onModelReady: (provider) {
            provider.isChecked =
                List<bool>.filled(provider.myContactListName.length, false);
            provider.sortContactList();
          },
          builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 2.5),
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
                    inviteFriendList(scaler, "sample@gmail.com", provider)
                  ],
                ),
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

  Widget inviteFriendList(
      ScreenScaler scaler, String friendEmail, InviteFriendsProvider provider) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: provider.myContactListName.length,
        itemBuilder: (context, index) {
          String currentHeader =
              provider.myContactListName[index].capitalize().substring(0, 1);
          String header = index == 0
              ? provider.myContactListName[index].capitalize().substring(0, 1)
              : provider.myContactListName[index - 1]
                  .capitalize()
                  .substring(0, 1);
          if (searchBarController.text.isEmpty) {
            return aToZHeader(
                provider, currentHeader, header, index, scaler, friendEmail);
          } else if (provider.myContactListName[index]
              .toLowerCase()
              .contains(searchBarController.text)) {
            return inviteFriendProfileCard(
                scaler, friendEmail, provider, index);
          } else {
            return Container();
          }
        });
  }

  aToZHeader(InviteFriendsProvider provider, String cHeader, String header,
      int index, scaler, friendEmail) {
    if (index == 0 ? true : (header != cHeader)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(cHeader).semiBoldText(ColorConstants.colorBlack,
                scaler.getTextSize(9.8), TextAlign.left),
          ),
          inviteFriendProfileCard(scaler, friendEmail, provider, index),
        ],
      );
    } else {
      return inviteFriendProfileCard(scaler, friendEmail, provider, index);
    }
  }

  Widget inviteFriendProfileCard(ScreenScaler scaler, String friendEmail,
      InviteFriendsProvider provider, int index) {
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
                  child: Container(
                    color: ColorConstants.primaryColor,
                    width: scaler.getWidth(10),
                    height: scaler.getWidth(10),
                  ),
                ),
                SizedBox(width: scaler.getWidth(2.5)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(provider.myContactListName[index].capitalize())
                          .semiBoldText(ColorConstants.colorBlack,
                              scaler.getTextSize(9.8), TextAlign.left,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                      SizedBox(height: scaler.getHeight(0.2)),
                      Text(friendEmail).regularText(ColorConstants.colorGray,
                          scaler.getTextSize(8.3), TextAlign.left,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Checkbox(
                  value: provider.isChecked[index],
                  onChanged: (bool? value) {
                    provider.setCheckBoxValue(value!, index);
                  },
                ), //
              ],
            ),
          ),
        ),
        SizedBox(height: scaler.getHeight(0.5)),
      ],
    );
  }
}
