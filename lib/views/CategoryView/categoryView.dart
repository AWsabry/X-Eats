// ignore_for_file: use_build_context_synchronously

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/Components.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/ItemClass.dart';
import 'package:xeats/controllers/Cubit.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/States.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/Profile/Profile.dart';
import 'package:xeats/views/Search/SearchProducts.dart';

class CategoriesView extends StatelessWidget {
  final String? image;
  final String? category;
  final String? categoryId;
  final String? restaurantName;

  const CategoriesView({
    super.key,
    required this.restaurantID,
    required this.image,
    required this.category,
    required this.categoryId,
    required this.restaurantName,
  });

  final String? restaurantID;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Xeatscubit, XeatsStates>(
      builder: ((context, state) {
        var navcubit = NavBarCubitcubit.get(context);
        return Scaffold(
          appBar: appBar(context, subtitle: restaurantName, title: category),
          body: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                FutureBuilder(
                  future: Xeatscubit.get(context).getCurrentProducts(context,
                      restaurantName: restaurantName,
                      id: restaurantID,
                      CatId: categoryId,
                      image: image,
                      category: category),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else {
                      return Loading();
                    }
                  }),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: GoogleFonts.poppins(),
            backgroundColor: Colors.white,
            items: navcubit.bottomitems,
            currentIndex: 1,
            onTap: (index) async {
              Navigator.pop(context);
              await Xeatscubit.get(context).ClearId();
              if (index == 1) {
                await Xeatscubit.get(context).ClearId();
              } else if (index == 0) {
                await Xeatscubit.get(context).ClearId();
                Navigation(context, Layout());
              } else {
                await Xeatscubit.get(context).ClearId();
                Navigation(context, Profile());
              }
            },
          ),
        );
      }),
    );
  }
}
