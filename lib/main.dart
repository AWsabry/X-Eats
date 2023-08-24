import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/controllers/Components/ObServer/BlocObserver.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestuarantsCubit.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/views/Splash%20Screen/Splach%20Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  Bloc.observer = MyBlocObserver();

  DioHelper.init();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();

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
          defaultColor: const Color.fromARGB(255, 9, 134, 211),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          ledColor: Colors.white,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic group', channelGroupName: 'basic_channel')
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

// this will be used as notification channel id
const notificationChannelId = 'X-EATS';

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'X-EATS', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId:
          notificationChannelId, // this must match with notification channel you created above.
      initialNotificationTitle: 'X-eats',
      initialNotificationContent: 'Welcome to X-Eats',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(),
  );
}

Future<void> onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        SharedPreferences User = await SharedPreferences.getInstance();
        var EmailInforamtion = User.getString('EmailInf');

        try {
          var response = await Dio().get(
              "${AppConstants.BaseUrl}/check_order_existence/${EmailInforamtion}");
          String Data = response.data["Names"][0]["status"];

          if (response.data["Names"] == "[]" ||
              response.data["Names"][0]["status"] != "Pending") {
            // Handle order non-existence or status not pending
            print("a7a");
          } else {
            var LocationNumber = response.data["Names"][0]["deliver_to"];
            var totalPrice = response.data["Names"][0]["totalPrice"];
            print("aaaaaaa$totalPrice");

            var response1 = await Dio().get(
                "${AppConstants.BaseUrl}/get_time_of_first_public_order_in_location/$LocationNumber");
            var OrderIdOfExistence = response.data["Names"][0]["id"];
            var FirstOrderId = response1.data["Names"][0]["id"];
            var count = (OrderIdOfExistence - FirstOrderId) + 1;
            var EndingOrder = response1.data["end_on"];
            var endingOrderTime = DateTime.parse(EndingOrder);
            print(endingOrderTime.difference(DateTime.now()).inMinutes);
            var OrderedDateExistance =
                DateTime.parse(response.data["Names"][0]["ordered_date"]);

            var endingOrderTimeSecond =
                endingOrderTime.difference(DateTime.now()).inSeconds;

            var TimeOf5minutes =
                DateTime.now().difference(OrderedDateExistance).inMinutes;

            var CanCancelled = TimeOf5minutes >= 5 ? false : true;
            bool CheckingDifference = DateTime.now()
                .isBefore(endingOrderTime.add(const Duration(minutes: 0)));
            if (CheckingDifference == false) {
              Dio().post(
                  "${AppConstants.BaseUrl}/get_time_of_first_public_order_in_location/$LocationNumber");
              print("om");
            } else {}

            flutterLocalNotificationsPlugin.show(
              notificationId,
              ' ${CheckingDifference == true ? 'Your Order still in progress' : 'Your Order Now is Recived by Restaurant'}',
              '${CheckingDifference == true ? 'Remaining $endingOrderTimeSecond seconds for your order' : 'Thank you for using X-Eats'}',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                    notificationChannelId, 'X-EATS',
                    icon: 'ic_bg_service_small', ongoing: true, actions: []),
              ),
            );
          }
        } catch (error) {
          print("Error: $error");
        }
      }
    }
  });
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
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
          BlocProvider(create: (context) => RestuarantsCubit()),
          BlocProvider(create: (context) => AuthCubit()..GettingUserData()),
          BlocProvider(create: (context) => NavBarCubitcubit()),
          BlocProvider(create: (context) => ProductsCubit()),
          BlocProvider(
              create: (context) => OrderCubit()
                ..getLocation(context)
                ..checkOrderExistence(context))
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
