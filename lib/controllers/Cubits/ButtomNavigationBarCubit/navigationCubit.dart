import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/NavStates.dart';
import 'package:xeats/views/HomePage/HomePage.dart';
import 'package:xeats/views/Profile/Profile.dart';
import 'package:xeats/views/Resturants/Resturants.dart';

class NavBarCubitcubit extends Cubit<NavBarCubitStates> {
  NavBarCubitcubit() : super(SuperNavBarCubitStates());

  int currentindex = 0;
  List<Widget> Screens = [
    const HomePage(),
    Restaurants(),
    const Profile(),
  ];

  static NavBarCubitcubit get(context) => BlocProvider.of(context);

  void changebottomnavindex(int index) {
    currentindex = index;

    emit(ChangeSuccefully());
  }

  List<BottomNavigationBarItem> bottomitems = const [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home_filled,
        color: Colors.white,
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.restaurant,
          color: Colors.white,
        ),
        label: 'Restaurants'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        label: 'Profile'),
  ];
}
