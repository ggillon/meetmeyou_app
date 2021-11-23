import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/search_profile_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';

class SearchProfileScreen extends StatelessWidget {
  SearchProfileScreen({Key? key}) : super(key: key);
  final searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorConstants.colorWhite,
          appBar: DialogHelper.appBarWithBack(scaler, context),
          body: BaseView<SearchProfileProvider>(
              onModelReady: (provider) {
                provider.searchList =
                    provider.myContactListName.where((element) {
                      return element
                          .toLowerCase()
                          .contains(searchBarController.text);
                    });
              },
              builder: (builder, provider, _) {
                return Padding(
                  padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("search_for_profile".tr()).boldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(16),
                          TextAlign.left),
                      SizedBox(height: scaler.getHeight(1)),
                      searchBar(scaler, provider),
                      SizedBox(height: scaler.getHeight(0.5)),
                      DialogHelper.btnWidget(scaler, context, "search".tr(),
                          ColorConstants.primaryColor),
                      SizedBox(height: scaler.getHeight(2.5)),
                      searchBarController.text.isEmpty ||
                              provider.searchList.length == 0
                          ? Container()
                          : Text("${provider.searchList.length}" +
                                  " " +
                                  "profiles_found".tr())
                              .boldText(ColorConstants.colorBlack,
                                  scaler.getTextSize(10), TextAlign.left),
                      SizedBox(height: scaler.getHeight(1)),
                      contactList(scaler, "sample@sample.com", provider)
                    ],
                  ),
                );
              })),
    );
  }

  Widget searchBar(ScreenScaler scaler, SearchProfileProvider provider) {
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
      ScreenScaler scaler, String friendEmail, SearchProfileProvider provider) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.myContactListName.length,
            itemBuilder: (context, index) {
              if (searchBarController.text.isEmpty) {
                return Container();
              } else if (provider.myContactListName[index]
                  .toLowerCase()
                  .contains(searchBarController.text)) {
                return CommonWidgets.userContactCard(
                    scaler, friendEmail, provider.myContactListName[index]);
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
