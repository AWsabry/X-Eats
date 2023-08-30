import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton({
    Key? key,
    required this.function,
    required this.text,
  }) : super(key: key);

  final bool isUppercase = true;
  final double radius = 20;
  final VoidCallback function;
  final String text;

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 55.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(widget.radius)),
            ),
        onPressed: widget.function,
        child: Text(widget.isUppercase ? widget.text : widget.text,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 16.0.sp,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }
}
