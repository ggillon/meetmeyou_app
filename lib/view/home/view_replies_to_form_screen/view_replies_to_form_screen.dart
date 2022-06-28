import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/view_replies_to_form_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';

class ViewRepliesToFormScreen extends StatelessWidget {
  const ViewRepliesToFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: DialogHelper.appBarWithBack(scaler, context, email: true),
      body: BaseView<ViewReplyToFormProvider>(
        onModelReady: (provider){
          provider.getAnswersEventForm(context);
        },
        builder: (context, provider, _){
          return provider.state == ViewState.Busy ?
          CommonWidgets.loading(scaler, txt: "getting_replies".tr()) :
         provider.eventAnswersList.isEmpty ?  Center(
           child: Text("no_replies_received_yet".tr())
               .mediumText(
               ColorConstants.primaryColor,
               scaler.getTextSize(11),
               TextAlign.left),
         ) : Column(
            children: [

            ],
          );
        },
      ),
    );
  }
}
