import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum SnackBarType { success, error, warning }

void ShowSnackbar({
  required BuildContext context,
  required SnackBarType type,
  required String message,
}) {
  switch (type) {
    case SnackBarType.success:
      CherryToast.success(
        title: Text(
          'Success',
          style: GoogleFonts.montez(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        description: Text(
          message,
          style: GoogleFonts.montez(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        toastDuration: Duration(milliseconds: 2000),
        toastPosition: Position.top,
        shadowColor: Colors.white,

        animationDuration: const Duration(milliseconds: 500),
        autoDismiss: true,
        animationType: AnimationType.fromTop,
        backgroundColor: Colors.green.withAlpha(40),
      ).show(context);
      break;

    case SnackBarType.error:
      CherryToast.success(
        title: Text(
          'Error',
          style: GoogleFonts.montez(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        description: Text(
          message,
          style: GoogleFonts.montez(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        toastDuration: Duration(milliseconds: 2000),
        toastPosition: Position.top,
        shadowColor: Colors.white,

        animationDuration: const Duration(milliseconds: 500),
        autoDismiss: true,
        animationType: AnimationType.fromTop,
        backgroundColor: Colors.green.withAlpha(40),
      ).show(context);
    case SnackBarType.warning:
      // TODO: Handle this case.
      throw UnimplementedError();
  }
}
