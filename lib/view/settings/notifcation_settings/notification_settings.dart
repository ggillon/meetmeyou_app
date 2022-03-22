import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/notification_settings_provider.dart';
import 'package:meetmeyou_app/services/mmy/notification.dart';
import 'package:meetmeyou_app/view/base_view.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context),
        body: BaseView<NotificationSettingsProvider>(
          onModelReady: (provider){},
          builder: (context, provider, _){
            return  SafeArea(
              child: Padding(
                padding: scaler.getPaddingLTRB(3.0, 0.0, 3.5, 2.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("notification_settings".tr()).boldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(16),
                          TextAlign.left),
                    ),
                    SizedBox(height: scaler.getHeight(2)),
                    eventNotificationToggle(context, scaler, provider),
                    SizedBox(height: scaler.getHeight(1.5)),
                    contactInvitationNotificationToggle(context, scaler, provider),
                    SizedBox(height: scaler.getHeight(1.5)),
                    messagesNotificationToggle(context, scaler, provider)
                  ],
                ),
              ),
            );
          },
        )
    );
  }

  Widget eventNotificationToggle(BuildContext context, ScreenScaler scaler, NotificationSettingsProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("receive_event_notification".tr()).regularText(
            ColorConstants.colorBlack, scaler.getTextSize(10), TextAlign.left),
        FlutterSwitch(
          activeColor: ColorConstants.primaryColor,
          width: scaler.getWidth(10.5),
          height: scaler.getHeight(2.3),
          toggleSize: scaler.getHeight(1.8),
          value: provider.notificationDetail.eventNotification,
          borderRadius: 30.0,
          padding: 2.0,
          showOnOff: false,
          onToggle: (val) {
            provider.notificationDetail.eventNotification = val;
            provider.setUserParameter(context, PARAM_NOTIFY_EVENT, provider.notificationDetail.eventNotification);
          },
        ),
      ],
    );
  }

  Widget contactInvitationNotificationToggle(BuildContext context, ScreenScaler scaler, NotificationSettingsProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("receive_contact_notification".tr()).regularText(
            ColorConstants.colorBlack, scaler.getTextSize(10), TextAlign.left),
        FlutterSwitch(
          activeColor: ColorConstants.primaryColor,
          width: scaler.getWidth(10.5),
          height: scaler.getHeight(2.3),
          toggleSize: scaler.getHeight(1.8),
          value: provider.notificationDetail.contactInvitationNotification,
          borderRadius: 30.0,
          padding: 2.0,
          showOnOff: false,
          onToggle: (val) {
            provider.notificationDetail.contactInvitationNotification = val;
            provider.setUserParameter(context, PARAM_NOTIFY_INVITATION, provider.notificationDetail.contactInvitationNotification);
          },
        ),
      ],
    );
  }

  Widget messagesNotificationToggle(BuildContext context, ScreenScaler scaler, NotificationSettingsProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("receive_message_notification".tr()).regularText(
            ColorConstants.colorBlack, scaler.getTextSize(10), TextAlign.left),
        FlutterSwitch(
          activeColor: ColorConstants.primaryColor,
          width: scaler.getWidth(10.5),
          height: scaler.getHeight(2.3),
          toggleSize: scaler.getHeight(1.8),
          value: provider.notificationDetail.messagesNotification,
          borderRadius: 30.0,
          padding: 2.0,
          showOnOff: false,
          onToggle: (val) {
            provider.notificationDetail.messagesNotification = val;
            provider.setUserParameter(context, PARAM_NOTIFY_DISCUSSION, provider.notificationDetail.messagesNotification);
          },
        ),
      ],
    );
  }
}
