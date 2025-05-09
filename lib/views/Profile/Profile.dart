import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/Auth%20Components/ProfileMenu.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/States.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/theme.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/Resturants/Resturants.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          var navcubit = NavBarCubitcubit.get(context);
          return ConditionalBuilder(
            fallback: (context) => const Center(child: Loading()),
            condition: AuthCubit.get(context).userEmailShared != null,
            builder: (BuildContext context) {
              return Scaffold(
                appBar: appBar(context, subtitle: 'Your', title: 'Profile'),
                body: SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height / 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: width / 10),
                              child: Text.rich(
                                TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: "Name: ${cubit.firstNameShared}\n",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ThemeApp.accentColor),
                                    ),
                                    TextSpan(
                                      text:
                                          "Email: ${AuthCubit.get(context).userEmailShared}\n",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ThemeApp.accentColor),
                                    ),
                                    TextSpan(
                                      text: "Wallet: ${cubit.walletShared} \n",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ThemeApp.accentColor),
                                    ),
                                    TextSpan(
                                      text:
                                          "Phonenumber: ${cubit.phoneNumberShared} \n",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ThemeApp.accentColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: height / 20),
                                ProfileMenu(
                                  text: "My Orders (Soon) ",
                                  icon: "assets/icons/receipt.svg",
                                  press: () {},
                                ),
                                SizedBox(height: height / 20),
                                ProfileMenu(
                                  text: 'Sign Out',
                                  press: () {
                                    cubit.signOut(context);
                                  },
                                  icon: "assets/icons/Log out.svg",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  unselectedItemColor: Colors.white,
                  unselectedFontSize: 9,
                  selectedFontSize: 12,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  selectedItemColor: Theme.of(context).primaryColor,
                  items: navcubit.bottomitems,
                  currentIndex: 2,
                  onTap: (index) {
                    if (index == 2) {
                      Navigator.popUntil(context, (route) => route.isCurrent);
                    } else if (index == 0) {
                      Navigation(context, Layout());
                    } else {
                      Navigation(
                          context,
                          Restaurants(
                              currentLocation: OrderCubit.currentLocation));
                    }
                  },
                ),
              );
            },
          );
        });
  }
}
