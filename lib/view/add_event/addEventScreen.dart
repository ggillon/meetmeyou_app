import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/multiple_date_option.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:provider/provider.dart';

class AddEventScreen extends StatelessWidget {
   AddEventScreen({Key? key}) : super(key: key);
  EventDetail eventDetail = locator<EventDetail>();
   MultipleDateOption multipleDateOption = locator<MultipleDateOption>();

  @override
  Widget build(BuildContext context) {
    final dashBoardProvider =
    Provider.of<DashboardProvider>(context, listen: false);
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: Padding(
          padding: scaler.getPaddingLTRB(2.5, 2.5, 5, 2.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("create_event".tr()).boldText(ColorConstants.colorBlack,
                  scaler.getTextSize(16), TextAlign.left),
              SizedBox(height: scaler.getHeight(2)),
              eventCard(context, scaler, dashBoardProvider)
            ],
          ),
        ),
      ),
    );
  }

  Widget eventCard(BuildContext context, ScreenScaler scaler, DashboardProvider dashboardProvider) {
    return GestureDetector(
      onTap: () {
        eventDetail.eventPhotoUrl = null;
        eventDetail.editEvent = false;
        eventDetail.contactCIDs = [];
        // clear multi date and time lists
        multipleDateOption.startDate.clear();
        multipleDateOption.endDate.clear();
        multipleDateOption.startTime.clear();
        multipleDateOption.endTime.clear();
        multipleDateOption.startDateTime.clear();
        multipleDateOption.endDateTime.clear();
        multipleDateOption.invitedContacts.clear();
        multipleDateOption.eventAttendingPhotoUrlLists.clear();
        multipleDateOption.eventAttendingKeysList.clear();
        multipleDateOption.multiStartTime = TimeOfDay(hour: 19, minute: 0);
        multipleDateOption.multiEndTime = TimeOfDay(hour: 19, minute: 0).addHour(3);
        Navigator.of(context).pushNamed(RoutesConstants.createEventScreen).then((value) {
          dashboardProvider.onItemTapped(0);
        });
      },
      child: Card(
        shadowColor: ColorConstants.colorWhite,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircular(10)),
        child: Padding(
          padding: scaler.getPadding(2, 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageView(
                  path: ImageConstants.person_icon,
                  height: 25,
                  width: 25,
                  color: ColorConstants.colorBlack),
              SizedBox(height: scaler.getHeight(0.7)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: scaler.getWidth(65),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("private_in_person_event".tr()).semiBoldText(
                            ColorConstants.colorBlack,
                            scaler.getTextSize(10),
                            TextAlign.left),
                        SizedBox(height: scaler.getHeight(0.2)),
                        Text("get_together".tr()).regularText(
                            ColorConstants.colorBlack,
                            scaler.getTextSize(9.5),
                            TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  ImageView(path: ImageConstants.arrow_icon)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
