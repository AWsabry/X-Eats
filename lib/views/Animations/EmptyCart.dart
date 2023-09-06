import "package:flutter/material.dart";
import 'package:xeats/controllers/Components/Global%20Components/Buttons/DefaultButton.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/views/Layout/Layout.dart';

class EmptyCart extends StatefulWidget {
  const EmptyCart({super.key});

  @override
  State<EmptyCart> createState() => _EmptyCartState();
}

class _EmptyCartState extends State<EmptyCart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 200,
            child: Image.asset("assets/Images/emptyCart.gif"),
          ),
          const Text(
            "Cart is Empty",
            style: TextStyle(fontSize: 20),
          ),

          DefaultButton(
            function: () {
              Navigation(context, const Layout());
            },
            text: 'Continue Shopping',
          )

          //   ElevatedButton(
          //       onPressed: () {

          //       },
          //       style:

          //       ButtonStyle(
          //         backgroundColor: MaterialStateProperty.all(Colors.white),
          //         shape: MaterialStateProperty.all(
          //           RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(18.0),
          //             side: const BorderSide(
          //                 color: Color.fromARGB(255, 9, 134, 211)),
          //           ),
          //         ),
          //       ),
          //       child: const Text(
          //         "Continue Shopping",
          //         style: TextStyle(color: Colors.black),
          //       )),
        ],
      ),
    );
  }
}
