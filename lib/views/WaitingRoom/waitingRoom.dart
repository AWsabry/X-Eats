// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';

import '../../controllers/Components/Global Components/DefaultButton.dart';

class WaitingRoom extends StatelessWidget {
  WaitingRoom({Key? key, this.endingOrderTimeMinute}) : super(key: key);
  var endingOrderTimeMinute;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => OrderCubit()..getLocation(context),
      child: BlocBuilder<OrderCubit, OrderStates>(builder: (context, state) {
        return Scaffold(
          appBar: appBar(context, subtitle: "Waiting Room"),
          body: Container(
              height: height,
              width: width,
              child: Column(
                children: [
                  DefaultButton(
                      function: () {
                        // print(
                        // "aaaaaaaaaa${DateTime.now().difference(OrderCubit.get(context).endingOrderTime!).inMinutes}");

                        Dio().post(
                            "x-eats.com/get_time_of_first_public_order_in_location/1",
                            data: {});
                      },
                      text: "Orders Missing"),
                  Center(
                    child: Text("$endingOrderTimeMinute"),
                  ),
                ],
              )),
        );
      }),
    );
  }
}
