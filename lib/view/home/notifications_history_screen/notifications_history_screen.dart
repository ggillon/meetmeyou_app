import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/notifications_history_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';

class NotificationsHistoryScreen extends StatelessWidget {
  const NotificationsHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context),
      body: BaseView<NotificationsHistoryProvider>(
        onModelReady: (provider){
          provider.getUserNotificationHistory(context);
        },
        builder: (context, provider, _){
          return Padding(
            padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("notifications".tr()).boldText(ColorConstants.colorBlack,
                    scaler.getTextSize(16), TextAlign.left),
                SizedBox(height: scaler.getHeight(1)),
                provider.state == ViewState.Busy ?  Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(height: scaler.getHeight(1)),
                      Text("loading_notifications".tr()).mediumText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(10),
                          TextAlign.left),
                    ],
                  ),
                ) : provider.notificationHistoryList.length == 0 ?  Expanded(
                  child: Center(
                    child: Text("no_notifications".tr())
                        .mediumText(
                        ColorConstants.primaryColor,
                        scaler.getTextSize(10),
                        TextAlign.left),
                  ),
                ) : notificationHistoryListView(scaler, provider)
              ],
            ),
          );
        },
      )
    );
  }

  Widget notificationHistoryListView(ScreenScaler scaler, NotificationsHistoryProvider provider){
    return ListView.builder(
        shrinkWrap: true,
        itemCount: provider.notificationHistoryList.length,
        itemBuilder: (context, index){
      return Column(
        children: [

        ],
      );
    });
  }
}
