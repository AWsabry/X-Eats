// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xeats/controllers/Components/LocalService/LocalService.dart';
import 'package:xeats/controllers/Components/ObServer/BlocObserver.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestuarantsCubit.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/views/Splash%20Screen/Splach%20Screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();

//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  Bloc.observer = MyBlocObserver();

  DioHelper.init();
  WidgetsFlutterBinding.ensureInitialized();
  await LocalService.initializeService();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // AwesomeNotifications().initialize(
  //     null,
  //     [
  //       NotificationChannel(
  //         channelKey: 'basic_channel',
  //         channelName: 'Basic Notification',
  //         channelDescription: 'Notification for tests',
  //         defaultColor: const Color.fromARGB(255, 9, 134, 211),
  //         importance: NotificationImportance.High,
  //         channelShowBadge: true,
  //         ledColor: Colors.white,
  //       ),
  //     ],
  //     channelGroups: [
  //       NotificationChannelGroup(
  //           channelGroupKey: 'basic group', channelGroupName: 'basic_channel')
  //     ],
  //     debug: true);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //     alert: true, badge: true, sound: true);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((_) {
  runApp(const MyApp());
  // });
}

// this will be used as notification channel id

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => RestuarantsCubit()),
          BlocProvider(create: (context) => AuthCubit()..GettingUserData()),
          BlocProvider(create: (context) => NavBarCubitcubit()),
          BlocProvider(create: (context) => ProductsCubit()),
          BlocProvider(create: (context) => OrderCubit())
        ],
        child: ScreenUtilInit(
          designSize: const Size(415, 900),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'X-Eats',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                textTheme: Typography.englishLike2018
                    .apply(fontSizeFactor: 1.sp, bodyColor: Colors.black),
              ),
              home: child,
            );
          },
          child: const SplashScreen(),
        ));
  }
}
