// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:xeats/controllers/Components/Categories%20Components/CategoryCard.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestaurantsStates.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestuarantsCubit.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/theme.dart';
import 'package:xeats/views/CategoryView/categoryView.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/Profile/Profile.dart';
import 'package:xeats/views/Resturants/Resturants.dart';
import '../../controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';

class ResturantsMenu extends StatelessWidget {
  ResturantsMenu({
    super.key,
    required this.data,
    required this.RestaurantId,
  });
  var data;
  int RestaurantId;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final BannerAd bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-5674432343391353/4524475505",
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (Ad ad) => print('Ad loaded.'),
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
          },
        ),
        request: const AdRequest());
    bannerAd.load();
    return BlocConsumer<RestuarantsCubit, RestuarantsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // var restuarantsOfSlugListResponse = OrderCubit.restuarantsOfSlugList;
        var navcubit = NavBarCubitcubit.get(context);
        return Scaffold(
          appBar: appBar(context, subtitle: 'Products Of', title: data['Name']),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Stack(children: [
                    Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width * 0.8,
                        //     decoration: BoxDecoration(
                        //       color: Colors.black.withOpacity(0.1),
                        //       borderRadius: BorderRadius.circular(15),
                        //     ),
                        //     child: TextField(
                        //       decoration: const InputDecoration(
                        //           contentPadding: EdgeInsets.symmetric(
                        //               horizontal: 20, vertical: 9),
                        //           border: InputBorder.none,
                        //           focusedBorder: InputBorder.none,
                        //           enabledBorder: InputBorder.none,
                        //           hintText: "Search For Products",
                        //           prefixIcon: Icon(Icons.search)),
                        //       controller:
                        //           ProductsCubit.get(context).searchController,
                        //       onSubmitted: (value) async {
                        //         // NavigateAndRemov(
                        //         //     context,
                        //         //     SearchProductsScreen(
                        //         //         restaurantName: data['Name'])
                        //         //         );
                        //       },
                        //     ),
                        //   ),
                        // ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(width / 20),
                                      child: Container(
                                        height: height / 9,
                                        width: width / 5,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.transparent,
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image(
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Text(error.toString());
                                            },
                                            image: CachedNetworkImageProvider(
                                                AppConstants.BaseUrl +
                                                    data['logo']),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 45,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        data['Name'] + " " + "Categories",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     SizedBox(
                                //       width: width / 7,
                                //       height: height / 13,
                                //       child: const Image(
                                //           image: AssetImage(
                                //         'assets/Images/First.png',
                                //       )),
                                //     ),
                                //     SizedBox(
                                //       width: width / 79,
                                //     ),
                                //     Text(
                                //       overflow: TextOverflow.ellipsis,
                                //       maxLines: 1,
                                //       'X-Eats Delivery',
                                //       style: GoogleFonts.poppins(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 10,
                                //       ),
                                //     )
                                //   ],
                                // ),
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  ]),
                ),
                SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: AdWidget(ad: bannerAd),
                ),
                SizedBox(
                  height: height / 75.6,
                ),
                SizedBox(
                  height: height / 75.6,
                ),
                SizedBox(
                  height: height / 1.995,
                  child: FutureBuilder(
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                            itemBuilder: ((context, index) {
                              if (RestuarantsCubit.get(context)
                                      .restaurantByCategoryResponse!
                                      .data["Names"][index] ==
                                  null) {
                                return const Loading();
                              } else {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  child: CategoryCard(
                                    category: RestuarantsCubit.get(context)
                                        .restaurantByCategoryResponse!
                                        .data["Names"][index]['display_name']
                                        .toString(),
                                    image: AppConstants.BaseUrl +
                                        RestuarantsCubit.get(context)
                                            .restaurantByCategoryResponse!
                                            .data["Names"][index]['image'],
                                    description: "",
                                    press: () async {
                                      Navigation(
                                        context,
                                        CategoriesView(
                                            image: AppConstants.BaseUrl +
                                                RestuarantsCubit.get(context)
                                                        .restaurantByCategoryResponse!
                                                        .data["Names"][index]
                                                    ['image'],
                                            category: RestuarantsCubit.get(
                                                        context)
                                                    .restaurantByCategoryResponse!
                                                    .data["Names"][index]
                                                ['display_name'],
                                            categoryId: RestuarantsCubit.get(
                                                    context)
                                                .restaurantByCategoryResponse!
                                                .data["Names"][index]['id']
                                                .toString(),
                                            restaurantName:
                                                data['Name'].toString(),
                                            restaurantID: data["id"].toString()),
                                      );
                                    },
                                  ),
                                );
                              }
                              // "${value.data["Names"][index]["display_name"]}")),
                            }),
                            separatorBuilder: ((context, index) {
                              return const SizedBox(
                                height: 20,
                                child: Divider(),
                              );
                            }),
                            itemCount: RestuarantsCubit.get(context)
                                .restaurantByCategoryResponse!
                                .data["Names"]
                                .length);
                      } else {
                        return const Loading();
                      }
                    }),
                    future:
                        RestuarantsCubit.get(context).getRestaurantCategories(
                      context,
                      image: data["logo"].toString(),
                      restaurantId: RestaurantId.toString(),
                      restaurantName: data['Name'].toString(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.white,
            unselectedFontSize: 9,
            selectedFontSize: 12,
            backgroundColor: Theme.of(context).backgroundColor,
            selectedItemColor: Theme.of(context).primaryColor,
            items: navcubit.bottomitems,
            currentIndex: 1,
            onTap: (index) {
              if (index == 1) {
                Navigation(context, Restaurants());
              } else if (index == 0) {
                Navigation(context, Layout());
              } else {
                Navigation(context, const Profile());
              }
            },
          ),
        );
      },
    );
  }
}
