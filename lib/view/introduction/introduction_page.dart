import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/helper/shared_pref.dart';
import 'package:meetmeyou_app/provider/introduction_provider.dart';
import 'package:meetmeyou_app/view/base_view.dart';
import 'package:meetmeyou_app/widgets/custom_shape.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class IntroductionPage extends StatefulWidget {

  const IntroductionPage({Key? key}) : super(key: key);

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  PageController? controller;
  
  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()
      ..init(context);
    return SafeArea(
      child: BaseView<IntroductionProvider>(
        onModelReady: (provider){
           provider.setUpList();
        },
        builder: (context,provider,_){
          return Scaffold(
            backgroundColor: ColorConstants.colorWhite,
            body: Padding(
              padding: scaler.getPaddingAll(13),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: scaler.getHeight(50),
                      child: PageView.builder(
                        physics: ClampingScrollPhysics(),
                        itemCount: provider.introWidgetsList.length,
                        onPageChanged: (int page) {
                         provider.pageChange(page);
                        },
                        controller: controller,
                        itemBuilder: (context, index) {
                          return provider.introWidgetsList[index];
                        },
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: controller!,
                      count: provider.introWidgetsList.length,
                      axisDirection: Axis.horizontal,
                      effect: WormEffect(dotColor: ColorConstants.colorGray,
                          activeDotColor: ColorConstants.primaryColor,
                          dotWidth: scaler.getWidth(1.5),
                          dotHeight: scaler.getWidth(1.5)),
                    ),

                    SizedBox(height: scaler.getHeight(5),),
                    GestureDetector(
                      onTap: (){
                        if(provider.buttonText=="getStarted".tr()){
                          SharedPref.prefs?.setBool(SharedPref.INTRODUCTION_COMPLETE, true);
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                              RoutesConstants.loginOptions,
                                  (route) => false);
                        }else{
                          controller!.nextPage(duration: Duration(milliseconds: 400),
                              curve: Curves.easeIn);
                        }
                      },
                      child: CustomShape(
                        child: Center(child: Text(provider.buttonText).mediumText(
                            ColorConstants.colorWhite, scaler.getTextSize(10),
                            TextAlign.center)),
                        bgColor: ColorConstants.primaryColor,
                        radius: BorderRadius.all(Radius.circular(10)),
                        height: scaler.getHeight(4),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
