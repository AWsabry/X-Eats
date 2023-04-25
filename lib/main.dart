import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestuarantsCubit.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/views/Resturants/Resturants.dart';
import 'package:xeats/views/Splash%20Screen/Splach%20Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:connectivity/connectivity.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  DioHelper.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notification',
          channelDescription: 'Notification for tests',
          defaultColor: Color.fromARGB(255, 9, 134, 211),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          ledColor: Colors.white,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupName: 'basic group', channelGroupKey: 'basic_channel')
      ],
      debug: true);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // inittiken();
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => RestuarantsCubit()..GetResturants()),
          BlocProvider(create: (context) => AuthCubit()..GettingUserData()),
          BlocProvider(create: (context) => NavBarCubitcubit()),
          BlocProvider(
            create: (context) => ProductsCubit()
              ..GetMostSoldProducts()
              ..getPoster()
              ..NewProducts(),
          ),
          BlocProvider(
            create: (context) => OrderCubit()..getCartID(context),
          )
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
          child: SplashScreen(),
        ));
  }
}
