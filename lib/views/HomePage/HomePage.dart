// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/controllers/Components/DiscountBanner/DiscountBanner.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/Product%20Class/Products_Class.dart';
import 'package:xeats/controllers/Components/Products%20Components/ProductView.dart';
import 'package:xeats/controllers/Components/Restaurant%20Components/RestaurantView.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsStates.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestuarantsCubit.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/views/Profile/Profile.dart';
import 'package:xeats/views/Resturants/Resturants.dart';
import 'package:xeats/views/ResturantsMenu/ResturantsMenu.dart';
import 'package:xeats/views/Search/SearchRestaurants.dart';

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
            create: (context) => ProductsCubit()
              ..GetMostSoldProducts()
              ..getPoster()),
        BlocProvider(
          create: (context) => RestuarantsCubit()..GetResturants(),
        ),
        BlocProvider(create: (context) => AuthCubit()..GettingUserData()),
        BlocProvider(
          create: (context) => OrderCubit()..getCartID(context),
        )
      ],
      child: BlocBuilder<ProductsCubit, ProductsStates>(
        builder: ((context, state) {
          var cubit = AuthCubit.get(context);
          var navcubit = NavBarCubitcubit.get(context);
          var product_api = ProductsCubit.get(context).MostSold;
          var restaurant_api = RestuarantsCubit.ResturantsList;
          var FirstName = cubit.FirstName ?? ' ';
          print(product_api);
          return Scaffold(
            appBar: appBar(context,
                subtitle: 'Delivering to', title: 'Nile University, Giza'),
            body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                      hintText: "Search For Restaurants",
                                      prefixIcon: Icon(Icons.search)),
                                  controller: RestuarantsCubit.get(context)
                                      .searchRestaurantsController,
                                  onSubmitted: (value) async {
                                    await RestuarantsCubit.get(context)
                                        .clearRestaurantId();
                                    await RestuarantsCubit.get(context)
                                        .GetIdOfResutarant(context);
                                    await RestuarantsCubit.get(context)
                                        .SearchOnListOfRestuarant(context);
                                    if (RestuarantsCubit.get(context)
                                        .restaurant_nameFromSearching
                                        .toString()
                                        .toLowerCase()
                                        .contains(RestuarantsCubit.get(context)
                                            .searchRestaurantsController
                                            .text
                                            .toLowerCase())) {
                                      Navigation(
                                          context,
                                          SearchRestaurantsScreen(
                                            Restuarantsdata:
                                                RestuarantsCubit.get(context)
                                                    .Restuarantsdata,
                                            RestaurantId:
                                                RestuarantsCubit.get(context)
                                                    .RestaurantId,
                                            imageOfRestaurant:
                                                RestuarantsCubit.get(context)
                                                    .imageOfRestaurant,
                                            restaurant_nameFromSearching:
                                                RestuarantsCubit.get(context)
                                                    .restaurant_nameFromSearching,
                                          ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration:
                                            const Duration(milliseconds: 1500),
                                        content: Text(
                                            "There isn't Restuarant called ${RestuarantsCubit.get(context).searchRestaurantsController.text.toLowerCase()}"),
                                        backgroundColor: Colors.red,
                                      ));
                                    }
                                  },
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, bottom: 12),
                                child: Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  "Welcome, $FirstName",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          ConditionalBuilder(
                              condition: ProductsCubit.get(context)
                                  .getposters
                                  .isNotEmpty,
                              fallback: (context) => Center(
                                    child: Loading(),
                                  ),
                              builder: (context) => const DiscountBanner()),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Restaurant',
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ...List.generate(
                                restaurant_api.length,
                                (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigation(
                                          context,
                                          ResturantsMenu(
                                              data: restaurant_api[index],
                                              RestaurantId:
                                                  restaurant_api[index]['id']));
                                    },
                                    child: RestaurantView(
                                      data: restaurant_api[index]['Name'] ??
                                          Loading(),
                                      Colors:
                                          const Color.fromARGB(255, 5, 95, 9),
                                      image: Image(
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: Loading(),
                                          );
                                        },
                                        image: CachedNetworkImageProvider(
                                            DioHelper.dio!.options.baseUrl +
                                                restaurant_api[index]['logo']),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Most Ordered',
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...List.generate(
                                  product_api.length,
                                  (index) {
                                    return ConditionalBuilder(
                                        fallback: (context) {
                                          return Loading();
                                        },
                                        condition:
                                            product_api[index]["image"] != null,
                                        builder: (
                                          context,
                                        ) {
                                          double? price =
                                              product_api[index]['price'];

                                          return GestureDetector(
                                            child: ProductView(
                                                image: product_api[index]
                                                    ["image"],
                                                width: width / 2.0,
                                                height: height / 4.2,
                                                data: product_api[index]
                                                    ["name"],
                                                Colors: Colors.white,
                                                Navigate: () => {
                                                      Navigation(
                                                          context,
                                                          ProductClass()
                                                              .productDetails(
                                                            context,
                                                            productName:
                                                                product_api[
                                                                        index][
                                                                    "productName"],
                                                            id: product_api[
                                                                index]["id"],
                                                            restaurant:
                                                                product_api[
                                                                        index][
                                                                    "Restaurant"],
                                                            image: product_api[
                                                                index]["image"],
                                                            price: price,
                                                            englishName:
                                                                product_api[
                                                                        index]
                                                                    ["name"],
                                                            arabicName:
                                                                product_api[
                                                                        index][
                                                                    "ArabicName"],
                                                            description: product_api[
                                                                        index][
                                                                    "description"] ??
                                                                "No Description for this Product",
                                                            restaurantName:
                                                                product_api[index]
                                                                        [
                                                                        "Restaurant"]
                                                                    .toString(),
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
                    )
                  ]),
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
                  Navigation(context, const Restaurants());
                } else {
                  Navigation(context, Profile());
                }
              },
            ),
          );
        }),
      ),
    );
  }
}
