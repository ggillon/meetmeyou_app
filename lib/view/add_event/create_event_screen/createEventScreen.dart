import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/provider/create_event_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class CreateEventScreen extends StatelessWidget {
  CreateEventScreen({Key? key}) : super(key: key);
  final eventNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorConstants.colorWhite,
          body: BaseView<CreateEventProvider>(
            builder: (builder, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  provider.imageUrl != null || provider.image != null
                      ? selectedImage(context, scaler, provider)
                      : imageSelectCard(context, scaler, provider),
                  SizedBox(height: scaler.getHeight(0.5)),
                  Padding(
                    padding: scaler.getPaddingAll(10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("event_name".tr()).boldText(Colors.black,
                              scaler.getTextSize(9.5), TextAlign.center),
                        ),
                        SizedBox(height: scaler.getHeight(0.2)),
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: eventNameController,
                          style: ViewDecoration.textFieldStyle(
                              scaler.getTextSize(9.5),
                              ColorConstants.colorBlack),
                          decoration: ViewDecoration.inputDecorationWithCurve(
                              "Thomas Birthday Party",
                              scaler,
                              ColorConstants.primaryColor),
                          onFieldSubmitted: (data) {
                            // FocusScope.of(context).requestFocus(nodes[1]);
                          },
                          textInputAction: TextInputAction.next,
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
                        SizedBox(
                          height: scaler.getHeight(1),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }

  Widget imageSelectCard(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
    return GestureDetector(
      onTap: () {
        selectImageBottomSheet(context, scaler, provider);
      },
      child: Card(
        margin: scaler.getMarginAll(0.0),
        shadowColor: ColorConstants.colorWhite,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircularLR(0.0, 0.0, 15, 15)),
        color: ColorConstants.colorLightGray,
        child: Container(
          padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 0.0),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: scaler.getHeight(5)),
              GestureDetector(
                onTap: () {},
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
        ),
      ),
    );
  }

  Widget selectedImage(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
    return GestureDetector(
      onTap: () {
        selectImageBottomSheet(context, scaler, provider);
      },
      child: Card(
        margin: scaler.getMarginAll(0.0),
        shadowColor: ColorConstants.colorWhite,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: scaler.getBorderRadiusCircularLR(0.0, 0.0, 15, 15)),
        color: ColorConstants.colorLightGray,
        child: Container(
          height: scaler.getHeight(30),
          width: double.infinity,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                      borderRadius:
                          scaler.getBorderRadiusCircularLR(0.0, 0.0, 15, 15),
                      child: provider.image == null
                          ? ImageView(
                              file: provider.image,
                              fit: BoxFit.cover,
                              height: scaler.getHeight(30),
                              width: double.infinity,
                            )
                          : ImageView(
                              path: provider.imageUrl,
                              fit: BoxFit.cover,
                              height: scaler.getHeight(30),
                              width: double.infinity,
                            )),
                  Positioned(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                          padding: scaler.getPaddingLTRB(0.0, 2, 3.0, 0.0),
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

  selectImageBottomSheet(
      BuildContext context, ScreenScaler scaler, CreateEventProvider provider) {
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
                  SizedBox(height: scaler.getHeight(2)),
                  GestureDetector(
                    onTap: () {
                      provider.getImage(context, 1);
                    },
                    child: Text("take_a_photo".tr()).regularText(
                        ColorConstants.primaryColor,
                        scaler.getTextSize(11),
                        TextAlign.center),
                  ),
                  SizedBox(height: scaler.getHeight(0.9)),
                  Divider(),
                  SizedBox(height: scaler.getHeight(0.9)),
                  GestureDetector(
                    onTap: () {
                      provider.getImage(context, 2);
                    },
                    child: Text("choose_photo".tr()).regularText(
                        ColorConstants.primaryColor,
                        scaler.getTextSize(11),
                        TextAlign.center),
                  ),
                  SizedBox(height: scaler.getHeight(0.9)),
                  Divider(),
                  SizedBox(height: scaler.getHeight(0.9)),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(
                              context, RoutesConstants.defaultPhotoPage)
                          .then((value) {
                        provider.imageUrl = value as String?;
                      });
                    },
                    child: Text("default_photo".tr()).regularText(
                        ColorConstants.primaryColor,
                        scaler.getTextSize(11),
                        TextAlign.center),
                  ),
                  SizedBox(height: scaler.getHeight(2)),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Text("cancel".tr()).semiBoldText(
                      ColorConstants.colorRed,
                      scaler.getTextSize(11),
                      TextAlign.center),
                ),
              ),
              SizedBox(height: scaler.getHeight(1)),
            ],
          );
        });
  }
}
