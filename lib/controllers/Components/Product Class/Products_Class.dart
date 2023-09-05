// ignore_for_file: must_be_immutable, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:xeats/controllers/Components/Global%20Components/Buttons/DefaultButton.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/Requests%20Loading%20Components/RequstsLoading.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestuarantsCubit.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/theme.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/Profile/Profile.dart';
import 'package:xeats/views/Resturants/Resturants.dart';

class ProductClass extends StatelessWidget {
  final bool? isMostPopular, isNewProduct, isBestOffer;
  final double? deliveryFee;
  final double? price;
  final int? restaurant, category, id;
  final String? englishName, productSlug, creationDate, arabicName;
  final String? description;
  int quantity = 1;
  double? totalPrice;
  String? itemImage, restaurantImage;
  String? productName;
  String? cartItemId;
  String? currentTiming;

  static List<Widget> CartItems = [];

  ProductClass({
    super.key,
    this.deliveryFee,
    this.id,
    this.productName,
    this.quantity = 1,
    this.englishName,
    this.productSlug,
    this.description,
    this.creationDate,
    this.arabicName,
    this.restaurant,
    this.category,
    this.price,
    this.isMostPopular,
    this.itemImage,
    this.restaurantImage,
    this.isNewProduct,
    this.isBestOffer,
    this.cartItemId,
    this.totalPrice,
  });

