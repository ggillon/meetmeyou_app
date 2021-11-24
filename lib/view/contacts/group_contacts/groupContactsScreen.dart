import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/group_contacts_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class GroupContactsScreen extends StatelessWidget {
  GroupContactsScreen({Key? key}) : super(key: key);
  final searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorConstants.colorWhite,
          appBar: DialogHelper.appBarWithBack(scaler, context),
          body: BaseView<GroupContactsProvider>(onModelReady: (provider) {
            provider.sortContactList();
            provider.isChecked =
                List<bool>.filled(provider.myContactListName.length, false);
          }, builder: (builder, provider, _) {
            return Padding(
              padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("group_contacts".tr()).boldText(
                      ColorConstants.colorBlack,
                      scaler.getTextSize(16),
                      TextAlign.left),
                  SizedBox(height: scaler.getHeight(1)),
                  searchBar(scaler, provider),
                  SizedBox(height: scaler.getHeight(1)),
                  contactList(scaler, "sample@gmail.com", provider)
                ],
              ),
            );
          })),
    );
  }

  Widget searchBar(ScreenScaler scaler, GroupContactsProvider provider) {
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
          provider.updateValue(true);
        },
      ),
    );
  }

  Widget contactList(
      ScreenScaler scaler, String friendEmail, GroupContactsProvider provider) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.myContactListName.length,
            itemBuilder: (context, index) {
              String currentHeader = provider.myContactListName[index]
                  .capitalize()
                  .substring(0, 1);
              String header = index == 0
                  ? provider.myContactListName[index]
                      .capitalize()
                      .substring(0, 1)
                  : provider.myContactListName[index - 1]
                      .capitalize()
                      .substring(0, 1);
              if (searchBarController.text.isEmpty) {
                return aToZHeader(context, provider, currentHeader, header,
                    index, scaler, friendEmail);
              } else if (provider.myContactListName[index]
                  .toLowerCase()
                  .contains(searchBarController.text)) {
                return contactProfileCard(scaler, provider, index);
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  aToZHeader(BuildContext context, GroupContactsProvider provider,
      String cHeader, String header, int index, scaler, friendEmail) {
    if (index == 0 ? true : (header != cHeader)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(cHeader).semiBoldText(ColorConstants.colorBlack,
                scaler.getTextSize(9.8), TextAlign.left),
          ),
          contactProfileCard(scaler, provider, index),
        ],
      );
    } else {
      return contactProfileCard(scaler, provider, index);
    }
  }

  Widget contactProfileCard(
      ScreenScaler scaler, GroupContactsProvider provider, int index) {
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
                Stack(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  overflow: Overflow.visible,
                  children: [
                    ClipRRect(
                      borderRadius: scaler.getBorderRadiusCircular(10.0),
                      child: Container(
                        color: ColorConstants.primaryColor,
                        width: scaler.getWidth(10),
                        height: scaler.getWidth(10),
                      ),
                    ),
                    Positioned(
                        top: 25,
                        right: -5,
                        child: ImageView(path: ImageConstants.small_logo_icon))
                  ],
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
                      Text(provider.myContactListName[index]).regularText(
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
                    // provider.isChecked[index]
                    //     ? provider.checklist
                    //         .add(provider.myContactListName[index])
                    //     : provider.checklist
                    //         .remove(provider.myContactListName[index]);
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
