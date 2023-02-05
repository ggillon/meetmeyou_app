import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/extensions/allExtensions.dart';

class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;

  AnimatedToggle({
    required this.values,
    required this.onToggleCallback,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
  });

  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  bool initialPosition = true;

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = new ScreenScaler()..init(context);
    return Container(
      width: double.infinity,
      height: scaler.getHeight(4),
      margin: scaler.getMarginLTRB(2.2, 0.0, 2.2, 0.0),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              initialPosition = !initialPosition;
              var index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
              setState(() {});
            },
            child: Container(
              width: scaler.getWidth(100),
              height: scaler.getHeight(4),
              decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: scaler.getBorderRadiusCircular(15.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                    widget.values.length,
                    (index) => Container(
                          alignment: Alignment.center,
                          child: Text(widget.values[index]).semiBoldText(
                              ColorConstants.colorBlack,
                              scaler.getTextSize(9.5),
                              TextAlign.center),
                        )),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
                initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: scaler.getWidth(45),
              height: scaler.getHeight(4),
              decoration: BoxDecoration(
                  color: widget.buttonColor,
                  border: Border.all(
                    color: widget.backgroundColor,
                    width: scaler.getWidth(0.2), //
                  ),
                  borderRadius: scaler.getBorderRadiusCircular(15)),
              child: Text(initialPosition ? widget.values[0] : widget.values[1])
                  .semiBoldText(ColorConstants.colorBlack,
                      scaler.getTextSize(9.5), TextAlign.center),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
