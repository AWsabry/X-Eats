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
      backgroundColor: Color.fromRGBO(4, 137, 204, 1),
      icon: Icon(
        Icons.home_filled,
        color: Colors.black,
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
        backgroundColor: Color.fromRGBO(4, 137, 204, 1),
        icon: Icon(
          Icons.restaurant,
          color: Colors.black,
        ),
        label: 'Resturants'),
    BottomNavigationBarItem(
        backgroundColor: Color.fromRGBO(4, 137, 204, 1),
        icon: Icon(
          Icons.account_circle,
          color: Colors.black,
        ),
        label: 'Profile'),
  ];
}
