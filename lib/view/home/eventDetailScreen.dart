import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_stack/image_stack.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/date_option.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/provider/event_detail_provider.dart';
import 'package:meetmeyou_app/view/add_event/event_invite_friends_screen/eventInviteFriendsScreen.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/contacts/contact_description/contactDescriptionScreen.dart';
import 'package:meetmeyou_app/view/dashboard/dashboardPage.dart';
import 'package:meetmeyou_app/view/home/event_discussion_screen/new_event_discussion_screen.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/custom_stack.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/widgets/shimmer/multiDateAttendDateCardShimmer.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class EventDetailScreen extends StatelessWidget {
  // final Event event;
  final answer1Controller = TextEditingController();
  final answer2Controller = TextEditingController();
  final answer3Controller = TextEditingController();
  final answer4Controller = TextEditingController();
  final answer5Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  EventDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    // final dashBoardProvider = Provider.of<DashboardProvider>(context, listen: false);
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      key: _scaffoldkey,
      body: BaseView<EventDetailProvider>(
        onModelReady: (provider) async {
         // provider.getPhotoAlbum(context, provider.eventDetail.eid.toString());
          provider.calendarDetail.fromAnotherPage == true
              ? Container()
              : await provider.getEventParam(context, provider.eventDetail.eid.toString(), "photoAlbum", true);
           provider.calendarDetail.fromAnotherPage == true
               ? Container()
               : (provider.eventDetail.event!.eventType == EVENT_TYPE_PRIVATE ? Container() :
         await provider.getEventParam(context, provider.eventDetail.eid.toString(), "discussion", false));
          provider.calendarDetail.fromAnotherPage == true
              ? Container()
              :  provider.eventDetail.organiserId == provider.auth.currentUser?.uid ? Container() : provider.getOrganiserContact(context);
          // provider.calendarDetail.fromDeepLink == false
          //     ? Container() : provider.inviteUrl(context, provider.eventDetail.eid!);
          provider.calendarDetail.fromAnotherPage == true
              ? Container()
              : provider.eventGoingLength();
          provider.calendarDetail.fromAnotherPage == true
              ? Container()
              : provider.getUsersProfileUrl(context);
          provider.calendarDetail.fromAnotherPage == true
              ? Container()
              : provider.getOrganiserProfileUrl(
                  context, provider.eventDetail.organiserId!);
          provider.calendarDetail.fromAnotherPage == true
              ? await provider.getEvent(context, provider.eventDetail.eid!)
              : Container();
          provider.eventDetail.event?.multipleDates == true
              ? provider.getMultipleDateOptionsFromEvent(
                  context, provider.eventDetail.eid!,
                  onBtnClick: false)
              : Container();
          provider.eventDetail.event?.multipleDates == true
              ? provider.listOfDateSelected(context, provider.eventDetail.eid!).then((value) {
              // if(provider.didsOfMultiDateSelected.length == 0){
              //   provider.eventDetail.eventBtnStatus = "Not Going";
              //   provider.eventDetail.btnBGColor = ColorConstants.primaryColor.withOpacity(0.1);
              //   provider.eventDetail.textColor = ColorConstants.primaryColor;
              // } else if(provider.didsOfMultiDateSelected.length > 0){
              //   provider.eventDetail.eventBtnStatus = "Going";
              //   provider.eventDetail.btnBGColor = ColorConstants.primaryColor.withOpacity(0.1);
              //   provider.eventDetail.textColor = ColorConstants.primaryColor;
              // }
          })
              : Container();
         // print(provider.eventDetail.eid.toString());

          // If event is deleted or event value is null on get event api.
          if(provider.mayBeEventDeleted == true){
            Future.delayed(Duration(seconds: 5)).then((_) {
              Navigator.of(context).pop();
            });
          }
        },
        builder: (context, provider, _) {
          return (provider.calendarDetail.fromAnotherPage == true &&
                  provider.eventValue == true)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                    SizedBox(height: scaler.getHeight(1)),
                    Text("fetching_event".tr()).mediumText(
                        ColorConstants.primaryColor,
                        scaler.getTextSize(10),
                        TextAlign.left),
                  ],
                )
              : (provider.calendarDetail.fromAnotherPage == true && provider.mayBeEventDeleted == true) ?
          Padding(
            padding: scaler.getPaddingAll(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: scaler.getHeight(18)),
                ImageView(path: ImageConstants.splash, color: ColorConstants.primaryColor,),
                SizedBox(height: scaler.getHeight(5)),
                Text("event_deleted".tr()).boldText(
                    ColorConstants.primaryColor,
                    scaler.getTextSize(12.5),
                    TextAlign.left),
              ],
            ),
          )
              : SingleChildScrollView(
                  child: Column(children: [
                    Stack2(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      imageView(context, scaler, provider),
                      Positioned(
                        bottom: -scaler.getHeight(6.5),
                        child: titleDateLocationCard(context, scaler, provider),
                      )
                    ],
                  ),
                    provider.eventDetail.event!.multipleDates == true ? SizedBox(height: scaler.getHeight(1.8)) : Platform.isIOS ? SizedBox(height: scaler.getHeight(1.8)) : SizedBox(height: scaler.getHeight(3.5)),
                  SafeArea(
                    child: Padding(
                      padding: scaler.getPaddingLTRB(4.5, 2.5, 4.5, 1.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                       if (provider.value == true ||
                              provider.getMultipleDate == true)
                            Center(child: CircularProgressIndicator())
                          else
                          provider.eventDetail.isPastEvent == true ? CommonWidgets.commonBtn(scaler, context, "hide".tr(), ColorConstants.primaryColor, ColorConstants.colorWhite,
                          onTapFun: (){
                            CommonWidgets.respondToEventBottomSheet(
                                context, scaler, hide: () {
                              Navigator.of(context).pop();
                              provider.replyToEvent(
                                  context,
                                  provider.eventDetail.eid!,
                                  EVENT_NOT_INTERESTED);
                            }, pastEventOrAnnouncement: true);
                          }
                          )  : (provider.eventDetail.event!.multipleDates == true &&
                                 provider.eventDetail.event!.organiserID != provider.auth.currentUser!.uid) ? Container() : CommonWidgets.commonBtn(
                                scaler,
                                context,
                                 provider.eventDetail.eventBtnStatus?.tr() ?? "Respond",
                                 provider.eventDetail.btnBGColor ?? ColorConstants.primaryColor,
                                 provider.eventDetail.textColor ?? ColorConstants.colorWhite, onTapFun: () {
                              if (provider.eventDetail.eventBtnStatus ==
                                      "respond" ||
                                  provider.eventDetail.eventBtnStatus ==
                                      "going" ||
                                  provider.eventDetail.eventBtnStatus ==
                                      "not_going" ||
                                  provider.eventDetail.eventBtnStatus ==
                                      "hidden") {
                                CommonWidgets.respondToEventBottomSheet(
                                    context, scaler, going: () {
                                  // if (provider
                                  //         .eventDetail.event!.multipleDates ==
                                  //     true) {
                                  //   provider
                                  //       .getMultipleDateOptionsFromEvent(
                                  //           context,
                                  //           provider.eventDetail.event!.eid)
                                  //       .then((value) {
                                  //     // Navigator.of(context).pop();
                                  //     alertForMultiDateAnswers(context, scaler,
                                  //         provider.multipleDate, provider);
                                  //   });
                                  // } else
                                  //   {
                                  if (provider
                                      .eventDetail.event!.form.isNotEmpty) {
                                    List<String> questionsList = [];
                                    for (var value in provider
                                        .eventDetail.event!.form.values) {
                                      questionsList.add(value);
                                    }
                                    Navigator.of(context).pop();
                                    alertForQuestionnaireAnswers(
                                        _scaffoldkey.currentContext!,
                                        scaler,
                                        questionsList,
                                        provider);
                                  } else {
                                    Navigator.of(context).pop();
                                    provider.replyToEvent(
                                        context,
                                        provider.eventDetail.eid!,
                                        EVENT_ATTENDING);
                                  }
                                  // }
                                }, notGoing: () {
                                  Navigator.of(context).pop();
                                  provider.replyToEvent(
                                      context,
                                      provider.eventDetail.eid!,
                                      EVENT_NOT_ATTENDING);
                                }, hide: () {
                                  Navigator.of(context).pop();
                                  provider.replyToEvent(
                                      context,
                                      provider.eventDetail.eid!,
                                      EVENT_NOT_INTERESTED);
                                });
                              } else if (provider.eventDetail.eventBtnStatus ==
                                  "edit") {
                                // provider.setEventValuesForEdit(event);
                                if(provider.eventDetail.event!.eventType.toString() == EVENT_TYPE_ANNOUNCEMENT){
                                  provider.setEventValuesForAnnouncementEdit(provider.eventDetail.event!);
                                  Navigator.pushNamed(
                                      context, RoutesConstants.createAnnouncementScreen)
                                      .then((value) async {
                                    provider.eventDetail.eventBtnStatus = value as String? ?? "edit";
                                    await provider.getEventParam(context, provider.eventDetail.eid.toString(), "photoAlbum", true);
                                    await provider.getEventParam(context, provider.eventDetail.eid.toString(), "discussion", false);
                                    provider.updateBackValue(true);
                                  });
                                } else{
                                  provider.clearMultiDateOption();
                                  Navigator.pushNamed(context,
                                      RoutesConstants.createEventScreen)
                                      .then((value) async {
                                    provider.eventDetail.eventBtnStatus = value as String? ?? "edit";
                                    await provider.getEventParam(context, provider.eventDetail.eid.toString(), "photoAlbum", true);
                                    provider.updateBackValue(true);
                                  });
                                }
                              } else if (provider.eventDetail.eventBtnStatus ==
                                  "cancelled") {
                                if (provider.auth.currentUser!.uid ==
                                    provider.eventDetail.organiserId!) {
                                  CommonWidgets.eventCancelBottomSheet(
                                      context, scaler, delete: () {
                                    Navigator.of(context).pop();
                                    provider.deleteEvent(context,
                                        provider.eventDetail.eid.toString());
                                  });
                                } else {
                                  Container();
                                }
                              } else if (provider.eventDetail.eventBtnStatus == "hide") {
                                CommonWidgets.respondToEventBottomSheet(
                                    context, scaler, hide: () {
                                  Navigator.of(context).pop();
                                  provider.replyToEvent(
                                      context,
                                      provider.eventDetail.eid!,
                                      EVENT_NOT_INTERESTED);
                                }, pastEventOrAnnouncement: true);
                              }
                              else {
                                Container();
                              }
                            }),
                          SizedBox(height: scaler.getHeight(2.0)),
                     provider.eventDetail.organiserId == provider.auth.currentUser?.uid ? manageInvitationCardCard(context, scaler, provider)
                     : (provider.contact == true ? Center(child: CircularProgressIndicator()) : organiserCard(context, scaler, provider)),
                          SizedBox(height: scaler.getHeight(2)),
                          provider.eventAttendingLength == 0
                              ? Container()
                              : Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: provider.eventDetail.event!.multipleDates == true ? (){
                                        Navigator.pushNamed(context, RoutesConstants.checkAttendanceScreen);
                                      } : () {
                                        provider.eventDetail.attendingProfileKeys =
                                            provider.eventAttendingKeysList;
                                      // provider.eventDetail.organiserId == provider.auth.currentUser?.uid ?  Navigator.pushNamed(
                                      //     context,
                                      //     RoutesConstants
                                      //         .eventInviteFriendsScreen, arguments: EventInviteFriendsScreen(fromDiscussion: false, discussionId: "")).then((value) {
                                      //           Navigator.of(context).pop();
                                      // }) :
                                      Navigator.pushNamed(
                                            context,
                                            RoutesConstants
                                                .eventAttendingScreen)
                                            .then((value) {
                                              provider.eventAttendingKeysList.clear();
                                              provider.eventGoingLength();
                                              provider.eventDetail.attendingProfileKeys = provider.eventAttendingKeysList;
                                          // provider.eventAttendingLength = (provider
                                          //     .eventDetail
                                          //     .attendingProfileKeys
                                          //     ?.length ??
                                          //     0);
                                          // provider.eventAttendingKeysList = provider
                                          //     .eventDetail.attendingProfileKeys!;
                                          // provider.eventAttendingPhotoUrlLists = [];
                                          // provider.getUsersProfileUrl(context);
                                          provider.updateBackValue(true);
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Stack(
                                            alignment: Alignment.centerRight,
                                            clipBehavior: Clip.none,
                                            children: [
                                              ImageStack(
                                                imageList: provider
                                                    .eventAttendingPhotoUrlLists,
                                                totalCount: provider
                                                    .eventAttendingPhotoUrlLists
                                                    .length,
                                                imageRadius: 25,
                                                imageCount: provider
                                                    .imageStackLength(provider
                                                        .eventAttendingPhotoUrlLists
                                                        .length),
                                                imageBorderColor:
                                                    ColorConstants.colorWhite,
                                                backgroundColor:
                                                    ColorConstants.primaryColor,
                                                imageBorderWidth: 1,
                                                extraCountTextStyle: TextStyle(
                                                    fontSize: 7.7,
                                                    color:
                                                        ColorConstants.colorWhite,
                                                    fontWeight: FontWeight.w500),
                                                showTotalCount: false,
                                              ),
                                              Positioned(
                                                right: -22,
                                                child: provider
                                                            .eventAttendingPhotoUrlLists
                                                            .length <=
                                                        6
                                                    ? Container()
                                                    : ClipRRect(
                                                        borderRadius: scaler
                                                            .getBorderRadiusCircular(
                                                                15.0),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          color: ColorConstants
                                                              .primaryColor,
                                                          height: scaler
                                                              .getHeight(2.0),
                                                          width:
                                                              scaler.getWidth(6),
                                                          child: Text((provider
                                                                          .eventAttendingPhotoUrlLists
                                                                          .length -
                                                                      6)
                                                                  .toString())
                                                              .mediumText(
                                                                  ColorConstants
                                                                      .colorWhite,
                                                                  scaler
                                                                      .getTextSize(
                                                                          7.7),
                                                                  TextAlign
                                                                      .center),
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                          provider.eventAttendingPhotoUrlLists
                                              .length <=
                                              6
                                              ? SizedBox(
                                              width: scaler.getWidth(1))
                                              : SizedBox(
                                              width: scaler.getWidth(6)),
                                          Text(provider.eventDetail.event!.multipleDates == true ? "check_attendance".tr() : "attending".tr()).regularText(
                                              ColorConstants.colorGray,
                                              scaler.getTextSize(9),
                                              TextAlign.center),
                                        ],
                                      ),
                                    ),
                                    provider.eventDetail.isPastEvent == true ? Container() :
                                    provider.auth.currentUser!.uid == provider.eventDetail.organiserId && provider.eventDetail.eventBtnStatus ==
                                        "edit" ? Expanded(child: Container(
                                      alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                            onTap: () async {
                                              // String shareLink = provider.mmyEngine!.getEventText(provider.eventDetail.eid!);
                                              // Share.share(shareLink);
                                              String eventLink = provider.mmyEngine!.getEventLink(provider.eventDetail.eid!);
                                              await provider.dynamicLinksApi.createLink(context, eventLink).then((value) {
                                                String shareLink = provider.dynamicLinksApi.dynamicUrl.toString();
                                                String fid = shareLink.split("https://meetmeyou.page.link/")[1];
                                                //Share.share("Please find link to the event I’m organising: https://meetmeyou.com/event?eid=${provider.eventDetail.eid!}&fid=${fid}");
                                                //    Share.share("Please find link to the event I’m organising: ${shareLink}");
                                                Share.share("Please find link to the event I’m organising: https://meetmeyou.com/event?eid=${provider.eventDetail.eid!}");
                                              });
                                            },
                                            child: ImageView(path: ImageConstants.share_icon)))) : Container()
                                  ],
                                ),
                              ),
                          SizedBox(height: scaler.getHeight(1.5)),
                          provider.eventDetail.isPastEvent == true ? Container() : provider.eventDetail.event?.multipleDates == true &&
                                  provider.eventDetail.organiserId !=
                                      provider.auth.currentUser!.uid
                              ?
                          provider.statusMultiDate == true
                                  ? MultiDateAttendDateCardShimmer()
                                  :
                          attendDateUi(context, scaler, provider)
                              : Container(),
                          SizedBox(height: scaler.getHeight(1.5)),
                          Text("event_description".tr()).boldText(
                              ColorConstants.colorBlack,
                              scaler.getTextSize(10.8),
                              TextAlign.left),
                          SizedBox(height: scaler.getHeight(2)),
                          Text(provider.eventDetail.eventDescription ?? "")
                              .regularText(ColorConstants.colorBlack,
                                  scaler.getTextSize(10.5), TextAlign.left),
                          SizedBox(height: scaler.getHeight(3.5)),
                          provider.eventDetail.event!.eventType == EVENT_TYPE_PRIVATE ? eventDiscussionCard(context, scaler) :
                          (provider.discussionEnable == true ?  eventDiscussionCard(context, scaler) : Container()),
                          provider.photoGalleryEnable == true ?  SizedBox(height: scaler.getHeight(2.0)) : Container(),
                          provider.photoGalleryEnable == true ?  photoGalleryCard(context, scaler) : Container(),
                          SizedBox(height: scaler.getHeight(6.0)),
                          Align(
                            alignment: Alignment.center,
                            child: Text(provider.eventDetail.eid.toString()).regularText(
                                ColorConstants.colorGray,
                                scaler.getTextSize(10.8),
                                TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          )
                        ],
                      ),
                    ),
                  )
                ]));
        },
      ),
    );
  }

  Widget imageView(
      BuildContext context, ScreenScaler scaler, EventDetailProvider provider) {
    return Card(
      margin: scaler.getMarginAll(0.0),
      shadowColor: ColorConstants.colorWhite,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircularLR(0.0, 0.0, 16, 16)),
      color: ColorConstants.colorLightGray,
      child: Container(
        height: scaler.getHeight(34.5),
        width: double.infinity,
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      scaler.getBorderRadiusCircularLR(0.0, 0.0, 16, 16),
                  child: provider.eventDetail.photoUrlEvent == null ||
                          provider.eventDetail.photoUrlEvent == ""
                      ? Container(
                          color: ColorConstants.primaryColor,
                          height: scaler.getHeight(34.5),
                          width: double.infinity,
                        )
                      : ImageView(
                          path: provider.eventDetail.photoUrlEvent,
                          fit: BoxFit.cover,
                          height: scaler.getHeight(34.5),
                          width: double.infinity,
                        ),
                ),
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      //  provider.calendarDetail.fromCalendarPage == true ? Navigator.of(context).popUntil((route) => route.isFirst) : Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        padding: scaler.getPaddingLTRB(3.0, 4.0, 3.0, 0.0),
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ImageView(
                                path: ImageConstants.back,
                                color: ColorConstants.colorWhite),
                            ImageView(
                                path: ImageConstants.close_icon,
                                color: ColorConstants.colorWhite),
                          ],
                        )),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bool showText = true;

  Widget titleDateLocationCard(BuildContext context,
      ScreenScaler scaler, EventDetailProvider provider) {
    return Padding(
      padding: scaler.getPaddingLTRB(1.0, 0.0, 1.0, 0.0),
      child: Card(
          shadowColor: ColorConstants.colorWhite,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
              borderRadius: scaler.getBorderRadiusCircular(10)),
          child: Padding(
            padding: scaler.getPaddingLTRB(2.5, 1.2, 2.0, 1.2),
            child: Row(
            //  mainAxisSize: MainAxisSize.min,
              children: [
                dateCard(scaler, provider),
                SizedBox(width: scaler.getWidth(1.8)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: scaler.getWidth(55),
                      child: Text(provider.eventDetail.eventName ?? "")
                          .boldText(ColorConstants.colorBlack,
                              scaler.getTextSize(11.6), TextAlign.left,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(height: scaler.getHeight(0.3)),
                    Row(
                      children: [
                        ImageView(path: ImageConstants.event_clock_icon),
                        SizedBox(width: scaler.getWidth(1)),
                        Container(
                          width: scaler.getWidth(50),
                          child: Text((provider.eventDetail.startDateAndTime.toString().substring(0, 11)) ==
                                      (provider.eventDetail.endDateAndTime
                                          .toString()
                                          .substring(0, 11))
                                  ? DateTimeHelper.getWeekDay(provider.eventDetail.startDateAndTime ?? DateTime.now()) +
                                      " - " +
                                      DateTimeHelper.convertEventDateToTimeFormat(
                                          provider.eventDetail.startDateAndTime ??
                                              DateTime.now()) +
                                      " to " +
                                      DateTimeHelper.convertEventDateToTimeFormat(
                                          provider.eventDetail.endDateAndTime ??
                                              DateTime.now())
                                  : DateTimeHelper.getWeekDay(provider.eventDetail.startDateAndTime ?? DateTime.now()) +
                                      " - " +
                                      DateTimeHelper.convertEventDateToTimeFormat(provider.eventDetail.startDateAndTime ?? DateTime.now()) +
                                      " to " +
                                      DateTimeHelper.dateConversion(provider.eventDetail.endDateAndTime ?? DateTime.now(), date: false) +
                                      " ( ${DateTimeHelper.convertEventDateToTimeFormat(provider.eventDetail.endDateAndTime ?? DateTime.now())})")
                              .regularText(ColorConstants.colorGray, scaler.getTextSize(9.8), TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                    SizedBox(height: scaler.getHeight(0.3)),
                    provider.eventDetail.eventLocation == "" || provider.eventDetail.eventLocation == null ? SizedBox() :  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: provider.eventDetail.eventLocation == "" || provider.eventDetail.eventLocation == null ?  (){} : () async {
                        try{
                          List<Location> locations = await locationFromAddress(provider.eventDetail.eventLocation?? "");
                          print(locations);
                          provider.launchMap(context, locations[0].latitude, locations[0].longitude);
                        } on PlatformException catch(err){
                          DialogHelper.showMessage(context, "could_not_open_map".tr());
                        } catch(e){
                          DialogHelper.showMessage(context, "could_not_open_map".tr());
                        }
                      },
                      child: Row(
                        children: [
                          ImageView(path: ImageConstants.map),
                          SizedBox(width: scaler.getWidth(1)),
                          Container(
                              width: scaler.getWidth(50),
                              child: Text(provider.eventDetail.eventLocation ?? "")
                                  .regularText(ColorConstants.colorGray,
                                  scaler.getTextSize(9.8), TextAlign.left,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Widget dateCard(ScreenScaler scaler, EventDetailProvider provider) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(8)),
      child: Container(
        decoration: BoxDecoration(
            color: ColorConstants.primaryColor.withOpacity(0.2),
            borderRadius: scaler.getBorderRadiusCircular(
                8.0) // use instead of BorderRadius.all(Radius.circular(20))
            ),
        padding: scaler.getPaddingLTRB(3.0, 0.4, 3.0, 0.4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateTimeHelper.getMonthByName(
                    provider.eventDetail.startDateAndTime ?? DateTime.now()))
                .regularText(ColorConstants.primaryColor,
                    scaler.getTextSize(11.8), TextAlign.center),
            Text((provider.eventDetail.startDateAndTime?.day  ?? DateTime.now().day) <= 9
                    ? "0" +
                        (provider.eventDetail.startDateAndTime?.day.toString() ?? DateTime.now().day.toString())
                    : (provider.eventDetail.startDateAndTime?.day.toString() ?? DateTime.now().day.toString()))
                .boldText(ColorConstants.primaryColor, scaler.getTextSize(13.8),
                    TextAlign.center)
          ],
        ),
      ),
    );
  }


  Widget organiserCard(BuildContext context, ScreenScaler scaler, EventDetailProvider provider) {
    return GestureDetector(
      onTap: (){
        if(provider.organiserContact != null){
          provider.setContactsValue();
          provider.discussionDetail.userId = provider.eventDetail.organiserId;
          Navigator.pushNamed(
              context, RoutesConstants.contactDescription, arguments: ContactDescriptionScreen(showEventScreen: false, isFromNotification: false, contactId: "")
          );
        } else{
          DialogHelper.showMessage(context, "error_message".tr());
        }

      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircular(8)),
        child: Padding(
          padding: scaler.getPaddingLTRB(2.0, 1.2, 2.0, 1.2),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: scaler.getBorderRadiusCircular(15.0),
                  child: provider.userDetail.profileUrl == null
                      ? Container(
                          color: ColorConstants.primaryColor,
                          height: scaler.getHeight(3.5),
                          width: scaler.getWidth(9.5),
                        )
                      : Container(
                          height: scaler.getHeight(3.5),
                          width: scaler.getWidth(9.5),
                          child: ImageView(
                              path: provider.userDetail.profileUrl,
                              height: scaler.getHeight(3.5),
                              width: scaler.getWidth(9.5),
                              fit: BoxFit.cover),
                        )),
              SizedBox(width: scaler.getWidth(2)),
              Expanded(
                  child: Container(
                alignment: Alignment.centerLeft,
                child: Text(provider.eventDetail.organiserName! +
                        " " +
                        "(${"organiser".tr()})")
                    .semiBoldText(ColorConstants.colorBlack,
                        scaler.getTextSize(10.8), TextAlign.left,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
              )),
              SizedBox(width: scaler.getWidth(2)),
              ImageView(
                path: ImageConstants.event_arrow_icon,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget manageInvitationCardCard(BuildContext context, ScreenScaler scaler, EventDetailProvider provider) {
    return GestureDetector(
      onTap: provider.eventDetail.isPastEvent == true ? (){} : (){
        provider.setContactKeys(provider.eventDetail.event!);
        Navigator.pushNamed(
            context,
            RoutesConstants
                .eventInviteFriendsScreen, arguments: EventInviteFriendsScreen(fromDiscussion: false, discussionId: "", fromChatDiscussion: false,)).then((value) {
          Navigator.of(context).pop();
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircular(8)),
        child: Padding(
          padding: scaler.getPaddingLTRB(2.0, 1.6, 2.0, 1.6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: scaler.getWidth(2)),
              Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("manage_invitations".tr())
                        .semiBoldText(ColorConstants.colorBlack,
                        scaler.getTextSize(10.8), TextAlign.left,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  )),
              SizedBox(width: scaler.getWidth(2)),
              ImageView(
                path: ImageConstants.event_arrow_icon,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget attendDateUi(
      BuildContext context, ScreenScaler scaler, EventDetailProvider provider) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text("which_days_could_you_attend".tr()).boldText(
              ColorConstants.colorBlack,
              scaler.getTextSize(11.5),
              TextAlign.left),
        ),
        SizedBox(height: scaler.getHeight(2)),
        provider.multipleDate.length <= 6
            ? SingleChildScrollView(
                child: Container(
                  margin: scaler.getMargin(0.0, 5.0),
                  width: scaler.getWidth(100),
                  //  height: scaler.getHeight(15),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.multipleDate.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 3.0),
                    itemBuilder: (context, index) {
                      //  var value = provider.dateOptionStatus(context, provider.eventDetail.event!.eid,  provider.multipleDate[index].did);
                      return attendDateCard(context, scaler, provider, index);
                    },
                  ),
                ),
              )
            :
        Container(
                margin: scaler.getMargin(0.0, 7.0),
                width: scaler.getWidth(100),
                height: scaler.getHeight(10.0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: provider.multipleDate.length,
                    itemBuilder: (context, index) {
                      return attendDateCard(context, scaler, provider, index);
                    }),
              )
      ],
    );
  }

  Widget attendDateCard(BuildContext context, ScreenScaler scaler,
      EventDetailProvider provider, int index) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (provider.didsOfMultiDateSelected
                .contains(provider.multipleDate[index].did)) {
              // DialogHelper.showDialogWithTwoButtons(context, "Not-Attend Event",
              //     "Are you sure to not attend event on this date?",
              //     positiveButtonPress: () {
              //
              // });
              provider
                  .answerMultiDateOption(
                  context,
                  provider.multipleDate[index].eid,
                  provider.multipleDate[index].did,
                  false)
                  .then((value) {
              //  Navigator.of(context).pop();
                provider.getMultipleDateOptionsFromEvent(
                    context, provider.eventDetail.eid!,
                    onBtnClick: false);
                provider.listOfDateSelected(
                    context, provider.eventDetail.eid!).then((value) {
                  if(provider.didsOfMultiDateSelected.length == 0){
                    provider.eventDetail.eventBtnStatus = "not_going";
                    provider.eventDetail.btnBGColor = ColorConstants.primaryColor.withOpacity(0.1);
                    provider.eventDetail.textColor = ColorConstants.primaryColor;
                  }
                });
              });
            } else {

              // DialogHelper.showDialogWithTwoButtons(context, "Attend Event",
              //     "Are you sure to attend event on this date?",
              //     positiveButtonPress: () {
              //
              // });
              provider
                  .answerMultiDateOption(
                  context,
                  provider.multipleDate[index].eid,
                  provider.multipleDate[index].did,
                  true)
                  .then((value) {
             //   Navigator.of(context).pop();
                provider.getMultipleDateOptionsFromEvent(
                    context, provider.eventDetail.eid!,
                    onBtnClick: false);
                provider.listOfDateSelected(
                    context, provider.eventDetail.eid!).then((value) {
                      if(provider.didsOfMultiDateSelected.length > 0){
                        provider.eventDetail.eventBtnStatus = "going";
                        provider.eventDetail.btnBGColor = ColorConstants.primaryColor.withOpacity(0.1);
                        provider.eventDetail.textColor = ColorConstants.primaryColor;
                      }
                });
              });
            }
          },
          child: Container(
            margin: scaler.getMarginLTRB(0.5, 0.5, 1.0, 0.5),
            padding: scaler.getPaddingLTRB(1.5, 0.5, 1.5, 0.5),
            width: scaler.getWidth(17.5),
            height: scaler.getHeight(10),
            decoration: BoxDecoration(
                color: ColorConstants.colorLightGray,
                borderRadius: scaler.getBorderRadiusCircular(12.0),
                boxShadow: [
                  BoxShadow(color: provider.didsOfMultiDateSelected.contains(provider.multipleDate[index].did)
                            ? ColorConstants.primaryColor : ColorConstants.colorWhitishGray, spreadRadius: 1)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: scaler.getHeight(0.2)),
                Text("${DateTimeHelper.getMonthByName(provider.multipleDate[index].start)} "
                   " ${provider.multipleDate[index].start.year}")
                   .semiBoldText(Colors.deepOrangeAccent, scaler.getTextSize(9.5), TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: scaler.getHeight(0.2)),
                Text(provider.multipleDate[index].start.day.toString())
                    .boldText(ColorConstants.colorBlack, scaler.getTextSize(14.8), TextAlign.center),
                  SizedBox(height: scaler.getHeight(0.2)),
                Text("${DateTimeHelper.convertEventDateToTimeFormat(provider.multipleDate[index].start)}")
                      .regularText(ColorConstants.colorGray, 10.5, TextAlign.center,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: scaler.getHeight(0.2)),
              ],
            ),
          ),
          // Card(
          //   elevation: 4.0,
          //   shape: RoundedRectangleBorder(
          //     side: BorderSide(
          //         color: provider.didsOfMultiDateSelected
          //                 .contains(provider.multipleDate[index].did)
          //             ? ColorConstants.primaryColor
          //             : ColorConstants.colorWhite,
          //         width: 1),
          //     borderRadius: scaler.getBorderRadiusCircular(8.0),
          //   ),
          //   child: Container(
          //     height: scaler.getHeight(7.5),
          //     padding: scaler.getPaddingLTRB(4.0, 0.5, 4.0, 0.5),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(DateTimeHelper.getMonthByName(
          //                 provider.multipleDate[index].start))
          //             .regularText(ColorConstants.primaryColor,
          //                 scaler.getTextSize(11), TextAlign.left),
          //         Text(provider.multipleDate[index].start.day.toString())
          //             .boldText(ColorConstants.primaryColor,
          //                 scaler.getTextSize(14), TextAlign.left),
          //       ],
          //     ),
          //   ),
          // ),
        ),
        SizedBox(width: scaler.getWidth(2.0))
      ],
    );
  }

  Widget eventDiscussionCard(BuildContext context, ScreenScaler scaler) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesConstants.newEventDiscussionScreen, arguments: NewEventDiscussionScreen(fromContactOrGroup: false, fromChatScreen: false, chatDid: ""));
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircular(8)),
        child: Padding(
          padding: scaler.getPaddingLTRB(2.0, 0.8, 2.0, 0.8),
          child: Row(
            children: [
              ImageView(path: ImageConstants.event_chat_icon),
              SizedBox(width: scaler.getWidth(2)),
              Expanded(
                  child: Container(
                alignment: Alignment.centerLeft,
                child: Text("event_discussion".tr()).mediumText(
                    ColorConstants.colorBlack,
                    scaler.getTextSize(10.8),
                    TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              )),
              SizedBox(width: scaler.getWidth(2)),
              ImageView(
                path: ImageConstants.small_arrow_icon,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget photoGalleryCard(BuildContext context, ScreenScaler scaler) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesConstants.eventGalleryPage);
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircular(8)),
        child: Padding(
          padding: scaler.getPaddingLTRB(2.0, 0.8, 2.0, 0.8),
          child: Row(
            children: [
              Icon(Icons.picture_in_picture_alt_outlined),
              SizedBox(width: scaler.getWidth(2)),
              Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("photo_gallery".tr()).mediumText(
                        ColorConstants.colorBlack,
                        scaler.getTextSize(10.8),
                        TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  )),
              SizedBox(width: scaler.getWidth(2)),
              ImageView(
                path: ImageConstants.small_arrow_icon,
              )
            ],
          ),
        ),
      ),
    );
  }

  alertForQuestionnaireAnswers(BuildContext context, ScreenScaler scaler,
      List<String> questionsList, EventDetailProvider provider) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            child: AlertDialog(
                title: Text("event_form_questionnaire".tr())
                    .boldText(ColorConstants.colorBlack, 15.0, TextAlign.left),
                content: Container(
                  width: scaler.getWidth(75),
                  child: Form(
                    key: _formKey,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: questionsList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${index + 1}. ${questionsList[index]}")
                                  .mediumText(ColorConstants.colorBlack, 13,
                                      TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                              SizedBox(height: scaler.getHeight(0.3)),
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: answerController(index),
                                style: ViewDecoration.textFieldStyle(
                                    scaler.getTextSize(10.5),
                                    ColorConstants.colorBlack),
                                decoration:
                                    ViewDecoration.inputDecorationWithCurve(
                                        " ${"answer".tr()} ${index + 1}",
                                        scaler,
                                        ColorConstants.primaryColor),
                                onFieldSubmitted: (data) {
                                  // FocusScope.of(context).requestFocus(nodes[1]);
                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "answer_required".tr();
                                  }
                                  {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: scaler.getHeight(1.0)),
                            ],
                          );
                        }),
                  ),
                ),
                actions: <Widget>[
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              final Map<String, dynamic> answersMap = {
                                "1. text": answer1Controller.text,
                                "2. text": answer2Controller.text,
                                "3. text": answer3Controller.text,
                                "4. text": answer4Controller.text,
                                "5. text": answer5Controller.text
                              };
                              Navigator.of(context).pop();
                              provider.answersToEventQuestionnaire(
                                  _scaffoldkey.currentContext!,
                                  provider.eventDetail.eid!,
                                  answersMap);
                            }
                          },
                          child: Container(
                              padding: scaler.getPadding(1, 2),
                              decoration: BoxDecoration(
                                  color: ColorConstants.primaryColor,
                                  borderRadius:
                                      scaler.getBorderRadiusCircular(10.0)),
                              child: Text('submit_answers'.tr()).semiBoldText(
                                  ColorConstants.colorWhite,
                                  13,
                                  TextAlign.left))),
                      SizedBox(height: scaler.getHeight(0.5))
                    ],
                  )
                ]),
          );
        });
  }

  answerController(int index) {
    switch (index) {
      case 0:
        return answer1Controller;

      case 1:
        return answer2Controller;

      case 2:
        return answer3Controller;

      case 3:
        return answer4Controller;

      case 4:
        return answer5Controller;
    }
  }

