import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/provider/publication_visibilty_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/animated_toggle.dart';

class PublicationVisibility extends StatefulWidget {
  const PublicationVisibility({Key? key}) : super(key: key);

  @override
  _PublicationVisibilityState createState() => _PublicationVisibilityState();
}

class _PublicationVisibilityState extends State<PublicationVisibility> with TickerProviderStateMixin{

  final searchBarController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);

    return Scaffold(
      appBar: DialogHelper.appBarWithBack(scaler, context),
      backgroundColor: ColorConstants.colorWhite,
      body: BaseView<PublicationVisibilityProvider>(
        onModelReady: (provider){
          provider.tabController = TabController(length: 3, vsync: this);
          provider.getConfirmedContactsList(context);
          provider.tabChangeEvent(context);
          provider.contactsKeys.addAll(provider.announcementDetail.contactCIDs);
        },
        builder: (context, provider, _){
          return SafeArea(
            child: Padding(
              padding: scaler.getPaddingLTRB(3.0, 0, 3.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("visibility".tr()).boldText(
                      ColorConstants.colorBlack,
                      scaler.getTextSize(16),
                      TextAlign.left),
                  SizedBox(height: scaler.getHeight(1.5)),
                  Text("publication_visibility".tr()).semiBoldText(
                      ColorConstants.colorBlack,
                      scaler.getTextSize(12.5),
                      TextAlign.left),
                  SizedBox(height: scaler.getHeight(3.0)),
                  TabBar(
                    controller: provider.tabController,
                    tabs: [
                      Text("all_contacts".tr()).semiBoldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(11),
                          TextAlign.center),
                      Text("favourite_contacts".tr()).semiBoldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(11),
                          TextAlign.center),
                      Text("manually_select".tr()).semiBoldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(11),
                          TextAlign.center)
                    ],
                    labelPadding: scaler.getPaddingLTRB(0.0, 0.0, 0.0, 1.0),
                  ),
                  SizedBox(height: scaler.getHeight(2.2)),
                  Expanded(child: TabBarView(
                    controller: provider.tabController,
                    children: [
                      allContactsTabBar(scaler, provider),
                      provider.confirmContactList.length == 0
                          ? Expanded(
                        child: Center(
                          child: Text("sorry_no_contacts_found".tr())
                              .mediumText(
                              ColorConstants.primaryColor,
                              scaler.getTextSize(11),
                              TextAlign.left),
                        ),
                      )
                          : SingleChildScrollView(child: contactList(scaler, provider.favouriteContactList, provider)),
                      manuallySelectTabBar(scaler, provider)
                    ],
                  )),
                  SizedBox(height: scaler.getHeight(1)),
            provider.state == ViewState.Busy ? Container() : (provider.inviteContacts == true ? Center(child: CircularProgressIndicator()) : Container(
                    child: DialogHelper.btnWidget(
                        scaler,
                        context,
                        "save_publication".tr(),
                        ColorConstants.primaryColor, funOnTap: () {
                          if(provider.tabController!.index == 0){
                            provider.inviteAllContacts(context, provider.announcementDetail.announcementId.toString());
                          } else if(provider.tabController!.index == 1){
                            provider.inviteAllFavourites(context, provider.announcementDetail.announcementId.toString());
                          } else{
                            if (provider.announcementDetail.contactCIDs.isNotEmpty ||
                                provider.announcementDetail.groupIndexList.isNotEmpty) {
                              Navigator.of(context).pop();
                            } else {
                              DialogHelper.showMessage(
                                  context, "please_select_contacts_to_Invite".tr());
                            }
                          }
                    }),
                  ))
                ],
              ),
            ),
          );
        },
      )
    );
  }

  Widget allContactsTabBar(ScreenScaler scaler, PublicationVisibilityProvider provider){
    return provider.state == ViewState.Busy
        ? Column(
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
        )
        : provider.confirmContactList.length == 0
        ? Center(
          child: Text("sorry_no_contacts_found".tr())
              .mediumText(
              ColorConstants.primaryColor,
              scaler.getTextSize(11),
              TextAlign.left),
        )
        : SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              SizedBox(height: scaler.getHeight(1)),
              provider.confirmContactList.length == 0
                  ? Container()
                  : contactList(scaler, provider.confirmContactList, provider)
            ],
          ),
        );
  }

  Widget manuallySelectTabBar(ScreenScaler scaler, PublicationVisibilityProvider provider){
    return  Column(
      children: [
        searchBar(scaler, provider),
        SizedBox(height: scaler.getHeight(1.2)),
        AnimatedToggle(
          values: ['all'.tr(), 'groups'.tr()],
          onToggleCallback: (value) {
            provider.toggle = value;
            if (value == 0) {
              provider.contactsKeys =
                  provider.announcementDetail.contactCIDs;
              provider.getConfirmedContactsList(context);
            } else {
              provider.contactsKeys =
                  provider.announcementDetail.contactCIDs;
              provider.getGroupList(context);
            }
            provider.updateLoadingStatus(true);

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
                  scaler.getTextSize(11),
                  TextAlign.left),
            ],
          ),
        )
            : provider.confirmContactList.length == 0
            ? Expanded(
          child: Center(
            child: Text("sorry_no_contacts_found".tr())
                .mediumText(
                ColorConstants.primaryColor,
                scaler.getTextSize(11),
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
                provider.confirmContactList.length == 0
                    ? Container()
                    : contactList(
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
                  scaler.getTextSize(11),
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
                scaler.getTextSize(11),
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
                contactList(scaler,
                    provider.groupList, provider),
              ],
            ),
          ),),
      ],
    );
  }

  Widget inviteContactProfileCard(
      BuildContext context,
      ScreenScaler scaler,
      List<Contact> contactOrGroupList,
      int index,
      PublicationVisibilityProvider provider) {
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
                CommonWidgets.profileCardImageDesign(
                    scaler, contactOrGroupList[index].photoURL),
                SizedBox(width: scaler.getWidth(2.5)),
                CommonWidgets.profileCardNameAndEmailDesign(
                    scaler,
                    contactOrGroupList[index].displayName,
                    provider.toggle == 0
                        ? contactOrGroupList[index].email
                        : contactOrGroupList[index].group.length.toString() +
                        " " +
                        "members".tr()),
                provider.toggle == 0
                    ? Container(
                  width: scaler.getWidth(8),
                  height: scaler.getHeight(3.5),
                  alignment: Alignment.center,
                  child: provider.value[index] == true
                      ? Container(
                      height: scaler.getHeight(2),
                      width: scaler.getWidth(4.5),
                      child: CircularProgressIndicator())
                      : Checkbox(
                    value: provider.contactCheckIsSelected(
                        provider.confirmContactList[index]),
                    onChanged: (bool? value) {
                      if (value!) {
                        provider.inviteContactToEvent(
                            context,
                            provider.confirmContactList[index].cid,
                            index);
                      } else {
                        provider.removeContactFromEvent(
                            context,
                            provider.confirmContactList[index].cid,
                            index);
                      }
                    },
                  ),
                )
                    : Container(
                    width: scaler.getWidth(8),
                    height: scaler.getHeight(3.5),
                    alignment: Alignment.center,
                    child: provider.value[index] == true
                        ? Container(
                        height: scaler.getHeight(2),
                        width: scaler.getWidth(4.5),
                        child: CircularProgressIndicator())
                        : Checkbox(
                      value: provider.announcementDetail.editAnnouncement == true
                          ? provider.groupCheck(
                          contactOrGroupList[index], index)
                          : provider.groupCheckIsSelected(index),
                      onChanged: (bool? value) {
                        if (value!) {
                          List<String> keysList = [];
                          for (var key in provider
                              .groupList[index].group.keys) {
                            keysList.add(key);
                          }

                          provider.inviteGroupToEvent(
                              context,
                              keysList,
                              index,
                              provider.groupList[index]);
                        } else {
                          List<String> keysList = [];
                          for (var key in provider
                              .groupList[index].group.keys) {
                            keysList.add(key);
                          }

                          provider.removeGroupFromEvent(
                              context,
                              keysList,
                              index,
                              provider.groupList[index]);
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
        SizedBox(height: scaler.getHeight(0.5)),
      ],
    );
  }

  Widget searchBar(ScreenScaler scaler, PublicationVisibilityProvider provider) {
    return Card(
      color: ColorConstants.colorWhite,
      elevation: 3.0,
      shadowColor: ColorConstants.colorWhite,
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(11)),
      child: TextFormField(
        controller: searchBarController,
        style: ViewDecoration.textFieldStyle(
            scaler.getTextSize(13), ColorConstants.colorBlack),
        decoration: ViewDecoration.inputDecorationForSearchBox(
            "search_field_name".tr(), scaler),
        onFieldSubmitted: (data) {
          // FocusScope.of(context).requestFocus(nodes[1]);
        },
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.name,
        onChanged: (value) {
          provider.updateLoadingStatus(true);
        },
      ),
    );
  }

  Widget contactList(ScreenScaler scaler, List<Contact> cList,
      PublicationVisibilityProvider provider) {
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
            return  provider.isManuallyList ? inviteContactProfileCard(context, scaler, cList, index, provider
            ) :  contactProfileCard(context, scaler, cList, index, provider);
          } else {
            return Container();
          }

        });
  }

  aToZHeader(BuildContext context, String cHeader, String header, int index,
      scaler, List<Contact> cList, PublicationVisibilityProvider provider) {
    if (index == 0 ? true : (header != cHeader)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(cHeader).semiBoldText(ColorConstants.colorBlack,
                scaler.getTextSize(10.8), TextAlign.left),
          ),
       provider.isManuallyList ? inviteContactProfileCard(context, scaler, cList, index, provider
       ) :  contactProfileCard(context, scaler, cList, index, provider)
        ],
      );
    } else {
      return  provider.isManuallyList ? inviteContactProfileCard(context, scaler, cList, index, provider
      ) :  contactProfileCard(context, scaler, cList, index, provider);
    }
  }


  Widget contactProfileCard(BuildContext context, ScreenScaler scaler,
      List<Contact> cList, int index, PublicationVisibilityProvider provider,) {
  return GestureDetector(
        onTap: () {},
        child: CommonWidgets.userContactCard(
            scaler, cList[index].email, cList[index].displayName,
            profileImg: cList[index].photoURL, isFavouriteContact: cList[index].other['Favourite']));
  }

}
