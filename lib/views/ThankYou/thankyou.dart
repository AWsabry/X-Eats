import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/States.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/views/Layout/Layout.dart';

import '../../controllers/Components/Global Components/loading.dart';

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
          body: Container(
            height: height,
            width: width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.3,
                image: AssetImage("assets/Images/055.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: height / 1.9),
                Image(
                  image: const AssetImage(
                    "assets/Images/success.png",
                  ),
                  height: height / 5,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: Loading(),
                    );
                  },
                ),
                Center(
                  child: Text(
                    "Order is send Sucessfully",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: height / 200),
                const Center(),
                const Spacer(),
                SizedBox(
                  width: width / 1.3,
                  child: ElevatedButton(
                      onPressed: () {
                        NavigateAndRemov(context, Layout());
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 9, 134, 211)),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Back to Home Page",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