  static double getSubtotal() {
    double total = 0;
    for (var i in CartItems) {
      print("CartItems $CartItems");
      try {
        i = i as ProductClass;
        total += i.price! * i.quantity;
        print("TOTAL $total");
      } catch (e) {
        continue;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderStates>(builder: (context, state) {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
      return SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            Navigation(
              context,
              productDetails(
                context,
                productName: productName,
                image: AppConstants.BaseUrl + "/" + itemImage!,
                id: id,
                restaurant: restaurant,
                price: price,
                restaurantName: restaurant.toString(),
                arabicName: arabicName,
                description: description ?? "No Description for this Product",
                englishName: englishName,
              ),
            );
          },
          child: Dismissible(
            onDismissed: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                if (OrderCubit.get(context).getUserCartItemsResponse.data !=
                    null) {
                  NavigateAndRemov(context, Layout());
                }
                await OrderCubit.get(context)
                    .deleteCartItem(context, "$cartItemId")
                    .then((value) {
                  ProductClass.CartItems.remove(this);

                  OrderCubit.get(context).updateCartPrice(context);
                });
              } else {
                await OrderCubit.get(context)
                    .deleteCartItem(context, "$cartItemId")
                    .then((value) {
                  ProductClass.CartItems.remove(this);

                  OrderCubit.get(context).updateCartPrice(context);
                });
              }
            },
            key: const Key(""),
            background: Container(
              color: Colors.red,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    Text('Move to trash',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: width / 5,
                    child: Image(
                      errorBuilder: (context, error, stackTrace) {
                        return Text(error.toString());
                      },
                      width: width / 5,
                      image: CachedNetworkImageProvider(
                          "${AppConstants.BaseUrl}$itemImage"),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: Loading(),
                        );
                      },
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text("$englishName",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${RestuarantsCubit.currentRestaurant["Name"]}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.bodySmall),
                            // Text(
                            //   "$arabicName",
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            //   textAlign: TextAlign.right,
                            //   style: GoogleFonts.poppins(
                            //     fontSize: 13,
                            //     color: Colors.black,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("QTY : $quantity"),
                            Text(
                              "$totalPrice EGP",
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget productsOfCategory(
    BuildContext context, {
    required String? image,
    required String? category,
    required String? CatId,
    required String? restaurantName,
    required double? price,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigation(
                context,
                productDetails(context,
                    image: '$image',
                    id: id,
                    restaurant: restaurant,
                    restaurantName: restaurantName,
                    price: price,
                    arabicName: arabicName,
                    description:
                        description ?? "No Description for this Product",
                    englishName: englishName,
                    productName: productName),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  FutureBuilder(
                    future: ProductsCubit.get(context).getCategoryById(CatId),
                    builder: ((context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          height: 130.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image(
                              errorBuilder: (context, error, stackTrace) {
                                return Text(error.toString());
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return const Center(
                                    child: Loading(),
                                  );
                                }
                              },
                              image: CachedNetworkImageProvider(
                                "$image",
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 130.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Loading(),
                          ),
                        );
                      }
                    }),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            englishName!,
                            style: Theme.of(context).textTheme.displayMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            description.toString(),
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 2,
                          ),
                          SizedBox(
                            height: height / 50,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("$price  EGP",
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Search For Products //

  Widget productDetails(BuildContext context,
      {required String? image,
      required String? restaurantName,
      required double? price,
      required String? productName,
      required String? arabicName,
      required String? description,
      required String? englishName,
      required int? id,
      required int? restaurant}) {
    final BannerAd bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-5674432343391353/3216382829",
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (Ad ad) => Logger().d('Ad loaded.'),
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
          },
        ),
        request: const AdRequest());
    bannerAd.load();

    return BlocConsumer<OrderCubit, OrderStates>(
      builder: (context, state) {
        var navcubit = NavBarCubitcubit.get(context);
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return Scaffold(
          // floatingActionButton: isRequestFinished
          //     ? FloatingActionButton(
          //         backgroundColor: const Color.fromARGB(255, 9, 134, 211),
          //         //add to cart button
          //         onPressed: () async {
          //           await OrderCubit.get(context).addToCart(context,
          //               cartItemId: cartItemId,
          //               productId: id,
          //               quantity: quantity,
          //               price: price,
          //               totalPrice: price! * quantity,
          //               restaurantId: restaurant,
          //               timeShift: currentTiming,
          //               ProductObject: this);
          //         },

          //         child: const Icon(Icons.add_shopping_cart_rounded),
          //       )
          //     : SizedBox(
          //         width: 100,
          //         child: Image.asset("assets/Images/loading2.gif"),
          //       ),
          appBar: appBar(context,
              subtitle: restaurantName.toString(), title: englishName),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height / 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: SizedBox(
                    child: Column(
                      children: [
                        ClipRRect(
                          child: Image(
                            errorBuilder: (context, error, stackTrace) {
                              return Text(error.toString());
                            },
                            fit: BoxFit.contain,
                            width: width / 3,
                            height: height / 5,
                            image: CachedNetworkImageProvider(
                              '$image',
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: Loading(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  "$englishName",
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      "$arabicName",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("$description",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("EGP $price",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              if (quantity != 1) {
                                                quantity--;
                                                totalPrice = quantity * price!;
                                                OrderCubit.get(context)
                                                    .emit(RemoveQuantity());
                                              }
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              color: ThemeApp.primaryColor,
                                            )),
                                        Text("$quantity"),
                                        IconButton(
                                            onPressed: () {
                                              quantity++;
                                              totalPrice = quantity * price!;
                                              OrderCubit.get(context)
                                                  .emit(AddQuantity());
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              color: ThemeApp.primaryColor,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                  width: double.maxFinite,
                  // child: AdWidget(ad: bannerAd),
                ),
                isRequestFinished
                    ? DefaultButton(
                        function: () {
                          // OrderCubit.get(context).getPublicOrder(context);

                          OrderCubit.get(context).addToCart(
                            context,
                            cartItemId: cartItemId,
                            productId: id,
                            quantity: quantity,
                            price: price,
                            totalPrice: price! * quantity,
                            restaurantId: restaurant,
                            timeShift: currentTiming,
                            productObject: this,
                          );
                        },
                        text: "Add to Cart")
                    : Loading(),
                const SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  // child: AdWidget(ad: bannerAd),
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
              Navigator.pop(context);
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
      listener: ((context, state) {}),
    );
  }

  Widget MostSoldProducts(
    BuildContext context, {
    final double raduisPadding = 8.0,
    final double raduisButton = 10.0,
    double height = 100,
    double width = 100,
    required final String? image,
    required final Color? Colors,
    required final String? data,
    required String? restaurantName,
  }) {
    return Column(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: Padding(
            padding: EdgeInsets.all(raduisPadding),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(raduisButton)))),
              onPressed: () {
                Navigation(
                  context,
                  productDetails(context,
                      image: '$image',
                      id: id,
                      restaurant: restaurant,
                      restaurantName: restaurantName,
                      price: price,
                      arabicName: arabicName,
                      description:
                          description ?? "No Description for this Product",
                      englishName: englishName,
                      productName: productName),
                );
              },
              child: Image(
                errorBuilder: (context, error, stackTrace) {
                  return Text(error.toString());
                },
                image: CachedNetworkImageProvider(
                  image!,
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: Loading(),
                  );
                },
              ),
            ),
          ),
        ),
        Text("${data}", style: Theme.of(context).textTheme.displaySmall),
      ],
    );
  }

  Widget NewProducts(
    BuildContext context, {
    final double raduisPadding = 8.0,
    final double raduisButton = 10.0,
    double height = 100,
    double width = 100,
    required final String? image,
    required final Color? Colors,
    final String? title,
    required String? restaurantName,
  }) {
    return Column(
      children: [
        SizedBox(
          height: height,
          width: width,
          child: Padding(
            padding: EdgeInsets.all(raduisPadding),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(raduisButton)))),
              onPressed: () {
                Navigation(
                  context,
                  productDetails(context,
                      image: '$image',
                      id: id,
                      restaurant: restaurant,
                      restaurantName: restaurantName,
                      price: price,
                      arabicName: arabicName,
                      description:
                          description ?? "No Description for this Product",
                      englishName: englishName,
                      productName: productName),
                );
              },
              child: Image(
                errorBuilder: (context, error, stackTrace) {
                  return Text(error.toString());
                },
                width: 200,
                image: CachedNetworkImageProvider(
                  image!,
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: Loading(),
                  );
                },
              ),
            ),
          ),
        ),
        Text("${title}", style: Theme.of(context).textTheme.displaySmall),
      ],
    );
  }
}
