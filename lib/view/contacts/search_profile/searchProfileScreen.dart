import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_used.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/search_profile_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class SearchProfileScreen extends StatelessWidget {
  SearchProfileScreen({Key? key}) : super(key: key);
  final searchBarController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context),
        body: BaseView<SearchProfileProvider>(
            onModelReady: (provider) {},
            builder: (builder, provider, _) {
              return SafeArea(
                child: Padding(
                  padding: scaler.getPaddingLTRB(3.0, 0.0, 3.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("search_for_profile".tr()).boldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(16.5),
                          TextAlign.left),
                      SizedBox(height: scaler.getHeight(1.45)),
                      searchBar(context, scaler, provider),
                      SizedBox(height: scaler.getHeight(0.8)),
                      GestureDetector(
                        onTap: () {
                          hideKeyboard(context);
                          if (searchBarController.text.isNotEmpty) {
                            provider.getSearchContacts(
                                context, searchBarController.text);
                            provider.searchValue = true;
                          }
                        },
                        child: DialogHelper.btnWidget(scaler, context,
                            "search".tr(), ColorConstants.primaryColor),
                      ),
                      SizedBox(height: scaler.getHeight(2.8)),
                      provider.state == ViewState.Busy
                          ? Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: CircularProgressIndicator()),
                                    SizedBox(height: scaler.getHeight(1)),
                                    Text("searching_profiles".tr()).mediumText(
                                        ColorConstants.primaryColor,
                                        scaler.getTextSize(11),
                                        TextAlign.left),
                                  ],
                                ),
                              ),
                            )
                          : provider.searchContactList.length == 0 &&
                                  provider.searchValue
                              ? Expanded(
                                  child: Center(
                                    child: Text("sorry_no_profile_found".tr())
                                        .mediumText(
                                            ColorConstants.primaryColor,
                                            scaler.getTextSize(11),
                                            TextAlign.left),
                                  ),
                                )
                              : Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      provider.searchContactList.length == 0 ||
                                              searchBarController.text.isEmpty
                                          ? Container()
                                          : Text("${provider.searchContactList.length}" +
                                                  " " +
                                                  "profiles_found".tr())
                                              .boldText(
                                                  ColorConstants.colorBlack,
                                                  scaler.getTextSize(11),
                                                  TextAlign.left),
                                      SizedBox(height: scaler.getHeight(1)),
                                      searchBarController.text.isEmpty
                                          ? Container()
                                          : contactList(scaler, provider)
                                    ],
                                  ),
                                )
                    ],
                  ),
                ),
              );
            }));
  }

  Widget searchBar(BuildContext context, ScreenScaler scaler,
      SearchProfileProvider provider) {
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
          if (searchBarController.text.isNotEmpty) {
            provider.getSearchContacts(context, data);
            provider.searchValue = true;
          }
        },
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.name,
        onChanged: (value) {
          provider.updateValue(true);
          provider.searchContactList.clear();
          provider.searchValue = false;
        },
      ),
    );
  }

  Widget contactList(ScreenScaler scaler, SearchProfileProvider provider) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.searchContactList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                // onTap: provider.searchContactList[index].status ==
                //             'Listed profile' ||
                //         provider.searchContactList[index].status ==
                //             'Invited contact'
                //     ? () {}
                //     : () {
                //   provider.setContactsValue(provider.searchContactList[index], false, "");
                //         Navigator.pushNamed(
                //             context, RoutesConstants.contactDescription,
                //
                //         );
                //       },
                child: CommonWidgets.userContactCard(
                    scaler,
                    provider.searchContactList[index].email,
                    provider.searchContactList[index].displayName,
                    profileImg: provider.searchContactList[index].photoURL,
                    searchStatus: provider.searchContactList[index].status,
                    search: true, addIconTapAction: () {
                  provider.inviteProfile(_scaffoldKey.currentContext!,
                      provider.searchContactList[index]);
                }),
              );
            }),
      ),
    );
  }
}
