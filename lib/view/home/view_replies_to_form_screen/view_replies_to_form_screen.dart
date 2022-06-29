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
  ViewRepliesToFormScreen({Key? key}) : super(key: key);

  List<String> questionsList = [];
  ViewReplyToFormProvider provider = ViewReplyToFormProvider();
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: DialogHelper.appBarWithBack(scaler, context, email: provider.state == ViewState.Busy ? false : true, onTapEmail: (){
        provider.emailEventAnswers(context);
      }),
      body: BaseView<ViewReplyToFormProvider>(
        onModelReady: (provider){
          this.provider = provider;
          provider.getAnswersEventForm(context);
          for (var value in provider
              .eventDetail.event!.form.values) {
            questionsList.add(value);
          }
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
         ) : SingleChildScrollView(
           child: Padding(
             padding: scaler.getPaddingLTRB(3.5, 1.0, 3.5, 1.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(provider.eventDetail.eventName.toString())
                      .boldText(
                      ColorConstants.colorBlack,
                      scaler.getTextSize(13.8),
                      TextAlign.left, maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: scaler.getHeight(1.0)),
                  questionsListView(scaler),
                  SizedBox(height: scaler.getHeight(2.0)),
                  Text("${provider.eventDetail.eventName.toString()} ${"answers".tr()}")
                      .boldText(
                      ColorConstants.colorBlack,
                      scaler.getTextSize(12.5),
                      TextAlign.left, maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: scaler.getHeight(2.0)),
                  answersListView(provider, scaler),
                ],
              ),
           ),
         );
        },
      ),
    );
  }

  Widget questionsListView(ScreenScaler scaler){
    return ListView.builder(
      shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: questionsList.length,
        itemBuilder: (context, index){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${index + 1}.  ${questionsList[index]}")
                .mediumText(ColorConstants.colorBlack, 13,
                TextAlign.left,
                maxLines: 3,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: scaler.getHeight(0.2)),
          ],
        );
    });
  }

  Widget answersListView(ViewReplyToFormProvider provider, ScreenScaler scaler){
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: provider.answersList.length,
        itemBuilder: (context, index){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(provider.answersList[index].displayName.toString())
                  .boldText(
                  ColorConstants.colorBlack,
                  scaler.getTextSize(12.0),
                  TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: scaler.getHeight(0.2)),
              ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: provider.answersList[index].answersList?.length ?? 0,
                  itemBuilder: (context, i){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${i + 1}.  ${provider.answersList[index].answersList![i]}")
                            .mediumText(ColorConstants.colorBlack, 13,
                            TextAlign.left,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                        SizedBox(height: scaler.getHeight(0.2)),
                      ],
                    );
                  }),
              SizedBox(height: scaler.getHeight(2.0)),
            ],
          );
        });
  }
}
