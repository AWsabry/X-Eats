import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

class LocalService {
  static const notificationChannelId = 'X-EATS';

// this will be used for notification id, So you can update your custom notification with this id.
  static const notificationId = 888;

  static Future<void> initializeService() async {
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

  static Future<void> onStart(ServiceInstance service) async {
    SharedPreferences User = await SharedPreferences.getInstance();
    var EmailInforamtion = User.getString('EmailInf');
    if (EmailInforamtion!.isNotEmpty) {
      DartPluginRegistrant.ensureInitialized();

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      // bring to foreground
      Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (service is AndroidServiceInstance) {
          if (await service.isForegroundService()) {
            try {
              var orderExistenceresponse = await Dio().get(
                  "${AppConstants.BaseUrl}/check_order_existence/${EmailInforamtion}");
              if (orderExistenceresponse.data["Names"] == "[]" ||
                  orderExistenceresponse.data["Names"][0]["status"] !=
                      "Pending") {
              } else {
                var LocationNumber =
                    orderExistenceresponse.data["Names"][0]["deliver_to"];

                var publicOrderResponse = await Dio().get(
                    "${AppConstants.BaseUrl}/get_public_orders_in_location/$LocationNumber");
                var EndingOrder = publicOrderResponse.data["end_on"];
                var endingOrderTime = DateTime.parse(EndingOrder);

                var endingOrderTimeSecond =
                    endingOrderTime.difference(DateTime.now()).inSeconds;

                bool CheckingDifference = DateTime.now()
                    .isBefore(endingOrderTime.add(const Duration(seconds: 3)));
                if (CheckingDifference == false) {
                  Dio().post(
                      "${AppConstants.BaseUrl}/get_time_of_first_public_order_in_location/$LocationNumber");

                  Timer.periodic(Duration(seconds: 5), (timer) {
                    service.stopSelf();
                  });
                  print("om");
                } else {}

                flutterLocalNotificationsPlugin.show(
                  notificationId,
                  ' ${CheckingDifference == true ? 'Your Order still in progress' : 'Your Order Now is Recived by Restaurant'}',
                  '${CheckingDifference == true ? 'Remaining $endingOrderTimeSecond seconds for your order' : 'Thank you for using X-Eats'}',
                  const NotificationDetails(
                    android: AndroidNotificationDetails(
                        notificationChannelId, 'X-EATS',
                        icon: 'ic_bg_service_small',
                        ongoing: true,
                        actions: []),
                  ),
                );
              }
            } catch (error) {
              service.stopSelf();
            }
          }
        }
      });
    } else {
      service.stopSelf();
    }
    // Only available for flutter 3.0.0 and later
  }
}
