// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllers/Cubits/ButtomNavigationBarCubit/NavStates.dart';
import '../../controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';

class Layout extends StatelessWidget {
  Layout({super.key}) {}

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
