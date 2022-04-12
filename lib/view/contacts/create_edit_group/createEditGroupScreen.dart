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
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/group_detail.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/create_edit_group_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/widgets/imagePickerDialog.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateEditGroupScreen extends StatelessWidget {
  CreateEditGroupScreen({Key? key}) : super(key: key);

  final groupNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        appBar: DialogHelper.appBarWithBack(scaler, context),
        body: BaseView<CreateEditGroupProvider>(onModelReady: (provider) {
          groupNameController.text = provider.groupDetail.createGroup ?? false
              ? ""
              : provider.groupDetail.groupName ?? "";
          descriptionController.text = provider.groupDetail.createGroup ?? false
              ? ""
              : provider.groupDetail.about ?? "";
        }, builder: (context, provider, _) {
          return SafeArea(
            child: LayoutBuilder(builder: (context, constraint) {
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
                                  if (await Permission.storage.request().isGranted) {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialog(
                                              cameraClick: () {
                                                provider.getImage(context, 1);
                                              },
                                              galleryClick: () {
                                                provider.getImage(context, 2).catchError((e){
                                                  CommonWidgets.errorDialog(context, "enable_storage_permission".tr());
                                                });
                                              },
                                              cancelClick: () {
                                                Navigator.of(context).pop();
                                              },
                                            ));
                                  } else if(await Permission.storage.request().isDenied){
                                    Map<Permission, PermissionStatus> statuses = await [
                                      Permission.storage,
                                    ].request();
                                  } else if(await Permission.storage.request().isPermanentlyDenied){
                                    CommonWidgets.errorDialog(context, "enable_storage_permission".tr());
                                  }
                                  // var value = await provider.permissionCheck();
                                  // if (value) {
                                  //   showDialog(
                                  //       barrierDismissible: false,
                                  //       context: context,
                                  //       builder: (BuildContext context) =>
                                  //           CustomDialog(
                                  //             cameraClick: () {
                                  //               provider.getImage(context, 1);
                                  //             },
                                  //             galleryClick: () {
                                  //               provider.getImage(context, 2);
                                  //             },
                                  //             cancelClick: () {
                                  //               Navigator.of(context).pop();
                                  //             },
                                  //           ));
                                  // }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Stack(
                                    children: [
                                      provider.image == null
                                          ? provider.groupDetail
                                                      .groupPhotoUrl !=
                                                  null
                                              ? Container(
                                                  width: scaler.getWidth(20),
                                                  height: scaler.getWidth(20),
                                                  child: ImageView(
                                                    path: provider.groupDetail
                                                        .groupPhotoUrl,
                                                    width: scaler.getWidth(20),
                                                    fit: BoxFit.cover,
                                                    height: scaler.getWidth(20),
                                                  ),
                                                )
                                              : Container(
                                                  color: ColorConstants
                                                      .primaryColor,
                                                  width: scaler.getWidth(20),
                                                  height: scaler.getWidth(20),
                                                )
                                          : provider.image != null
                                              ? Container(
                                                  width: scaler.getWidth(20),
                                                  height: scaler.getWidth(20),
                                                  child: ImageView(
                                                    file: provider.image,
                                                    width: scaler.getWidth(20),
                                                    fit: BoxFit.cover,
                                                    height: scaler.getWidth(20),
                                                  ),
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
                              controller: groupNameController,
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
                            SizedBox(height: scaler.getHeight(2.5)),
                            provider.groupDetail.createGroup ?? false
                                ? provider.groupCreated
                                    ? CommonWidgets.settingsPageCard(
                                        scaler,
                                        context,
                                        ImageConstants.person_icon,
                                        "manage_group_contacts".tr(),
                                        true, onTapCard: () {
                                        if (_formKey.currentState!.validate()) {
                                          Navigator.pushNamed(
                                                  context,
                                                  RoutesConstants
                                                      .groupContactsScreen)
                                              .then((value) {
                                            provider.update = true;
                                          });
                                        }
                                      })
                                    : Container()
                                : CommonWidgets.settingsPageCard(
                                    scaler,
                                    context,
                                    ImageConstants.person_icon,
                                    "manage_group_contacts".tr(),
                                    true, onTapCard: () {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.pushNamed(
                                        context,
                                        RoutesConstants.groupContactsScreen,
                                      ).then((value) {
                                        provider.update = true;
                                      });
                                    }
                                  }),
                            SizedBox(height: scaler.getHeight(2)),
                            provider.groupDetail.createGroup ?? false
                                ? Container()
                                : provider.groupDelete == true
                                    ? Center(
                                        child: CircularProgressIndicator())
                                    : Expanded(
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          child: DialogHelper.btnWidget(
                                              scaler,
                                              context,
                                              "delete_group".tr(),
                                              ColorConstants.colorRed,
                                              funOnTap: ()  {
                                            DialogHelper.showDialogWithTwoButtons(
                                                context,
                                                "Delete Group",
                                                "Are you sure you want to delete this group?", positiveButtonPress: (){
                                               provider.deleteGroup(context);
                                            });
                                          }),
                                        ),
                                      ),
                            SizedBox(height: scaler.getHeight(1)),
                            provider.groupDetail.createGroup ?? false
                                ? provider.state == ViewState.Busy
                                    ? Expanded(
                                        child: Container(
                                            alignment: Alignment.bottomCenter,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                CircularProgressIndicator(),
                                                SizedBox(
                                                    height:
                                                        scaler.getHeight(1)),
                                              ],
                                            )),
                                      )
                                    : Expanded(
                                        child: CommonWidgets.expandedRowButton(
                                            context,
                                            scaler,
                                            "discard".tr(),
                                            "save_changes".tr(), onTapBtn2: () {
                                          hideKeyboard(context);
                                          if (_formKey.currentState!
                                              .validate()) {
                                            provider.groupDetail.createGroup!
                                                ? provider.update
                                                    ? provider.updateGroupContact(
                                                        context,
                                                        provider.groupDetail
                                                                .groupCid ??
                                                            "",
                                                        groupName:
                                                            groupNameController
                                                                .text,
                                                        about:
                                                            descriptionController
                                                                .text)
                                                    : provider.createNewGroupContact(
                                                        context,
                                                        groupNameController
                                                            .text,
                                                        // groupImg: provider.groupDetail.groupPhotoUrl,
                                                        about:
                                                            descriptionController
                                                                .text)
                                                : provider.updateGroupContact(
                                                    context,
                                                    provider.groupDetail
                                                            .groupCid ??
                                                        "",
                                                    groupName:
                                                        groupNameController
                                                            .text,
                                                    about: descriptionController
                                                        .text);
                                          }
                                        }),
                                      )
                                : provider.state == ViewState.Busy
                                    ? Container(
                                        alignment: Alignment.bottomCenter,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(
                                                height: scaler.getHeight(1)),
                                          ],
                                        ))
                                    : CommonWidgets.expandedRowButton(
                                        context,
                                        scaler,
                                        "discard".tr(),
                                        "save_changes".tr(), onTapBtn2: () {
                                        hideKeyboard(context);
                                        if (_formKey.currentState!.validate()) {
                                          provider.groupDetail.createGroup!
                                              ? provider.update
                                                  ? provider.updateGroupContact(
                                                      context,
                                                      provider.groupDetail
                                                              .groupCid ??
                                                          "",
                                                      groupName:
                                                          groupNameController
                                                              .text,
                                                      about: descriptionController
                                                          .text)
                                                  : provider.createNewGroupContact(
                                                      context,
                                                      groupNameController.text,
                                                      // groupImg: provider.groupDetail.groupPhotoUrl,
                                                      about: descriptionController
                                                          .text)
                                              : provider.updateGroupContact(
                                                  context,
                                                  provider.groupDetail.groupCid ??
                                                      "",
                                                  groupName:
                                                      groupNameController.text,
                                                  about: descriptionController
                                                      .text);
                                        }
                                      })
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }));
  }
}
