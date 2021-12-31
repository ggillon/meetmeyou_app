import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/profile.dart';
import 'package:meetmeyou_app/provider/event_attending_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';

class EventAttendingScreen extends StatelessWidget {
  EventAttendingScreen({Key? key}) : super(key: key);
  final searchBarController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: DialogHelper.appBarWithBack(scaler, context),
          backgroundColor: ColorConstants.colorWhite,
          body: BaseView<EventAttendingProvider>(
            onModelReady: (provider) {
              provider.getContactsFromProfile(context);
            },
            builder: (context, provider, _) {
              return Padding(
                padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchBar(context, scaler, provider),
                    SizedBox(height: scaler.getHeight(1.2)),
                    Text("attending".tr()).boldText(ColorConstants.colorBlack,
                        scaler.getTextSize(12), TextAlign.center),
                    SizedBox(height: scaler.getHeight(1.0)),
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
                        : eventAttendingList(context, scaler,
                            provider.eventAttendingLists, provider)
                  ],
                ),
              );
            },
          )),
    );
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
            scaler.getTextSize(12), ColorConstants.colorBlack),
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
      child: SingleChildScrollView(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cList.length,
            itemBuilder: (context, index) {
              if (searchBarController.text.isEmpty) {
                return contactProfileCard(
                    context, scaler, cList, index, provider);
              } else if (cList[index]
                  .displayName
                  .toLowerCase()
                  .contains(searchBarController.text)) {
                return contactProfileCard(
                    context, scaler, cList, index, provider);
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  Widget contactProfileCard(BuildContext context, ScreenScaler scaler,
      List<Contact> cList, int index, EventAttendingProvider provider) {
    return CommonWidgets.userContactCard(
        scaler, cList[index].email, cList[index].displayName,
        profileImg: cList[index].photoURL,
        search: true,
        searchStatus: provider.eventDetail.eventBtnStatus == "edit"
            ? "Event Edit"
            : cList[index].status == "Confirmed contact"
                ? ""
                : cList[index].email == provider.userDetail.email
                    ? ""
                    : cList[index].status,
        addIconTapAction: () {
      provider.inviteProfile(context, cList[index]);
    }, deleteIconTapAction: () {
      deleteIconAlertDialog(context, scaler, cList, index, provider);
    });
  }

  deleteIconAlertDialog(BuildContext context, ScreenScaler scaler,
      List<dynamic> cList, int index, EventAttendingProvider provider) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text("remove_attendant".tr()).semiBoldText(
                  ColorConstants.colorBlack,
                  scaler.getTextSize(9.8),
                  TextAlign.center),
              content: Text("remove_attendant_text".tr()).regularText(
                  ColorConstants.colorBlack,
                  scaler.getTextSize(7.9),
                  TextAlign.center),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("cancel".tr()).regularText(
                      ColorConstants.primaryColor,
                      scaler.getTextSize(9.8),
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
                      scaler.getTextSize(9.8),
                      TextAlign.center),
                )
              ],
            ));
  }
}