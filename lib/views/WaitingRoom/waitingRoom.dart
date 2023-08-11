// ignore_for_file: non_constant_identifier_names

import 'package:custom_timer/custom_timer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';

import '../../controllers/Components/Global Components/DefaultButton.dart';

class WaitingRoom extends StatefulWidget {
  WaitingRoom({Key? key, this.endingOrderTimeSecond}) : super(key: key);
  var endingOrderTimeSecond;

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom>
    with SingleTickerProviderStateMixin {
  late final CustomTimerController _controller = CustomTimerController(
    vsync: this,
    begin: Duration(seconds: widget.endingOrderTimeSecond),
    end: Duration(seconds: 0),
    initialState: CustomTimerState.reset,
    interval: CustomTimerInterval.seconds,
  );

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    int minutes = widget.endingOrderTimeSecond * 60;
    _controller.start();

    return BlocProvider(
      create: (context) => OrderCubit()..getLocation(context),
      child: BlocBuilder<OrderCubit, OrderStates>(builder: (context, state) {
        return Scaffold(
          appBar: appBar(context, subtitle: "Waiting Room"),
          body: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: CustomTimer(
                controller: _controller,
                builder: (state, time) {
                  return Text("${time.minutes}:${time.seconds}",
                      style: TextStyle(fontSize: 24.0));
                },
              )),
            ],
          )),
        );
      }),
    );
  }
}
