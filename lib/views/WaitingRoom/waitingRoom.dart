import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
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
          body: SafeArea(
            child: RefreshIndicator(
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
                        height: 108.h,
                        width: width,
                        color: Colors.transparent,
                      ),
                      const SizedBox(
                        height: 10,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: CustomTimer(
                                          controller:
                                              OrderCubit.timerController!,
                                          builder: (state, time) {
                                            return Text(
                                                "${time.minutes}:${time.seconds}",
                                                style: const TextStyle(
                                                    fontSize: 24.0));
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
                                          return customDivider();
                                        },
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                              child: Column(
                                            children: [
                                              const SizedBox(
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
                                                  style: const TextStyle(
                                                    fontFamily: "IntegralCf",
                                                  ),
                                                ),
                                              ]),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              customDivider()
                                            ],
                                          ));
                                        },
                                        itemCount:
                                            OrderCubit.get(context).count!),
                                  ),
                                  const SizedBox(
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
                                              style: const TextStyle(
                                                  fontFamily: "IntegralCf"),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
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
