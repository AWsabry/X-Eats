import "package:flutter/material.dart";
import 'package:xeats/views/Layout/Layout.dart';

import '../../controllers/Components/General Components/Components.dart';

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
            child: Image.asset("assets/Images/emptyCart.gif"),
            width: 200,
          ),
          Text(
            "Waiting for your orders",
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
              onPressed: () {
                Navigation(context, Layout());
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 9, 134, 211)),
                  ),
                ),
              ),
              child: const Text(
                "Continue Shopping",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
  }
}
