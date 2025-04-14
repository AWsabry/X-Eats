// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_divider.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/Product%20Class/Products_Class.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsStates.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/Profile/Profile.dart';
import 'package:xeats/views/ResturantsMenu/ResturantsMenu.dart';

// ignore: must_be_immutable
class Restaurants extends StatelessWidget {
  Restaurants({super.key, this.currentLocation, this.Locations});
  String? currentLocation;
  List<dynamic>? Locations;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocConsumer<ProductsCubit, ProductsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<dynamic> newProducts = ProductsCubit.new_products;
        var navcubit = NavBarCubitcubit.get(context);
        var Connection = false;
        Logger().i(newProducts);

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              height / 11,
            ), // Adjust the height here
            child: appBar(context,
                subtitle: 'Your Location', title: 'Restaurants'),
          ),
          // appBar:
          //     appBar(context, subtitle: 'Your Location', title: 'Restaurants'),
          body: SingleChildScrollView(
            child: SafeArea(
              child: BlocBuilder<OrderCubit, OrderStates>(
                  builder: (Ordercontext, Orderstate) {
                var RestaurantsSlugApi = OrderCubit.restaurantsInLocation;
                return ConditionalBuilder(
                  condition: RestaurantsSlugApi.isNotEmpty,
                  fallback: (context) {
                    Logger().i(RestaurantsSlugApi);
                    if (OrderStates is getRestuarantSlugStateLoading) {
                      return Column(
                        children: [
                          SizedBox(
                            height: height / 2.6,
                          ),
                          Center(
                            child: Container(child: const Loading()),
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
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                  builder: (context) {
                    return Column(children: [
                      ConditionalBuilder(
                          condition: ProductsCubit.NoNewProducts == false,
                          fallback: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Coming Soon',
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                          builder: (context) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...List.generate(
                                    newProducts.length,
                                    (index) {
                                      return ConditionalBuilder(
                                          fallback: (context) {
                                            return const Loading();
                                          },
                                          condition: newProducts[index]
                                                  ["image"] !=
                                              null,
                                          builder: (context) {
                                            return ProductClass(
                                              productName: newProducts[index]
                                                  ["name"],
                                              id: newProducts[index]["id"],
                                              restaurant: newProducts[index]
                                                  ["Restaurant"],
                                              itemImage:
                                                  "${AppConstants.BaseUrl}/uploads/" +
                                                      newProducts[index]
                                                          ["image"],
                                              price: newProducts[index]
                                                  ['price'],
                                              englishName: newProducts[index]
                                                  ["name"],
                                              arabicName: newProducts[index]
                                                  ["ArabicName"],
                                              description: newProducts[index]
                                                      ["description"] ??
                                                  "No Description for this Product",
                                            ).NewProducts(context,
                                                height: height / 4,
                                                width: width / 1.15,
                                                restaurantName:
                                                    newProducts[index]
                                                        ["restaurant_name"],
                                                title: newProducts[index]
                                                    ["name"],
                                                Colors: Theme.of(context)
                                                    .canvasColor,
                                                image:
                                                    "${AppConstants.BaseUrl}/uploads/" +
                                                        newProducts[index]
                                                            ["image"]);
//  context,
                                          });
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Restaurants',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          BlocBuilder<OrderCubit, OrderStates>(
                            builder: (context, state) {
                              var restuarantsOfSlugListApi =
                                  OrderCubit.restaurantsInLocation;
                              return ConditionalBuilder(
                                condition:
                                    restuarantsOfSlugListApi.isNotEmpty &&
                                        Connection == false,
                                fallback: (context) =>
                                    const Center(child: Loading()),
                                builder: (context) => ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (restuarantsOfSlugListApi[index]
                                            ['logo'] ==
                                        null) {
                                      return const Loading();
                                    } else {
                                      return InkWell(
                                        onTap: () {
                                          Navigation(
                                              context,
                                              ResturantsMenu(
                                                data: restuarantsOfSlugListApi[
                                                    index],
                                                RestaurantId:
                                                    restuarantsOfSlugListApi[
                                                        index]['id'],
                                              ));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(children: [
                                            Container(
                                              height: 130.h,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: const Color.fromARGB(
                                                        74, 158, 158, 158)),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: CachedNetworkImage(
                                                  progressIndicatorBuilder: (context,
                                                          url, progress) =>
                                                      const Center(
                                                          child: Loading()

                                                          //     CircularProgressIndicator(
                                                          //   value: progress.progress,
                                                          // ),
                                                          ),
                                                  imageUrl: AppConstants
                                                          .BaseUrl +
                                                      restuarantsOfSlugListApi[
                                                          index]['logo'],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                height: height / 7,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(children: [
                                                      Text(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          '${restuarantsOfSlugListApi[index]['Name']}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                          )),
                                                    ]),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    const Row(children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      Text(' 4.1'),
                                                      Text(' (100+)')
                                                    ]),
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons
                                                              .timer_sharp),
                                                          Text(
                                                            ' 45 mins',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                          ),
                                                          SizedBox(
                                                            width: 25.w,
                                                          ),
                                                          const Icon(Icons
                                                              .delivery_dining_outlined),
                                                          SizedBox(
                                                            width: 2.w,
                                                          ),
                                                          Text(
                                                            'X-Eats Delivery',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                      );
                                    }
                                  },
                                  separatorBuilder: ((context, index) =>
                                      customDivider()),
                                  itemCount: restuarantsOfSlugListApi.length,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ]);
                  },
                );
              }),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.white,
            unselectedFontSize: 9,
            selectedFontSize: 12,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            selectedItemColor: Theme.of(context).primaryColor,
            items: navcubit.bottomitems,
            currentIndex: 1,
            onTap: (index) {
              if (index == 1) {
                Navigator.popUntil(context, (route) => route.isCurrent);
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
