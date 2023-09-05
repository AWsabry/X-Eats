// ignore_for_file: use_build_context_synchronously, unused_local_variable, body_might_complete_normally_catch_error

import 'dart:async';
import 'package:custom_timer/custom_timer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeats/controllers/Components/Global%20Components/custom_navigate.dart';
import 'package:xeats/controllers/Components/Product%20Class/Products_Class.dart';
import 'package:xeats/controllers/Components/Requests%20Loading%20Components/RequstsLoading.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/core/logger.dart';
import 'package:xeats/theme.dart';
import 'package:xeats/views/ThankYou/thankyou.dart';
import 'package:xeats/views/WaitingRoom/waitingRoom.dart';
import '../../../views/Cart/cart.dart';

class OrderCubit extends Cubit<OrderStates> {
  OrderCubit() : super(SuperOrderStates());
  static OrderCubit get(context) => BlocProvider.of(context);

  int? cartID;

  Future<void> getCartID(context) async {
    SharedPreferences userCartID = await SharedPreferences.getInstance();
    int? d;
    if (userCartID.containsKey("cartIDSaved") &&
        (d = userCartID.getInt("cartIDSaved")) != null) {
      print("cart id is 1 : $cartID" "$d");
      cartID = d;
    } else {
      print("cart id is 2 : ${AuthCubit.get(context).userEmailShared}");
      await Dio()
          .get(
              "${AppConstants.BaseUrl}/get_carts_by_id/${AuthCubit.get(context).userEmailShared}")
          .then((value) {
        userCartID.setInt("cartIDSaved", value.data["Names"][0]['id']);
        cartID = value.data["Names"][0]['id'];
        print("cart id is 3 : $cartID");
      }).catchError((error) {
        print("User Didn't Logged in yet to have an id");
      });
    }
    emit(SuccessGetCartID());
  }

  // function to add item to the cart
  Future<void> addToCart(BuildContext context,
      {int? productId,
      int? quantity,
      String? cartItemId,
      double? price,
      double? totalPrice,
      int? restaurantId,
      String? timeShift,
      required ProductClass productObject}) async {
    try {
      isRequestFinished = false;

      emit(ButtonPressedLoading());

      final userEmail = AuthCubit.get(context).userEmailShared;
      final userId = AuthCubit.get(context).userIdShared;

      final cartItemsUrl =
          "${AppConstants.BaseUrl}/get_user_cartItems/$userEmail";

      final cartItemsData = {
        "user": userId,
        "cart": cartID,
        "product": productId,
        "price": price,
        "quantity": quantity,
        "totalOrderItemPrice": totalPrice,
        "Restaurant": restaurantId,
      };

      final response = await _postData(cartItemsUrl, cartItemsData);

      if (response.statusCode == 202) {
        final updateCartData = {
          "id": cartItemId,
          "user": userId,
          "product": productId,
          "quantity": quantity,
          "totalOrderItemPrice": totalPrice,
          "price": price,
          "ordered": false,
        };

        await _putData(cartItemsUrl, updateCartData).catchError((e) {
          if (e.response?.statusCode == 403) {
            print("Data is Null or No Items in Cart");
          }
        });

        print("Updated in Cart");
      } else {
        print("Added To Cart");
      }

      _updateProductInCart(productObject);
      updateCartPrice(context);
      Navigation(context, const Cart());
    } catch (e) {
      print(e.toString());
      _showErrorSnackBar(
          context, "You have order from different restaurant in cart");
    } finally {
      isRequestFinished = true;
      emit(ButtonPressedLoading());
    }
  }

  Future<Response> _postData(String url, Map<String, dynamic> data) async {
    return await Dio().post(url, data: data);
  }

  Future<Response> _putData(String url, Map<String, dynamic> data) async {
    return await Dio().put(url, data: data);
  }

  void _updateProductInCart(ProductClass productObject) {
    bool isAlreadyAdded = false;
    for (var productLoop in ProductClass.CartItems) {
      try {
        final product = productLoop as ProductClass;
        if (product.id == productObject.id) {
          print("${product.quantity}  ${productObject.quantity}");
          product.quantity = productObject.quantity;
          isAlreadyAdded = true;
          break;
        }
      } catch (e) {
        continue;
      }
    }
    if (!isAlreadyAdded) {
      ProductClass.CartItems.add(productObject);
    }
  }

