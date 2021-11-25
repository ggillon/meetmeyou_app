import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDescriptionProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  static const whatsAppUrl = "whatsapp://send?phone=9876543210";

  makePhoneCall(BuildContext context) async {
    const url = 'tel://214324234';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      DialogHelper.showMessage(context, "Could not launch $url!");
    }
  }

  sendingSMS(BuildContext context) async {
    const url = 'sms:9876543210';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      DialogHelper.showMessage(context, "Could not launch $url!");
    }
  }

  openingWhatsApp(BuildContext context) async {
    await canLaunch(whatsAppUrl)
        ? launch(whatsAppUrl)
        : DialogHelper.showMessage(context, "Error in opening WhatsApp!");
  }

  sendingMails(BuildContext context) async {
    const url = 'mailto:sample@gmail.com';
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
}
