import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/group_description_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';

class GroupDescriptionScreen extends StatelessWidget {
  const GroupDescriptionScreen({Key? key, required this.userDetail})
      : super(key: key);
  final UserDetail userDetail;

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorConstants.colorWhite,
          appBar: DialogHelper.appBarWithBack(scaler, context, showEdit: true,
              editClick: () {
            Navigator.pushNamed(context, RoutesConstants.createEditGroupScreen);
          }),
          body: BaseView<GroupDescriptionProvider>(
            onModelReady: (provider) {
              provider.getGroupContactsList(context, userDetail.group!);
            },
            builder: (builder, provider, _) {
              return Padding(
                padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: scaler.getHeight(1.0)),
                    CommonWidgets.userDetails(scaler,
                        profilePic: userDetail.profileUrl,
                        firstName: userDetail.firstName,
                        lastName: "",
                        email: userDetail.about),
                    SizedBox(height: scaler.getHeight(1.5)),
                    userDetail.membersLength == 0.toString() ||
                            userDetail.membersLength == null
                        ? Container()
                        : Text("${userDetail.membersLength}" +
                                " " +
                                "contacts_in_group".tr())
                            .boldText(ColorConstants.colorBlack,
                                scaler.getTextSize(10), TextAlign.left),
                    SizedBox(height: scaler.getHeight(1.5)),
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
                        : provider.groupContactList.length == 0
                            ? Expanded(
                                child: Center(
                                  child: Text("please_add_members_in_your_group"
                                          .tr())
                                      .mediumText(
                                          ColorConstants.primaryColor,
                                          scaler.getTextSize(10),
                                          TextAlign.left),
                                ),
                              )
                            : Expanded(
                                child: SingleChildScrollView(
                                  child: confirmContactList(scaler,
                                      provider.groupContactList, provider),
                                ),
                              )
                  ],
                ),
              );
            },
          )),
    );
  }

  Widget confirmContactList(ScreenScaler scaler, List<Contact> cList,
      GroupDescriptionProvider provider) {
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

          return aToZHeader(
              context, currentHeader, header, index, scaler, cList, provider);
        });
  }

  aToZHeader(BuildContext context, String cHeader, String header, int index,
      scaler, List<Contact> cList, GroupDescriptionProvider provider) {
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
      List<Contact> cList, int index, GroupDescriptionProvider provider) {
    return GestureDetector(
        onTap: () {},
        child: CommonWidgets.userContactCard(
            scaler, cList[index].email, cList[index].displayName,
            profileImg: cList[index].photoURL));
  }
}
