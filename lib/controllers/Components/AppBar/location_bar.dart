import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/theme.dart';
import 'package:xeats/views/Cart/Cart.dart';

class LocationBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100);
  const LocationBar(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var cubit = OrderCubit.get(context);
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        width: width,
        height: height / 8,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
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
                          Text(AppConstants.delivering,
                              style: Theme.of(context).textTheme.headlineSmall),
                        ],
                      ),
                      BlocBuilder<OrderCubit, OrderStates>(
                        builder: (context, state) {
                          return ConditionalBuilder(
                              condition: cubit.LocationsNames.isNotEmpty,
                              fallback: (context) {
                                return SpinKitThreeInOut(
                                  color: ThemeApp.primaryColor,
                                  size: 10,
                                );
                              },
                              builder: (
                                context,
                              ) {
                                return DropdownButton(
                                  hint: Text(
                                    "Select your Location",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  items: cubit.LocationsNames.map<
                                      DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium),
                                    );
                                  }).toList(),
                                  onChanged: (dynamic value) {
                                    cubit.clearCartItems(context);
                                    cubit.ChangeLocation(value, context);
                                    cubit.getRestaurantsOfLocation(context);
                                  },
                                  value: OrderCubit.currentLocation,
                                  icon: const Icon(Icons.arrow_drop_down),
                                );
                              });
                        },
                      ),
                    ]),
              ),
              if (OrderCubit.currentLocation == null)
                const Row(
                  children: [
                    // IconButton(
                    //   onPressed: () {
                    //     print(OrderCubit.currentLocation);
                    //   },
                    //   icon: Icon(
                    //     Icons.shopping_cart,
                    //     color: Theme.of(context).primaryColor,
                    //   ),
                    // )
                  ],
                ),
              if (OrderCubit.currentLocation != null)
                IconButton(
                  onPressed: () {
                    Navigation(context, const Cart());
                    // print(OrderCubit.currentLocation);
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).primaryColor,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
