import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/Global%20Components/Buttons/DefaultButton.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/States.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/views/HomePage/HomePage.dart';

class ThankYou extends StatelessWidget {
  const ThankYou({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: ((context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
            appBar: appBar(context,
                subtitle: "Thank You", title: "${cubit.firstNameShared}"),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width / 6,
                  height: height / 6,
                  child: Image.asset("assets/Images/tick.png"),
                ),
                Text(
                  "Thank You for Ordering",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(
                  height: height / 10,
                ),
                Center(
                  child: DefaultButton(
                      function: () {
                        Navigation(context, const HomePage());
                      },
                      text: 'Back to Home'),
                )
              ],
            ));
      }),
    );
  }
}