// alertForMultiDateAnswers(BuildContext context, ScreenScaler scaler,
//     List<DateOption> multiDate, EventDetailProvider provider) {
//   showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(builder: (context, StateSetter setInnerState) {
//           return Container(
//               width: double.infinity,
//               child: AlertDialog(
//                 contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
//                 insetPadding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 24.0),
//                 title:
//                     CommonWidgets.answerMultiDateAlertTitle(context, scaler),
//                 content: Container(
//                   //  color: Colors.red,
//                   height: scaler.getHeight(25.0),
//                   width: scaler.getWidth(100.0),
//                   child: GridView.builder(
//                     shrinkWrap: true,
//                     itemCount: provider.multipleDate.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: 2.0,
//                         mainAxisSpacing: 3.0),
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setInnerState(() {
//                             provider.selectedMultiDateIndex = index;
//                             provider.attendDateBtnColor = true;
//                             provider.selectedAttendDateDid =
//                                 multiDate[index].did;
//                             provider.selectedAttendDateEid =
//                                 multiDate[index].eid;
//                             //   provider.dateOptionStatus(context, provider.eventDetail.event!.eid, multiDate[index].did);
//                           });
//                         },
//                         child: CommonWidgets.gridViewOfMultiDateAlertDialog(
//                             scaler, multiDate, index,
//                             selectedIndex: provider.selectedMultiDateIndex),
//                       );
//                     },
//                   ),
//                 ),
//                 actions: [
//                   provider.answerMultiDate == true
//                       ? Center(child: CircularProgressIndicator())
//                       : CommonWidgets.commonBtn(
//                           scaler,
//                           context,
//                           "submit".tr(),
//                           provider.attendDateBtnColor == true
//                               ? ColorConstants.primaryColor
//                               : ColorConstants.colorNewGray,
//                           provider.attendDateBtnColor == true
//                               ? ColorConstants.colorWhite
//                               : ColorConstants.colorGray,
//                           onTapFun: provider.attendDateBtnColor == true ||
//                                   provider.selectedAttendDateDid != null
//                               ? () {
//                                   setInnerState(() {
//                                     provider
//                                         .answerMultiDateOption(
//                                             context,
//                                             provider.selectedAttendDateEid
//                                                 .toString(),
//                                             provider.selectedAttendDateDid
//                                                 .toString(), true)
//                                         .then((value) {
//                                       if (provider.eventDetail.event!.form
//                                           .isNotEmpty) {
//                                         List<String> questionsList = [];
//                                         for (var value in provider
//                                             .eventDetail.event!.form.values) {
//                                           questionsList.add(value);
//                                         }
//                                         Navigator.of(context).pop();
//                                         alertForQuestionnaireAnswers(
//                                             _scaffoldkey.currentContext!,
//                                             scaler,
//                                             questionsList,
//                                             provider);
//                                       } else {
//                                         Navigator.of(context).pop();
//                                         provider.replyToEvent(
//                                             _scaffoldkey.currentContext!,
//                                             provider.eventDetail.eid!,
//                                             EVENT_ATTENDING);
//                                       }
//                                     });
//                                   });
//                                 }
//                               : () {})
//                 ],
//               ));
//         });
//       });
// }
}
