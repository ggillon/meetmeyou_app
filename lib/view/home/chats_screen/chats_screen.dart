import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorConstants.colorNewGray,
        // automaticallyImplyLeading: false,
        // leading: Center(child: Row(
        //   children: [
        //     SizedBox(width: scaler.getWidth(3.0)),
        //     Text("edit".tr()).mediumText(Colors.blue, scaler.getTextSize(10.5), TextAlign.center)
        //   ],
        // )),
        title: Text("chats".tr()).mediumText(ColorConstants.colorBlack, scaler.getTextSize(10.5), TextAlign.center),
        actions: [
          Row(
            children: [
              Icon(Icons.chat, color: Colors.blue,),
              SizedBox(width: scaler.getWidth(3.0)),
            ],
          )
        ],
      ),
      body: usersList(context, scaler),
    );
  }

  Widget usersList(BuildContext context, ScreenScaler scaler){
    return ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index){
      return Column(
        children: <Widget>[
          Padding(
            padding: scaler.getPaddingAll(8.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 74.0,
                ),
                Expanded(
                  child: Padding(
                    padding: scaler.getPaddingAll(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Sam Kalra").boldText(ColorConstants.colorBlack, scaler.getTextSize(10.8), TextAlign.left),
                            Text(
                              "Yesterday").regularText(ColorConstants.colorGray, scaler.getTextSize(10.0), TextAlign.left),
                          ],
                        ),
                        Padding(
                          padding: scaler.getPaddingLTRB(0.0, 0.4, 0.0, 0.0),
                          child: Text(
                            "Hiiiiiii, i am using meetMeYou ").regularText(ColorConstants.colorGray, scaler.getTextSize(10.0), TextAlign.left),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(),
        ],
      );
    });
  }
}