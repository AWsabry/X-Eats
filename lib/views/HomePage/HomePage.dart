// ignore_for_file: use_build_context_synchronously, prefer_interpolation_to_compose_strings
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:xeats/controllers/Components/DiscountBanner/DiscountBanner.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/AppBar/LocationBar.dart';
import 'package:xeats/controllers/Components/Product%20Class/Products_Class.dart';
import 'package:xeats/controllers/Components/Restaurant%20Components/RestaurantView.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/Cubits/InternetCubit/internet_cubit.dart';
import 'package:xeats/controllers/Cubits/InternetCubit/internet_states.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsStates.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestuarantsCubit.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/theme.dart';
import 'package:xeats/views/Profile/Profile.dart';
import 'package:xeats/views/Resturants/Resturants.dart';
import 'package:xeats/views/ResturantsMenu/ResturantsMenu.dart';

// Future<bool> check() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     }
//     return false;
//   }
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final BannerAd bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-5674432343391353/7700576837",
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
          },
        ),
        request: const AdRequest());
    final BannerAd bannerAd2 = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-5674432343391353/4883815579",
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
          },
        ),
        request: const AdRequest());
    bannerAd.load();
    bannerAd2.load();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => OrderCubit()
              ..getCartID(context)
              ..getLocation(context)),
        BlocProvider(create: (context) => ProductsCubit()..getPoster()),
        BlocProvider(create: (context) => AuthCubit()..GettingUserData()),
      ],
      child: BlocBuilder<InternetCubit, InternetStates>(
          builder: (context, internetstate) {
        if (internetstate is NotConnectedState) {
          return const SafeArea(
              child: Scaffold(
            body: Center(
              child: Loading(),
            ),
          ));
        } else if (internetstate is ConnectedState) {
          return BlocBuilder<ProductsCubit, ProductsStates>(
            builder: ((context, state) {
              List<dynamic> mostSoldProducts = ProductsCubit.MostSold;
              var cubit = AuthCubit.get(context);
              var navcubit = NavBarCubitcubit.get(context);
              var FirstName = cubit.firstNameShared ?? '';
              return SafeArea(
                child: Scaffold(
                  appBar: LocationBar(context),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BlocBuilder<OrderCubit, OrderStates>(
                          builder: (Ordercontext, OrderStates) {
                            var RestaurantsSlugApi =
                                OrderCubit.restaurantsInLocation;
                            return ConditionalBuilder(
                                fallback: (context) {
                                  if (OrderStates
                                      is getRestuarantSlugStateLoading) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: height / 2.6,
                                        ),
                                        Center(
                                          child:
                                              Container(child: const Loading()),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: height / 2.6,
                                        ),
                                        Center(
                                          child: Container(
                                            child: Text(
                                                AppConstants
                                                    .PleaseSelectLocation,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                                condition: RestaurantsSlugApi.isNotEmpty,
                                builder: (context) {
                                  if (OrderStates
                                      is getRestuarantSlugStateLoading) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: height / 2.6,
                                        ),
                                        Center(
                                          child:
                                              Container(child: const Loading()),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: ConditionalBuilder(
                                                condition: ProductsCubit
                                                    .getposters.isNotEmpty,
                                                fallback: (context) =>
                                                    const Center(
                                                      child: Loading(),
                                                    ),
                                                builder: (context) =>
                                                    const DiscountBanner()),
                                          ),
                                          SizedBox(
                                            height: height / 30,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text('Restaurants',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium),
                                              ),
                                              Column(
                                                children: [
                                                  ...List.generate(
                                                    OrderCubit
                                                        .restaurantsInLocation
                                                        .length,
                                                    (index) {
                                                      return Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigation(
                                                                  context,
                                                                  ResturantsMenu(
                                                                      data: RestaurantsSlugApi[
                                                                          index],
                                                                      RestaurantId:
                                                                          RestaurantsSlugApi[index]
                                                                              [
                                                                              'id']));
                                                            },
                                                            child:
                                                                RestaurantView(
                                                              data: RestaurantsSlugApi[
                                                                      index] ??
                                                                  const Loading(),
                                                              image: Image(
                                                                image: CachedNetworkImageProvider(
                                                                    "${AppConstants.BaseUrl}/" +
                                                                        RestaurantsSlugApi[index]
                                                                            [
                                                                            'logo']),
                                                              ),
                                                            ),
                                                          ),
                                                          Divider(),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                              // const SizedBox(
                                              //   height: 10,
                                              // ),
                                              SizedBox(
                                                height: height / 50,
                                                width: double.maxFinite,
                                                child: AdWidget(ad: bannerAd),
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text('Most Ordered',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium),
                                              ),
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: ConditionalBuilder(
                                                    fallback: (context) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Text(
                                                            'Coming Soon',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium),
                                                      );
                                                    },
                                                    condition: (ProductsCubit
                                                                .NoMostSoldProducts ==
                                                            false ||
                                                        ProductsCubit
                                                                    .NoMostSoldProducts
                                                                .toString() ==
                                                            "null"),
                                                    builder: (context) {
                                                      return Row(
                                                        children: [
                                                          ...List.generate(
                                                            mostSoldProducts
                                                                .length,
                                                            (index) {
                                                              return ProductClass(
                                                                productName:
                                                                    mostSoldProducts[
                                                                            index]
                                                                        [
                                                                        "name"],
                                                                id: mostSoldProducts[
                                                                        index]
                                                                    ["id"],
                                                                restaurant:
                                                                    mostSoldProducts[
                                                                            index]
                                                                        [
                                                                        "Restaurant"],
                                                                itemImage: "${AppConstants.BaseUrl}/uploads/" +
                                                                    mostSoldProducts[
                                                                            index]
                                                                        [
                                                                        "image"],
                                                                price: mostSoldProducts[
                                                                        index]
                                                                    ['price'],
                                                                englishName:
                                                                    mostSoldProducts[
                                                                            index]
                                                                        [
                                                                        "name"],
                                                                arabicName:
                                                                    mostSoldProducts[
                                                                            index]
                                                                        [
                                                                        "ArabicName"],
                                                                description: mostSoldProducts[
                                                                            index]
                                                                        [
                                                                        "description"] ??
                                                                    "No Description for this Product",
                                                              ).MostSoldProducts(
                                                                  context,
                                                                  width: width /
                                                                      2.0,
                                                                  height:
                                                                      height /
                                                                          4.2,
                                                                  image: "${AppConstants.BaseUrl}/uploads/" +
                                                                      mostSoldProducts[
                                                                              index]
                                                                          [
                                                                          "image"],
                                                                  Colors: Colors
                                                                      .white,
                                                                  data: mostSoldProducts[
                                                                          index]
                                                                      ["name"],
                                                                  restaurantName:
                                                                      mostSoldProducts[index]
                                                                              [
                                                                              "Restaurant"]
                                                                          .toString());

                                                              // return ProductView(
                                                              //   image:
                                                              //       mostSoldProducts[
                                                              //               index]
                                                              //           ["image"],
                                                              //   width:
                                                              //       width / 2.0,
                                                              //   height:
                                                              //       height / 4.2,
                                                              //   data:
                                                              //       mostSoldProducts[
                                                              //               index]
                                                              //           ["name"],
                                                              //   Colors:
                                                              //       Colors.white,
                                                              //   Navigate: () {
                                                              //     Navigation(
                                                              //         context,
                                                              //         ProductClass()
                                                              //             .productDetails(
                                                              //           context,
                                                              //           productName:
                                                              //               mostSoldProducts[index]
                                                              //                   [
                                                              //                   "productName"],
                                                              //           id: mostSoldProducts[
                                                              //                   index]
                                                              //               [
                                                              //               "id"],
                                                              //           restaurant:
                                                              //               mostSoldProducts[index]
                                                              //                   [
                                                              //                   "Restaurant"],
                                                              //           image: "${AppConstants.BaseUrl}/uploads/" +
                                                              //               mostSoldProducts[index]
                                                              //                   [
                                                              //                   "image"],
                                                              //           price: mostSoldProducts[
                                                              //                   index]
                                                              //               [
                                                              //               'price'],
                                                              //           englishName:
                                                              //               mostSoldProducts[index]
                                                              //                   [
                                                              //                   "name"],
                                                              //           arabicName:
                                                              //               mostSoldProducts[index]
                                                              //                   [
                                                              //                   "ArabicName"],
                                                              //           description:
                                                              //               mostSoldProducts[index]["description"] ??
                                                              //                   "No Description for this Product",
                                                              //           restaurantName:
                                                              //               mostSoldProducts[index]["Restaurant"]
                                                              //                   .toString(),
                                                              //         ));
                                                              //   },
                                                              // );
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height / 40,
                                            width: double.maxFinite,
                                            child: AdWidget(ad: bannerAd2),
                                          ),
                                          // ListView.builder(
                                          //   itemBuilder: (context, index) {},
                                          // )
                                        ]);
                                  }
                                });
                          },
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
                    currentIndex: 0,
                    onTap: (index) {
                      if (index == 0) {
                        Navigator.popUntil(context, (route) => route.isCurrent);
                      } else if (index == 1) {
                        Navigation(
                            context,
                            Restaurants(
                              currentLocation: OrderCubit.currentLocation,
                            ));
                      } else {
                        Navigation(context, const Profile());
                      }
                    },
                  ),
                ),
              );
            }),
          );
        } else {
          return const SafeArea(
              child: Scaffold(
            body: Center(
              child: Loading(),
            ),
          ));
        }
      }),
    );
  }
}
