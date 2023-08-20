// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/controllers/Components/DiscountBanner/DiscountBanner.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/LocationBar/LocationBar.dart';
import 'package:xeats/controllers/Components/Product%20Class/Products_Class.dart';
import 'package:xeats/controllers/Components/Products%20Components/ProductView.dart';
import 'package:xeats/controllers/Components/Restaurant%20Components/RestaurantView.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsStates.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestuarantsCubit.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/views/Profile/Profile.dart';
import 'package:xeats/views/Resturants/Resturants.dart';
import 'package:xeats/views/ResturantsMenu/ResturantsMenu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

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
            ..getLocation()
            ..getRestaurantsOfLocation(context)
            ..deliveryFees(),
        ),
        BlocProvider(create: (context) => ProductsCubit()..getPoster()),
        BlocProvider(
          create: (context) => RestuarantsCubit(),
        ),
        BlocProvider(create: (context) => AuthCubit()..GettingUserData()),
      ],
      child: BlocBuilder<ProductsCubit, ProductsStates>(
        builder: ((context, state) {
          var cubit = AuthCubit.get(context);
          var navcubit = NavBarCubitcubit.get(context);
          var productApi = ProductsCubit.MostSold;
          var FirstName = cubit.FirstName ?? '';
          print(OrderCubit.currentLocation);
          return SafeArea(
            child: Scaffold(
              appBar: LocationBar(context),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BlocBuilder<OrderCubit, OrderStates>(
                      builder: (context, OrderStates) {
                        print(" Khaled $OrderStates");

                        var RestaurantsSlugApi =
                            OrderCubit.restuarantsOfSlugList;
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
                                      child: Container(
                                          child: const CircularProgressIndicator()),
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
                                          AppConstants.PleaseSelectLocation,
                                          style: GoogleFonts.openSans(
                                              fontSize: 18),
                                        ),
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
                                      child: Container(
                                          child: const CircularProgressIndicator()),
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12, bottom: 12),
                                                  child: Text(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    "Welcome, $FirstName",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ConditionalBuilder(
                                                condition: ProductsCubit
                                                    .getposters.isNotEmpty,
                                                fallback: (context) => const Center(
                                                      child: Loading(),
                                                    ),
                                                builder: (context) =>
                                                    const DiscountBanner()),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              'Restaurant',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                ...List.generate(
                                                  OrderCubit
                                                      .restuarantsOfSlugList
                                                      .length,
                                                  (index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigation(
                                                            context,
                                                            ResturantsMenu(
                                                                data:
                                                                    RestaurantsSlugApi[
                                                                        index],
                                                                RestaurantId:
                                                                    RestaurantsSlugApi[
                                                                            index]
                                                                        [
                                                                        'id']));
                                                      },
                                                      child: RestaurantView(
                                                        data:
                                                            RestaurantsSlugApi[
                                                                        index]
                                                                    ['Name'] ??
                                                                const Loading(),
                                                        Colors: const Color
                                                                .fromARGB(
                                                            255, 5, 95, 9),
                                                        image: Image(
                                                          // loadingBuilder:
                                                          //     (context, child, loadingProgress) {
                                                          //   if (loadingProgress == null) {
                                                          //     return text;
                                                          //   }
                                                          //   return Center(
                                                          //     child: Loading(),
                                                          //   );
                                                          // },
                                                          image: CachedNetworkImageProvider(
                                                              DioHelper
                                                                      .dio!
                                                                      .options
                                                                      .baseUrl +
                                                                  RestaurantsSlugApi[
                                                                          index]
                                                                      ['logo']),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 50,
                                            width: double.maxFinite,
                                            child: AdWidget(ad: bannerAd),
                                          )
                                        ],
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Text(
                                                'Most Ordered',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  ...List.generate(
                                                    productApi.length,
                                                    (index) {
                                                      return ConditionalBuilder(
                                                          fallback: (context) {
                                                            return const Loading();
                                                          },
                                                          condition: productApi[
                                                                      index]
                                                                  ["image"] !=
                                                              null,
                                                          builder: (
                                                            context,
                                                          ) {
                                                            double? price =
                                                                productApi[
                                                                        index]
                                                                    ['price'];

                                                            return GestureDetector(
                                                              child:
                                                                  ProductView(
                                                                      image: productApi[
                                                                              index][
                                                                          "image"],
                                                                      width:
                                                                          width /
                                                                              2.0,
                                                                      height:
                                                                          height /
                                                                              4.2,
                                                                      data: productApi[
                                                                              index]
                                                                          [
                                                                          "name"],
                                                                      Colors: Colors
                                                                          .white,
                                                                      Navigate:
                                                                          () =>
                                                                              {
                                                                                Navigation(
                                                                                    context,
                                                                                    ProductClass().productDetails(
                                                                                      context,
                                                                                      productName: productApi[index]["productName"],
                                                                                      id: productApi[index]["id"],
                                                                                      restaurant: productApi[index]["Restaurant"],
                                                                                      image: "${AppConstants.BaseUrl}/uploads/" + productApi[index]["image"],
                                                                                      price: price,
                                                                                      englishName: productApi[index]["name"],
                                                                                      arabicName: productApi[index]["ArabicName"],
                                                                                      description: productApi[index]["description"] ?? "No Description for this Product",
                                                                                      restaurantName: productApi[index]["Restaurant"].toString(),
                                                                                    )),
                                                                              }),
                                                              onTap: () {},
                                                            );
                                                          });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
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
                selectedLabelStyle: GoogleFonts.poppins(),
                backgroundColor: Colors.white,
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
      ),
    );
  }
}
