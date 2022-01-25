import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/provider/event_detail_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class DynamicLinksApi extends BaseProvider {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  EventDetail eventDetail = locator<EventDetail>();
  UserDetail userDetail = locator<UserDetail>();
  CalendarDetail calendarDetail = locator<CalendarDetail>();
  String? dynamicUrl;
  MMYEngine? mmyEngine;
  var linkEid;

  Future<Uri> createLink(BuildContext context, String shareLink) async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        // The Dynamic Link URI domain. You can view created URIs on your Firebase console
        uriPrefix: 'https://meetmeyou.page.link/',
        // The deep Link passed to your application which you can use to affect change
        link: Uri.parse(shareLink),
        // Android application details needed for opening correct app on device/Play Store
        androidParameters: AndroidParameters(
          packageName: "com.meetmeyou.meetmeyou",
          //   fallbackUrl: Uri.parse("https://play.google.com/store/apps/details?id=com.meetmeyou.meetmeyou"),
          minimumVersion: 1,
        ),
        // iOS application details needed for opening correct app on device/App Store
        // iosParameters: const IOSParameters(
        //   bundleId: iosBundleId,
        //   minimumVersion: '2',
        // ),
      );

      final ShortDynamicLink shortDynamicLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      final Uri shortUri = shortDynamicLink.shortUrl;
      //  final Uri LongUri = await dynamicLinks.buildLink(parameters);

      // linkEid = LongUri.queryParameters["link"].toString().split("=");
      //  print(linkEid);

      dynamicUrl = shortUri.toString();
      return shortUri;
    } catch (e) {
      return DialogHelper.showMessage(context, "Something went Wrong!");
    }
  }

  handleDynamicLink(BuildContext context) async {
    await dynamicLinks.getInitialLink();

    // this is for background/foreground state
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      linkEid = dynamicLinkData.link.toString().split("=");
      print(linkEid);
      calendarDetail.fromCalendarPage = true;
      eventDetail.eid = linkEid[1].toString();
      //  inviteUrl(context, linkEid[1].toString());
      Navigator.pushNamed(context, RoutesConstants.eventDetailScreen);
    }).onError((error) {
      // Handle errors
      return DialogHelper.showMessage(context, "No Link found!");
    });

    // this is for terminated state
    PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
    try {
      if (data != null) {
        linkEid = data.link.toString().split("=");
        calendarDetail.fromCalendarPage = true;
        eventDetail.eid = linkEid[1].toString();
        //  inviteUrl(context, linkEid[1].toString());
        Navigator.pushNamed(context, RoutesConstants.eventDetailScreen);
      }
    } catch (e) {
      return DialogHelper.showMessage(context, "No Link found!");
    }
  }

  Future inviteUrl(BuildContext context, var eid) async {
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    await mmyEngine!.inviteURL(eid).catchError((e) {
      setState(ViewState.Idle);
    });

    setState(ViewState.Idle);
  }

// // These functions are used when user comes from link.
// Event? event;
// int eventAttendingLength = 0;
// List<String> eventAttendingKeysList = [];
// List<String> eventAttendingPhotoUrlLists = [];
//
// bool eventValue = false;
//
// void updateEventValue(bool value) {
//   eventValue = value;
//   notifyListeners();
// }
//
// Future getEvent(BuildContext context, String eid) async {
//   updateEventValue(true);
//
//   getUsersProfileUrl(context);
//
//   var value = await mmyEngine!.getEvent(eid).catchError((e) {
//     updateEventValue(false);
//     DialogHelper.showMessage(context, e.message);
//   });
//
//   if (value != null) {
//     event = value;
//     updateEventValue(false);
//     eventDetail.eventBtnStatus = CommonEventFunction.getEventBtnStatus(
//         event!, userDetail.cid.toString());
//     eventDetail.textColor = CommonEventFunction.getEventBtnColorStatus(
//         event!, userDetail.cid.toString());
//     eventDetail.btnBGColor = CommonEventFunction.getEventBtnColorStatus(
//         event!, userDetail.cid.toString(),
//         textColor: false);
//     eventDetail.eventMapData = event!.invitedContacts;
//     eventDetail.organiserId = event!.organiserID;
//     eventDetail.organiserName = event!.organiserName;
//     eventGoingLength();
//     getOrganiserProfileUrl(context, eventDetail.organiserId!);
//     getUsersProfileUrl(context);
//     setEventValuesForEdit(event!);
//   } else {
//     updateEventValue(false);
//     DialogHelper.showMessage(context, "ERROR! something wrong.");
//   }
// }
//
// eventGoingLength() {
//   List<String> keysList = [];
//   for (var key in eventDetail.eventMapData!.keys) {
//     keysList.add(key);
//   }
//   List<String> valuesList = [];
//
//   for (var value in eventDetail.eventMapData!.values) {
//     valuesList.add(value);
//   }
//
//   for (int i = 0; i < keysList.length; i++) {
//     if (valuesList[i] == "Attending") {
//       eventAttendingLength = eventAttendingLength + 1;
//       eventAttendingKeysList.add(keysList[i]);
//     } else if (valuesList[i] == "Organiser") {
//       organiserKey = keysList[i];
//     }
//   }
//   return eventAttendingLength;
// }
//
//
// Future getUsersProfileUrl(BuildContext context) async {
//   setState(ViewState.Busy);
//
//   mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
//   for (var key in eventAttendingKeysList) {
//     var value = await mmyEngine!
//         .getUserProfile(user: false, uid: key)
//         .catchError((e) {
//       setState(ViewState.Idle);
//       DialogHelper.showMessage(context, e.message);
//     });
//     eventAttendingPhotoUrlLists.add(value.photoURL);
//   }
//   // print(eventAttendingLists);
//   setState(ViewState.Idle);
// }
//
// Future getOrganiserProfileUrl(
//     BuildContext context, String organiserUid) async {
//   setState(ViewState.Busy);
//
//   var value = await mmyEngine!
//       .getUserProfile(user: false, uid: organiserUid)
//       .catchError((e) {
//     setState(ViewState.Idle);
//     DialogHelper.showMessage(context, e.message);
//   });
//
//   userDetail.profileUrl = value.photoURL;
//   setState(ViewState.Idle);
// }
//
// setEventValuesForEdit(eventModel.Event event) {
//   eventDetail.editEvent = true;
//   eventDetail.eid = event.eid;
//   eventDetail.photoUrlEvent = event.photoURL;
//   eventDetail.eventName = event.title;
//   eventDetail.startDateAndTime = event.start;
//   eventDetail.endDateAndTime = event.end;
//   eventDetail.eventLocation = event.location;
//   eventDetail.eventDescription = event.description;
//   eventDetail.event = event;
//   List<String> valuesList = [];
//   for (var value in event.invitedContacts.values) {
//     valuesList.add(value);
//   }
//   List<String> keysList = [];
//   for (var key in event.invitedContacts.keys) {
//     keysList.add(key);
//   }
//   List<String> contactsKeys = [];
//   for (int i = 0; i < keysList.length; i++) {
//     if (valuesList[i] != "Organiser") {
//       contactsKeys.add(keysList[i]);
//     }
//  }

//   eventDetail.contactCIDs = contactsKeys;
// }

}
