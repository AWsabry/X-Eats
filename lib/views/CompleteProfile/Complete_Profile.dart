import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/States.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/views/Verification/Verification.dart';
import '../../controllers/Components/Auth Components/DropDownListTitle.dart';
import '../../controllers/Components/Global Components/defaultFormField.dart';

class Complete_Profile extends StatelessWidget {
  Complete_Profile({super.key});
  static String verify = "";
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
          backgroundColor: Color(0xff0986d3),
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
                        Text("Complete Profile",
                            style: TextStyle(
                              fontFamily: 'UberMoveTextBold',
                              fontSize: 25.0.sp,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 9, 134, 211),
                            )),
                        Center(
                          child: Image(
                            image: AssetImage('assets/Images/First.png'),
                            width: width / 2,
                            height: width / 2,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: DefaultFormField(
                              isPassword: false,
                              controller: cubit.first_nameController,
                              label: 'First Name',
                              type: TextInputType.name,
                              validator: (value) => value!.isEmpty
                                  ? 'Put your First Name'
                                  : null),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          width: double.infinity,
                          child: DefaultFormField(
                              isPassword: false,
                              controller: cubit.last_nameController,
                              label: 'Last Name',
                              type: TextInputType.name,
                              validator: (value) =>
                                  value!.isEmpty ? 'Put your Last Name' : null),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          child: DefaultFormField(
                              isPassword: false,
                              prefix: Icons.phone_android,
                              controller: cubit.PhoneNumberController,
                              label: 'Phone No.',
                              type: TextInputType.phone,
                              validator: (value) => value!.isEmpty
                                  ? 'Put your Phone number'
                                  : null),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          child: SelectedTitle(
                            changed: (value) {
                              value = cubit.ValueTitle;
                              title = cubit.title;
                              cubit.changetitle();
                            },
                            form: (value) =>
                                value == null ? 'Select your title' : null,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            FloatingActionButton(
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    print('+2' +
                                        '${cubit.PhoneNumberController.text}');
                                    await FirebaseAuth.instance
                                        .verifyPhoneNumber(
                                      phoneNumber: '+2' +
                                          '${cubit.PhoneNumberController.text}',
                                      verificationCompleted:
                                          (PhoneAuthCredential credential) {},
                                      verificationFailed:
                                          (FirebaseAuthException e) {},
                                      codeSent: (String verificationId,
                                          int? resendToken) {
                                        Complete_Profile.verify =
                                            verificationId;
                                      },
                                      codeAutoRetrievalTimeout:
                                          (String verificationId) {},
                                    )
                                        .then((value) {
                                      Navigation(context, Verify());
                                    });
                                  }
                                },
                                backgroundColor: Colors.black,
                                child: const Icon(Icons.arrow_forward_ios)),
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
