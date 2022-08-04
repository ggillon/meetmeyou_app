import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/contact.dart';
import 'package:meetmeyou_app/models/discussion_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDescriptionProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  UserDetail userDetail = locator<UserDetail>();
  DiscussionDetail discussionDetail = locator<DiscussionDetail>();
  bool favouriteSwitch = false;

  makePhoneCall(BuildContext context) async {
    var url = 'tel://${userDetail.phone}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      DialogHelper.showMessage(context, "Could not launch $url!");
    }
  }

  sendingSMS(BuildContext context) async {
    var url = 'sms:${userDetail.phone}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      DialogHelper.showMessage(context, "Could not launch $url!");
    }
  }

  openingWhatsApp(BuildContext context) async {
    var whatsAppUrl_android =
        "whatsapp://send?phone=${userDetail.countryCode}${userDetail.phone}";
    var whatsAppUrl_iOS =
        "https://wa.me/${userDetail.countryCode}${userDetail.phone}";
    if (Platform.isIOS) {
      // for iOS phone only
      await canLaunch(whatsAppUrl_iOS)
          ? await launch(whatsAppUrl_iOS, forceSafariVC: false)
          : DialogHelper.showMessage(context, "Error in opening WhatsApp!");
    } else {
      await canLaunch(whatsAppUrl_android)
          ? launch(whatsAppUrl_android)
          : DialogHelper.showMessage(context, "Error in opening WhatsApp!");
    }
  }

  sendingMails(BuildContext context) async {
    var url = 'mailto:${userDetail.email}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      DialogHelper.showMessage(context, "Could not launch $url!");
    }
  }

  acceptOrRejectInvitation(
      BuildContext context, String cid, bool accept, String msg) async {
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    await mmyEngine!.respondInvitation(cid, accept).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    setState(ViewState.Idle);
    Navigator.of(context).pop();
  }

  launchMap(BuildContext context, lat, lng) async {
    if (Platform.isAndroid) {
      var url = "https://www.google.com/maps/search/?api=1&query=${lat},${lng}";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        DialogHelper.showMessage(context, "could_not_open_map".tr());
      }
    } else {
      var urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      if (await canLaunch(urlAppleMaps)) {
        await launch(urlAppleMaps);
      } else {
        DialogHelper.showMessage(context, "could_not_open_map".tr());
      }
    }
  }

  Contact? contactFromInvitation;
  bool contact = false;

  updateGetContact(bool val){
    contact = val;
    notifyListeners();
  }

  String? email;
  Future getContact(BuildContext context, String contactId) async{

    updateGetContact(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value =  await mmyEngine!.getContact(contactId).catchError((e){
      updateGetContact(false);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      contactFromInvitation = value;
      email = value.email;
      setContactsValue(contactFromInvitation!, value.status == "Confirmed contact" ? false : true, contactFromInvitation!.cid);
      updateGetContact(false);
    }

  }

  setContactsValue(Contact contact, bool value, String cid) {
    userDetail.firstName = contact.firstName;
    userDetail.lastName = contact.lastName;
    userDetail.email = contact.email;
    userDetail.profileUrl = contact.photoURL;
    userDetail.phone = contact.phoneNumber;
    userDetail.countryCode = contact.countryCode;
    userDetail.address = contact.addresses['Home'];
    userDetail.checkForInvitation = value;
    userDetail.cid = contact.cid;
  }
}
