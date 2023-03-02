import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xeats/controllers/Components/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/Components.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/Restaurant%20Components/RestaurantView.dart';
import 'package:xeats/controllers/Cubit.dart';
import 'package:xeats/controllers/States.dart';
import 'package:xeats/views/Animations/EmptyCart.dart';
import 'package:xeats/views/Checkout/CheckOut.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/ResturantsMenu/ResturantsMenu.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

late Future FutureRestaurants;
late Future getCartItemsFuture;
late List<Widget> allWhatInCart = [];

class _CartState extends State<Cart> {
  @override
  void initState() {
    FutureRestaurants =
        Xeatscubit.get(context).getCurrentAvailableOrderRestauant();
    getCartItemsFuture = Xeatscubit.get(context).getCartItems(
      context,
      email: Xeatscubit.get(context).EmailInforamtion,
    );
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocConsumer<Xeatscubit, XeatsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = Xeatscubit.get(context);
        return Scaffold(
          appBar:
              appBar(context, subtitle: "${cubit.FirstName}'s", title: "Cart"),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                FutureBuilder(
                  builder: (ctx, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        Xeatscubit.currentRestaurant["Name"] != null) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: width / 2,
                            child: Column(
                              children: [
                                Text(
                                  "${cubit.FirstName},",
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: width / 40),
                                  child: const Text(
                                    "You are Ordering From :",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                Container(
                                  height: height / 6,
                                  width: width / 2.4,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          width: 20, color: Colors.white)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: GestureDetector(
                                      child: Image(
                                        image: NetworkImage(
                                            "https://x-eats.com${Xeatscubit.currentRestaurant["image"]}"),
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: Loading(),
                                          );
                                        },
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                                Text(
                                  "${Xeatscubit.currentRestaurant["Name"]}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox(
                        height: height / 20,
                      );
                    }
                  },
                  future: FutureRestaurants,
                ),
                FutureBuilder(
                    future: getCartItemsFuture,
                    builder: (ctx, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (!snapshot.data.isEmpty) {
                          allWhatInCart = snapshot.data;

                          allWhatInCart.add(Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "Slide Left to delete an Item",
                                  style: TextStyle(color: Colors.red),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigation(context, Layout());
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 9, 134, 211)),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Continue Shopping",
                                          style: TextStyle(color: Colors.black),
                                        )),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      height: 50.h,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                          onPressed: () async {
                                            await Xeatscubit.get(context)
                                                .deliveryFees();
                                            Navigation(
                                                context, const CheckOut());
                                          },
                                          child: const Text("Check Out")),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ));

                          return Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return allWhatInCart[index];
                              },
                              separatorBuilder: (context, index) {
                                return Dividerr();
                              },
                              itemCount: allWhatInCart.length,
                            ),
                          );
                        } else {
                          return const Center(child: EmptyCart());
                        }
                      } else {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Loading(),
                        );
                      }
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
