import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/States.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';

import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/views/CompleteProfile/Complete_Profile.dart';
import 'package:xeats/views/SignIn/SignIn.dart';

class Verify extends StatelessWidget {
  Verify({super.key});

  var formkey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var code = "";
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 90.w,
      height: 80.h,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 4),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
    );

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: ((context, state) {}),
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff0986d3),
            elevation: 0,
          ),
          backgroundColor: Color(0xff0986d3),
          body: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(70.r),
                    topLeft: Radius.circular(70.r))),
            child: SafeArea(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formkey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 26.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image(
                            image: AssetImage('assets/Images/password.png'),
                            width: width / 2,
                            height: width / 2,
                          ),
                        ),
                        Center(
                          child: Text("Verification Code",
                              style: TextStyle(
                                fontFamily: 'UberMoveTextBold',
                                fontSize: 30.0.sp,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 9, 134, 211),
                              )),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Center(
                          child: Text(
                            'Please type the verification code sent to your Phone',
                            style: TextStyle(fontSize: 15.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Pinput(
                                  defaultPinTheme: defaultPinTheme,
                                  androidSmsAutofillMethod:
                                      AndroidSmsAutofillMethod.smsRetrieverApi,
                                  length: 6,
                                  onChanged: (value) {
                                    code = value;
                                  },
                                  controller: AuthCubit.get(context).XeatOtp1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Resend Code',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      textStyle: TextStyle(color: Colors.blue)),
                                )),
                            Spacer(),
                            FloatingActionButton(
                              child: Icon(Icons.arrow_forward_ios),
                              backgroundColor: Colors.black,
                              onPressed: () async {
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                  verificationId: Complete_Profile.verify,
                                  smsCode: code,
                                );
                                try {
                                  await auth.signInWithCredential(credential);
                                  cubit.CreateUser(
                                    context,
                                    password: cubit.password.text,
                                    email: cubit.emailController.text,
                                    first_name: cubit.first_nameController.text,
                                    last_name: cubit.last_nameController.text,
                                    title: cubit.title,
                                    PhoneNumber:
                                        cubit.PhoneNumberController.text,
                                  );
                                  NavigateAndRemov(context, SignIn());
                                } on FirebaseAuthException catch (e) {
                                  const snackBar = SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text('The otp is wrong'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
