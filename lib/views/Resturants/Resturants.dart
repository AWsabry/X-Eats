import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/Components.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/ItemClass.dart';
import 'package:xeats/controllers/Cubit.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/States.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/Profile/Profile.dart';
import 'package:xeats/views/ResturantsMenu/ResturantsMenu.dart';
import '../../controllers/Components/Products Components/NewProducts.dart';

class Restaurants extends StatelessWidget {
  const Restaurants({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BlocConsumer<Xeatscubit, XeatsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = Xeatscubit.get(context);
        var data_from_api = Xeatscubit.ResturantsList;
        var newProducts = Xeatscubit.new_products;
        var navcubit = NavBarCubitcubit.get(context);
        var Connection = false;

        return Scaffold(
          appBar: appBar(context, subtitle: 'X-Eats', title: 'Restaurants'),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'New Products',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        newProducts.length,
                        (index) {
                          return ConditionalBuilder(
                              fallback: (context) {
                                return Loading();
                              },
                              condition: newProducts[index]["image"] != null,
                              builder: (context) {
                                return GestureDetector(
                                  child: NewProducts(
                                      title: newProducts[index]["name"],
                                      Colors: Colors.white,
                                      image: newProducts[index]["image"],
                                      Navigate: () => {
                                            Navigation(
                                              context,
                                              FoodItem().productDetails(
                                                context,
                                                image: newProducts[index]
                                                    ["image"],
                                                id: newProducts[index]['id'],
                                                restaurant: newProducts[index]
                                                    ['Restaurant'],
                                                price: newProducts[index]
                                                    ['price'],
                                                englishName: newProducts[index]
                                                    ["name"],
                                                arabicName: newProducts[index]
                                                    ["ArabicName"],
                                                description: newProducts[index]
                                                        ["description"] ??
                                                    "No Description for this Product",
                                                restaurantName:
                                                    newProducts[index]
                                                            ["Restaurant"]
                                                        .toString(),
                                                productName: '',
                                              ),
                                            ),
                                          }),
                                );

                                // },
                              });
                        },
                      ),
                    ],
                  ),
                ),
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
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ConditionalBuilder(
                      condition:
                          data_from_api.isNotEmpty && Connection == false,
                      fallback: (context) => Center(child: Loading()),
                      builder: (context) => ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (data_from_api[index]['image'] == null) {
                            return Loading();
                          } else {
                            return InkWell(
                              onTap: () {
                                Navigation(
                                    context,
                                    ResturantsMenu(
                                      data: data_from_api[index],
                                      RestaurantId: data_from_api[index]['id'],
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(children: [
                                  Container(
                                    height: 130.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              74, 158, 158, 158)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Image.network(
                                          'https://www.x-eats.com' +
                                              data_from_api[index]['image'],
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: Loading(),
                                            );
                                          },
                                        )),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: height / 7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(children: [
                                            Text(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                '${data_from_api[index]['Name']}',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                )),
                                          ]),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(children: const [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            Text(' 4.1'),
                                            Text(' (100+)')
                                          ]),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                const Icon(Icons.timer_sharp),
                                                Text(
                                                  ' 45 mins',
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  width: 25.w,
                                                ),
                                                Icon(Icons
                                                    .delivery_dining_outlined),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                Text(
                                                  'X-Eats Delivery',
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w400),
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
                        separatorBuilder: ((context, index) => Dividerr()),
                        itemCount: data_from_api.length,
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedLabelStyle: GoogleFonts.poppins(),
            backgroundColor: Colors.white,
            items: navcubit.bottomitems,
            currentIndex: 1,
            onTap: (index) {
              if (index == 1) {
                Navigator.popUntil(context, (route) => route.isCurrent);
              } else if (index == 0) {
                Navigation(context, Layout());
              } else {
                Navigation(context, Profile());
              }
            },
          ),
        );
      },
    );
  }
}
