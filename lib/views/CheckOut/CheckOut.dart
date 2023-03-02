import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xeats/controllers/Components/Components.dart';
import 'package:xeats/controllers/Components/Global%20Components/DefaultButton.dart';
import 'package:xeats/controllers/Components/ItemClass.dart';
import 'package:xeats/controllers/Cubit.dart';
import 'package:xeats/controllers/States.dart';
import 'package:xeats/views/Cart/cart.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Xeatscubit, XeatsStates>(builder: (context, state) {
      double deliveryFees = Xeatscubit.get(context).deliveryfees!;
      return Scaffold(
        appBar: AppBar(
          actions: [Image.asset("assets/Images/shopping-cart.png")],
          backgroundColor: const Color.fromARGB(255, 9, 134, 211),
          toolbarHeight: 100,
          leadingWidth: 800,
          leading: const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Checkout",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Payment Summary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Subtotal",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "EGP ${FoodItem.getSubtotal()}",
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Delivery Fee",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "EGP ${deliveryFees}",
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
                    "EGP ${deliveryFees + FoodItem.getSubtotal()}",
                    style: const TextStyle(fontSize: 24),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigation(context, const Cart());
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 9, 134, 211))))),
                      child: const Text(
                        "Back to cart",
                        style: TextStyle(color: Colors.black),
                      )),
                  DefaultButton(
                      function: () {
                        Xeatscubit.get(context).confirmOrder(
                          context,
                        );
                      },
                      text: "Order Now")
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
