import 'package:flutter/material.dart';

extension KeyboardStatus on BuildContext {
  bool get isKeyboardOpen => MediaQuery.viewInsetsOf(this).bottom > 0;
}
