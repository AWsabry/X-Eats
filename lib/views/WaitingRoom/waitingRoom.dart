import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:xeats/controllers/Components/AppBar/waitingRoomAppBar.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_divider.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/PaymentSummary.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';

// ignore: must_be_immutable
class WaitingRoom extends StatefulWidget {
  WaitingRoom(
      {Key? key,
      this.endingOrderTimeSecond,
      this.count,
      this.TimeOfLastOrder,
      this.LengthOfPublicOrders,
      this.LocationNumber,
      this.canCancelled,
      this.subtotal,
      this.OrderId})
      : super(key: key);
  var endingOrderTimeSecond;
  var count;
  var LocationNumber;
  DateTime? TimeOfLastOrder;
  var LengthOfPublicOrders;
  int? OrderId;
  double? subtotal;
  bool? canCancelled;
  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    OrderCubit.timerController = CustomTimerController(
      vsync: this,
      begin: Duration(seconds: widget.endingOrderTimeSecond),
      end: const Duration(seconds: 0),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.seconds,
    );

    OrderCubit.get(context).confirmAllPublicOrders(
        context, widget.endingOrderTimeSecond,
        IdLocation: widget.LocationNumber);

    return BlocProvider(
      create: (context) => OrderCubit()
        ..startTime()
        ..clickableChange()
        ..getPublicOrder(context, LocationNumber: widget.LocationNumber)
        ..deliveryFees(context, locaionNumber: widget.LocationNumber),
      child: BlocBuilder<OrderCubit, OrderStates>(builder: (context, state) {
        Logger().f(widget.LocationNumber);
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              height / 11,
            ), // Adjust the height here
            child: waitingRoomAppBar(context,
                subtitle: 'Your', title: 'Waiting Room'),
          ),
          body: SafeArea(
            child: RefreshIndicator(
              color: Theme.of(context).primaryColor,
              onRefresh: () async {
                OrderCubit.get(context).getPublicOrder(context,
                    LocationNumber: widget.LocationNumber);
              },
              child: SingleChildScrollView(
                child: SizedBox(
                  height: height - 45.h,
                  width: width,
                  child: Column(
                    children: [
                      Container(
                        height: height / 20,
                        width: width,
                      ),
                      ConditionalBuilder(
                        fallback: (context) => const Center(child: Loading()),
                        condition: OrderCubit.deliveryfees != null,
                        builder: (context) {
                          if (OrderCubit.get(context).count == null) {
                            return const Center(child: Loading());
                          } else {
                            return Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Time Remaining:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        Container(
                                          child: CustomTimer(
                                            controller:
                                                OrderCubit.timerController!,
                                            builder: (state, time) {
                                              return Text(
                                                  "${time.minutes}:${time.seconds}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: height / 50),
                                  customDivider(),
                                  SizedBox(height: height / 50),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) {
                                          return customDivider();
                                        },
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                              child: Column(
                                            children: [
                                              SizedBox(
                                                height: height / 100,
                                              ),
                                              Row(children: [
                                                CircleAvatar(
                                                  radius: 40,
                                                  backgroundColor: Colors.black,
                                                  child: CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor: widget
                                                                  .count !=
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
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor))),
                                                ),
                                                SizedBox(
                                                  width: width / 20,
                                                ),
                                                Text(
                                                    widget.count != index + 1
                                                        ? "Item ${index + 1}"
                                                        : "Your order ${widget.count} ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge),
                                              ]),
                                            ],
                                          ));
                                        },
                                        itemCount:
                                            OrderCubit.get(context).count!),
                                  ),
                                  SizedBox(
                                    height: height / 50,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 25.w),
                                            child: Text("Total Delivery fees",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 30.0.w),
                                            child: Text(
                                                "EGP ${OrderCubit.deliveryfees}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height / 50,
                                  ),
                                  customDivider(),
                                  SizedBox(
                                    height: height / 50,
                                  ),
                                  const Center(
                                    child: Text(
                                      "Slide down to refresh",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 9,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  PaymentSummary(
                                    widget: widget,
                                    Orderid: widget.OrderId,
                                    SubTotal: widget.subtotal,
                                    CanCancelled: widget.canCancelled,
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
