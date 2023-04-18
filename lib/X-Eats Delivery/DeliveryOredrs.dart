import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xeats/X-Eats%20Delivery/FullOrderPage.dart';

class DeliveryOrder extends StatefulWidget {
  final String? id, orderTime, fullName, email, phoneNumber;
  final bool? isPaid;
  final double? totalPrice, totalPriceAfterDelivery;
  final int? uid, cartId;
  DateTime? orderDatetime;
  final LatLng? from, to;

  DeliveryOrder(
      {this.id,
      this.orderTime,
      this.isPaid,
      this.totalPrice,
      this.totalPriceAfterDelivery,
      this.uid,
      this.cartId,
      this.from,
      this.to,
      this.fullName,
      this.email,
      this.phoneNumber}) {
    orderDatetime = DateTime.parse(orderTime as String);
  }

  @override
  State<DeliveryOrder> createState() => _DeliveryOrderState();
}

class _DeliveryOrderState extends State<DeliveryOrder> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullOrderPage(
                        orderTime: widget.orderTime,
                        fullName: widget.fullName,
                        id: widget.id,
                        phoneNumber: widget.phoneNumber,
                        email: widget.email,
                      ).build(context)));
        },
        child: SizedBox(
          height: 150,
          width: 400,
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "${widget.id}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text("Total Price:\n${widget.totalPriceAfterDelivery} LE"),
                const Icon(
                  Icons.delivery_dining_outlined,
                  color: Colors.black,
                  size: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
