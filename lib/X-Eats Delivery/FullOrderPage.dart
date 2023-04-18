import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'DeliveryOredrs.dart';

class FullOrderPage extends DeliveryOrder {
  FullOrderPage({
    super.id,
    super.email,
    super.phoneNumber,
    super.fullName,
    super.orderTime,
    super.isPaid,
    super.totalPrice,
    super.totalPriceAfterDelivery,
    super.uid,
    super.cartId,
  });

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("${super.id}"),
        ),
      ),
      body: FutureBuilder(
        builder: (context, ss) {
          if (ss.hasData) {
            if (ss.data.length == 0) {
              return Center(
                child: Text("No orders here"),
              );
            } else {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Image.network(
                          "https://x-eats.com${ss.data[index]["image"]}",
                          width: 200,
                        ),
                        Text(ss.data[index]["product_name"]),
                        Text(ss.data[index]["restaurant_name"]),
                        Text(ss.data[index]["totalOrderItemPrice"].toString())
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                  itemCount: ss.data.length);
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: getOrderDetails(super.email as String),
      ),
    );
  }

  static Future getOrderDetails(String email) async {
    List orders = [];
    await Dio()
        .get("https://x-eats.com/get_user_cartItems/$email")
        .then((value) => orders = value.data["Names"])
        .catchError((onError) => print(onError));
    return orders;
  }

  static void changeOrderStatus(String email) async {
    await Dio()
        .put("https://x-eats.com/get_orders_by_email/$email",
            data: {"paid": true})
        .then((value) => print(value.data))
        .catchError((onError) => print(onError));
  }
}
