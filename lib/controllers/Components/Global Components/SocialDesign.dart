import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialAuth extends StatefulWidget {
  const SocialAuth({Key? key}) : super(key: key);

  @override
  State<SocialAuth> createState() => _SocialAuthState();
}

class _SocialAuthState extends State<SocialAuth> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              height: 53.w,
              width: 53.w,
              child: IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/Images/Facebook-mdpi.png",
                  ))),
          SizedBox(
              width: 53.w,
              height: 53.w,
              child: IconButton(
                  onPressed: () {},
                  icon: Image.asset("assets/Images/Google.png")))
        ],
      ),
    );
  }
}
