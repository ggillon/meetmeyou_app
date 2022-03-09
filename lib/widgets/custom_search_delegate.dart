import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/models/search_result.dart';
import 'package:meetmeyou_app/provider/custom_search_delegate_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';

class CustomSearchDelegate extends SearchDelegate   {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    // if (query.length < 3) {
    //   return Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Center(
    //         child: Text(
    //           "Search term must be longer than two letters.",
    //         ),
    //       )
    //     ],
    //   );
    // }

   return BaseView<CustomSearchDelegateProvider>(
     onModelReady: (provider){
       provider.search(context, query);
     },
       builder: (context, provider, _){
     return provider.state == ViewState.Busy ?  Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Center(child: CircularProgressIndicator()),
         SizedBox(height: scaler.getHeight(1)),
         Text("searching_data".tr()).mediumText(
             ColorConstants.primaryColor,
             scaler.getTextSize(10),
             TextAlign.left),
       ],
     ) :  Padding(
       padding: scaler.getPaddingAll(10.5),
       child: Column(
         children: <Widget>[
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text("people".tr()).boldText(ColorConstants.colorBlack, 20.0, TextAlign.left),
               Text("see_all".tr()).mediumText(ColorConstants.primaryColor, 15.0, TextAlign.left),
             ],
           ),
           SizedBox(height: scaler.getHeight(1.0)),
           (provider.contactsList.isEmpty || provider.contactsList == null) ? Expanded(
             child: Center(
               child: Text("sorry_no_contacts_found".tr())
                   .mediumText(
                   ColorConstants.primaryColor,
                   scaler.getTextSize(10),
                   TextAlign.left),
             ),
           ) : contactList(scaler, provider)
         ],
       ),
     );
   });


  }

  Widget contactList(ScreenScaler scaler, CustomSearchDelegateProvider provider) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.contactsList.length <= 3 ? provider.contactsList.length : 3,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: provider.contactsList[index].status ==
                            'Listed profile' ||
                        provider.contactsList[index].status ==
                            'Invited contact'
                    ? () {}
                    : () {
                  provider.setContactsValue(provider.contactsList[index]);
                  provider.discussionDetail.userId = provider.contactsList[index].cid;
                        Navigator.pushNamed(
                            context, RoutesConstants.contactDescription,
                        );
                      },
                child: CommonWidgets.userContactCard(
                    scaler,
                    provider.contactsList[index].email,
                    provider.contactsList[index].displayName,
                    profileImg: provider.contactsList[index].photoURL,
                    searchStatus: provider.contactsList[index].status,
                    search: true, addIconTapAction: () {
                  // provider.inviteProfile(_scaffoldKey.currentContext!,
                  //     provider.searchContactList[index]);
                }),
              );
            }),
      ),
    );
  }
    @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
      return Column();
  }
}