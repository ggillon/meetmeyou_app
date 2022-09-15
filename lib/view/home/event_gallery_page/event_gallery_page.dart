import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/models/photo.dart';
import 'package:meetmeyou_app/provider/event_gallery_page_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/imagePickerDialog.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../video_player/video_player.dart' as video_player;

class EventGalleryPage extends StatelessWidget {
  EventGalleryPage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: DialogHelper.appBarWithBack(scaler, context),
      backgroundColor: ColorConstants.colorWhite,
      body: BaseView<EventGalleryPageProvider>(
        onModelReady: (provider){
          provider.getPhotoAlbum(context, provider.eventDetail.eid.toString(), postBtn: postPhotoBtn(context, scaler, provider)).then((value) {
         //   provider.galleryImagesUrl.insert(provider.galleryImagesUrl.length, postPhotoBtn(context, scaler, provider));
          });
        },
        builder: (context, provider, _){
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: scaler.getPaddingLTRB(2.5, 0.0, 2.5, 1.0),
                  child: Text(provider.eventDetail.event!.title.toString()).boldText(
                      ColorConstants.colorBlack,
                      scaler.getTextSize(12.5),
                      TextAlign.left, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                provider.getAlbum == true || provider.state == ViewState.Busy ? SizedBox(
                  height: scaler.getHeight(75),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(height: scaler.getHeight(1)),
                      Text("fetching_gallery".tr()).mediumText(
                          ColorConstants.primaryColor,
                          scaler.getTextSize(11),
                          TextAlign.left),
                    ],
                  ),
                ) :  galleryGridView(scaler, provider),

              ],
            ),
          );
        },
      )
    );
  }

  Widget galleryGridView(ScreenScaler scaler, EventGalleryPageProvider provider){
    return  Container(
        height: scaler.getHeight(100),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: provider.galleryImagesUrl.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0
          ),
          itemBuilder: (BuildContext context, int index){

            return(index+1) == provider.galleryImagesUrl.length ? provider.galleryImagesUrl[index] :
            (provider.mmyPhotoList[index].type == PHOTO_TYPE_VIDEO ?
            Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(provider.mmyPhotoList[index].videoPlayerController!),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, RoutesConstants.videoPlayer, arguments:
                    video_player.VideoPlayer(videoUrl: provider.mmyPhotoList[index].photoURL, fromDiscussion: false,
                    aid: provider.mmyPhotoList[index].aid, pid: provider.mmyPhotoList[index].pid, ownerId: provider.mmyPhotoList[index].ownerId,)).then((value) {
                      provider.getPhotoAlbum(_scaffoldKey.currentContext!, provider.eventDetail.eid.toString(), postBtn: postPhotoBtn(_scaffoldKey.currentContext!, scaler, provider));
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstants.colorWhitishGray,
                      shape: BoxShape.circle,
                    ),
                    padding: scaler.getPaddingAll(6.0),
                    child: Icon(Icons.play_arrow, size: 24, color: Colors.blueGrey,),
                  ),
                )
              ],
            ) : GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, RoutesConstants.eventGalleryImageView, arguments: provider.mmyPhotoList[index]).then((value) {
                  provider.getPhotoAlbum(_scaffoldKey.currentContext!, provider.eventDetail.eid.toString(), postBtn: postPhotoBtn(_scaffoldKey.currentContext!, scaler, provider));
                });
              },
                child: Card(child: ImageView(path: provider.galleryImagesUrl[index], fit: BoxFit.cover,))));
          },
        ));
  }

  Widget postPhotoBtn(BuildContext context, ScreenScaler scaler, EventGalleryPageProvider provider){
    return GestureDetector(
      onTap: () async {
        if (await Permission.storage.request().isGranted) {
          showDialog(
              barrierDismissible: false,
              context: _scaffoldKey.currentContext!,
              builder: (BuildContext context) =>
                  CustomDialog(
                    cameraClick: () {
                      provider.getImage(
                          _scaffoldKey.currentContext!, 1, postPhotoBtn(context, scaler, provider));
                    },
                    galleryClick: () {
                      provider.getImage(
                          _scaffoldKey.currentContext!, 2, postPhotoBtn(context, scaler, provider)).catchError((e){
                        CommonWidgets.errorDialog(_scaffoldKey.currentContext!, "enable_storage_permission".tr());
                      });
                    },
                    videoSelection: true,
                    videoClick: (){
                      provider.getImage(
                          _scaffoldKey.currentContext!, 3, postPhotoBtn(context, scaler, provider)).catchError((e){
                        CommonWidgets.errorDialog(_scaffoldKey.currentContext!, "enable_storage_permission".tr());
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
          CommonWidgets.errorDialog(_scaffoldKey.currentContext!, "enable_storage_permission".tr());
        }
      },
      child: Card(
        child: Container(
          color: ColorConstants.colorLightCyan,
          height: scaler.getHeight(14.5),
          width: scaler.getWidth(30),
          alignment: Alignment.center,
          child: Icon(Icons.add, color: Colors.lightBlue, size: 50),
        ),
      ),
    );
  }
}
