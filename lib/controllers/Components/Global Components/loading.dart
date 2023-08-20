import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(25.0),
      child: SpinKitFadingCircle(
        color: Color.fromARGB(255, 9, 134, 211),
        size: 30,
      ),
    );
  }
}
