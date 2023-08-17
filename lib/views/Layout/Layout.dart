// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../controllers/Cubits/ButtomNavigationBarCubit/NavStates.dart';
import '../../controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';

class Layout extends StatelessWidget {
  String Hour = DateFormat("HH").format(DateTime.now());
  late String Hour1;
  late String Hour2;
  late String Minute1;
  late String Minute2;
  late int sum123;
  String minute = DateFormat.m().format(DateTime.now());
  String second = DateFormat.s().format(DateTime.now());

  var dt = DateTime.now();

  Layout({super.key}) {
    sum123 = int.parse(Hour + minute);

    Hour1 = Hour.substring(0, 1);
    Hour2 = Hour.substring(1);
    Minute1 = minute.substring(0, 1);
    Minute2 = minute.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavBarCubitcubit, NavBarCubitStates>(
        builder: ((context, state) {
          {
            var navcubit = NavBarCubitcubit.get(context);
            return Scaffold(body: navcubit.Screens[navcubit.currentindex]);
          }
        }),
        listener: ((context, state) {}));
  }
}
