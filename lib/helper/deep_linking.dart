import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

class DeepLinking extends BaseProvider{
  CalendarDetail calendarDetail = locator<CalendarDetail>();
  var linkEid;
  EventDetail eventDetail = locator<EventDetail>();
  MMYEngine? mmyEngine;
  EventBus eventBus = locator<EventBus>();
  UserDetail userDetail = locator<UserDetail>();

  Future<void> initUniLinks(BuildContext context) async {
    // ... check initialLink

    // Attach a listener to the stream
    sub = linkStream.listen((String? link) {
      // Parse the link and warn the user, if it is not correct
      if(link != null){
        print(link);
        linkEid = link.toString().split("=");
        calendarDetail.fromAnotherPage = true;
        calendarDetail.fromDeepLink = true;
        eventDetail.eid = linkEid[1].toString();
        Navigator.pushNamed(context, RoutesConstants.eventDetailScreen).then((value)  {
          calendarDetail.fromDeepLink = false;
          unRespondedEventsApi(context);
          eventBus.fire(InviteEventFromLink(true));
        });
      }

    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      return DialogHelper.showMessage(context, "error_message".tr());
    //  print("Exception!!!!!!!!!~~~~~~~");
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }


  Future<void> initUniLinks1(BuildContext context) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialLink();
      if(initialLink != null){
        userDetail.loginAfterDeepLink = false;
        linkEid = initialLink.toString().split("=");
        calendarDetail.fromAnotherPage = true;
        calendarDetail.fromDeepLink = true;
        eventDetail.eid = linkEid[1].toString();
        Navigator.pushNamed(context, RoutesConstants.eventDetailScreen).then((value)  {
          calendarDetail.fromDeepLink = false;
          unRespondedEventsApi(context);
          eventBus.fire(InviteEventFromLink(true));
        });
      }
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
      return DialogHelper.showMessage(context, "error_message".tr());
    }
  }

  bool val = false;

  updateValue(bool value) {
    val = value;
    notifyListeners();
  }

  Future unRespondedEventsApi(BuildContext context) async {
    updateValue(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    eventDetail.unRespondedEvent1 =
    await mmyEngine!.unrespondedEvents().catchError((e) {
      updateValue(false);
      DialogHelper.showMessage(context, e.message);
    });

    updateValue(false);
  }

}

class InviteEventFromLink{

  bool eventFireHomePage;

  InviteEventFromLink(this.eventFireHomePage);

}