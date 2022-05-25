import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:image_stack/image_stack.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/image_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:meetmeyou_app/helper/common_widgets.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/provider/check_attendance_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/image_view.dart';

class CheckAttendanceScreen extends StatelessWidget {
  const CheckAttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: DialogHelper.appBarWithBack(scaler, context),
      body: BaseView<CheckAttendanceProvider>(
        onModelReady: (provider) async {
         await provider.getMultipleDateOptionsFromEvent(context).then((value) {
            provider.imageUrlAndAttendingKeysList(context);
          });
        },
        builder: (context, provider, _){
          return provider.state == ViewState.Busy ? Center(
            child: CircularProgressIndicator(),
          ) : Column(
            children: [
              Padding(
                padding: scaler.getPaddingLTRB(2.5, 0.0, 0.0, 0.0),
                child: optionsDesign(scaler, provider),
              ),
              SizedBox(height: scaler.getHeight(2.5)),
              multiDateGridView(context, scaler, provider)
            ],
          );
        },
      ),
    );
  }

  Widget multiDateGridView(BuildContext context, ScreenScaler scaler, CheckAttendanceProvider provider){
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          //  color: Colors.red,
           // height: scaler.getHeight(22.0),
            width: double.infinity,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: provider.multipleDate.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0),
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    CommonWidgets.gridViewOfMultiDateAlertDialog(
                        scaler, provider.multipleDate, index),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        provider.eventDetail.attendingProfileKeys = provider.eventAttendingKeysList[index];
                        Navigator.pushNamed(
                            context,
                            RoutesConstants
                                .eventAttendingScreen);
                      },
                      child: provider.eventAttendingPhotoUrlLists[index].length == 0 ? Container() : Row(
                        children: [
                          SizedBox(width: scaler.getWidth(3.8)),
                          ImageStack(
                            imageList: provider.eventAttendingPhotoUrlLists[index],
                            totalCount: 3,
                            imageRadius: 15,
                            imageCount: 3,
                            imageBorderColor:
                            ColorConstants.colorWhite,
                            backgroundColor:
                            ColorConstants.primaryColor,
                            imageBorderWidth: 1,
                            extraCountTextStyle: TextStyle(
                                fontSize: 7.7,
                                color:
                                ColorConstants.colorWhite,
                                fontWeight: FontWeight.w500),
                            showTotalCount: false,
                          ),
                          SizedBox(width: scaler.getWidth(0.2)),
                          Container(
                           // alignment: Alignment.centerLeft,
                           // color: Colors.red,
                            width: 20,
                            child: Text(provider.eventAttendingPhotoUrlLists[index].length.toString()).regularText(
                                ColorConstants.colorGray,
                                scaler.getTextSize(8),
                                TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(width: scaler.getWidth(0.1)),
                          Text("available".tr()).regularText(
                              ColorConstants.colorGray,
                              scaler.getTextSize(8),
                              TextAlign.center),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )),
      ),
    );
  }


  Widget optionsDesign(ScreenScaler scaler, CheckAttendanceProvider provider) {
    return Row(
      children: [
        Icon(Icons.calendar_today),
        SizedBox(width: scaler.getWidth(1.5)),
        Text("${provider.multipleDate.length} ${"options".tr()}")
            .mediumText(ColorConstants.colorBlackDown, scaler.getTextSize(10.5),
            TextAlign.center),
      ],
    );
  }
}
