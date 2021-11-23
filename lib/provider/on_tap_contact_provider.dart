import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OnTapContactProvider extends BaseProvider {
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
}
