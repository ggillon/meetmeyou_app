import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/provider/event_gallery_page_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/imagePickerDialog.dart';
import 'package:permission_handler/permission_handler.dart';

class EventGalleryPage extends StatelessWidget {
  EventGalleryPage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      key: _scaffoldKey,
      body: BaseView<EventGalleryPageProvider>(
        onModelReady: (provider){

        },
        builder: (context, provider, _){
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: scaler.getPaddingLTRB(2.5, 4.0, 2.5, 0.0),
                  child: Text(provider.eventDetail.event!.title.toString()).boldText(
                      ColorConstants.colorBlack,
                      scaler.getTextSize(12),
                      TextAlign.left, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                SizedBox(height: scaler.getHeight(2)),
                GestureDetector(
                  onTap: () async {
                    if (await Permission.storage.request().isGranted) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) =>
                              CustomDialog(
                                cameraClick: () {
                                  provider.getImage(
                                      _scaffoldKey.currentContext!, 1);
                                },
                                galleryClick: () {
                                  provider.getImage(
                                      _scaffoldKey.currentContext!, 2).catchError((e){
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
                  },
                    child: postPhotoBtn(scaler)),
              ],
            ),
          );
        },
      )
    );
  }

  Widget postPhotoBtn(ScreenScaler scaler){
    return Container(
      color: ColorConstants.colorLightCyan,
      height: scaler.getHeight(14.5),
      width: scaler.getWidth(30),
      alignment: Alignment.center,
      child: Icon(Icons.add, color: Colors.lightBlue, size: 50),
    );
  }
}
