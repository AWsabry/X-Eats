import 'package:flutter/material.dart';

void NavigateAndRemov(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);

void Navigation(context, widget,
        {Duration duration = const Duration(seconds: 1)}) =>
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, a1, a2) => widget,
        transitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Alignment.topCenter;
          var end = Alignment.center;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return AlignTransition(
            alignment: animation.drive(tween),
            // turns: animation.drive(tween),
            child: child,
          );
        },
      ),
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
    timings.add(const DropdownMenuItem(
      value: "11:00 AM",
      child: Text("11:00 AM"),
    ));
  }
  if (hour < 13) {
    timings.add(const DropdownMenuItem(
      value: "1:00 PM",
      child: Text("1:00 PM"),
    ));
  }
  if (hour < 15) {
    timings.add(const DropdownMenuItem(
      value: "3:00 PM",
      child: Text("3:00 PM"),
    ));
  }
  return timings;
}

String? currentTiming;
