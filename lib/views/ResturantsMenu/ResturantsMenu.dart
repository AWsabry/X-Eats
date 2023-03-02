// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:xeats/controllers/Components/Components.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/AppBarCustomized.dart';
import 'package:xeats/controllers/Cubit.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/controllers/States.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/Profile/Profile.dart';
import 'package:xeats/views/Resturants/Resturants.dart';
import 'package:xeats/views/Search/SearchProducts.dart';
import '../../controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';

class ResturantsMenu extends StatelessWidget {
  ResturantsMenu({super.key, required this.data, required this.RestaurantId});
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
    return BlocConsumer<Xeatscubit, XeatsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = Xeatscubit.get(context);
        var navcubit = NavBarCubitcubit.get(context);
        return Scaffold(
          appBar: appBar(context, subtitle: 'Products Of', title: data['Name']),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  builder: (context, snapshot) {
                    return Container();
                  },
                  future: Xeatscubit.get(context)
                      .getCurrentAvailableOrderRestauant(),
                ),
                SafeArea(
                  child: Stack(children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 9),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  hintText: "Search For Products",
                                  prefixIcon: Icon(Icons.search)),
                              controller:
                                  Xeatscubit.get(context).searchController,
                              onSubmitted: (value) async {
                                await Xeatscubit.get(context).GetIdOfProducts(
                                  context,
                                  id: RestaurantId.toString(),
                                );
                                await Xeatscubit.get(context)
                                    .SearchOnListOfProduct(
                                  context,
                                );

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
                                  Navigation(
                                      context,
                                      SearchProductsScreen(
                                        restaurantID: RestaurantId.toString(),
                                        image:
                                            Xeatscubit.get(context).image.first,
                                        category: Xeatscubit.get(context)
                                            .category_name
                                            .first
                                            .toString(),
                                        categoryId: Xeatscubit.get(context)
                                            .category
                                            .first
                                            .toString(),
                                        restaurantName: Xeatscubit.get(context)
                                            .restaurant_name
                                            .first,
                                      ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    content: Text(
                                        "There isn't product called ${Xeatscubit.get(context).searchController.text}"),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Container(
                                        height: height / 5,
                                        width: width / 2.4,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.transparent,
                                            border: Border.all(
                                                width: 20,
                                                color: Colors.white)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image(
                                            image: NetworkImage(
                                                DioHelper.dio!.options.baseUrl +
                                                    data['image']),
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
                                        style:
                                            GoogleFonts.poppins(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: width / 7,
                                      height: height / 13,
                                      child: const Image(
                                          image: AssetImage(
                                        'assets/Images/First.png',
                                      )),
                                    ),
                                    SizedBox(
                                      width: width / 79,
                                    ),
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      'X-Eats Delivery',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    )
                                  ],
                                ),
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
                        return snapshot.data!;
                      } else {
                        return Loading();
                      }
                    }),
                    future: Xeatscubit.get(context).getRestaurantCategories(
                      context,
                      image: data["image"].toString(),
                      restaurantId: data["id"].toString(),
                      restaurantName: data['Name'].toString(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: GoogleFonts.poppins(),
            backgroundColor: Colors.white,
            items: navcubit.bottomitems,
            currentIndex: 1,
            onTap: (index) {
              if (index == 1) {
                Navigation(context, Restaurants());
              } else if (index == 0) {
                Navigation(context, Layout());
              } else {
                Navigation(context, Profile());
              }
            },
          ),
        );
      },
    );
  }
}
