import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/mmy_notification.dart';
import 'package:meetmeyou_app/provider/notifications_history_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/view/contacts/contact_description/contactDescriptionScreen.dart';
import 'package:meetmeyou_app/view/home/event_discussion_screen/new_event_discussion_screen.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

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
            padding: scaler.getPaddingLTRB(3.0, 0.0, 3.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("notifications".tr()).boldText(ColorConstants.colorBlack,
                    scaler.getTextSize(16.5), TextAlign.left),
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
                          scaler.getTextSize(11),
                          TextAlign.left),
                    ],
                  ),
                ) : (provider.notificationHistoryList.length == 0 || provider.notificationHistoryList.isEmpty) ?  Expanded(
                  child: Center(
                    child: Text("no_notifications".tr())
                        .mediumText(
                        ColorConstants.primaryColor,
                        scaler.getTextSize(11),
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
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: provider.notificationHistoryList.length,
            itemBuilder: (context, index){
              String currentHeader = provider.notificationHistoryList[index].timeStamp.toString().substring(0, 11);
              String header = index == 0
                  ? provider.notificationHistoryList[index].timeStamp.toString().substring(0, 11)
                  : provider.notificationHistoryList[index-1].timeStamp.toString().substring(0, 11);
          // return Column(
          //   children: [
          //     notificationType(context, provider.notificationHistoryList[index].type, scaler, provider, provider.notificationHistoryList[index])
          //   ],
          // );
              return aToZHeader(context, provider.notificationHistoryList[index].type, scaler, provider, provider.notificationHistoryList[index], index, header, currentHeader);
        }),
      ),
    );
  }


  aToZHeader(BuildContext context, String type, ScreenScaler scaler, NotificationsHistoryProvider provider, MMYNotification notificationHistoryList, int index, String header, String cHeader) {
    if (index == 0 ? true : (header != cHeader)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: scaler.getPaddingLTRB(1.0, 0.5, 1.0, 1.0),
            child: Text(cHeader == DateTime.now().toString().substring(0, 11) ? "today".tr() : (cHeader == DateTime.now().subtract(Duration(days: 1)).toString().substring(0, 11)? "yesterday".tr() : DateTimeHelper.notificationDateFormat(provider.notificationHistoryList[index].timeStamp))).boldText(ColorConstants.colorBlack,
                scaler.getTextSize(12.5), TextAlign.left),
          ),
         // SizedBox(height: scaler.getHeight(1.0)),
          notificationType(context, provider.notificationHistoryList[index].type, scaler, provider, provider.notificationHistoryList[index])
        ],
      );
    }
    else {
      return notificationType(context, provider.notificationHistoryList[index].type, scaler, provider, provider.notificationHistoryList[index]);
    }
  }


  notificationType(BuildContext context, String type, ScreenScaler scaler, NotificationsHistoryProvider provider, MMYNotification notificationHistoryList){
    switch(type){
      case NOTIFICATION_EVENT_INVITE:
        return eventNotification(context, scaler, provider, notificationHistoryList);

      case NOTIFICATION_MESSAGE_NEW:
        return messageNotification(context, scaler, provider, notificationHistoryList);

      case NOTIFICATION_USER_INVITE:
        return invitationNotification(context, scaler, provider, notificationHistoryList);
    }
  }

  Widget eventNotification(BuildContext context, ScreenScaler scaler, NotificationsHistoryProvider provider, MMYNotification notificationHistoryList){
    return Container(
        padding: scaler.getPaddingLTRB(1.0, 0.5, 1.0, 1.0),
        child:  Row(children: [
          CommonWidgets.notificationImage(scaler, notificationHistoryList.photoURL),
          SizedBox(width: scaler.getWidth(2.5)),
          Expanded(child: Text(notificationHistoryList.text).mediumText(ColorConstants.colorBlack, scaler.getTextSize(11.0), TextAlign.left,
              maxLines: 2, overflow: TextOverflow.ellipsis),),
          SizedBox(width: scaler.getWidth(2.5)),
          GestureDetector(
            onTap: (){
              provider.calendarDetail.fromAnotherPage = true;
              provider.eventDetail.eid = notificationHistoryList.id;
              Navigator.pushNamed(context, RoutesConstants.eventDetailScreen).then((value) {
               provider.getUserNotificationHistory(context);
              });
            },
              child: respondBtn(scaler, "respond".tr()))
        ],)
    );
  }

  Widget messageNotification(BuildContext context, ScreenScaler scaler, NotificationsHistoryProvider provider, MMYNotification notificationHistoryList){
    return Container(
        padding: scaler.getPaddingLTRB(1.0, 0.5, 1.0, 1.0),
        child:  Row(children: [
          CommonWidgets.notificationImage(scaler, notificationHistoryList.photoURL),
          SizedBox(width: scaler.getWidth(2.5)),
          Expanded(child: Text(notificationHistoryList.text).mediumText(ColorConstants.colorBlack, scaler.getTextSize(11.0), TextAlign.left,
              maxLines: 2, overflow: TextOverflow.ellipsis),),
          SizedBox(width: scaler.getWidth(2.5)),
          GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, RoutesConstants.newEventDiscussionScreen,
                    arguments: NewEventDiscussionScreen(fromContactOrGroup: false, fromChatScreen: true, chatDid: notificationHistoryList.id)).then((value) {
                  provider.getUserNotificationHistory(context);
                });
              },
              child: respondBtn(scaler, "respond".tr()))
        ],)
    );
  }

  Widget invitationNotification(BuildContext context, ScreenScaler scaler, NotificationsHistoryProvider provider, MMYNotification notificationHistoryList){
    return Container(
        padding: scaler.getPaddingLTRB(1.0, 0.5, 1.0, 1.0),
        child:  Row(children: [
          CommonWidgets.notificationImage(scaler, notificationHistoryList.photoURL),
          SizedBox(width: scaler.getWidth(2.5)),
          Expanded(child: Text(notificationHistoryList.text).mediumText(ColorConstants.colorBlack, scaler.getTextSize(11.0), TextAlign.left,
              maxLines: 2, overflow: TextOverflow.ellipsis),),
          SizedBox(width: scaler.getWidth(2.5)),
          GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, RoutesConstants.contactDescription, arguments: ContactDescriptionScreen(showEventScreen: false, isFromNotification: true, contactId: notificationHistoryList.id)).then((value) {
                  provider.getUserNotificationHistory(context);
                });
              },
              child: respondBtn(scaler, "accept".tr()))
        ],)
    );
  }


  Widget respondBtn(ScreenScaler scaler, String text){
    return  CustomShape(
      child: Center(
          child:Text(text)
              .semiBoldText(
              ColorConstants.colorWhite,
              scaler.getTextSize(10.5),
              TextAlign.center)),
      bgColor: ColorConstants.primaryColor,
      radius: BorderRadius.all(
        Radius.circular(12),
      ),
      width: scaler.getWidth(20),
      height: scaler.getHeight(4.0),
    );
  }
}
