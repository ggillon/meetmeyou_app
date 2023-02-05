import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/creator_mode.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class PublicHomePageProvider extends BaseProvider{
  CreatorMode creatorMode = locator<CreatorMode>();
  List<Event> publicEvents = [];
  List<Event> locationEvents = [];

  Future getUserPublicEvents(BuildContext context) async {
    setState(ViewState.Busy);

    var value = await creatorMode.mmyCreator!.getUserPublicEvents().catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      publicEvents = value;
      setState(ViewState.Idle);
    }
  }

  Future getUserLocationEvents(BuildContext context) async {
    var value = await creatorMode.mmyCreator!.getUserLocationEvents().catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, e.message);
    });

    if(value != null){
      locationEvents = value;
      setState(ViewState.Idle);
    }
  }
}