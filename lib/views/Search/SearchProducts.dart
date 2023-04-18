// ignore_for_file: use_build_context_synchronously

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsStates.dart';
import 'package:xeats/views/CategoryView/categoryView.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/Profile/Profile.dart';

class SearchProductsScreen extends StatefulWidget {
  SearchProductsScreen({
    super.key,
    this.restaurantID,
    required this.category,
    required this.categoryId,
    required this.restaurantName,
  });
  final String? restaurantID;

  final String? category;
  final String? categoryId;
  final String? restaurantName;

  @override
  State<SearchProductsScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsStates>(
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
                    controller: ProductsCubit.get(context).searchController,
                    onSubmitted: (value) async {
                      setState(() async {
                        await ProductsCubit.get(context)
                            .ClearProductsId()
                            .then((value) async {
                          await ProductsCubit.get(context).GetIdOfProducts(
                            context,
                            id: widget.restaurantID,
                          );
                          await ProductsCubit.get(context)
                              .SearchOnListOfProduct(
                            context,
                          );
                          if (ProductsCubit.get(context)
                                  .ArabicName
                                  .toString()
                                  .toLowerCase()
                                  .contains(ProductsCubit.get(context)
                                      .searchController
                                      .text
                                      .toLowerCase()) ||
                              ProductsCubit.get(context)
                                  .EnglishName
                                  .toString()
                                  .toLowerCase()
                                  .contains(ProductsCubit.get(context)
                                      .searchController
                                      .text
                                      .toLowerCase())) {
                            super.widget;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(milliseconds: 1500),
                              content: Text(
                                  "There isn't product called ${ProductsCubit.get(context).searchController.text}"),
                              backgroundColor: Colors.red,
                            ));
                          }
                        });
                      });
                    },
                  ),
                ),
                FutureBuilder(
                    future: ProductsCubit.get(context).getListOfProducts(
                        context,
                        restaurantName: widget.restaurantName,
                        CatId: widget.categoryId,
                        category: widget.category),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData &&
                          ProductsCubit.get(context).data != null) {
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
              await ProductsCubit.get(context).ClearProductsId();
              if (index == 1) {
                await ProductsCubit.get(context).ClearProductsId();
              } else if (index == 0) {
                await ProductsCubit.get(context).ClearProductsId();
                Navigation(context, Layout());
              } else {
                await ProductsCubit.get(context).ClearProductsId();
                Navigation(context, Profile());
              }
            },
          ),
        );
      },
    );
  }
}
