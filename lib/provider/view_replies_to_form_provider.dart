import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event_answer.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';

class ViewReplyToFormProvider extends BaseProvider{
  MMYEngine? mmyEngine;
  EventDetail eventDetail = locator<EventDetail>();
  List<EventAnswer> eventAnswersList = [];

  Future getAnswersEventForm(BuildContext context) async{
    setState(ViewState.Busy);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);
    var value =  await mmyEngine!.getAnswersEventForm(eventDetail.eid.toString()).catchError((e){
      setState(ViewState.Idle);
      DialogHelper.showMessage(context, "error_in_getting_answer_form".tr());
    });

    if(value != null){
      eventAnswersList = value;
      setState(ViewState.Idle);
    }
  }
}