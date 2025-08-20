import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meetly/core/utils/const/color.dart';

class customButton extends StatelessWidget {
  final String data;
  Function()? onPressed;
  customButton({super.key, required this.data, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25),
      child: SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(

          style: ElevatedButton.styleFrom(
            fixedSize: Size(double.maxFinite, 55),
           backgroundColor: kblueColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            data,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
