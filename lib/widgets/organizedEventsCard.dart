import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/provider/organize_event_card_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:meetmeyou_app/widgets/shimmer/organizedEventCardShimmer.dart';

class OrganizedEventsCard extends StatelessWidget {
  final bool showEventRespondBtn;

  const OrganizedEventsCard({Key? key, required this.showEventRespondBtn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return BaseView<OrganizeEventCardProvider>(onModelReady: (provider) {
      provider.getUserEvents(context);
    }, builder: (context, provider, _) {
      return provider.state == ViewState.Busy
          ? OrganizedEventCardShimmer(showEventRespondBtn: showEventRespondBtn)
          : Container(
              // height: scaler.getHeight(28),
              child: CarouselSlider.builder(
                itemCount: provider.eventLists.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  return Card(
                    shadowColor: ColorConstants.colorWhite,
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: scaler.getBorderRadiusCircular(10)),
                    child: CustomShape(
                        child: eventCard(scaler, context, provider,
                            provider.eventLists[itemIndex]),
                        bgColor: ColorConstants.colorWhite,
                        radius: scaler.getBorderRadiusCircular(10),
                        width: MediaQuery.of(context).size.width / 1.2),
                  );
                },
                options: CarouselOptions(
                  height: scaler.getHeight(30.5),
                  enableInfiniteScroll: false,
                  // aspectRatio: 1.5,
                  viewportFraction: 0.9,
                ),
              ),
            );
    });
  }

  Widget eventCard(ScreenScaler scaler, BuildContext context,
      OrganizeEventCardProvider provider, Event eventList) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius:
                  scaler.getBorderRadiusCircularLR(10.0, 10.0, 0.0, 0.0),
              child: eventList.photoURL == null
                  ? Container(
                      height: scaler.getHeight(21),
                      width: MediaQuery.of(context).size.width / 1.2,
                      color: ColorConstants.primaryColor,
                    )
                  : ImageView(
                      path: eventList.photoURL,
                      fit: BoxFit.fill,
                      height: scaler.getHeight(21),
                      width: MediaQuery.of(context).size.width / 1.2,
                    ),
            ),
            Positioned(
                top: scaler.getHeight(1),
                left: scaler.getHeight(1.5),
                child: dateCard(scaler, eventList))
          ],
        ),
        Padding(
          padding: showEventRespondBtn
              ? scaler.getPaddingLTRB(2.5, 0.5, 2.5, 0.7)
              : scaler.getPaddingLTRB(2.5, 0.5, 7.5, 0.7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(eventList.title).boldText(ColorConstants.colorBlack,
                        scaler.getTextSize(10), TextAlign.left,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    //  SizedBox(height: scaler.getHeight(0.1)),
                    Text(eventList.description).regularText(
                        ColorConstants.colorGray,
                        scaler.getTextSize(8.5),
                        TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        isHeight: true),
                  ],
                ),
              ),
              showEventRespondBtn
                  ? SizedBox(width: scaler.getWidth(1))
                  : SizedBox(width: scaler.getWidth(0)),
              showEventRespondBtn
                  ? eventRespondBtn(scaler, eventList, provider)
                  : Container()
            ],
          ),
        )
      ],
    );
  }

  Widget dateCard(ScreenScaler scaler, Event event) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: scaler.getBorderRadiusCircular(8)),
      child: CustomShape(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateTimeHelper.getMonthByName(event.start)).regularText(
                ColorConstants.colorBlack,
                scaler.getTextSize(8.5),
                TextAlign.center),
            Text(event.start.day <= 9
                    ? "0" + event.start.day.toString()
                    : event.start.day.toString())
                .boldText(ColorConstants.colorBlack, scaler.getTextSize(11),
                    TextAlign.center)
          ],
        ),
        bgColor: ColorConstants.colorWhite,
        radius: scaler.getBorderRadiusCircular(8),
        width: scaler.getWidth(10),
        height: scaler.getHeight(4),
      ),
    );
  }

  Widget eventRespondBtn(
      ScreenScaler scaler, Event event, OrganizeEventCardProvider provider) {
    return CustomShape(
      child: Center(
          child: Text(CommonEventFunction.getEventBtnStatus(
                      event, event.organiserID)
                  .toString()
                  .tr())
              .semiBoldText(
                  CommonEventFunction.getEventBtnColorStatus(
                      event, event.organiserID),
                  scaler.getTextSize(9.5),
                  TextAlign.center)),
      bgColor: CommonEventFunction.getEventBtnColorStatus(
          event, event.organiserID,
          textColor: false),
      radius: BorderRadius.all(
        Radius.circular(12),
      ),
      width: scaler.getWidth(20),
      height: scaler.getHeight(3.5),
    );
  }
}
