import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/views/Cart/Cart.dart';
import 'package:xeats/views/HomePage/HomePage.dart';

AppBar LocationBar(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return AppBar(
    automaticallyImplyLeading: false,
    foregroundColor: Colors.white,
    backgroundColor: Colors.white,
    actions: [
      Container(
        color: Colors.transparent,
        width: width,
        height: height / 13,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            Appconstants.delivering,
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: Colors.grey),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ConditionalBuilder(
                              condition: OrderCubit.get(context)
                                  .LocationsNames
                                  .isNotEmpty,
                              fallback: (context) {
                                return const SpinKitThreeInOut(
                                  color: Color.fromARGB(255, 9, 134, 211),
                                  size: 10,
                                );
                              },
                              builder: (
                                context,
                              ) {
                                return BlocBuilder<OrderCubit, OrderStates>(
                                  builder: (context, state) {
                                    var cubit = OrderCubit.get(context);
                                    return DropdownButton(
                                      hint: Text("Select your Location"),
                                      items: cubit.LocationsNames.map<
                                          DropdownMenuItem<String>>((value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.black,
                                              )),
                                        );
                                      }).toList(),
                                      onChanged: (dynamic value) {
                                        cubit.ChangeLocation(value);
                                        cubit.getRestaurantsOfLocation(context);
                                      },
                                      value: OrderCubit.currentLocation,
                                      icon: Icon(Icons.arrow_drop_down),
                                    );
                                  },
                                );
                              })
                        ],
                      )
                    ]),
              ),
              IconButton(
                onPressed: () {
                  Navigation(context, const Cart());
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    ],
  );
}
