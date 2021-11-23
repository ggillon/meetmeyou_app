import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/constants/string_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/contacts_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/contacts/onTapContactScreen.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ContactsScreen extends StatelessWidget {
  ContactsScreen({Key? key}) : super(key: key);
  final searchBarController = TextEditingController();
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: BaseView<ContactsProvider>(
          onModelReady: (provider) {
            provider.sortContactList();
          },
          builder: (context, provider, _) {
            return Padding(
              padding: scaler.getPaddingLTRB(2.5, 0.7, 2.5, 2.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("contacts".tr()).semiBoldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(16),
                          TextAlign.left),
                      GestureDetector(
                          onTap: () {
                            CommonWidgets.bottomSheet(context, scaler, bottomDesign(scaler, context));
                          },
                          child: ImageView(path: ImageConstants.more_icon))
                    ],
                  ),
                  SizedBox(height: scaler.getHeight(1)),
                  // searchBar(scaler, provider),
                  // SizedBox(height: scaler.getHeight(1)),
                  allGroupsToggleSwitch(scaler, provider),
                  SizedBox(height: scaler.getHeight(1)),
                  toggle
                      ? contactList(scaler, "16 members", provider)
                      : contactList(scaler, "sample@gmail.com", provider)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget searchBar(ScreenScaler scaler, ContactsProvider provider) {
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

  Widget allGroupsToggleSwitch(ScreenScaler scaler, ContactsProvider provider) {
    return ToggleSwitch(
      minHeight: 30.0,
      minWidth: double.infinity,
      borderColor: [
        ColorConstants.colorMediumGray,
        ColorConstants.colorMediumGray
      ],
      borderWidth: 1.0,
      cornerRadius: 20.0,
      activeBgColors: [
        [ColorConstants.colorWhite],
        [ColorConstants.colorWhite]
      ],
      activeFgColor: ColorConstants.colorBlack,
      inactiveBgColor: ColorConstants.colorMediumGray,
      inactiveFgColor: ColorConstants.colorBlack,
      // initialLabelIndex: 0,
      totalSwitches: 2,
      labels: ["All", "Groups"],
      customTextStyles: [
        TextStyle(
            color: ColorConstants.colorBlack,
            fontFamily: StringConstants.spProDisplay,
            fontWeight: FontWeight.w600,
            fontSize: 8.3),
        TextStyle(
            color: ColorConstants.colorBlack,
            fontFamily: StringConstants.spProDisplay,
            fontWeight: FontWeight.w500,
            fontSize: 8.3)
      ],
      radiusStyle: true,
      onToggle: (index) {
        //  provider.updateToggle();
      },
    );
  }

  Widget contactList(
      ScreenScaler scaler, String friendEmail, ContactsProvider provider) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.myContactListName.length,
            itemBuilder: (context, index) {
              String currentHeader = provider.myContactListName[index]
                  .capitalize()
                  .substring(0, 1);
              String header = index == 0
                  ? provider.myContactListName[index]
                      .capitalize()
                      .substring(0, 1)
                  : provider.myContactListName[index - 1]
                      .capitalize()
                      .substring(0, 1);
              if (searchBarController.text.isEmpty) {
                return aToZHeader(context, provider, currentHeader, header,
                    index, scaler, friendEmail);
              } else if (provider.myContactListName[index]
                  .toLowerCase()
                  .contains(searchBarController.text)) {
                return contactProfileCard(context, scaler, friendEmail,
                    provider, index, provider.myContactListName[index]);
              } else {
                return Container();
              }
            }),
      ),
    );
  }

  aToZHeader(BuildContext context, ContactsProvider provider, String cHeader,
      String header, int index, scaler, friendEmail) {
    if (index == 0 ? true : (header != cHeader)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(cHeader).semiBoldText(ColorConstants.colorBlack,
                scaler.getTextSize(9.8), TextAlign.left),
          ),
          contactProfileCard(context, scaler, friendEmail, provider, index,
              provider.myContactListName[index]),
        ],
      );
    } else {
      return contactProfileCard(context, scaler, friendEmail, provider, index,
          provider.myContactListName[index]);
    }
  }

  Widget contactProfileCard(
      BuildContext context,
      ScreenScaler scaler,
      String friendEmail,
      ContactsProvider provider,
      int index,
      String contactName) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutesConstants.onTapContactScreen,
              arguments: DataToOnTapContactScreen(
                  contactName: provider.myContactListName[index],
                  contactEmail: friendEmail));
        },
        child: CommonWidgets.userContactCard(scaler, friendEmail, contactName));
  }


  Widget bottomDesign(ScreenScaler scaler, BuildContext context) {
    return Column(
      children: [
        Card(
          color: ColorConstants.colorWhite.withOpacity(0.7),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            children: [
              SizedBox(height: scaler.getHeight(1.5)),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
                 Navigator.pushNamed(context, RoutesConstants.searchProfileScreen);
               },
             child: Text("search_for_contact".tr()).regularText(
                   ColorConstants.primaryColor,
                   scaler.getTextSize(11),
                   TextAlign.center),
             ),
              SizedBox(height: scaler.getHeight(0.9)),
              Divider(),
              SizedBox(height: scaler.getHeight(0.9)),
              Text("create_group_of_contacts".tr()).regularText(
                  ColorConstants.primaryColor,
                  scaler.getTextSize(11),
                  TextAlign.center),
              SizedBox(height: scaler.getHeight(1.5)),
            ],
          ),
        ),
        CommonWidgets.cancelBtn(scaler, context),
        SizedBox(height: scaler.getHeight(1)),
      ],
    );
  }


}
