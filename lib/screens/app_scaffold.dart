import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final Color? drawerScrimColor;
  final double? drawerEdgeWidth;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final EdgeInsetsGeometry padding;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerScrimColor,
    this.drawerEdgeWidth,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      drawerDragStartBehavior: drawerDragStartBehavior,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeWidth,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: Padding(
        padding: padding,
        child: body,
      ),
    );
  }
}