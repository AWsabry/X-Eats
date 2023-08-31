// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';
import 'package:xeats/views/HomePage/HomePage.dart';
import 'package:xeats/views/WaitingRoom/waitingRoom.dart';

import 'Product Class/Products_Class.dart';

class PaymentSummary extends StatelessWidget {
  PaymentSummary({
    super.key,
    required this.widget,
    this.Orderid,
    this.CanCancelled,
    this.SubTotal,
  });
  int? Orderid;
  double? SubTotal;
  final WaitingRoom widget;
  bool? CanCancelled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderStates>(builder: (context, state) {
      return Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.only(top: 24, left: 19),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Payment Summary",
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text("Subtotal",
                            style: Theme.of(context).textTheme.labelSmall),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Text(
                              "EGP ${ProductClass.getSubtotal() == 0.0 ? SubTotal : ProductClass.getSubtotal()}",
                              style: Theme.of(context).textTheme.labelSmall),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text("Your Delivery Fees",
                            style: Theme.of(context).textTheme.labelSmall),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Text(
                              "EGP ${OrderCubit.deliveryfees! / widget.count}",
                              style: Theme.of(context).textTheme.labelSmall),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text("Service Fees",
                            style: Theme.of(context).textTheme.labelSmall),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Text("EGP ${OrderCubit.servicefees ?? 5.00}",
                              style: Theme.of(context).textTheme.labelSmall),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Text("Total Amount",
                            style: Theme.of(context).textTheme.labelSmall),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Text(
                              "EGP ${(ProductClass.getSubtotal() == 0.0 ? SubTotal : ProductClass.getSubtotal())! + (OrderCubit.servicefees!) + (OrderCubit.deliveryfees! / widget.count)}",
                              style: Theme.of(context).textTheme.labelSmall),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: ConditionalBuilder(
                        condition: OrderCubit.get(context).clikable == false ||
                            CanCancelled == false,
                        fallback: (context) {
                          return Container(
                            width: 353,
                            height: 50,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 9, 134, 211),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 9, 134, 211))),
                              onPressed: () {
                                OrderCubit.get(context).clostTime(context);
                                OrderCubit.get(context).cancelOrders(Orderid);
                                OrderCubit.get(context).confirmOrderPressed();
                                NavigateAndRemov(context, const HomePage());
                              },
                              child: const Center(
                                child: Text(
                                  "Cancel Your Order",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "IntegralCf",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        },
                        builder: (context) {
                          return Container(
                            width: 353,
                            height: 50,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: const Center(
                              child: Text(
                                "Cancel Your Order",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "IntegralCf",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
