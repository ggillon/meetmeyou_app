import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/provider/event_attending_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/contacts/contact_description/contactDescriptionScreen.dart';

class EventAttendingScreen extends StatelessWidget {
  EventAttendingScreen({Key? key}) : super(key: key);
  final searchBarController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: DialogHelper.appBarWithBack(scaler, context),
        backgroundColor: ColorConstants.colorWhite,
        body: BaseView<EventAttendingProvider>(
          onModelReady: (provider) async {
            provider.getContactsFromProfile(context);
            await provider.getEventParam(context, provider.eventDetail.eid.toString(), "AttendanceVisibility");
          },
          builder: (context, provider, _) {
            return SafeArea(
              child: Padding(
                padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchBar(context, scaler, provider),
                    SizedBox(height: scaler.getHeight(1.2)),
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
                        : (provider.eventAttendingLists.isEmpty && provider.eventNotAttendingLists.isEmpty && provider.eventInvitedLists.isEmpty) ?
                    Expanded(
                      child: Center(
                        child: Text("sorry_no_contacts_found".tr()).mediumText(
                            ColorConstants.primaryColor,
                            scaler.getTextSize(11),
                            TextAlign.left)
                      ),
                    )
                        :  Expanded(
                          child: Column(
                            children: [
                              provider.eventAttendingLists.isEmpty ? Container() :   Expanded(
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("attending".tr()).boldText(ColorConstants.colorBlack,
                                        scaler.getTextSize(13), TextAlign.center),
                                    SizedBox(height: scaler.getHeight(1.5)),
                                    eventAttendingList(context, scaler,
                                        provider.eventAttendingLists, provider),
                                  ],
                                ),
                              ),
                             (provider.allowNonAttendingOrInvited || provider.eventDetail.organiserId.toString() == provider.auth.currentUser!.uid.toString()) ?
                             (provider.eventNotAttendingLists.isEmpty ? Container() :  SizedBox(height: scaler.getHeight(1.0))) : Container(),
                              (provider.allowNonAttendingOrInvited || provider.eventDetail.organiserId.toString() == provider.auth.currentUser!.uid.toString()) ?
                              (provider.eventNotAttendingLists.isEmpty ? Container() : Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("not_attending".tr()).boldText(ColorConstants.colorBlack,
                                        scaler.getTextSize(13), TextAlign.center),
                                    SizedBox(height: scaler.getHeight(1.5)),
                                    eventAttendingList(context, scaler,
                                        provider.eventNotAttendingLists, provider),
                                  ],
                                ),
                              )) : Container(),
                              (provider.allowNonAttendingOrInvited || provider.eventDetail.organiserId.toString() == provider.auth.currentUser!.uid.toString())
                                  ?  (provider.eventNotAttendingLists.isEmpty ? Container() : SizedBox(height: scaler.getHeight(1.0))) : Container(),
                              (provider.allowNonAttendingOrInvited || provider.eventDetail.organiserId.toString() == provider.auth.currentUser!.uid.toString())
                                  ? (provider.eventInvitedLists.isEmpty ? Container() :  Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("invited".tr()).boldText(ColorConstants.colorBlack,
                                        scaler.getTextSize(13), TextAlign.center),
                                    SizedBox(height: scaler.getHeight(1.5)),
                                    eventAttendingList(context, scaler,
                                        provider.eventInvitedLists, provider)
                                  ],
                                ),
                              )) : Container(),
                            ],
                          ),
                        )
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget searchBar(BuildContext context, ScreenScaler scaler,
      EventAttendingProvider provider) {
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
        onFieldSubmitted: (data) {},
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.name,
        onChanged: (value) {
          provider.updateSearchValue(true);
        },
      ),
    );
  }

  Widget eventAttendingList(BuildContext context, ScreenScaler scaler,
      List<Contact> cList, EventAttendingProvider provider) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: cList.length,
          itemBuilder: (context, index) {
            bool currentUser = cList[index].uid == provider.auth.currentUser?.uid;
            if (searchBarController.text.isEmpty) {
              return contactProfileCard(
                  context, scaler, cList, index, provider, currentUser);
            } else if (cList[index]
                .displayName
                .toLowerCase()
                .contains(searchBarController.text)) {
              return contactProfileCard(
                  context, scaler, cList, index, provider, currentUser);
            } else {
              return Container();
            }
          }),
    );
  }

  Widget contactProfileCard(BuildContext context, ScreenScaler scaler,
      List<Contact> cList, int index, EventAttendingProvider provider, bool currentUser) {
    return GestureDetector(

        onTap: cList[index].status == 'Listed profile' || cList[index].status =='Invited contact' || cList[index].status == 'Rejected invitation'
            ? () {}
            : () {
          provider.discussionDetail.userId = cList[index].cid;
          provider.setContactsValue(cList[index], false);
                Navigator.pushNamed(
                    context, RoutesConstants.contactDescription, arguments: ContactDescriptionScreen(showEventScreen: false, isFromNotification: false, contactId: "",
                isFavouriteContact: cList[index].other['Favourite'],)
                ).then((value) {
                  // provider.eventAttendingLists.clear();
                  // provider.eventDetail.attendingProfileKeys = provider.eventAttendingKeysList;
                  // provider.getContactsFromProfile(context);
                });
              },

      child: CommonWidgets.userContactCard(
          scaler, cList[index].email, cList[index].displayName,
          profileImg: cList[index].photoURL,
          search: true,
          searchStatus: provider.eventDetail.eventBtnStatus == "edit"
              ? "Event Edit"
              : cList[index].status == "Confirmed contact"
                  ? ""
                  : cList[index].email == provider.auth.currentUser?.email
                      ? ""
                      : cList[index].status,
          addIconTapAction: () {
        provider.inviteProfile(context, cList[index]);
      }, deleteIconTapAction: () {
        deleteIconAlertDialog(context, scaler, cList, index, provider);
      }, currentUser: currentUser, isFavouriteContact: cList[index].other['Favourite']),
    );
  }

  deleteIconAlertDialog(BuildContext context, ScreenScaler scaler,
      List<dynamic> cList, int index, EventAttendingProvider provider) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text("remove_attendant".tr()).semiBoldText(
                  ColorConstants.colorBlack,
                  scaler.getTextSize(10.8),
                  TextAlign.center),
              content: Text("remove_attendant_text".tr()).regularText(
                  ColorConstants.colorBlack,
                  scaler.getTextSize(8.9),
                  TextAlign.center),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("cancel".tr()).regularText(
                      ColorConstants.primaryColor,
                      scaler.getTextSize(10.8),
                      TextAlign.center),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    provider.removeContactsFromEvent(
                        _scaffoldKey.currentContext!, cList[index].cid);
                  },
                  child: Text("remove".tr()).semiBoldText(
                      ColorConstants.primaryColor,
                      scaler.getTextSize(10.8),
                      TextAlign.center),
                )
              ],
            ));
  }
}
