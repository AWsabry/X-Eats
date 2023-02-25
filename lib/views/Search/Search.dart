// ignore_for_file: use_build_context_synchronously

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/Components.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/ItemClass.dart';
import 'package:xeats/controllers/Cubit.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/States.dart';
import 'package:xeats/views/CategoryView/categoryView.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/Profile/Profile.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({
    super.key,
    this.restaurantID,
    required this.image,
    required this.category,
    required this.categoryId,
    required this.restaurantName,
  });
  final String? restaurantID;

  final String? image;
  final String? category;
  final String? categoryId;
  final String? restaurantName;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Xeatscubit, XeatsStates>(
      builder: (context, state) {
        var navcubit = NavBarCubitcubit.get(context);

        return Scaffold(
          appBar: appBar(context,
              title: widget.category, subtitle: widget.restaurantName),
          body: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "Search For Products",
                        prefixIcon: Icon(Icons.search)),
                    controller: Xeatscubit.get(context).searchController,
                    onSubmitted: (value) async {
                      setState(() async {
                        await Xeatscubit.get(context)
                            .ClearId()
                            .then((value) async {
                          await Xeatscubit.get(context).GetIdOfProducts(context,
                              id: widget.restaurantID,
                              CatId: widget.categoryId);

                          await Xeatscubit.get(context).SearchOnListOfProduct(
                              context,
                              CatId: widget.categoryId,
                              image: widget.image,
                              category: widget.category,
                              restaurantName: widget.restaurantName);
                          print("Khaled1${Xeatscubit.get(context).ArabicName}");
                          print(
                              "Khaled2${Xeatscubit.get(context).EnglishName}");
                          print(
                              "Khaled3${Xeatscubit.get(context).searchController.text}");

                          if (Xeatscubit.get(context)
                                  .ArabicName
                                  .toString()
                                  .toLowerCase()
                                  .contains(Xeatscubit.get(context)
                                      .searchController
                                      .text
                                      .toLowerCase()) ||
                              Xeatscubit.get(context)
                                  .EnglishName
                                  .toString()
                                  .toLowerCase()
                                  .contains(Xeatscubit.get(context)
                                      .searchController
                                      .text
                                      .toLowerCase())) {
                            super.widget;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(milliseconds: 1500),
                              content: Text(
                                  "There isn't product called ${Xeatscubit.get(context).searchController.text}"),
                              backgroundColor: Colors.red,
                            ));
                          }
                        });
                      });
                    },
                  ),
                ),
                FutureBuilder(
                    future: Xeatscubit.get(context).getListOfProducts(context,
                        restaurantName: widget.restaurantName,
                        CatId: widget.categoryId,
                        image: widget.image,
                        category: widget.category),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData &&
                          Xeatscubit.get(context).data != null) {
                        return snapshot.data!;
                      } else {
                        return Center(
                          child: Loading(),
                        );
                      }
                    })),
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
      },
    );
  }
}
