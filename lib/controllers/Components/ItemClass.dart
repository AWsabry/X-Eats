import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/Requests%20Loading%20Components/RequstsLoading.dart';
import 'package:xeats/controllers/Cubit.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/States.dart';
import 'package:xeats/controllers/Components/Components.dart';
import 'package:xeats/views/Cart/cart.dart';
import 'package:xeats/views/CheckOut/CheckOut.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/Profile/Profile.dart';
import 'package:xeats/views/Resturants/Resturants.dart';

class FoodItem extends StatelessWidget {
  final bool? isMostPopular, isNewProduct, isBestOffer;
  static double deliveryFee = 10;
  final double? price;
  final int? restaurant, category, id;
  final String? englishName, productSlug, creationDate, arabicName;
  final String? description;
  int quantity = 1;
  double? totalPrice;
  String? itemImage, restaurantImage;
  String? cartItemId;

  static List<Widget> CartItems = [];

  FoodItem({
    this.id,
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
  }) {}

  static double getSubtotal() {
    double total = 0;
    for (var i in CartItems) {
      print("CartItems" + " " + "$CartItems");
      try {
        i = i as FoodItem;
        total += i.price! * i.quantity;
        print("TOTAL" + " " + "$total");
      } catch (e) {
        continue;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Xeatscubit, XeatsStates>(builder: (context, state) {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
      return SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            Navigation(
              context,
              productDetails(
                context,
                image: itemImage,
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
                NavigateAndRemov(context, const CheckOut());
              } else {
                await Xeatscubit.get(context)
                    .deleteCartItem(context, "$cartItemId")
                    .then((value) {
                  FoodItem.CartItems.remove(this);

                  Xeatscubit.get(context).updateCartPrice();
                });
              }
            },
            key: const Key(""),
            background: Container(
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: const [
                    Icon(Icons.arrow_forward_rounded, color: Colors.white),
                    Text('Move to CheckOut',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
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
                      width: width / 5,
                      image: NetworkImage(
                        "https://x-eats.com${this.itemImage}",
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
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
                            Text(
                              "$englishName",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
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
                              "Price: $price",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "$arabicName",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black,
                              ),
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
                            Text("QTY : $quantity"),
                            Text(
                              "Total: $totalPrice EGP",
                              style: const TextStyle(fontSize: 16),
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
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigation(
                  context,
                  productDetails(
                    context,
                    image: '${image}',
                    id: id,
                    restaurant: restaurant,
                    restaurantName: restaurantName,
                    price: price,
                    arabicName: arabicName,
                    description:
                        description ?? "No Description for this Product",
                    englishName: englishName,
                  ),
                  duration: Duration(seconds: 2));
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  FutureBuilder(
                    builder: ((context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          height: 130.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(74, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Hero(
                              tag: this.englishName.toString(),
                              child: Image(
                                image: NetworkImage(
                                  "https://x-eats.com${snapshot.data.data["Names"][0]["image"]}",
                                ),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: Loading(),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Loading();
                      }
                    }),
                    future: Dio()
                        .get("https://x-eats.com/get_category_by_id/$CatId"),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              englishName!,
                              style: GoogleFonts.poppins(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            category.toString(),
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 11),
                          ),
                          Text(
                            price.toString() + "  EGP",
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 14),
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

  Widget productDetails(BuildContext context,
      {required String? image,
      required String? restaurantName,
      required double? price,
      required String? arabicName,
      required String? description,
      required String? englishName,
      required int? id,
      required int? restaurant}) {
    String? shift;

    final BannerAd bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-5674432343391353/3216382829",
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

    return BlocProvider(
      create: (context) => Xeatscubit()
        ..GettingUserData()
        ..getCartID(),
      child: BlocConsumer<Xeatscubit, XeatsStates>(
        builder: (context, states) {
          if (CartItems.isEmpty) {
            Xeatscubit.currentRestaurant = {};
          }
          var navcubit = NavBarCubitcubit.get(context);
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
          return Scaffold(
            floatingActionButton: isRequestFinished
                ? FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 9, 134, 211),
                    //add to cart button
                    onPressed: () async {
                      await Xeatscubit.get(context).addToCart(context,
                          cartItemId: cartItemId,
                          productId: id,
                          quantity: quantity,
                          price: price,
                          totalPrice: price! * quantity,
                          restaurantId: restaurant,
                          timeShift: currentTiming,
                          foodItemObject: this);
                    },

                    child: const Icon(Icons.add_shopping_cart_rounded),
                  )
                : SizedBox(
                    child: Image.asset("assets/Images/loading2.gif"),
                    width: 100,
                  ),
            appBar: appBar(context,
                subtitle: restaurantName.toString(), title: englishName),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(300.0),
                            child: Hero(
                              tag: this.englishName.toString(),
                              child: Image(
                                width: 200,
                                image: NetworkImage(
                                  'https://x-eats.com$image',
                                ),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: Loading(),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "$price EGP",
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        "$englishName\n",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height / 20,
                                    ),
                                  ],
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
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Description:\n",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "$description",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Quantity :",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              if (quantity != 1) {
                                                quantity--;
                                                totalPrice = quantity * price!;
                                                Xeatscubit.get(context)
                                                    .emit(RemoveQuantity());
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.remove,
                                              color: Color.fromARGB(
                                                  255, 9, 134, 211),
                                            )),
                                        Text("${this.quantity}"),
                                        IconButton(
                                            onPressed: () {
                                              quantity++;
                                              totalPrice = quantity * price!;
                                              Xeatscubit.get(context)
                                                  .emit(AddQuantity());
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              color: Color.fromARGB(
                                                  255, 9, 134, 211),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Order Time :",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    DropdownButton(
                                        hint: shift == null
                                            ? const Text("Time Shift")
                                            : Text("$shift"),
                                        items: getTimings(),
                                        onChanged: (data) {
                                          shift = data as String?;
                                          currentTiming = data;
                                          // Xeatscubit.get(context).emit(SetTiming());
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.maxFinite,
                    child: AdWidget(ad: bannerAd),
                  ),
                  const SizedBox(
                    height: 40,
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
                Navigator.pop(context);
                if (index == 1) {
                  Navigation(context, const Restaurants());
                } else if (index == 0) {
                  Navigation(context, Layout());
                } else {
                  Navigation(context, Profile());
                }
              },
            ),
          );
        },
        listener: ((context, state) {}),
      ),
    );
  }
}
