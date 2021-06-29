import 'package:flutter/material.dart';

showCustomSnackBar(Text text) {
  return SnackBar(
    content: text,
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
}
