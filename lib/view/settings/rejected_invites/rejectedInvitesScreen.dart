import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/provider/rejected_invites_Provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';

class RejectedInvitesScreen extends StatelessWidget {
  RejectedInvitesScreen({Key? key}) : super(key: key);
  final searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorConstants.colorWhite,
          appBar: DialogHelper.appBarWithBack(scaler, context),
          body: BaseView<RejectedInvitesProvider>(onModelReady: (provider) {
            provider.getRejectedInvitesList(context);
          }, builder: (builder, provider, _) {
            return Padding(
              padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("rejected_invites".tr()).semiBoldText(
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
                              Text("loading_rejected_contacts".tr()).mediumText(
                                  ColorConstants.primaryColor,
                                  scaler.getTextSize(10),
                                  TextAlign.left),
                            ],
                          ),
                        )
                      : provider.rejectedContactList.length == 0
                          ? Expanded(
                              child: Center(
                                child: Text("no__rejected_contacts_found".tr())
                                    .mediumText(ColorConstants.primaryColor,
                                        scaler.getTextSize(11), TextAlign.left),
                              ),
                            )
                          : contactList(scaler, provider)
                ],
              ),
            );
          })),
    );
  }

  Widget searchBar(ScreenScaler scaler, RejectedInvitesProvider provider) {
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
          provider.updateValue(true);
        },
      ),
    );
  }

  Widget contactList(ScreenScaler scaler, RejectedInvitesProvider provider) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.rejectedContactList.length,
            itemBuilder: (context, index) {
              String currentHeader = provider
                  .rejectedContactList[index].displayName
                  .capitalize()
                  .substring(0, 1);
              String header = index == 0
                  ? provider.rejectedContactList[index].displayName
                      .capitalize()
                      .substring(0, 1)
                  : provider.rejectedContactList[index - 1].displayName
                      .capitalize()
                      .substring(0, 1);
              if (searchBarController.text.isEmpty) {
                return aToZHeader(
                    context, provider, currentHeader, header, index, scaler);
              } else if (provider.rejectedContactList[index].displayName
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

  aToZHeader(BuildContext context, RejectedInvitesProvider provider,
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
      RejectedInvitesProvider provider, int index) {
    return GestureDetector(
        onTap: () {
          provider.setRejectedInvitesValue(provider.rejectedContactList[index]);
          Navigator.pushNamed(
              context, RoutesConstants.rejectedInvitesDescriptionScreen);
        },
        child: CommonWidgets.userContactCard(
            scaler,
            provider.rejectedContactList[index].email,
            provider.rejectedContactList[index].displayName,
            profileImg: provider.rejectedContactList[index].photoURL));
  }
}
