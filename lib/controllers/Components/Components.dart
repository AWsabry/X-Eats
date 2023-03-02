import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

void NavigateAndRemov(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

void Navigation(context, widget,
        {Duration duration = const Duration(seconds: 1)}) =>
    Navigator.push(
      context,
      PageRouteBuilder(
          pageBuilder: (context, a1, a2) => widget,
          transitionDuration: duration),
    );
void NavigationToSameScreen(context, widget,
        {Duration duration = const Duration(seconds: 1)}) =>
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
          pageBuilder: (context, a1, a2) => widget,
          transitionDuration: duration),
    );

// Widget CircularNotchBottom(
//         {required List<BottomNavigationBarItem> Items,
//         CircularNotchedRectangle? Circle,
//         required int currentindex,
//         int? notchMargin,
//         Color? color,
//         Function(int)? ontap}) =>
//     BottomNavigationBar(currentIndex: currentindex, onTap: ontap, items: Items);

Widget Dividerr() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 5.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );

List<DropdownMenuItem> getTimings() {
  var hour = DateTime.now().hour;
  List<DropdownMenuItem> timings = [];

  if (hour < 11) {
    timings.add(DropdownMenuItem(
      child: Text("11:00 AM"),
      value: "11:00 AM",
    ));
  }
  if (hour < 13) {
    timings.add(DropdownMenuItem(
      child: Text("1:00 PM"),
      value: "1:00 PM",
    ));
  }
  if (hour < 15) {
    timings.add(DropdownMenuItem(
      child: Text("3:00 PM"),
      value: "3:00 PM",
    ));
  }
  return timings;
}

String? currentTiming;
