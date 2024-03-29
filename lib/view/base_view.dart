import 'package:flutter/material.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:provider/provider.dart';
import '../locator.dart';

class BaseView<T extends BaseProvider> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T)? onModelReady;

  BaseView({required this.builder, this.onModelReady});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseProvider> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (context) => model,
        child: Consumer<T>(builder: widget.builder));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider<T>.value(
  //       value: model,
  //       child: Consumer<T>(builder: widget.builder));
  // }
}
