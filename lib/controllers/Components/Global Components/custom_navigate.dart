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
