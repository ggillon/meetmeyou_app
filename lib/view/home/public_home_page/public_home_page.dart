import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/CommonEventFunction.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/provider/public_home_page_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class PublicHomePage extends StatelessWidget {
  const PublicHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorLightCyan,
      body: BaseView<PublicHomePageProvider>(
        onModelReady: (provider) {
          provider.getUserPublicEvents(context);
          provider.getUserLocationEvents(context);
        },
        builder: (context, provider, _) {
          return SafeArea(
            child: provider.state == ViewState.Busy ? CommonWidgets.loading(scaler) :  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: scaler.getPaddingLTRB(2.8, 1.0, 0.0, 0),
                    child: Text("my_managed_events".tr()).boldText(
                        ColorConstants.colorBlack,
                        scaler.getTextSize(16),
                        TextAlign.left),
                  ),
                  (provider.publicEvents.length == 0 && provider.locationEvents.length == 0) ? Container(
                    height: scaler.getHeight(80),
                      child: CommonWidgets.noEventFoundText(scaler)) :  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      provider.publicEvents.length == 0 ? Container() : SizedBox(height: scaler.getHeight(1.5)),
                      provider.publicEvents.length == 0 ? Container() : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: scaler.getPaddingLTRB(2.8, 0.0, 0.0, 0),
                            child: Text("public_events".tr()).boldText(
                                ColorConstants.colorBlack,
                                scaler.getTextSize(12),
                                TextAlign.left),
                          ),
                          SizedBox(height: scaler.getHeight(1.0)),
                          Container(
                            child: CarouselSlider.builder(
                              itemCount: provider.publicEvents.length,
                              itemBuilder:
                                  (BuildContext context, int index, int pageViewIndex) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                    shadowColor: ColorConstants.colorWhite,
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: scaler.getBorderRadiusCircular(10)),
                                    child: CustomShape(
                                        child: eventCard(scaler, context,
                                            provider.publicEvents, index, provider),
                                        bgColor: ColorConstants.colorWhite,
                                        radius: scaler.getBorderRadiusCircular(10),
                                        width: MediaQuery.of(context).size.width / 1.2),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: scaler.getHeight(30),
                                enableInfiniteScroll: false,
                                // aspectRatio: 0.5,
                                viewportFraction: 0.9,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: scaler.getHeight(1.5)),
                      provider.locationEvents.length == 0 ? Container() :  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: scaler.getPaddingLTRB(2.8, 0.0, 0.0, 0),
                            child: Text("locations".tr()).boldText(
                                ColorConstants.colorBlack,
                                scaler.getTextSize(12),
                                TextAlign.left),
                          ),
                          SizedBox(height: scaler.getHeight(1.0)),
                          Container(
                            child: CarouselSlider.builder(
                              itemCount: provider.locationEvents.length,
                              itemBuilder:
                                  (BuildContext context, int index, int pageViewIndex) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                    shadowColor: ColorConstants.colorWhite,
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: scaler.getBorderRadiusCircular(10)),
                                    child: CustomShape(
                                        child: eventCard(scaler, context,
                                            provider.locationEvents, index, provider),
                                        bgColor: ColorConstants.colorWhite,
                                        radius: scaler.getBorderRadiusCircular(10),
                                        width: MediaQuery.of(context).size.width / 1.2),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: scaler.getHeight(30),
                                enableInfiniteScroll: false,
                                // aspectRatio: 0.5,
                                viewportFraction: 0.9,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: scaler.getHeight(1.5)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget eventCard(ScreenScaler scaler, BuildContext context,
      List<Event> eventList, int index, PublicHomePageProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius:
                  scaler.getBorderRadiusCircularLR(10.0, 10.0, 0.0, 0.0),
              child: eventList[index].photoURL == null
                  ? Container(
                      height: scaler.getHeight(21),
                      width: double.infinity,
                      color: ColorConstants.primaryColor,
                    )
                  : ImageView(
                      path: eventList[index].photoURL,
                      fit: BoxFit.cover,
                      height: scaler.getHeight(21),
                      width: double.infinity,
                    ),
            ),
            Positioned(
                top: scaler.getHeight(1),
                left: scaler.getHeight(1.5),
                child: dateCard(scaler, eventList[index]))
          ],
        ),
        Padding(
          padding: scaler.getPaddingLTRB(3.0, 0.8, 3.0, 0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: scaler.getWidth(45),
                      child: Text(eventList[index].title).boldText(
                          ColorConstants.colorBlack,
                          scaler.getTextSize(10),
                          TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(height: scaler.getHeight(0.2)),
                    Container(
                      width: scaler.getWidth(45),
                      child: Text(eventList[index].description).regularText(
                          ColorConstants.colorGray,
                          scaler.getTextSize(8.5),
                          TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              SizedBox(width: scaler.getWidth(1)),
              eventRespondBtn(context, scaler, eventList[index], provider, index)
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

  Widget eventRespondBtn(BuildContext context, ScreenScaler scaler, Event event,
      PublicHomePageProvider provider, int index) {
    return GestureDetector(
      onTap: () {
        provider.creatorMode.publicEvent = event;
        provider.creatorMode.editPublicEvent = true;
        event.eventType == EVENT_TYPE_PUBLIC ? provider.creatorMode.isLocationEvent = false : provider.creatorMode.isLocationEvent = true;
        Navigator.pushNamed(context, RoutesConstants.publicLocationCreateEventScreen).then((value) {
          provider.getUserPublicEvents(context);
          provider.getUserLocationEvents(context);
        });
      },
      child: CustomShape(
        child: Center(
            child: Text("manage".tr()).semiBoldText(ColorConstants.colorWhite,
                scaler.getTextSize(9.5), TextAlign.center)),
        bgColor: ColorConstants.primaryColor,
        radius: BorderRadius.all(
          Radius.circular(12),
        ),
        width: scaler.getWidth(20),
        height: scaler.getHeight(3.5),
      ),
    );
  }
}
