// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xeats/controllers/Components/Global%20Components/Buttons/DefaultButton.dart';
import 'package:xeats/controllers/Components/Global%20Components/Buttons/SecondryButton.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/Product%20Class/Products_Class.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';
import 'package:xeats/theme.dart';
import 'package:xeats/views/Cart/cart.dart';

class CheckOut extends StatelessWidget {
  CheckOut({
    super.key,
    required this.Private,
  });
  bool? Private;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderStates>(builder: (context, state) {
      double deliveryFees = OrderCubit.deliveryfees ?? 20;
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;

      return Scaffold(
        appBar: AppBar(
          // actions: [Image.asset("assets/Images/shopping-cart.png")],
          backgroundColor: ThemeApp.accentColor,
          toolbarHeight: 100,
          leadingWidth: 800,
          leading: const Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                "Payment Summary",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(113, 224, 1, 1)),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(
                width: width / 6,
                height: height / 6,
                child: Image.asset("assets/Images/tick.png"),
              ),
              SizedBox(
                height: height / 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Subtotal",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "EGP ${ProductClass.getSubtotal()}",
                    style: Theme.of(context).textTheme.displayLarge,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Max Delivery Fee ",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "EGP $deliveryFees",
                    style: Theme.of(context).textTheme.displayLarge,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "EGP ${deliveryFees + ProductClass.getSubtotal()}",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              SizedBox(
                height: height / 50,
              ),
              const Divider(),
              SizedBox(
                height: height / 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OrderCubit.get(context).confirmOrderPressedButton == false
                      ? DefaultButton(
                          function: () {
                            OrderCubit.get(context).confirmOrderPressed();
                            OrderCubit.get(context)
                                .confirmOrder(context, Private);
                          },
                          text: "Order Now")
                      : const Loading(),
                  SizedBox(
                    height: 30.sp,
                  ),
                  OrderCubit.get(context).confirmOrderPressedButton == false
                      ? SecondaryButton(
                          function: () {
                            Navigation(context, const Cart());
                          },
                          text: "Back to cart",
                        )
                      : const SizedBox(),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
