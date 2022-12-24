import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xeats/controllers/Components/Components.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/ItemClass.dart';
import 'package:xeats/controllers/Cubit.dart';
import 'package:xeats/controllers/States.dart';
import 'package:xeats/views/Animations/EmptyCart.dart';
import 'package:xeats/views/Layout/Layout.dart';

List<Widget> allWhatInCart = [];

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Xeatscubit()
        ..CartData()
        ..GettingUserData(),
      child: BlocConsumer<Xeatscubit, XeatsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = Xeatscubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              actions: [Image.asset("assets/Images/shopping-cart.png")],
              backgroundColor: const Color.fromARGB(255, 9, 134, 211),
              toolbarHeight: 120,
              leadingWidth: 400,
              leading: const Padding(
                padding: EdgeInsets.all(25.0),
                child: Text(
                  "Cart",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: Xeatscubit.get(context).getCartItems(
                        context,
                        email: cubit.EmailInforamtion,
                      ),
                      builder: (ctx, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (!snapshot.data.isEmpty) {
                            allWhatInCart = snapshot.data;

                            allWhatInCart.add(Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Slide Left to delete an Item",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  SizedBox(
                                    height: 10.h,
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height: 50.h,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20))),
                                            onPressed: () {
                                              if (FoodItem.CartItems.length ==
                                                  1) {
                                                print(cubit.cartItems);
                                                // showDialog<void>(
                                                //   context: context,
                                                //   barrierDismissible:
                                                //       false, // user must tap button!
                                                //   builder:
                                                //       (BuildContext context) {
                                                //     return AlertDialog(
                                                //       title: const Text(
                                                //           'Error !!'),
                                                //       content:
                                                //           SingleChildScrollView(
                                                //         child: ListBody(
                                                //           children: const <
                                                //               Widget>[
                                                //             Text(
                                                //                 'You can\'t order from different reataurants\nPlease make your order with the same restaurant only.'),
                                                //           ],
                                                //         ),
                                                //       ),
                                                //       actions: <Widget>[
                                                //         TextButton(
                                                //           child: const Text(
                                                //               'Got It'),
                                                //           onPressed: () {
                                                //             Navigator.of(
                                                //                     context)
                                                //                 .pop();
                                                //           },
                                                //         ),
                                                //       ],
                                                //     );
                                                //   },
                                                // );
                                              } else {
                                                // Navigation(context, CheckOut());
                                              }
                                            },
                                            child: Text("Check Out")),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ));

                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 1.25,
                              child: ListView.separated(
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
                            return Center(child: EmptyCart());
                          }
                        } else {
                          return SizedBox(
                            child: Loading(),
                            height: MediaQuery.of(context).size.height / 1.3,
                          );
                        }
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
