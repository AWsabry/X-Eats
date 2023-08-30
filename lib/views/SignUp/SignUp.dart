import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/States.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Components/Global%20Components/Buttons/DefaultButton.dart';
import 'package:xeats/controllers/Components/Global%20Components/defaultFormField.dart';
import 'package:xeats/views/SignIn/SignIn.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: ((context, state) {}),
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
          backgroundColor: const Color(0xff0986d3),
          body: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(150.r))),
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
                        Text("Signup",
                            style: TextStyle(
                              fontFamily: 'UberMoveTextBold',
                              fontSize: 25.0.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 9, 134, 211),
                            )),
                        Center(
                          child: Image(
                            image: const AssetImage('assets/Images/First.png'),
                            width: width / 2,
                            height: width / 2,
                          ),
                        ),
                        // SocialAuth(),
                        DefaultFormField(
                            isPassword: false,
                            prefix: Icons.email_outlined,
                            controller: AuthCubit.emailController,
                            label: 'Email',
                            type: TextInputType.emailAddress,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter your Email'
                                : null),
                        SizedBox(
                          height: 15.h,
                        ),
                        DefaultFormField(
                            prefix: Icons.lock_open,
                            controller: AuthCubit.password,
                            label: 'Password',
                            suffix: cubit.isPassword_signup
                                ? Icons.visibility
                                : Icons.visibility_off,
                            type: TextInputType.visiblePassword,
                            isPassword: cubit.isPassword_signup,
                            suffixpressed: () {
                              cubit.changepasswordVisablitySignup();
                            },
                            validator: (value) => value!.isEmpty
                                ? 'Please Enter your Password'
                                : null),
                        SizedBox(
                          height: 15.h,
                        ),
                        DefaultFormField(
                            prefix: Icons.lock_open,
                            controller: cubit.signup_confirm_password,
                            label: 'Confirm Password',
                            suffix: cubit.isPassword_confirm_signup
                                ? Icons.visibility
                                : Icons.visibility_off,
                            type: TextInputType.visiblePassword,
                            isPassword: cubit.isPassword_confirm_signup,
                            suffixpressed: () {
                              cubit.changepasswordVisablityConfirmSignup();
                            },
                            validator: (value) => value!.isEmpty ||
                                    value != AuthCubit.password.text
                                ? 'Password Doesn\'t match'
                                : null),
                        SizedBox(
                          height: 15.h,
                        ),
                        DefaultButton(
                            function: () {
                              // cubit.CheckExistEmail(context,
                              //         Email: AuthCubit.emailController.text)
                              //     .then((value) {
                              //   if (formkey.currentState!.validate()) {
                              //     if (cubit.EmailExist.length == 0) {
                              //       Navigation(context, Complete_Profile());
                              //     } else {
                              //       const snackBar = SnackBar(
                              //         backgroundColor: Colors.red,
                              //         content:
                              //             Text('This Email Already Signed up'),
                              //       );
                              //       ScaffoldMessenger.of(context)
                              //           .showSnackBar(snackBar);
                              //     }
                              //   }
                              // });
                            },
                            text: 'Sign Up'),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(
                              flex: 1,
                            ),
                            Text(
                              'Already have an account?',
                              style: TextStyle(fontSize: 15.sp),
                            ),
                            TextButton(
                                onPressed: () {
                                  NavigateAndRemov(context, SignIn());
                                },
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(fontSize: 15.sp),
                                ))
                          ],
                        )
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
