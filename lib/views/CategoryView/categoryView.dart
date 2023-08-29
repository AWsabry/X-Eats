// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Components/Product%20Class/Products_Class.dart';

import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsStates.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/Profile/Profile.dart';

class CategoriesView extends StatelessWidget {
  final String? category;
  final String? categoryId;
  final String? restaurantName;
  final String? image;
  const CategoriesView({
    super.key,
    required this.restaurantID,
    required this.category,
    required this.categoryId,
    required this.restaurantName,
    required this.image,
  });

  final String? restaurantID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit()
        ..getCurrentProducts(context, id: restaurantID, CatId: categoryId),
      child: BlocBuilder<ProductsCubit, ProductsStates>(
        builder: ((context, state) {
          var navcubit = NavBarCubitcubit.get(context);
          return Scaffold(
            appBar: appBar(context, subtitle: restaurantName, title: category),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  ConditionalBuilder(
                    fallback: (context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    condition: ProductsCubit.get(context)
                            .getProductsByCategoryResponse
                            ?.data !=
                        null,
                    builder: ((context) {
                      return Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return ProductClass(
                                itemImage: image![index],
                                englishName: ProductsCubit.get(context)
                                    .getProductsByCategoryResponse!
                                    .data["Names"][index]["name"],
                                arabicName: ProductsCubit.get(context)
                                    .getProductsByCategoryResponse!
                                    .data["Names"][index]["ArabicName"],
                                price: ProductsCubit.get(context)
                                    .getProductsByCategoryResponse!
                                    .data["Names"][index]["price"],
                                id: ProductsCubit.get(context)
                                    .getProductsByCategoryResponse!
                                    .data["Names"][index]["id"],
                                description: ProductsCubit.get(context)
                                    .getProductsByCategoryResponse!
                                    .data["Names"][index]["description"],
                                creationDate: ProductsCubit.get(context)
                                    .getProductsByCategoryResponse!
                                    .data["Names"][index]["created"],
                                restaurant: ProductsCubit.get(context)
                                    .getProductsByCategoryResponse!
                                    .data["Names"][index]["Restaurant"],
                                isBestOffer: ProductsCubit.get(context)
                                    .getProductsByCategoryResponse!
                                    .data["Names"][index]["Best_Offer"],
                                isMostPopular: ProductsCubit.get(context)
                                    .getProductsByCategoryResponse!
                                    .data["Names"][index]["Most_Popular"],
                                isNewProduct: ProductsCubit.get(context)
                                    .getProductsByCategoryResponse!
                                    .data["Names"][index]["New_Products"],
                              ).productsOfCategory(context,
                                  image: AppConstants.BaseUrl +
                                      "/uploads/" +
                                      ProductsCubit.get(context)
                                          .getProductsByCategoryResponse!
                                          .data["Names"][index]["image"],
                                  category: category,
                                  CatId: categoryId,
                                  restaurantName: restaurantName,
                                  price: ProductsCubit.get(context)
                                      .getProductsByCategoryResponse!
                                      .data["Names"][index]["price"]);
                            },
                            separatorBuilder: ((context, index) {
                              return const Divider();
                            }),
                            itemCount: ProductsCubit.get(context)
                                .getProductsByCategoryResponse!
                                .data["Names"]
                                .length),
                      );
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
        }),
      ),
    );
  }
}
