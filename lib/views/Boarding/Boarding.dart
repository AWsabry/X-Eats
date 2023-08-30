import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:math' as math;
import 'dart:ui';

import 'package:xeats/theme.dart';

class Boarding extends StatelessWidget {
  const Boarding({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/Images/BG.png',
                    ),
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                Image(
                  height: height / 2.4,
                  image: const AssetImage('assets/Images/time.png'),
                ),
                Text(
                  "ON TIME!!!",
                  style: GoogleFonts.poppins(
                      fontSize: 40,
                      textStyle: const TextStyle(color: Colors.black)),
                ),
                const Spacer(),
                Container(
                  color: ThemeApp.primaryColor,
                  child: CustomPaint(
                    isComplex: true,

                    size: Size(
                        width,
                        height *
                            0.300), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                    painter: MyPainter(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = ThemeApp.primaryColor;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 1.3, size.width / 30),
        height: size.height,
        width: size.width + 12,
      ),
      math.pi * 2,
      math.pi * 2,
      false,
      paint,
    );
    final ParagraphBuilder paragraphBuilder = ParagraphBuilder(ParagraphStyle(
      fontSize: 40,
      textAlign: TextAlign.justify,
    ))
      ..addText('Welcome to X-eats');
    final Paragraph paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: size.width - 12.0 - 12.0));
    canvas.drawParagraph(paragraph, const Offset(12.0, 36.0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
