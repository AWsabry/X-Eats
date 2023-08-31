import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestuarantsCubit.dart';
import 'package:xeats/theme.dart';
import 'package:xeats/views/Cart/Cart.dart';

AppBar waitingRoomAppBar(BuildContext context,
    {String? subtitle, String? title, bool? SameScreen}) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return AppBar(
    automaticallyImplyLeading: false,
    // foregroundColor: Colors.white,
    backgroundColor: Theme.of(context).backgroundColor,
    actions: [
      Container(
        color: Colors.transparent,
        width: width,
        height: height / 6,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      subtitle!.length < 3
                          ? FutureBuilder(
                              builder: (ctx, AsyncSnapshot snapshot) {
                                print(snapshot.connectionState);
                                if (snapshot.hasData) {
                                  return Text(snapshot.data ?? 'to',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall);
                                } else {
                                  return SpinKitThreeInOut(
                                    color: ThemeApp.primaryColor,
                                    size: 10,
                                  );
                                }
                              },
                              future: RestuarantsCubit.get(context)
                                  .getRestaurantName(subtitle.toString()),
                            )
                          : Text(subtitle,
                              style: Theme.of(context).textTheme.headlineSmall),
                      Text(title ?? ' ',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ]),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
