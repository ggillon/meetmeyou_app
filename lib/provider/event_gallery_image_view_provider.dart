import 'package:flutter/cupertino.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class EventGalleryImageViewProvider extends BaseProvider{

  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();

  /// Delete photo
  Future deletePhoto(BuildContext context, String aid, String pid) async{
    setState(ViewState.Busy);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine!.deletePhoto(aid, pid).catchError((e) {
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    setState(ViewState.Idle);
    Navigator.of(context).pop();
  }
}