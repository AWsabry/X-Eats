import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/States.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/views/Layout/Layout.dart';
import 'package:xeats/views/SignIn/SignIn.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? Check;
  Future<bool> checkVersion() async {
    final newVersion = NewVersionPlus(
      androidId: "com.xeats.egy",
    );
    final status = await newVersion.getVersionStatus();

    Check = status!.canUpdate;
    if (status.canUpdate) {
      return true;
    } else {
      print(status.localVersion);
      print(status.storeVersion);
      return false;
    }
  }

  void initState() {
    print("Check Version Method is ${checkVersion()}");
    super.initState();
    inittiken();
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage remoteMessage) {
        RemoteNotification? notification = remoteMessage.notification;

        AndroidNotification? android = remoteMessage.notification!.android;

        if (notification != null && android != null) {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 1,
                  channelKey: 'basic_channel',
                  title: notification.title,
                  body: notification.body,
                  showWhen: true,
                  displayOnBackground: true,
                  displayOnForeground: true));
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage remoteMessage) {
        RemoteNotification? notification = remoteMessage.notification;

        AndroidNotification? android = remoteMessage.notification!.android;

        if (notification != null && android != null) {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
            id: 1,
            channelKey: 'basic_channel',
            title: notification.title,
            body: notification.body,
            showWhen: true,
            displayOnBackground: true,
            displayOnForeground: true,
            autoDismissible: false,
          ));
        }
      },
    );
  }

  void inittiken() async {
    await FirebaseMessaging.instance.getToken().then(
      (value) {
        print("Token is Passed to the POST FUNCTION: $value");
        OrderCubit.get(context).postToken(token: "$value");
      },
    );
  }

  Future init(context) async {
    AuthCubit.get(context).GettingUserData();
    OrderCubit.get(context).getCartID(context);
    print(AuthCubit.get(context).GettingUserData());

    Future.delayed(const Duration(seconds: 6)).then(
      (value) {
        // if (Check == true) {
        //   NavigateAndRemov(context, UpdateDialog());
        // } else {
        if (AuthCubit.get(context).EmailInforamtion != null) {
          NavigateAndRemov(context, Layout());
        } else {
          NavigateAndRemov(context, SignIn());
        }
        // }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OrderCubit()),
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Image(
                      image: const AssetImage('assets/Images/logo.png'),
                      width: width,
                      height: height / 2,
                    ),
                  ),
                  SizedBox(
                    height: height / 6,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      SpinKitThreeInOut(
                        color: Color.fromARGB(255, 9, 134, 211),
                        size: 35,
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
