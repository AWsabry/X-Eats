// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsStates.dart';
import 'package:xeats/core/logger.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/Profile/Profile.dart';

class SearchProductsScreen extends StatefulWidget {
  const SearchProductsScreen({
    super.key,
    required this.restaurantName,
  });
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
              title: ProductsCubit.get(context).searchController.text,
              subtitle: widget.restaurantName),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
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
                    onChanged: (value) {
                      ProductsCubit.get(context)
                          .GetSearchedProductsInRestaurant(
                              context, widget.restaurantName!);

                      AppLogger.d(ProductsCubit.get(context)
                          .searchedProducts
                          .length
                          .toString());
                    },
                  ),
                ),
                FutureBuilder(
                  future: ProductsCubit.get(context).getCurrentProducts(context,
                      restaurantName: widget.restaurantName,
                      id: ProductsCubit.get(context).searchedProducts[0]
                          ['Restaurant'],
                      CatId: ProductsCubit.get(context).searchedProducts[0]
                          ['category'],
                      image: ProductsCubit.get(context).searchedProducts[0]
                          ['image'],
                      category: ProductsCubit.get(context).searchedProducts[0]
                          ['category_name']),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else {
                      return const Loading();
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
              await ProductsCubit.get(context).ClearProductsId();
              if (index == 1) {
                await ProductsCubit.get(context).ClearProductsId();
              } else if (index == 0) {
                await ProductsCubit.get(context).ClearProductsId();
                Navigation(context, Layout());
              } else {
                await ProductsCubit.get(context).ClearProductsId();
                Navigation(context, const Profile());
              }
            },
          ),
        );
      },
    );
  }
}
