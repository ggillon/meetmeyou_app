import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_used.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/date_time_helper.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/create_event_provider.dart';
import 'package:meetmeyou_app/provider/public_location_create_event_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class PublicLocationCreateEventScreen extends StatelessWidget {
   PublicLocationCreateEventScreen({Key? key}) : super(key: key);
  final eventNameController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PublicLocationCreateEventProvider provider = PublicLocationCreateEventProvider();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorLightCyan,
      body: BaseView<PublicLocationCreateEventProvider>(
        onModelReady: (provider){
          this.provider = provider;
        },
        builder: (context, provider, _){
          return GestureDetector(
            onTap: (){
              hideKeyboard(context);
            },
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    selectedImage(context, scaler),
                    SafeArea(
                      child: Padding(
                        padding: scaler.getPaddingLTRB(3.0, 0.0, 3.0, 0.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("event_name".tr()).boldText(
                                  Colors.black,
                                  scaler.getTextSize(9.5),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.2)),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: eventNameController,
                              style: ViewDecoration.textFieldStyle(
                                  scaler.getTextSize(9.5),
                                  ColorConstants.colorBlack),
                              decoration:
                              ViewDecoration.inputDecorationWithCurve(
                                  "Thomas Birthday Party",
                                  scaler,
                                  ColorConstants.primaryColor),
                              onFieldSubmitted: (data) {
                                // FocusScope.of(context).requestFocus(nodes[1]);
                              },
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "event_name_required".tr();
                                }
                                {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: scaler.getHeight(1.5)),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child:
                                  Text("start_date_and_time".tr())
                                      .boldText(
                                      Colors.black,
                                      scaler.getTextSize(9.5),
                                      TextAlign.center),
                                ),
                                SizedBox(
                                    height: scaler.getHeight(0.2)),
                                startDateTimePickField(
                                    context, scaler, provider),
                                SizedBox(
                                    height: scaler.getHeight(1.5)),
                                provider.addEndDate == true
                                    ? Container()
                                    : GestureDetector(
                                  onTap: () {
                                   provider.addEndDate = true;
                                   provider.updateLoadingStatus(true);
                                  },
                                  child: Align(
                                      alignment:
                                      Alignment.bottomLeft,
                                      child: Row(
                                        children: [
                                          Icon(Icons.add,
                                              color: ColorConstants
                                                  .primaryColor,
                                              size: 16),
                                          Text("add_end_date_time"
                                              .tr())
                                              .mediumText(
                                              ColorConstants
                                                  .primaryColor,
                                              scaler
                                                  .getTextSize(
                                                  10),
                                              TextAlign
                                                  .center)
                                        ],
                                      )),
                                ),
                                provider.addEndDate == true
                                    ? Align(
                                  alignment:
                                  Alignment.bottomLeft,
                                  child: Text(
                                      "end_date_and_time"
                                          .tr())
                                      .boldText(
                                      Colors.black,
                                      scaler
                                          .getTextSize(9.5),
                                      TextAlign.center),
                                )
                                    : Container(),
                                provider.addEndDate == true
                                    ? SizedBox(
                                    height: scaler.getHeight(0.2))
                                    : Container(),
                                provider.addEndDate == true
                                    ? endDateTimePickField(
                                    context, scaler, provider)
                                    : Container(),
                              ],
                            ),
                            SizedBox(height: scaler.getHeight(0.7)),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("event_location".tr()).boldText(
                                  Colors.black,
                                  scaler.getTextSize(9.5),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.2)),
                            GestureDetector(
                              onTap: () async {
                                hideKeyboard(context);
                                Navigator.pushNamed(
                                    context, RoutesConstants.autoComplete)
                                    .then((value) {
                                  if (value != null) {
                                    Map<String, String> detail =
                                    value as Map<String, String>;
                                    final lat = value["latitude"];
                                    final lng = value["longitude"];
                                    final selectedAddress = detail["address"];
                                    addressController.text =
                                    selectedAddress != null
                                        ? selectedAddress
                                        : "";
                                  }
                                });
                              },
                              child: TextFormField(
                                enabled: false,
                                controller: addressController,
                                style: ViewDecoration.textFieldStyle(
                                    scaler.getTextSize(9.5),
                                    ColorConstants.colorBlack),
                                decoration:
                                ViewDecoration.inputDecorationWithCurve(
                                  "Thomas Birthday Party",
                                  scaler,
                                  ColorConstants.primaryColor,
                                  icon: Icons.map,
                                  // imageView: true,
                                  // path: ImageConstants.map_icon
                                ),
                                onFieldSubmitted: (data) {
                                  // FocusScope.of(context).requestFocus(nodes[1]);
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.streetAddress,
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "event_location_required".tr();
                                  }
                                  {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: scaler.getHeight(1.5)),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("website".tr()).boldText(
                                  Colors.black,
                                  scaler.getTextSize(9.5),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.2)),
                            TextFormField(
                              controller: websiteController,
                              style: ViewDecoration.textFieldStyle(
                                  scaler.getTextSize(9.5),
                                  ColorConstants.colorBlack),
                              decoration:
                              ViewDecoration.inputDecorationWithCurve(
                                "click_here_to_add_website".tr(),
                                scaler,
                                ColorConstants.primaryColor,
                              ),
                              onFieldSubmitted: (data) {
                                // FocusScope.of(context).requestFocus(nodes[1]);
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.url,
                            ),
                            SizedBox(height: scaler.getHeight(2)),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("event_description".tr()).boldText(
                                  Colors.black,
                                  scaler.getTextSize(9.5),
                                  TextAlign.center),
                            ),
                            SizedBox(height: scaler.getHeight(0.2)),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: eventDescriptionController,
                              style: ViewDecoration.textFieldStyle(
                                  scaler.getTextSize(10),
                                  ColorConstants.colorBlack),
                              decoration: ViewDecoration.inputDecorationWithCurve(
                                  "We are celebrating birthday with Thomas and his family."
                                      " If you are coming make sure you bring good mood and "
                                      "will to party whole night. We are going to have some "
                                      "pinatas so be ready to smash them. Let’s have some "
                                      "drinks and fun!",
                                  scaler,
                                  ColorConstants.primaryColor,
                                  textSize: 10),
                              onFieldSubmitted: (data) {
                                // FocusScope.of(context).requestFocus(nodes[1]);
                              },
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.multiline,
                              maxLines: 6,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "event_description_required".tr();
                                }
                                {
                                  return null;
                                }
                              },
                            ),

                            SizedBox(height: scaler.getHeight(3.5)),
                            provider.state == ViewState.Busy
                                ? Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(
                                      height: scaler.getHeight(1.5)),
                                ],
                              ),
                            )
                                :  CommonWidgets.commonBtn(
                                scaler,
                                context,
                                "next".tr(),
                                ColorConstants.primaryColor,
                                ColorConstants.colorWhite,
                                onTapFun: () {
                                  hideKeyboard(context);
                                  if (_formKey.currentState!
                                      .validate()) {
                                    provider.createPublicEvent(context, eventNameController.text, addressController.text, eventDescriptionController.text, DateTimeHelper
                                        .dateTimeFormat(
                                        provider.startDate,
                                        provider.startTime), image: provider.image, website: websiteController.text, end: DateTimeHelper
                                        .dateTimeFormat(
                                        provider.endDate,
                                        provider.endTime));
                                  }
                                }),
                            SizedBox(height: scaler.getHeight(0.5)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

   Widget selectedImage(
       BuildContext context, ScreenScaler scaler) {
     return GestureDetector(
       onTap: () async {
         hideKeyboard(context);
         var value = await provider.permissionCheck();
         if (value) {
           selectImageBottomSheet(context, scaler);
         }
       },
       child: Card(
         margin: scaler.getMarginLTRB(1.0, 0.0, 1.0, 0.0),
         shadowColor: ColorConstants.colorWhite,
         elevation: 5.0,
         shape: RoundedRectangleBorder(
             borderRadius: scaler.getBorderRadiusCircularLR(0.0, 0.0, 16, 16)),
         color: ColorConstants.colorLightGray,
         child: Container(
           height: scaler.getHeight(34),
           width: double.infinity,
           child: Column(
             children: [
               Stack(
                 children: [
                   ClipRRect(
                       borderRadius:
                       scaler.getBorderRadiusCircularLR(0.0, 0.0, 16, 16),
                       child: provider.image == null
                           ? provider.eventDetail.eventPhotoUrl != null
                           ? ImageView(
                         path: provider.eventDetail.eventPhotoUrl,
                         fit: BoxFit.cover,
                         height: scaler.getHeight(34),
                         width: double.infinity,
                       )
                           : imageSelectedCard(context, scaler)
                           : provider.image != null
                           ? ImageView(
                         file: provider.image,
                         fit: BoxFit.cover,
                         height: scaler.getHeight(34),
                         width: double.infinity,
                       )
                           : imageSelectedCard(context, scaler)),
                   provider.image == null &&
                       provider.eventDetail.eventPhotoUrl == null
                       ? Container()
                       : Positioned(
                     child: GestureDetector(
                       onTap: () {
                         Navigator.of(context).pop();
                       },
                       child: Container(
                           padding:
                           scaler.getPaddingLTRB(0.0, 4.0, 3.0, 0.0),
                           alignment: Alignment.centerRight,
                           child: ImageView(
                               path: ImageConstants.close_icon,
                               color: ColorConstants.colorWhite)),
                     ),
                   )
                 ],
               )
             ],
           ),
         ),
       ),
     );
   }

   Widget imageSelectedCard(BuildContext context, ScreenScaler scaler) {
     return Container(
       padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
       width: double.infinity,
       child: Column(
         children: [
           SizedBox(height: scaler.getHeight(4.5)),
           GestureDetector(
             onTap: () {
               Navigator.of(context).pop();
             },
             child: Container(
                 alignment: Alignment.centerRight,
                 child: ImageView(path: ImageConstants.close_icon)),
           ),
           SizedBox(height: scaler.getHeight(0.5)),
           Stack(
             alignment: Alignment.center,
             children: [
               ImageView(path: ImageConstants.image_border_icon),
               Positioned(
                   child: ImageView(path: ImageConstants.image_frame_icon))
             ],
           ),
           SizedBox(height: scaler.getHeight(1)),
           Text("select_image".tr()).regularText(ColorConstants.primaryColor,
               scaler.getTextSize(9.5), TextAlign.left),
           SizedBox(height: scaler.getHeight(3)),
         ],
       ),
     );
   }

   selectImageBottomSheet(
       BuildContext context, ScreenScaler scaler) {
     return showModalBottomSheet(
         useRootNavigator: true,
         shape: RoundedRectangleBorder(
           borderRadius: scaler.getBorderRadiusCircularLR(25.0, 25.0, 0.0, 0.0),
         ),
         context: context,
         builder: (BuildContext context) {
           return Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               SizedBox(height: scaler.getHeight(0.5)),
               Container(
                 decoration: BoxDecoration(
                     color: ColorConstants.colorMediumGray,
                     borderRadius: scaler.getBorderRadiusCircular(10.0)),
                 height: scaler.getHeight(0.4),
                 width: scaler.getWidth(12),
               ),
               Column(
                 children: [

                   GestureDetector(
                       behavior: HitTestBehavior.opaque,
                       onTap: () {
                         provider.getImage(context, 1);
                       },
                       child: Column(
                         children: [
                           SizedBox(height: scaler.getHeight(2)),
                           Container(
                             width: double.infinity,
                             child: Text("take_a_photo".tr()).regularText(
                                 ColorConstants.primaryColor,
                                 scaler.getTextSize(11),
                                 TextAlign.center),
                           ),
                           SizedBox(height: scaler.getHeight(0.9)),
                         ],
                       )
                   ),
                   Divider(),
                   GestureDetector(
                       behavior: HitTestBehavior.opaque,
                       onTap: () {
                         provider.getImage(context, 2);
                       },
                       child: Column(
                         children: [
                           SizedBox(height: scaler.getHeight(0.9)),
                           Container(
                             width: double.infinity,
                             child: Text("choose_photo".tr()).regularText(
                                 ColorConstants.primaryColor,
                                 scaler.getTextSize(11),
                                 TextAlign.center),
                           ),
                           SizedBox(height: scaler.getHeight(2.0)),
                         ],
                       )
                   ),
                 ],
               ),
               GestureDetector(
                 behavior: HitTestBehavior.opaque,
                 onTap: () {
                   Navigator.of(context).pop();
                 },
                 child: Center(
                     child: Container(
                       child: Text("cancel".tr()).semiBoldText(
                           ColorConstants.colorRed,
                           scaler.getTextSize(11),
                           TextAlign.center),
                     )
                 ),
               ),
               SizedBox(height: scaler.getHeight(1.5)),
             ],
           );
         });
   }

   Widget startDateTimePickField(
       BuildContext context, ScreenScaler scaler, PublicLocationCreateEventProvider provider) {
     return Container(
       height: scaler.getHeight(4),
       width: double.infinity,
       decoration: BoxDecoration(
           color: ColorConstants.colorLightGray,
           border: Border.all(
             color: ColorConstants.colorLightGray,
           ),
           borderRadius: scaler.getBorderRadiusCircular(8.0)),
       child: Container(
         padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             GestureDetector(
               onTap: () {
                 hideKeyboard(context);
                 provider.pickDateDialog(context, true);
               },
               child: Container(
                 padding: scaler.getPaddingLTRB(1.5, 0.0, 1.5, 0.0),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                     color: ColorConstants.colorWhite,
                     border: Border.all(
                       color: ColorConstants.colorWhite,
                     ),
                     borderRadius: scaler.getBorderRadiusCircular(8.0)),
                 height: scaler.getHeight(2.5),
                 child: Text(DateTimeHelper.dateConversion(provider.startDate))
                     .regularText(ColorConstants.colorGray,
                     scaler.getTextSize(9.5), TextAlign.center),
               ),
             ),
             GestureDetector(
               onTap: () {
                 hideKeyboard(context);
                 provider.selectTimeDialog(context, true);
               },
               child: Container(
                 padding: scaler.getPaddingLTRB(1.5, 0.0, 1.5, 0.0),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                     color: ColorConstants.colorWhite,
                     border: Border.all(
                       color: ColorConstants.colorWhite,
                     ),
                     borderRadius: scaler.getBorderRadiusCircular(8.0)),
                 height: scaler.getHeight(2.5),
                 child: Text(DateTimeHelper.timeConversion(provider.startTime))
                     .regularText(ColorConstants.colorGray,
                     scaler.getTextSize(9.5), TextAlign.center),
               ),
             )
           ],
         ),
       ),
     );
   }

   Widget endDateTimePickField(
       BuildContext context, ScreenScaler scaler, PublicLocationCreateEventProvider provider) {
     return Container(
       height: scaler.getHeight(4),
       width: double.infinity,
       decoration: BoxDecoration(
           color: ColorConstants.colorLightGray,
           border: Border.all(
             color: ColorConstants.colorLightGray,
           ),
           borderRadius: scaler.getBorderRadiusCircular(8.0)),
       child: Container(
         padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             GestureDetector(
               onTap: () {
                 hideKeyboard(context);
                 provider.pickDateDialog(context, false);
               },
               child: Container(
                 padding: scaler.getPaddingLTRB(1.5, 0.0, 1.5, 0.0),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                     color: ColorConstants.colorWhite,
                     border: Border.all(
                       color: ColorConstants.colorWhite,
                     ),
                     borderRadius: scaler.getBorderRadiusCircular(8.0)),
                 height: scaler.getHeight(2.5),
                 child: Text(
                     DateTimeHelper.dateConversion(provider.endDate))
                     .regularText(ColorConstants.colorGray,
                     scaler.getTextSize(9.5), TextAlign.center),
               ),
             ),
             GestureDetector(
               onTap: () {
                 hideKeyboard(context);
                 provider.selectTimeDialog(context, false);
               },
               child: Container(
                 padding: scaler.getPaddingLTRB(1.5, 0.0, 1.5, 0.0),
                 alignment: Alignment.center,
                 decoration: BoxDecoration(
                     color: ColorConstants.colorWhite,
                     border: Border.all(
                       color: ColorConstants.colorWhite,
                     ),
                     borderRadius: scaler.getBorderRadiusCircular(8.0)),
                 height: scaler.getHeight(2.5),
                 child: Text(DateTimeHelper.timeConversion(provider.endTime))
                     .regularText(ColorConstants.colorGray,
                     scaler.getTextSize(9.5), TextAlign.center),
               ),
             )
           ],
         ),
       ),
     );
   }


}
