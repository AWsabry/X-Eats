// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondaryButton extends StatefulWidget {
  SecondaryButton({
    Key? key,
    required this.function,
    required this.text,
  }) : super(key: key);

  double width = double.infinity;
  final bool isUppercase = true;
  final double radius = 20;
  final VoidCallback function;
  final String text;
  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.radius))),
        onPressed: widget.function,
        child: Row(children: [
          SizedBox(
            width: 117,
          ),
          Text(widget.isUppercase ? widget.text : widget.text,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontFamily: 'UberMoveTextBold',
                  fontSize: 25.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                ),
              )),
        ]),
      ),
    );
  }
}
