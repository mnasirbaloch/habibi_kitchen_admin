import 'package:flutter/material.dart';

void showSnackBar(
    {required BuildContext context,
    required String content,
    TextStyle? textStyle,
    TextAlign? textAlign,
    Duration? duration}) {
  bool isAssert = true;
  SnackBar snackBar = SnackBar(
    content: Text(
      content,
      textAlign: textAlign ?? TextAlign.center,
      style: textStyle ?? const TextStyle(),
    ),
    duration: duration ?? const Duration(seconds: 2),
  );
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  } catch (error) {
    isAssert = false;
    assert(isAssert, "Context not found to show snackbar");
  }
}
