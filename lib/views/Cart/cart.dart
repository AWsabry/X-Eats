import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/Global%20Components/Buttons/DefaultMiniButton.dart';
import 'package:xeats/controllers/Components/Global%20Components/Buttons/SecondaryMiniButton.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_divider.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsStates.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestaurantsStates.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestuarantsCubit.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/views/Animations/EmptyCart.dart';
import 'package:xeats/views/Checkout/CheckOut.dart';
import 'package:xeats/views/Layout/Layout.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

late Future FutureRestaurants;
late Future getCartItemsFuture;
List<Widget> allWhatInCart = [];

class _CartState extends State<Cart> {
  @override
  void initState() {
    super.initState();
    FutureRestaurants = RestuarantsCubit.get(context)
        .getCurrentAvailableOrderRestauant(context);
    getCartItemsFuture = OrderCubit.get(context).getCartItems(
      context,
      email: AuthCubit.get(context).userEmailShared,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OrderCubit(),
        ),
        BlocProvider(
          create: (context) => RestuarantsCubit(),
        ),
      ],
      child: BlocConsumer<RestuarantsCubit, RestuarantsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                height / 11,
              ), // Adjust the height here
              child: appBar(context,
                  subtitle: "${cubit.firstNameShared}'s", title: 'Cart'),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: height / 20,
                  ),
                  FutureBuilder(
                    builder: (ctx, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          RestuarantsCubit.currentRestaurant["Name"] != null) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // SizedBox(
                            //   width: width / 2,
                            //   child: Column(
                            //     children: [
                            //       Text("${cubit.firstNameShared},",
                            //           maxLines: 1,
                            //           style: Theme.of(context)
                            //               .textTheme
                            //               .headlineMedium),
                            //       Container(
                            //         margin: EdgeInsets.only(left: width / 40),
                            //         child: Text("You are Ordering From :",
                            //             style: Theme.of(context)
                            //                 .textTheme
                            //                 .displaySmall),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Column(
                              children: [
                                // Container(
                                //   height: height / 8,
                                //   width: width / 2.4,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(12),
                                //       color: Colors.transparent,
                                //       border: Border.all(
                                //           width: 20, color: Colors.white)),
                                //   child: ClipRRect(
                                //     borderRadius: BorderRadius.circular(20),
                                //     child: GestureDetector(
                                //       child: Image(
                                //         image: CachedNetworkImageProvider(
                                //             "${AppConstants.BaseUrl}${RestuarantsCubit.currentRestaurant["logo"]}"),
                                //         loadingBuilder:
                                //             (context, child, loadingProgress) {
                                //           if (loadingProgress == null) {
                                //             return child;
                                //           }
                                //           return const Center(
                                //             child: Loading(),
                                //           );
                                //         },
                                //       ),
                                //       onTap: () {},
                                //     ),
                                //   ),
                                // ),
                                // Text(
                                //     "${RestuarantsCubit.currentRestaurant["Name"]}",
                                //     style:
                                //         Theme.of(context).textTheme.bodyLarge),
                              ],
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
                                    "Slide Left or Right to delete an Item",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SecondaryMiniButton(
                                          function: () {
                                            Navigation(context, Layout());
                                          },
                                          text: 'Continue Shopping'),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          height: 50.h,
                                          child: DefaultMiniButton(
                                              function: () async {
                                                await OrderCubit.get(context)
                                                    .deliveryFees(context);
                                                if (ProductsCubit.get(context)
                                                        .privacy ==
                                                    Privacy.Private) {
                                                  Navigation(
                                                      context,
                                                      CheckOut(
                                                        Private: true,
                                                      ));
                                                } else {
                                                  Navigation(
                                                    context,
                                                    CheckOut(
                                                      Private: false,
                                                    ),
                                                  );
                                                }
                                              },
                                              text: 'Checkout'))
                                    ],
                                  ),
                                ],
                              ),
                            ));

                            return Column(
                              children: [
                                SingleChildScrollView(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return allWhatInCart[index];
                                    },
                                    separatorBuilder: (context, index) {
                                      return customDivider();
                                    },
                                    itemCount: allWhatInCart.length,
                                  ),
                                ),
                                BlocBuilder<ProductsCubit, ProductsStates>(
                                  builder: (ProductCubit, ProductStates) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("Public",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium),
                                        const SizedBox(width: 10),
                                        Radio<Privacy>(
                                          activeColor:
                                              Theme.of(context).backgroundColor,
                                          value: Privacy.Public,
                                          groupValue:
                                              ProductsCubit.get(ProductCubit)
                                                  .privacy,
                                          onChanged: (Privacy? value) {
                                            ProductsCubit.get(ProductCubit)
                                                .changePrivacyOrdertoPublic(
                                                    value);
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Private",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall),
                                        ),
                                        const SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Radio<Privacy>(
                                            value: Privacy.Private,
                                            activeColor: Theme.of(context)
                                                .backgroundColor,
                                            groupValue:
                                                ProductsCubit.get(ProductCubit)
                                                    .privacy,
                                            onChanged: (Privacy? value) {
                                              ProductsCubit.get(ProductCubit)
                                                  .changePrivacyOrdertoPublic(
                                                      value);
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return const Center(child: EmptyCart());
                          }
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: const Loading(),
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
