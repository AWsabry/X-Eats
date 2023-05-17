import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';

import '../../controllers/Components/Global Components/DefaultButton.dart';

class WaitingRoom extends StatelessWidget {
  const WaitingRoom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<OrderCubit, OrderStates>(builder: (context, state) {
      return Scaffold(
        appBar: appBar(context, subtitle: "Waiting Room"),
        body: Container(
            height: height,
            width: width,
            child: Column(
              children: [
                DefaultButton(
                    function: () {
                      OrderCubit.get(context).feesDistribution(
                        context,
                      );
                    },
                    text: "Order Now"),
                Center(
                  child: Text('Waiting Orders'),
                ),
              ],
            )),
      );
    });
  }
}
