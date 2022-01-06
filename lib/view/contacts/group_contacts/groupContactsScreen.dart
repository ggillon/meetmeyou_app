import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/group_contacts_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class GroupContactsScreen extends StatelessWidget {
  GroupContactsScreen({Key? key}) : super(key: key);
  final searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context),
        body: BaseView<GroupContactsProvider>(onModelReady: (provider) {
          // provider.isChecked =
          //     List<bool>.filled(provider.myContactListName.length, false);
          provider.getConfirmedContactsList(context);
        }, builder: (builder, provider, _) {
          return SafeArea(
            child: Padding(
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
                      : provider.confirmContactList.length == 0
                          ? Expanded(
                              child: Center(
                                child: Text("sorry_no_contacts_found".tr())
                                    .mediumText(ColorConstants.primaryColor,
                                        scaler.getTextSize(10), TextAlign.left),
                              ),
                            )
                          : contactList(scaler, provider)
                ],
              ),
            ),
          );
        }));
  }

  Widget searchBar(ScreenScaler scaler, GroupContactsProvider provider) {
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
            // provider.updateValue(true);
          provider.setState(ViewState.Idle);
        },
      ),
    );
  }

  Widget contactList(ScreenScaler scaler, GroupContactsProvider provider) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.confirmContactList.length,
            itemBuilder: (context, index) {
              String currentHeader = provider
                  .confirmContactList[index].displayName
                  .capitalize()
                  .substring(0, 1);
              String header = index == 0
                  ? provider.confirmContactList[index].displayName
                      .capitalize()
                      .substring(0, 1)
                  : provider.confirmContactList[index - 1].displayName
                      .capitalize()
                      .substring(0, 1);
              if (searchBarController.text.isEmpty) {
                return aToZHeader(
                    context, provider, currentHeader, header, index, scaler);
              } else if (provider.confirmContactList[index].displayName
                  .toLowerCase()
                  .contains(searchBarController.text)) {
                return contactProfileCard(context, scaler, provider, index);
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  aToZHeader(BuildContext context, GroupContactsProvider provider,
      String cHeader, String header, int index, scaler) {
    if (index == 0 ? true : (header != cHeader)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(cHeader).semiBoldText(ColorConstants.colorBlack,
                scaler.getTextSize(9.8), TextAlign.left),
          ),
          contactProfileCard(context, scaler, provider, index),
        ],
      );
    } else {
      return contactProfileCard(context, scaler, provider, index);
    }
  }

  Widget contactProfileCard(BuildContext context, ScreenScaler scaler,
      GroupContactsProvider provider, int index) {
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
                CommonWidgets.profileCardImageDesign(scaler, provider.confirmContactList[index].photoURL),
                SizedBox(width: scaler.getWidth(2.5)),
                CommonWidgets.profileCardNameAndEmailDesign(
                    scaler,
                    provider.confirmContactList[index].displayName,
                    provider.confirmContactList[index].email),
                Container(
                  width: scaler.getWidth(8),
                  height: scaler.getHeight(3.5),
                  alignment: Alignment.center,
                  child: provider.value[index] == true
                      ? Container(
                          height: scaler.getHeight(2),
                          width: scaler.getWidth(4.5),
                          child: CircularProgressIndicator())
                      : Checkbox(
                          value: provider.checkIsSelected(
                              provider.confirmContactList[index]),
                          onChanged: (bool? value) {
                            if (value!) {
                              provider.addContactsToGroup(
                                  context,
                                  provider.groupDetail.groupCid ?? "",
                                  provider.confirmContactList[index],
                                  index);
                            } else {
                              provider.removeContactsFromGroup(
                                  context,
                                  provider.groupDetail.groupCid ?? "",
                                  provider.confirmContactList[index],
                                  index);
                            }
                          },
                        ),
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
