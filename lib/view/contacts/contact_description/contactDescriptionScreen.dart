import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geocoding/geocoding.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/multiple_date_option.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/contact_description_provider.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/home/event_discussion_screen/new_event_discussion_screen.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/organizedEventsCard.dart';
import 'package:provider/provider.dart';

class ContactDescriptionScreen extends StatelessWidget {
  ContactDescriptionScreen({Key? key, required this.showEventScreen, required this.isFromNotification, required this.contactId, required this.isFavouriteContact}) : super(key: key);

  bool showEventScreen;
  bool isFromNotification;
  String contactId;
  bool? isFavouriteContact;
  ContactDescriptionProvider provider = ContactDescriptionProvider();
  EventDetail eventDetail = locator<EventDetail>();
  MultipleDateOption multipleDateOption = locator<MultipleDateOption>();
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return  BaseView<ContactDescriptionProvider>(
      onModelReady: (provider) async {
        this.provider = provider;
        if(isFromNotification == false){
          if(isFavouriteContact == true){
            provider.favouriteSwitch = true;
          } else{
            provider.favouriteSwitch = false;
          }
        }
        isFromNotification == true ? await provider.getContact(context, contactId).then((value) {
          if(value == true){
            if(provider.contactFromInvitation!.other['Favourite'] == true){
              provider.favouriteSwitch = true;
            } else{
              provider.favouriteSwitch = false;
            }
          }
        }) : Container();
      },
        builder: (builder, provider, _) {
          return provider.contact == true ?  Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
                SizedBox(height: scaler.getHeight(1)),
                Text("fetching_contact".tr()).mediumText(
                    ColorConstants.primaryColor,
                    scaler.getTextSize(10),
                    TextAlign.left),
              ],
            ),
          ) : Scaffold(
            backgroundColor: ColorConstants.colorWhite,
            appBar:  provider.userDetail.checkForInvitation! ? DialogHelper.appBarWithBack(scaler, context) : DialogHelper.appBarWithBack(scaler, context, showEdit: true, message: true, messageIconClick: (){
              provider.discussionDetail.title = "${provider.userDetail.firstName} ${provider.userDetail.lastName}";
              provider.discussionDetail.photoUrl = provider.userDetail.profileUrl;
              Navigator.pushNamed(
                  context, RoutesConstants.newEventDiscussionScreen, arguments: NewEventDiscussionScreen(fromContactOrGroup: true, fromChatScreen: false, chatDid: ""));
            }, onTapEvent: (){
              eventDetail.eventPhotoUrl = null;
              eventDetail.editEvent = false;
              eventDetail.contactCIDs = [];
              // clear multi date and time lists
              multipleDateOption.startDate.clear();
              multipleDateOption.endDate.clear();
              multipleDateOption.startTime.clear();
              multipleDateOption.endTime.clear();
              multipleDateOption.startDateTime.clear();
              multipleDateOption.endDateTime.clear();
              multipleDateOption.invitedContacts.clear();
              multipleDateOption.eventAttendingPhotoUrlLists.clear();
              multipleDateOption.eventAttendingKeysList.clear();
              multipleDateOption.multiStartTime = TimeOfDay(hour: 19, minute: 0);
              multipleDateOption.multiEndTime = TimeOfDay(hour: 19, minute: 0).addHour(3);

              eventDetail.isFromContactOrGroupDescription = true;
              eventDetail.contactIdsForEventCreation.add(provider.discussionDetail.userId.toString());
              Navigator.pushNamed(context, RoutesConstants.createEventScreen).then((value) {
                Navigator.of(context).pop(true);
              });
            }),
            body: LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Padding(
                          padding: scaler.getPaddingLTRB(3.0, 0.0, 3.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: scaler.getHeight(2)),
                              CommonWidgets.userDetails(scaler,
                                  profilePic: provider.userDetail.profileUrl ?? null,
                                  firstName: provider.userDetail.firstName == '' ? "" : provider.userDetail.firstName
                                      .toString()
                                      .capitalize(),
                                  lastName: provider.userDetail.lastName == '' ? "" : provider.userDetail.lastName
                                      .toString()
                                      .capitalize(),
                                  email: isFromNotification == true ? provider.email ?? "" :  provider.userDetail.email ?? "",
                                  actionOnEmail: provider.userDetail.checkForInvitation!
                                      ? () {}
                                      : () {
                                    provider.sendingMails(context);
                                  }),
                              SizedBox(height: scaler.getHeight(3.0)),
                              GestureDetector(
                                onTap: () {
                                  provider.userDetail.checkForInvitation!
                                      ? Container()
                                      // : CommonWidgets.bottomSheet(
                                      // context,
                                      // scaler,
                                      // bottomDesign(context, scaler,
                                      //     callClick: () {
                                      //       provider.makePhoneCall(context);
                                      //     }, smsClick: () {
                                      //       provider.sendingSMS(context);
                                      //     }, whatsAppClick: () {
                                      //       provider.openingWhatsApp(context);
                                      //     }));
                                  : bottomDesign(context, scaler,
                                      callClick: () {
                                        provider.makePhoneCall(context);
                                      }, smsClick: () {
                                        provider.sendingSMS(context);
                                      }, whatsAppClick: () {
                                        provider.openingWhatsApp(context);
                                      });
                                },
                                child: CommonWidgets.phoneNoAndAddressFun(
                                    scaler,
                                    ImageConstants.phone_no_icon,
                                    "phone_number".tr(),
                                    provider.userDetail.phone ?? "",
                                    countryCode: true,
                                    cCode: provider.userDetail.countryCode),
                              ),
                              SizedBox(height: scaler.getHeight(2.0)),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: provider.userDetail.address == "" || provider.userDetail.address == null ?  (){} : ()  async {
                                  try{
                                    List<Location> locations = await locationFromAddress(provider.userDetail.address?? "");
                                    print(locations);
                                    provider.launchMap(context, locations[0].latitude, locations[0].longitude);
                                  } on PlatformException catch(err){
                                    DialogHelper.showMessage(context, "could_not_open_map".tr());
                                  } catch(e){
                                    DialogHelper.showMessage(context, "could_not_open_map".tr());
                                  }
                                },
                                child: CommonWidgets.phoneNoAndAddressFun(
                                    scaler,
                                    ImageConstants.address_icon,
                                    "address".tr(),
                                    provider.userDetail.address ?? ""),
                              ),
                              SizedBox(height: scaler.getHeight(2.2)),
                              provider.userDetail.checkForInvitation == true
                                  ? Container() : addToFavourite(context, scaler),
                              // Text("organized_events".tr()).boldText(
                              //     ColorConstants.colorBlack,
                              //     scaler.getTextSize(10),
                              //     TextAlign.left),
                              // SizedBox(height: scaler.getHeight(1.5)),
                            ],
                          ),
                        ),
                        SizedBox(height: scaler.getHeight(3.2)),
                        OrganizedEventsCard(showEventRespondBtn: false, showEventScreen: showEventScreen, contactId: provider.discussionDetail.userId.toString()),
                        provider.userDetail.checkForInvitation!
                            ? provider.state == ViewState.Busy
                            ? Expanded(
                            child: Container(
                                padding: scaler.getPaddingLTRB(
                                    0.0, 0.0, 0.0, 1.0),
                                alignment: Alignment.bottomCenter,
                                child: CircularProgressIndicator()))
                            : Expanded(
                          child: CommonWidgets.expandedRowButton(
                              context,
                              scaler,
                              "reject_invite".tr(),
                              "accept_invite".tr(),
                              btn1: false, onTapBtn1: isFromNotification == true ? (){
                            provider.acceptOrRejectInvitation(context,
                                contactId, false, "Reject");
                          } : () {
                            provider.acceptOrRejectInvitation(context,
                                provider.userDetail.cid!, false, "Reject");
                          }, onTapBtn2:  isFromNotification == true ? (){
                            provider.acceptOrRejectInvitation(context, contactId, true, "Accept");
                          } : () {
                            provider.acceptOrRejectInvitation(context, provider.userDetail.cid!, true, "Accept");
                          }),
                        )
                            : Container(),
                        SizedBox(height: scaler.getHeight(1.5))
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }

  Widget addToFavourite(BuildContext context, ScreenScaler scaler){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("add_to_favourite".tr()).semiBoldText(
            ColorConstants.primaryColor,
            scaler.getTextSize(11.5),
            TextAlign.center),
        FlutterSwitch(
          activeColor: ColorConstants.primaryColor,
          width: scaler.getWidth(11.5),
          height: scaler.getHeight(3.2),
          toggleSize: scaler.getHeight(2.4),
          value: provider.favouriteSwitch,
          borderRadius: 30.0,
          padding: 2.0,
          showOnOff: false,
          onToggle: (val) {
            provider.favouriteSwitch = val;
            provider.addContactToFavourite(context, provider.discussionDetail.userId.toString());
            provider.updateLoadingStatus(true);
          },
        ),
      ],
    );
  }

   bottomDesign(BuildContext context, ScreenScaler scaler,
      {required VoidCallback callClick,
      required VoidCallback smsClick,
      required VoidCallback whatsAppClick}) {
    return showModalBottomSheet(
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircularLR(25.0, 25.0, 0.0, 0.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: scaler.getHeight(0.5)),
                Container(
                  decoration: BoxDecoration(
                      color: ColorConstants.colorMediumGray,
                      borderRadius: scaler.getBorderRadiusCircular(10.0)),
                  height: scaler.getHeight(0.4),
                  width: scaler.getWidth(12),
                ),
                Column(
                  children: [
                    SizedBox(height: scaler.getHeight(2)),
                    GestureDetector(
                      onTap: callClick,
                      child: Text("call".tr()).regularText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(11),
                          TextAlign.center),
                    ),
                    SizedBox(height: scaler.getHeight(0.9)),
                    Divider(),
                    SizedBox(height: scaler.getHeight(0.9)),
                    GestureDetector(
                      onTap: smsClick,
                      child: Text("sms".tr()).regularText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(11),
                          TextAlign.center),
                    ),
                    SizedBox(height: scaler.getHeight(0.9)),
                    Divider(),
                    SizedBox(height: scaler.getHeight(0.9)),
                    GestureDetector(
                      onTap: whatsAppClick,
                      child: Text("whats_app".tr()).regularText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(11),
                          TextAlign.center),
                    ),
                    SizedBox(height: scaler.getHeight(2)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Text("cancel".tr()).semiBoldText(
                        ColorConstants.colorRed,
                        scaler.getTextSize(11),
                        TextAlign.center),
                  ),
                ),
                 SizedBox(height: scaler.getHeight(0.5)),
              ],
            ),
          );
        });
    // return Column(
    //   children: [
    //     Card(
    //       color: ColorConstants.colorWhite.withOpacity(0.7),
    //       shape:
    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    //       child: Column(
    //         children: [
    //           SizedBox(height: scaler.getHeight(1.5)),
    //           GestureDetector(
    //             onTap: callClick,
    //             child: Text("call".tr()).regularText(
    //                 ColorConstants.primaryColor,
    //                 scaler.getTextSize(11),
    //                 TextAlign.center),
    //           ),
    //           SizedBox(height: scaler.getHeight(0.9)),
    //           Divider(),
    //           SizedBox(height: scaler.getHeight(0.9)),
    //           GestureDetector(
    //             onTap: smsClick,
    //             child: Text("sms".tr()).regularText(ColorConstants.primaryColor,
    //                 scaler.getTextSize(11), TextAlign.center),
    //           ),
    //           SizedBox(height: scaler.getHeight(0.9)),
    //           Divider(),
    //           SizedBox(height: scaler.getHeight(0.9)),
    //           GestureDetector(
    //             onTap: whatsAppClick,
    //             child: Text("whats_app".tr()).regularText(
    //                 ColorConstants.primaryColor,
    //                 scaler.getTextSize(11),
    //                 TextAlign.center),
    //           ),
    //           SizedBox(height: scaler.getHeight(1.5)),
    //         ],
    //       ),
    //     ),
    //     CommonWidgets.cancelBtn(scaler, context, 5.0),
    //     SizedBox(height: scaler.getHeight(1)),
    //   ],
    // );
  }
}
