import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/decoration.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/edit_group_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/imagePickerDialog.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class CreateEditGroupScreen extends StatelessWidget {
  CreateEditGroupScreen({Key? key}) : super(key: key);
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorConstants.colorWhite,
          appBar: DialogHelper.appBarWithBack(scaler, context),
          body: BaseView<EditGroupProvider>(builder: (builder, provider, _) {
            return LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: scaler.getPaddingLTRB(2.5, 1.0, 2.5, 1.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  var value = await provider.permissionCheck();
                                  if (value) {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialog(
                                              cameraClick: () {
                                                provider.getImage(context, 1);
                                              },
                                              galleryClick: () {
                                                provider.getImage(context, 2);
                                              },
                                              cancelClick: () {
                                                Navigator.of(context).pop();
                                              },
                                            ));
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Stack(
                                    children: [
                                      provider.image == null
                                          ? provider.imageUrl != null
                                              ? ImageView(
                                                  path: provider.imageUrl,
                                                  width: scaler.getWidth(20),
                                                  fit: BoxFit.cover,
                                                  height: scaler.getWidth(20),
                                                )
                                              : Container(
                                                  color: ColorConstants
                                                      .primaryColor,
                                                  width: scaler.getWidth(20),
                                                  height: scaler.getWidth(20),
                                                )
                                          : provider.image != null
                                              ? ImageView(
                                                  file: provider.image,
                                                  width: scaler.getWidth(20),
                                                  fit: BoxFit.cover,
                                                  height: scaler.getWidth(20),
                                                )
                                              : Container(
                                                  color: ColorConstants
                                                      .primaryColor,
                                                  width: scaler.getWidth(20),
                                                  height: scaler.getWidth(20),
                                                ),
                                      Positioned(
                                          right: 5,
                                          top: 5,
                                          child: CircleAvatar(
                                            radius: scaler.getWidth(2),
                                            child: ClipOval(
                                              child: Container(
                                                color:
                                                    ColorConstants.colorWhite,
                                                width: scaler.getWidth(5),
                                                height: scaler.getHeight(5),
                                                child: Center(
                                                  child: ImageView(
                                                    color: ColorConstants
                                                        .colorBlack,
                                                    path:
                                                        ImageConstants.ic_edit,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: scaler.getHeight(2)),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("name".tr()).boldText(Colors.black,
                                  scaler.getTextSize(9.5), TextAlign.center),
                            ),
                            SizedBox(
                              height: scaler.getHeight(0.2),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: nameController,
                              style: ViewDecoration.textFieldStyle(
                                  scaler.getTextSize(9.5),
                                  ColorConstants.colorBlack),
                              decoration:
                                  ViewDecoration.inputDecorationWithCurve(
                                      "Ian Hacks",
                                      scaler,
                                      ColorConstants.primaryColor),
                              onFieldSubmitted: (data) {
                                // FocusScope.of(context).requestFocus(nodes[1]);
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "group_name_required".tr();
                                }
                                {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: scaler.getHeight(1),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text("description".tr()).boldText(
                                  Colors.black,
                                  scaler.getTextSize(9.5),
                                  TextAlign.center),
                            ),
                            SizedBox(
                              height: scaler.getHeight(0.2),
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: descriptionController,
                              style: ViewDecoration.textFieldStyle(
                                  scaler.getTextSize(9.5),
                                  ColorConstants.colorBlack),
                              decoration:
                                  ViewDecoration.inputDecorationWithCurve(
                                      "random@random.com",
                                      scaler,
                                      ColorConstants.primaryColor),
                              onFieldSubmitted: (data) {
                                // FocusScope.of(context).requestFocus(nodes[1]);
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                            ),
                            SizedBox(
                              height: scaler.getHeight(2.5),
                            ),
                            CommonWidgets.settingsPageCard(
                                scaler,
                                context,
                                ImageConstants.person_icon,
                                "manage_group_contacts".tr(),
                                true, onTapCard: () {
                              if (_formKey.currentState!
                                  .validate()){
                                Navigator.pushNamed(
                                    context, RoutesConstants.groupContactsScreen);
                              }
                            }),
                            SizedBox(
                              height: scaler.getHeight(2),
                            ),
                            CommonWidgets.expandedRowButton(context, scaler, "discard".tr(), "save_changes".tr())
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
          })),
    );
  }
}
