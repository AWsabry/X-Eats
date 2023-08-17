// ignore_for_file: non_constant_identifier_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/controllers/Components/PaymentSummary/PaymentSummary.dart';
import 'package:xeats/controllers/Components/Product%20Class/Products_Class.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';
import 'package:xeats/views/ThankYou/thankyou.dart';

import '../../controllers/Components/Global Components/DefaultButton.dart';

class WaitingRoom extends StatefulWidget {
  WaitingRoom(
      {Key? key,
      this.endingOrderTimeSecond,
      this.count,
      this.TimeOfLastOrder,
      this.LengthOfPublicOrders})
      : super(key: key);
  var endingOrderTimeSecond;
  var count;
  DateTime? TimeOfLastOrder;
  var LengthOfPublicOrders;
  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

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
    Future.delayed(Duration(seconds: widget.endingOrderTimeSecond))
        .then((value) {
      OrderCubit.get(context).ConfirmAllPublicOrders(context);
      NavigateAndRemov(context, ThankYou());
    });

    return BlocProvider(
      create: (context) => OrderCubit()
        ..deliveryFees()
        ..clickableChange()
        ..getPublicOrder(context),
      child: BlocBuilder<OrderCubit, OrderStates>(builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await OrderCubit.get(context).getPublicOrder(context);
              },
              child: SingleChildScrollView(
                child: Container(
                  height: height - 45.h,
                  width: width,
                  child: Column(
                    children: [
                      Container(
                        height: 108.h,
                        width: width,
                        color: Colors.transparent,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ConditionalBuilder(
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                        condition: OrderCubit.deliveryfees != null,
                        builder: (context) {
                          if (OrderCubit.get(context).count == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: CustomTimer(
                                          controller: _controller,
                                          builder: (state, time) {
                                            return Text(
                                                "${time.minutes}:${time.seconds}",
                                                style:
                                                    TextStyle(fontSize: 24.0));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 50.sp),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) {
                                          return Dividerr();
                                        },
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                              child: Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(children: [
                                                CircleAvatar(
                                                  radius: 40,
                                                  backgroundColor: Colors.black,
                                                  child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor:
                                                          widget.count !=
                                                                  index + 1
                                                              ? Colors.white
                                                              : Colors.black,
                                                      child: Text(
                                                          "${index + 1}",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "IntegralCf",
                                                            color: widget
                                                                        .count !=
                                                                    index + 1
                                                                ? Colors.black
                                                                : const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    9,
                                                                    134,
                                                                    211),
                                                          ))),
                                                ),
                                                SizedBox(
                                                  width: width / 20,
                                                ),
                                                Text(
                                                  widget.count != index + 1
                                                      ? "Item ${index + 1}"
                                                      : "Your order ${widget.count} ",
                                                  style: TextStyle(
                                                    fontFamily: "IntegralCf",
                                                  ),
                                                ),
                                              ]),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Dividerr()
                                            ],
                                          ));
                                        },
                                        itemCount:
                                            OrderCubit.get(context).count!),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 25.w),
                                            child: const Text(
                                              "Total Delivery fees",
                                              style: TextStyle(
                                                fontFamily: "IntegralCf",
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 30.0.w),
                                            child: Text(
                                              "EGP ${OrderCubit.deliveryfees}",
                                              style: TextStyle(
                                                  fontFamily: "IntegralCf"),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  PaymentSummary(
                                    widget: widget,
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
