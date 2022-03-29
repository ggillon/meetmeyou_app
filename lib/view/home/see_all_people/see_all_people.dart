import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/discussion_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/see_all_people_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/contacts/contact_description/contactDescriptionScreen.dart';

class SeeAllPeople extends StatelessWidget {
   SeeAllPeople({Key? key, required this.contactsList}) : super(key: key);

  List<Contact> contactsList = [];

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: DialogHelper.appBarWithBack(scaler, context),
      body: BaseView<SeeAllPeopleProvider>(
        builder: (context, provider, _){
          return Padding(
            padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("people".tr()).boldText(ColorConstants.colorBlack,
                    scaler.getTextSize(16), TextAlign.left),
                SizedBox(height: scaler.getHeight(1)),
                contactList(scaler, provider)
              ],
            ),
          );
        },
      )
    );
  }

   Widget contactList(ScreenScaler scaler, SeeAllPeopleProvider provider) {
     return Expanded(
       child: SingleChildScrollView(
         child: ListView.builder(
             physics: NeverScrollableScrollPhysics(),
             shrinkWrap: true,
             itemCount: contactsList.length,
             itemBuilder: (context, index) {
               return GestureDetector(
                 onTap: contactsList[index].status ==
                     'Listed profile' ||
                     contactsList[index].status ==
                         'Invited contact'
                     ? () {}
                     : () {
                   provider.setContactsValue(contactsList[index]);
                   provider.discussionDetail.userId = contactsList[index].cid;
                   Navigator.pushNamed(
                     context, RoutesConstants.contactDescription, arguments: ContactDescriptionScreen(showEventScreen: false, isFromNotification: false, contactId: "")
                   );
                 },
                 child: Column(
                   children: [
                     CommonWidgets.userContactCard(
                         scaler,
                         contactsList[index].email,
                         contactsList[index].displayName,
                         profileImg: contactsList[index].photoURL,
                         searchStatus: contactsList[index].status,
                         search: true, addIconTapAction: () {
                       provider.inviteProfile(context, contactsList[index]);
                     }),
                     SizedBox(height: scaler.getHeight(0.5)),
                   ],
                 ),
               );
             }),
       ),
     );
   }

}
