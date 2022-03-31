import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/mmy_notification.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class NotificationsHistoryProvider extends BaseProvider{

  MMYEngine? mmyEngine;
  List<MMYNotification> notificationHistoryList = [];

  /// NOTIFICATION
  Future getUserNotificationHistory(BuildContext context)async{
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getUserNotification().catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "exception".tr());
    });

    if(value != null){
      notificationHistoryList = value;
      setState(ViewState.Idle);
    }
  }

}