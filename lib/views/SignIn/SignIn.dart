import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/controllers/Components/Global%20Components/DefaultButton.dart';
import 'package:xeats/controllers/Components/Global%20Components/defaultFormField.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/States.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestuarantsCubit.dart';
import 'package:xeats/views/ForgetPassword/forgetpassword.dart';
import 'package:xeats/views/LoginSuccess/loginSuccess.dart';
import 'package:xeats/views/SignUp/SignUp.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});
  var formkey = GlobalKey<FormState>();
// Created a bloc provider to have both auth cubit and xeats cubit because xeats cubit have the get email function and auth have login cubit
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()..GettingUserData()),
        BlocProvider(
            create: (context) => ProductsCubit()
              ..GetMostSoldProducts()
              ..getPoster()),
        BlocProvider(
          create: (context) => RestuarantsCubit()..GetResturants(),
        ),
        BlocProvider(create: (context) => OrderCubit()..getCartID(context))
      ],
      child: BlocConsumer<AuthCubit, AuthStates>(
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
              child: Form(
                key: formkey,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 26.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Login",
                              style: TextStyle(
                                fontFamily: 'UberMoveTextBold',
                                fontSize: 25.0.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 9, 134, 211),
                              )),
                          Center(
                            child: Image(
                              image:
                                  const AssetImage('assets/Images/First.png'),
                              width: width / 2,
                              height: width / 2,
                            ),
                          ),
                          // SocialAuth(),
                          DefaultFormField(
                              isPassword: false,
                              prefix: Icons.email_outlined,
                              controller: cubit.emailController,
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
                              controller: cubit.password,
                              label: 'Password',
                              suffix: cubit.isPassword_lpgin
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              type: TextInputType.visiblePassword,
                              isPassword: cubit.isPassword_lpgin,
                              suffixpressed: () {
                                cubit.changepasswordVisablityLogin();
                              },
                              validator: (value) => value!.isEmpty
                                  ? 'Please Enter your Password'
                                  : null),
                          SizedBox(
                            height: 15.h,
                          ),
                          DefaultButton(
                              function: () {
                                if (formkey.currentState!.validate()) {
                                  cubit
                                      .login(
                                    context,
                                    password: cubit.password.text,
                                    email: cubit.emailController.text,
                                  )
                                      .catchError((e) {
                                    var dioException = e as DioError;

                                    var status =
                                        dioException.response!.statusCode;
                                    print(status);
                                    if (e.runtimeType == DioError) {
                                      // print(dioException.response!.statusCode);
                                    }
                                    if (status == 302) {
                                      cubit.getEmail(context,
                                          email: cubit.emailController.text);
                                      NavigateAndRemov(context, LoginSuccess());
                                    } else if (status == 404) {
                                      const snackBar = SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            'Please Put The Right Credentials'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  });
                                }
                              },
                              text: 'Login'),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                              TextButton(
                                  onPressed: () {
                                    NavigateAndRemov(context, Signup());
                                  },
                                  child: Text(
                                    'Sign up',
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
      ),
    );
  }
}