  void _showErrorSnackBar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 2500),
        backgroundColor: Colors.red,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline_outlined,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 10.w),
              child: Text(
                errorMessage,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void updateCartPrice(context) async {
    await Dio()
        .get("${AppConstants.BaseUrl}/get_Delivery_Fees")
        .then((value) async {
      await Dio().put(
          "${AppConstants.BaseUrl}/get_carts_by_id/${AuthCubit.get(context).userEmailShared}}",
          data: {
            "total_price": ProductClass.getSubtotal(),
            "total_after_delivery": (value.data["Names"][0]["delivery_fees"] +
                    ProductClass.getSubtotal())
                .toDouble()
          }).then((value) {
        print(value);
      }).catchError((e) {
        var dioException = e as DioError;
        var status = dioException.response!.statusCode;
        print("CARTITEM ERROR" " " '$status');
      });
    });
  }

  List<dynamic> cartItems = [];
  // The Function Will Get The email of user and take it as EndPoint to show his information
  var getUserCartItemsResponse;
  Future<List> getCartItems(
    context,
  ) async {
    try {
      ProductClass.CartItems.clear();
      Map itemImages = {};
      getUserCartItemsResponse = await Dio().get(
          "${AppConstants.BaseUrl}/get_user_cartItems/${AuthCubit.get(context).userEmailShared}");
      for (var proudct in getUserCartItemsResponse.data["Names"]) {
        ProductClass? theItem;
        var getProductsResponse = await Dio().get(
          "${AppConstants.BaseUrl}/get_products_by_id/${proudct["product"]}",
        );
        theItem = ProductClass(
            id: proudct["product"],
            quantity: proudct["quantity"],
            cartItemId: proudct["id"].toString(),
            englishName: getProductsResponse.data["Names"][0]["name"],
            arabicName: getProductsResponse.data["Names"][0]["ArabicName"],
            productSlug: getProductsResponse.data["Names"][0]["productslug"],
            restaurant: proudct["Restaurant"],
            description: getProductsResponse.data["Names"][0]["description"] ??
                " No description for this Product",
            price: double.parse(
                getProductsResponse.data["Names"][0]["price"].toString()),
            totalPrice: double.parse(
                    getProductsResponse.data["Names"][0]["price"].toString()) *
                double.parse(proudct["quantity"].toString()),
            category: getProductsResponse.data["Names"][0]["category"],
            isBestOffer: getProductsResponse.data["Names"][0]["Best_Offer"],
            isMostPopular: getProductsResponse.data["Names"][0]["Most_Popular"],
            isNewProduct: getProductsResponse.data["Names"][0]["New_Products"],
            creationDate: getProductsResponse.data["Names"][0]["created"]);
        if (!itemImages
            .containsKey(getProductsResponse.data["Names"][0]["category"])) {
          var getCategoryByIdResponse = await Dio().get(
              "${AppConstants.BaseUrl}/get_category_by_id/${getProductsResponse.data["Names"][0]["category"]}");
          theItem.itemImage = getCategoryByIdResponse.data["Names"][0]["image"];
          itemImages.addAll({
            getUserCartItemsResponse.data["Names"][0]["category"]:
                getCategoryByIdResponse.data["Names"][0]["image"]
          });
        } else {
          theItem.itemImage =
              itemImages[getProductsResponse.data["Names"][0]["category"]];
        }
        ProductClass.CartItems.add(theItem);
      }
    } catch (error) {
      AppLogger.e(error.toString());
    }
    return ProductClass.CartItems;
  }

  static String? currentLocation;
  void ChangeLocation(String value, context) {
    currentLocation = value;
    print(currentLocation);
    emit(ChangeLocationStatesSuccefullty());
  }

  final List<dynamic> LocationsNames = [];
  List<dynamic> Locations = [];
  static List<dynamic> LocationSlugList = [];
  static List<dynamic> LocationId = [];
  static List<dynamic> LocationsStatic = [];
  void getLocation(context) async {
    try {
      var locationsResponse =
          await Dio().get("${AppConstants.BaseUrl}/get_locations/");
      Locations = locationsResponse.data["Names"];
      LocationsStatic = Locations;
      for (var location in Locations) {
        LocationsNames.add(location["location_Name"]);
        LocationSlugList.add(location["location_slug"]);
        LocationId.add(location["id"]);
      }
      emit(GetLocationNamesStatesSuccefully());
    } catch (LocationError) {
      Logger().e("Error While Getting LocationNames $LocationError");
    }
  }

  static List<dynamic> restaurantsInLocation = [];
  static int? PublicLocationId;
  Future<void> getRestaurantsOfLocation(context) async {
    emit(getRestuarantSlugStateLoading());
    for (final slug in LocationsStatic) {
      if (slug["location_Name"] == currentLocation) {
        try {
          final response = await Dio().get(
              "${AppConstants.BaseUrl}/get_restaurants_by_location/${slug["location_slug"]}");

          restaurantsInLocation = response.data["Names"];
          PublicLocationId = slug["id"] - 1;

          ProductsCubit.NoNewProducts = false;
          ProductsCubit.get(context).getNewProducts(context);
          ProductsCubit.NoMostSoldProducts = false;
          ProductsCubit.get(context).getMostSoldProducts(context);

          emit(getRestuarantsOfSlugStates());
        } catch (error) {
          // Handle error here
          print("Errorrrr: $error");
        }
      }
    }
  }

  // List<dynamic> OrdersPending = [];
  // void feesDistribution(
  //   context,
  // ) async {
  //   await Dio()
  //       .get(
  //     "${AppConstants.BaseUrl}/get_24_orders/",
  //   )
  //       .then((value) {
  //     for (var i in value.data["Names"]) {
  //       if (i['status'] == 'Pending') {
  //         OrdersPending = i['id'];
  //       }
  //     }
  //   });
  //   // NavigateAndRemov(context, const ThankYou());
  // }
  Future<void> clearCartItems(context) async {
    try {
      var clearCartItemsResponse = await Dio().delete(
          "${AppConstants.BaseUrl}/clear_user_cart/${AuthCubit.get(context).userEmailShared}");
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(AppConstants.ClearItemsError),
          backgroundColor: ThemeApp.redColor));
    }
  }

  Future<void> deleteCartItem(BuildContext context, String cartItemId) async {
    try {
      var deleteCartItemsResponse = await Dio()
          .delete("${AppConstants.BaseUrl}/delete_cartItems_by_id/$cartItemId");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: ThemeApp.primaryColor,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.done_rounded,
                color: ThemeApp.whiteColor,
              ),
              Container(
                  margin: EdgeInsets.only(left: 10.w),
                  child: Text(AppConstants.ItemDeletedSuccessfully))
            ],
          ),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          const Icon(
            Icons.error,
            color: Colors.white,
          ),
          Text(
            AppConstants.DeleteCartItemsError,
            style: TextStyle(color: ThemeApp.whiteColor),
          ),
        ]),
        backgroundColor: ThemeApp.redColor,
        duration: const Duration(seconds: 1),
      ));
    }
  }

  void postToken({
    required String token,
  }) async {
    print(token);
    await Dio()
        .post(
          "${AppConstants.BaseUrl}/notification_tokens",
          data: {"token": token},
        )
        .then((value) => print("WELCOMEEEEEE" "${value.data}"))
        .catchError((e) {
          var dioException = e as DioError;

          print(dioException.response!.statusCode);
          if (dioException.response!.statusCode == 200) {
            print(dioException.response!.statusCode);
            print('Token Exist');
          } else {
            print('HAMOKSHA');
          }
        });
  }

  List<dynamic> OrdersssPendeing = [];
  String StartingOrder = "";
  String EndingOrder = "";
  DateTime? difference;
  int? count;
  String LastOrder = "";
  int? LengthOfPublicOrders;
  int? OrderId;
  int? FirstOrderId;
  Future<Response> getPublicOrder(BuildContext context,
      {int? LocationNumber}) async {
    emit(getTimeStateLoading());

    try {
      var response = await Dio().get(
          "${AppConstants.BaseUrl}/get_public_orders_in_location/${PublicLocationId != null ? PublicLocationId! + 1 : LocationNumber}");

      if (response.data["count"] == 0) {
        count = response.data["count"];
      } else {
        count = response.data["count"];
        OrdersssPendeing = response.data["Names"];
        EndingOrder = response.data["end_on"];
        LengthOfPublicOrders = response.data["Names"].length - 1;
        LastOrder =
            response.data["Names"][LengthOfPublicOrders]["ordered_date"];
        OrderId = response.data["Names"][LengthOfPublicOrders]["id"];
        print(count);
      }
      emit(getTimeStateSuccess());

      return response;
    } catch (error) {
      print("7a7a $error");
      print(PublicLocationId! + 1);
      emit(getTimeStateFailier(error.toString()));
      throw error;
    }
  }

  static double? deliveryfees;
  static String? LocationName;
  Future<void> deliveryFees({var locaionNumber}) async {
    try {
      var deliveryResponse =
          await Dio().get("${AppConstants.BaseUrl}/get_Delivery_Fees/");
      deliveryfees = deliveryResponse.data["Names"]
          [PublicLocationId ?? locaionNumber - 1]["delivery_fees"];
      LocationName = deliveryResponse.data["Names"]
          [PublicLocationId ?? locaionNumber - 1]["location"];

      emit(getDeliveryFeesState());
    } catch (error) {
      Logger().e("Error In Delivery Fees $error");
    }
  }

  void ConfirmAllPublicOrders(context, {int? IdLocation}) {
    Dio().post(
      "${AppConstants.BaseUrl}/get_public_orders_in_location/${PublicLocationId != null ? PublicLocationId! + 1 : IdLocation}",
    );
  }

  void confirmAllPublicOrders(context, int? seconds, {int? IdLocation}) {
    Future.delayed(Duration(seconds: seconds!)).then((value) {
      OrderCubit.get(context)
          .ConfirmAllPublicOrders(context, IdLocation: IdLocation);
      NavigateAndRemov(context, const ThankYou());
    }).catchError((e) {
      Logger().e(e);
    });
  }

  static CustomTimerController? timerController;
  void startTime() {
    timerController!.start();
    emit(timeStartedState());
  }

  void clostTime(context) {
    timerController!.finish();
    emit(timeFinishedState());
  }

  void cancelOrders(
    Orderid,
  ) async {
    try {
      var cancelOrderResponse =
          await Dio().post("${AppConstants.BaseUrl}/cancel_order/$Orderid");
    } catch (e) {
      print(e);
    }
  }

  void switchOrderToPrivate(context) {
    try {
      Dio().post(
          "${AppConstants.BaseUrl}/create_orders/${AuthCubit.get(context).userEmailShared}",
          data: {
            "first_name": AuthCubit.get(context).firstNameShared,
            "last_name": AuthCubit.get(context).lastNameShared,
            "phone_number": AuthCubit.get(context).phoneNumberShared,
            "email": AuthCubit.get(context).userEmailShared,
            "location_name": LocationName,
            "total_price_after_delivery":
                deliveryfees! + ProductClass.getSubtotal(),
            "totalPrice": ProductClass.getSubtotal(),
            "flag": "Mobile",
            "private": true,
            "status": "Pending",
            "user": AuthCubit.get(context).userIdShared,
            "cart": cartID,
            "deliver_to": PublicLocationId! + 1
          });
      NavigateAndRemov(context, const ThankYou());
    } catch (error) {
      print("Error While Swithching to private $error");
    }
  }

  bool clikable = true;

  void clickableChange() {
    Future.delayed(const Duration(minutes: 5, seconds: 0)).then((value) {
      clikable = false;
      emit(ClickableState());
    });
  }

  var endingOrderTimeSecond;
  bool confirmOrderPressedButton = false;
  void confirmOrderPressed() {
    confirmOrderPressedButton = !confirmOrderPressedButton;
    emit(confirmOrderPressedState());
  }

  Future<void> confirmOrder(BuildContext context, bool? private) async {
    try {
      var publicOrderResponse = await getPublicOrder(context);
      var endingOrderTime = DateTime.parse(EndingOrder);

      bool isBeforeEndingOrder = DateTime.now()
          .isBefore(endingOrderTime.add(const Duration(minutes: 1)));
      endingOrderTimeSecond =
          endingOrderTime.difference(DateTime.now()).inSeconds;

      if (!isBeforeEndingOrder) {
        await clearAndCreateOrders(
            context, private, publicOrderResponse.data["Names"][0]["id"]);
      } else {
        await createOrders(context, private);
      }
    } catch (e) {
      await createOrders(context, private);
    }
  }

  Future<void> clearAndCreateOrders(
      BuildContext context, bool? private, int orderId) async {
    try {
      var clearOrder = await Dio().post(
          "${AppConstants.BaseUrl}/get_public_orders_in_location/${PublicLocationId! + 1}");

      var createOrdersResponse = await Dio().post(
        "${AppConstants.BaseUrl}/create_orders/${AuthCubit.get(context).userEmailShared}",
        data: {
          "first_name": AuthCubit.get(context).firstNameShared,
          "last_name": AuthCubit.get(context).lastNameShared,
          "phone_number": AuthCubit.get(context).phoneNumberShared,
          "email": AuthCubit.get(context).userEmailShared,
          "location_name": LocationName,
          "total_price_after_delivery":
              deliveryfees! + ProductClass.getSubtotal(),
          "totalPrice": ProductClass.getSubtotal(),
          "flag": "Mobile",
          "private": private,
          "status": !private! ? "Pending" : "Received By Restaurant",
          "user": AuthCubit.get(context).userIdShared,
          "cart": cartID,
          "deliver_to": PublicLocationId! + 1
        },
      );

      if (!private!) {
        navigateToWaitingRoom(context, createOrdersResponse.data["id"], 1200, 1,
            PublicLocationId! + 1);
      } else {
        NavigateAndRemov(context, const ThankYou());
      }
    } catch (e) {
      await createOrders(context, private);
    }
  }

  Future<void> createOrders(BuildContext context, bool? private) async {
    try {
      var createOrdersResponse = await Dio().post(
        "${AppConstants.BaseUrl}/create_orders/${AuthCubit.get(context).userEmailShared}",
        data: {
          "first_name": AuthCubit.get(context).firstNameShared,
          "last_name": AuthCubit.get(context).lastNameShared,
          "phone_number": AuthCubit.get(context).phoneNumberShared,
          "email": AuthCubit.get(context).userEmailShared,
          "location_name": LocationName,
          "total_price_after_delivery":
              deliveryfees! + ProductClass.getSubtotal(),
          "totalPrice": ProductClass.getSubtotal(),
          "flag": "Mobile",
          "private": private,
          "status": !private! ? "Pending" : "Received By Restaurant",
          "user": AuthCubit.get(context).userIdShared,
          "cart": cartID,
          "deliver_to": PublicLocationId! + 1
        },
      );

      if (!private!) {
        var publicOrderResponse = await getPublicOrder(context);
        var endingOrderTime = DateTime.parse(EndingOrder);
        var timeOfLastOrder = DateTime.parse(LastOrder);

        endingOrderTimeSecond =
            endingOrderTime.difference(DateTime.now()).inSeconds;
        var counter = count;

        navigateToWaitingRoom(
            context,
            publicOrderResponse.data["Names"][0]["id"],
            endingOrderTimeSecond,
            counter!,
            PublicLocationId! + 1);
      } else {
        NavigateAndRemov(context, const ThankYou());
      }
    } catch (error) {
      Logger().e(error);
    }
  }

  void navigateToWaitingRoom(BuildContext context, int orderId,
      int endingOrderTimeSecond, int counter, int locationNumber) {
    NavigateAndRemov(
      context,
      WaitingRoom(
        LocationNumber: locationNumber,
        OrderId: orderId,
        endingOrderTimeSecond: endingOrderTimeSecond,
        count: counter,
        TimeOfLastOrder: DateTime.now(),
        LengthOfPublicOrders: 0, // You need to set this value correctly
      ),
    );
  }

  int? LocationNumber;
  bool? orderExistance;
  var TimeOf5minutes;
  bool CanCancelled = true;
  var OrderIdOfExistence;
  double? totalPrice;
  static double? servicefees;

  Future<void> checkOrderExistence(context) async {
    try {
      emit(InitialcheckOrderExistance());
      var orderExistenceresponse = await Dio().get(
          "${AppConstants.BaseUrl}/check_order_existence/${AuthCubit.get(context).userEmailShared}");

      Logger().i("Response of Order Existence $orderExistenceresponse");
      if (orderExistenceresponse.data["Names"] == "[]" ||
          orderExistenceresponse.data["Names"][0]["status"] != "Pending") {
        orderExistance = false;
      } else {
        LocationNumber = orderExistenceresponse.data["Names"][0]["deliver_to"];
        totalPrice = orderExistenceresponse.data["Names"][0]["totalPrice"];
        servicefees = orderExistenceresponse.data["Names"][0]["service_fees"];
        var publicOrderResponse = await Dio().get(
            "${AppConstants.BaseUrl}/get_public_orders_in_location/$LocationNumber");

        OrderIdOfExistence = orderExistenceresponse.data["Names"][0]["id"];
        FirstOrderId = publicOrderResponse.data["Names"][0]["id"];
        count = (OrderIdOfExistence - FirstOrderId) + 1;
        EndingOrder = publicOrderResponse.data["end_on"];
        var endingOrderTime = DateTime.parse(EndingOrder);
        print(endingOrderTime.difference(DateTime.now()).inMinutes);
        var OrderedDateExistance = DateTime.parse(
            orderExistenceresponse.data["Names"][0]["ordered_date"]);

        endingOrderTimeSecond =
            endingOrderTime.difference(DateTime.now()).inSeconds;
        TimeOf5minutes =
            DateTime.now().difference(OrderedDateExistance).inMinutes;
        if (TimeOf5minutes >= 5) {
          CanCancelled = false;
        } else {}
        bool CheckingDifference = DateTime.now()
            .isBefore(endingOrderTime.add(const Duration(minutes: 0)));
        if (CheckingDifference == false) {
          Dio().post(
              "${AppConstants.BaseUrl}/get_public_orders_in_location/$LocationNumber");
          print("om");
        } else {
          orderExistance = true;
          emit(OrderExistanceTrue());
        }
      }
      emit(checkOrderExistanceSuccessfuly());
    } catch (error) {
      emit(checkOrderExistanceFailed(error.toString()));
    }
  }
}










 // ProductClass.CartItems.clear();
    // Map itemImages = {};
    // await Dio()
    //     .get(
    //         "${AppConstants.BaseUrl}/get_user_cartItems/${AuthCubit.get(context).userEmailShared}")
    //     .then((value) async {
    //   for (var i in value.data["Names"]) {
    //     ProductClass? theItem;
    //     await Dio()
    //         .get(
    //       "${AppConstants.BaseUrl}/get_products_by_id/${i["product"]}",
    //     )
    //         .then((v2) async {
    //       theItem = ProductClass(
    //           id: i["product"],
    //           quantity: i["quantity"],
    //           cartItemId: i["id"].toString(),
    //           englishName: v2.data["Names"][0]["name"],
    //           arabicName: v2.data["Names"][0]["ArabicName"],
    //           productSlug: v2.data["Names"][0]["productslug"],
    //           restaurant: i["Restaurant"],
    //           description: v2.data["Names"][0]["description"] ??
    //               " No description for this Product",
    //           price: double.parse(v2.data["Names"][0]["price"].toString()),
    //           totalPrice:
    //               double.parse(v2.data["Names"][0]["price"].toString()) *
    //                   double.parse(i["quantity"].toString()),
    //           category: v2.data["Names"][0]["category"],
    //           isBestOffer: v2.data["Names"][0]["Best_Offer"],
    //           isMostPopular: v2.data["Names"][0]["Most_Popular"],
    //           isNewProduct: v2.data["Names"][0]["New_Products"],
    //           creationDate: v2.data["Names"][0]["created"]);

    //       if (!itemImages.containsKey(v2.data["Names"][0]["category"])) {
    //         print("1111");
    //         await Dio()
    //             .get(
    //                 "${AppConstants.BaseUrl}/get_category_by_id/${v2.data["Names"][0]["category"]}")
    //             .then((value2) {
    //           print("2222");
    //           theItem!.itemImage = value2.data["Names"][0]["image"];
    //           itemImages.addAll({
    //             value.data["Names"][0]["category"]: value2.data["Names"][0]
    //                 ["image"]
    //           });
    //         });
    //       } else {
    //         theItem!.itemImage = itemImages[v2.data["Names"][0]["category"]];
    //       }
    //     }).catchError((onError) {
    //       print(onError);
    //     });

    //     ProductClass.CartItems.add(theItem!);
    //   }
    //   // ignore: avoid_print
    // }).catchError((onError) {});
    // print(ProductClass.CartItems);
    // return ProductClass.CartItems;