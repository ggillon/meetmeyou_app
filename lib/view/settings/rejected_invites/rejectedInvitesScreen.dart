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
            provider.sortRejectedContactList();
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
                          : contactList(scaler, "sample@gmail.com", provider)
                ],
              ),
            );
          })),
    );
  }

  Widget searchBar(ScreenScaler scaler, RejectedInvitesProvider provider) {
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

  Widget contactList(ScreenScaler scaler, String friendEmail,
      RejectedInvitesProvider provider) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.rejectedContactList.length,
            itemBuilder: (context, index) {
              String currentHeader = provider
                  .rejectedContactList[index].displayName!
                  .capitalize()
                  .substring(0, 1);
              String header = index == 0
                  ? provider.rejectedContactList[index].displayName!
                      .capitalize()
                      .substring(0, 1)
                  : provider.rejectedContactList[index - 1].displayName!
                      .capitalize()
                      .substring(0, 1);
              if (searchBarController.text.isEmpty) {
                return aToZHeader(context, provider, currentHeader, header,
                    index, scaler, friendEmail);
              } else if (provider.rejectedContactList[index].displayName!
                  .toLowerCase()
                  .contains(searchBarController.text)) {
                return contactProfileCard(
                    context,
                    scaler,
                    friendEmail,
                    provider,
                    index,
                    provider.rejectedContactList[index].displayName!);
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  aToZHeader(BuildContext context, RejectedInvitesProvider provider,
      String cHeader, String header, int index, scaler, friendEmail) {
    if (index == 0 ? true : (header != cHeader)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(cHeader).semiBoldText(ColorConstants.colorBlack,
                scaler.getTextSize(9.8), TextAlign.left),
          ),
          contactProfileCard(context, scaler, friendEmail, provider, index,
              provider.rejectedContactList[index].displayName!),
        ],
      );
    } else {
      return contactProfileCard(context, scaler, friendEmail, provider, index,
          provider.rejectedContactList[index].displayName!);
    }
  }

  Widget contactProfileCard(
      BuildContext context,
      ScreenScaler scaler,
      String friendEmail,
      RejectedInvitesProvider provider,
      int index,
      String contactName) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
              context, RoutesConstants.rejectedInvitesDescriptionScreen,
              arguments:
                  UserDetail(firstName: contactName, email: friendEmail));
        },
        child: CommonWidgets.userContactCard(scaler, friendEmail, contactName));
  }
}