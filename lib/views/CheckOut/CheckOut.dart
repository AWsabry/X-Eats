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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Subtotal",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "EGP ${ProductClass.getSubtotal()}",
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Max Delivery Fee ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "$deliveryFees EGP ",
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    "${deliveryFees + ProductClass.getSubtotal()} EGP ",
                    style: const TextStyle(fontSize: 24),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      : const Loading(),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
