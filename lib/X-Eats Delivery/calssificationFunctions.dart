import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xeats/X-Eats%20Delivery/DeliveryOredrs.dart';

// List<DeliveryOrder> allOrders = [
//   DeliveryOrder(
//       id: orders[0]["id"].toString(),
//       orderTime: orders[0]["ordered_date"],
//       isPaid: orders[0]["paid"],
//       totalPrice: orders[0]["totalPrice"],
//       totalPriceAfterDelivery: orders[0]["total_price_after_delivery"],
//       uid: orders[0]["user"],
//       cartId: orders[0]["cart"],
//       from: LatLng(orders[0]["from"][0], orders[0]["from"][1]),
//       to: LatLng(orders[0]["to"][0], orders[0]["to"][1])),
//   DeliveryOrder(
//       id: orders[1]["id"].toString(),
//       orderTime: orders[1]["ordered_date"],
//       isPaid: orders[1]["paid"],
//       totalPrice: orders[1]["totalPrice"],
//       totalPriceAfterDelivery: orders[1]["total_price_after_delivery"],
//       uid: orders[1]["user"],
//       cartId: orders[1]["cart"],
//       from: LatLng(orders[1]["from"][0], orders[0]["from"][1]),
//       to: LatLng(orders[1]["to"][0], orders[0]["to"][1]))
// ];

List<DeliveryOrder> unpaidOrders = [];

Future<List<DeliveryOrder>> getOrdersForDelivery(int operation) async {
  unpaidOrders.clear();
  await Dio().get("https://x-eats.com/get_orders/").then((value) {
    for (var i in value.data["Names"]) {
      unpaidOrders.add(DeliveryOrder(
          id: i["id"].toString(),
          orderTime: i["ordered_date"],
          isPaid: i["paid"],
          fullName: i["first_name"] + " " + i["last_name"],
          totalPrice: i["totalPrice"],
          totalPriceAfterDelivery: i["total_price_after_delivery"],
          uid: i["user"],
          email: i["email"],
          cartId: i["cart"]));
    }

    unpaidOrders.sort(
        (a, b) => b.orderDatetime!.compareTo(a.orderDatetime as DateTime));
  }).catchError((e) => print(e));
  if (operation == 6) {
    unpaidOrders = classificationTheOrders(operation);
  }
  return unpaidOrders;
}

List<DeliveryOrder> classificationTheOrders(int operation) {
  // operation is the value of the type of classification of the all orders
  // getPaid parameter is to choose which list of orders to get whether the paid and finished orders or the unpaid and unfinished orders
  switch (operation) {
    case 1: // sort by date from recently to old orders
      unpaidOrders.sort(
          (a, b) => a.orderDatetime!.compareTo(b.orderDatetime as DateTime));
      break;
    case 2: // sort by date from old to new orders

      unpaidOrders.sort(
          (a, b) => a.orderDatetime!.compareTo(b.orderDatetime as DateTime));
      unpaidOrders = unpaidOrders.reversed.toList();

      break;
    case 3: // sort by price from low to high paid/unpaid order
      unpaidOrders.sort((a, b) => a.totalPriceAfterDelivery!
          .compareTo(b.totalPriceAfterDelivery as num));
      break;
    case 4: // sort by price from high to low paid/unpaid order

      unpaidOrders.sort((a, b) => a.totalPriceAfterDelivery!
          .compareTo(b.totalPriceAfterDelivery as num));
      unpaidOrders = unpaidOrders.reversed.toList();

      break;
    case 5: // to get the last 7 days paid/unpaid orders
      List<DeliveryOrder> last_7_days_orders = [];
      for (var order in unpaidOrders) {
        if (order.orderDatetime!
                .compareTo(DateTime.now().subtract(const Duration(days: 7))) ==
            1) {
          last_7_days_orders.add(order);
        }
      }
      return last_7_days_orders;
    case 6: // to get todays orders or the orders from one day to the current second
      List<DeliveryOrder> today_orders = [];
      for (var order in unpaidOrders) {
        if (order.orderDatetime!
                .compareTo(DateTime.now().subtract(const Duration(days: 1))) ==
            1) {
          today_orders.add(order);
        }
      }
      print(today_orders);
      return today_orders;
  }
  return unpaidOrders;
}
