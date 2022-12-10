import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/Components.dart';
import 'package:xeats/controllers/Components/DiscountBanner.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/Products%20Components/ProductView.dart';
import 'package:xeats/controllers/Components/Restaurant%20Components/RestaurantView.dart';
import 'package:xeats/controllers/Components/search.dart';
import 'package:xeats/controllers/Cubit.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/controllers/States.dart';
import 'package:xeats/views/Cart/cart.dart';
import 'package:xeats/views/ResturantsMenu/ResturantsMenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var restaurant_api = Xeatscubit.ResturantsList;
    print(restaurant_api);
    var product_api = Xeatscubit.Get_Products;
    return BlocProvider(
        create: (context) => Xeatscubit(),
        child: BlocConsumer<Xeatscubit, XeatsStates>(
          builder: ((context, state) {
            var cubit = Xeatscubit.get(context);
            return Scaffold(
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height / 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SearchField(),
                                  IconButton(
                                    onPressed: () {
                                      Navigation(context, const Cart());
                                    },
                                    icon: Icon(Icons.shopping_cart,
                                        color: const Color.fromARGB(
                                            255, 9, 134, 211)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          width: width,
                          height: height / 4,
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Delivering to',
                                    style: GoogleFonts.kanit(fontSize: 15),
                                  ),
                                  Text(
                                    'User (Zayed-Nile University)',
                                    style: GoogleFonts.kanit(fontSize: 20),
                                  ),
                                ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: DiscountBanner(),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Resturants',
                                  style: GoogleFonts.kanit(fontSize: 26),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ...List.generate(
                                      restaurant_api.length,
                                      (index) {
                                        return RestaurantView(
                                          data: restaurant_api[index]['Name'] ??
                                              Loading(),
                                          Colors: const Color.fromARGB(
                                              255, 5, 95, 9),
                                          image: Image(
                                            image: NetworkImage(DioHelper
                                                    .dio!.options.baseUrl +
                                                restaurant_api[index]['image']),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Most Ordered',
                                  style: GoogleFonts.kanit(fontSize: 24),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  child: Row(
                                    children: [
                                      ...List.generate(
                                        product_api.length,
                                        (index) {
                                          return GestureDetector(
                                            child: ProductView(
                                                width: width / 2.0,
                                                height: height / 4.2,
                                                data: product_api[index]
                                                        ["name"] +
                                                    "\n",
                                                Colors: Colors.white,
                                                Navigate: () => {}),
                                            onTap: () {
                                              print(product_api[0]["name"]);
                                            },
                                          );
                                        },
                                      ),

                                      ProductView(
                                          width: width / 2.0,
                                          height: height / 4.2,
                                          data: "Shawrma Frakh" + "\n",
                                          Colors: Colors.white,
                                          image: const Image(
                                            image: AssetImage(
                                              'assets/Images/Shawrma.png',
                                            ),
                                          ),
                                          Navigate: () => {}),
                                      ProductView(
                                          width: width / 2.0,
                                          height: height / 4.2,
                                          data: "Shawrma Frakh" + "\n",
                                          Colors: Colors.white,
                                          image: const Image(
                                            image: AssetImage(
                                              'assets/Images/Shawrma.png',
                                            ),
                                          ),
                                          Navigate: () => {}),
                                      ProductView(
                                          width: width / 2.0,
                                          height: height / 4.2,
                                          data: "Shawrma Frakh" + "\n",
                                          Colors: Colors.white,
                                          image: const Image(
                                            image: AssetImage(
                                              'assets/Images/Shawrma.png',
                                            ),
                                          ),
                                          Navigate: () => {}),
                                      //
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            );
          }),
          listener: ((context, state) {}),
        ));
  }
}
