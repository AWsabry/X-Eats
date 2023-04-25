// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:xeats/controllers/Components/Global%20Components/DefaultButton.dart';
// import 'package:xeats/controllers/Cubits/AuthCubit/States.dart';
// import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';

// import '../../controllers/Components/Global Components/defaultFormField.dart';

// class ForgetPassword extends StatelessWidget {
//   ForgetPassword({super.key});
//   var formkey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: BlocConsumer<AuthCubit, AuthStates>(
//         builder: (context, state) {
//           return Scaffold(
//             backgroundColor: const Color(0xff0986d3),
//             body: Container(
//               width: width,
//               height: height,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius:
//                       BorderRadius.only(topRight: Radius.circular(150.r))),
//               child: Form(
//                 key: formkey,
//                 child: SafeArea(
//                   child: Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: 15.h, horizontal: 26.w),
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Login",
//                                 style: TextStyle(
//                                   fontFamily: 'UberMoveTextBold',
//                                   fontSize: 25.0.sp,
//                                   fontWeight: FontWeight.bold,
//                                   color: const Color.fromARGB(255, 9, 134, 211),
//                                 )),
//                             Center(
//                               child: Image(
//                                 image:
//                                     const AssetImage('assets/Images/First.png'),
//                                 width: width / 2,
//                                 height: width / 2,
//                               ),
//                             ),
//                             // SocialAuth(),
//                             DefaultFormField(
//                                 isPassword: false,
//                                 prefix: Icons.email_outlined,
//                                 controller:
//                                     AuthCubit.get(context).emailController,
//                                 label: 'Email',
//                                 type: TextInputType.emailAddress,
//                                 validator: (value) => value!.isEmpty
//                                     ? 'Please enter your Email'
//                                     : null),
//                             SizedBox(
//                               height: 15.h,
//                             ),
//                             DefaultButton(
//                                 function: () async {
//                                   if (formkey.currentState!.validate()) {
//                                     try {
//                                       await FirebaseAuth.instance
//                                           .sendPasswordResetEmail(
//                                               email: AuthCubit.get(context)
//                                                   .emailController
//                                                   .text
//                                                   .trim())
//                                           .then((value) => {
//                                                 print("email sent"),
//                                               });
//                                     } on FirebaseAuthException catch (e) {
//                                       print(e);
//                                     }
//                                   }
//                                 },
//                                 text: 'Reset your password')
//                           ]),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//         listener: (context, state) {},
//       ),
//     );
//   }
// }
