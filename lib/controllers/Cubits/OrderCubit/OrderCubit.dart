// ignore_for_file: invalid_return_type_for_catch_error, body_might_complete_normally_catch_error

import 'dart:async';

import 'package:custom_timer/custom_timer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeats/controllers/Components/Categories%20Components/CategoryCard.dart';
import 'package:xeats/controllers/Components/General%20Components/Components.dart';
import 'package:xeats/controllers/Components/Global%20Components/loading.dart';
import 'package:xeats/controllers/Components/Product%20Class/Products_Class.dart';
import 'package:xeats/controllers/Components/Requests%20Loading%20Components/RequstsLoading.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderStates.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsCubit.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/views/CategoryView/categoryView.dart';
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
      print("cart id is 2 : ${AuthCubit.get(context).EmailInforamtion}");
      await Dio()
          .get(
              "${AppConstants.BaseUrl}/get_carts_by_id/${AuthCubit.get(context).EmailInforamtion}")
          .then((value) {
        userCartID.setInt("cartIDSaved", value.data["Names"][0]['id']);
        cartID = value.data["Names"][0]['id'];
        print("cart id is 3 : $cartID");
      });
    }
    emit(SuccessGetCartID());
  }

  // function to add item to the cart
  Future<void> addToCart(context,
      {int? productId,
      int? quantity,
      String? cartItemId,
      double? price,
      double? totalPrice,
      int? restaurantId,
      String? timeShift,
      required ProductClass ProductObject}) async {
    isRequestFinished = false;
    emit(ButtonPressedLoading());

    await Dio().post(
      "${AppConstants.BaseUrl}/get_user_cartItems/${AuthCubit.get(context).EmailInforamtion}",
      data: {
        "user": AuthCubit.get(context).idInformation,
        "cart": cartID,
        "product": productId,
        "price": price,
        "quantity": quantity,
        "totalOrderItemPrice": totalPrice,
        "Restaurant": restaurantId,
      },
    ).then((value) async {
      if (value.statusCode == 202) {
        await Dio().put(
          "${AppConstants.BaseUrl}/get_user_cartItems/${AuthCubit.get(context).EmailInforamtion}",
          data: {
            "id": cartItemId,
            "user": "${AuthCubit.get(context).idInformation}",
            "product": productId,
            "quantity": quantity,
            "totalOrderItemPrice": totalPrice,
            "price": price,
            "ordered": false,
          },
        ).catchError((e) {
          var dioException = e as DioError;
          var status = dioException.response!.statusCode;
          if (status == 403) {
            print("Data is Null or No Items in Cart");
          }
        });
        isRequestFinished = true;
        emit(ButtonPressedLoading());

        print("Updated in Cart");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     duration: const Duration(milliseconds: 1000),
        //     backgroundColor: Colors.blue,
        //     content: Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         const Icon(
        //           Icons.done_rounded,
        //           color: Colors.white,
        //         ),
        //         Container(
        //           margin: EdgeInsets.only(left: 10.w),
        //           child: Text(
        //             "${value.data}",
        //             style: GoogleFonts.poppins(
        //                 fontSize: 11,
        //                 color: Colors.white,
        //                 fontWeight: FontWeight.bold),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // );
      } else {
        print("Added To Cart");
        isRequestFinished = true;
        emit(ButtonPressedLoading());
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     duration: const Duration(milliseconds: 1000),
        //     backgroundColor: Colors.green,
        //     content: Row(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         const Icon(
        //           Icons.done_rounded,
        //           color: Colors.white,
        //         ),
        //         Container(
        //           margin: EdgeInsets.only(left: 10.w),
        //           child: Text(
        //             "${value.data}",
        //             style: GoogleFonts.poppins(
        //                 fontSize: 11,
        //                 color: Colors.white,
        //                 fontWeight: FontWeight.bold),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // );
      }
      bool isAlreadyAdded = false;
      for (Widget ProductLoop in ProductClass.CartItems) {
        try {
          ProductLoop = ProductLoop as ProductClass;
          if (ProductLoop.id == ProductObject.id) {
            print("${ProductLoop.quantity}  ${ProductObject.quantity}");
            ProductLoop.quantity = ProductObject.quantity;
            isAlreadyAdded = true;
            break;
          }
        } catch (e) {
          continue;
        }
      }
      if (!isAlreadyAdded) {
        ProductClass.CartItems.add(ProductObject);
      }
      updateCartPrice(context);
      Navigation(context, const Cart());
    }).catchError(
      (e) {
        print(e.toString());
        isRequestFinished = true;
        emit(ButtonPressedLoading());
        // var dioException = e as DioError;
        // var resp = dioException.response!.data;
        print("${AuthCubit.get(context).EmailInforamtion}");
        // print(resp);
        // print(e);
        print("User ${AuthCubit.get(context).idInformation}");
        print("CartId $cartID");
        print("Product Id $productId");
        print("q $quantity");
        print("Total Price $totalPrice");
        print("price $price");
        print("Cart Item Id $cartItemId");
        print("price $price");

        print("Restaurants Id $restaurantId");

        // print("Food Item ${ProductObject}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1500),
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
                    "",
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
      },
    );
  }

  void updateCartPrice(context) async {
    await Dio()
        .get("${AppConstants.BaseUrl}/get_Delivery_Fees")
        .then((value) async {
      await Dio().put(
          "${AppConstants.BaseUrl}/get_carts_by_id/${AuthCubit.get(context).EmailInforamtion}}",
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

  Future<List> getCartItems(
    context, {
    // The Function Will Get The email of user and take it as EndPoint to show his information
    String? email,
  }) async {
    ProductClass.CartItems.clear();

    Map itemImages = {};

    await Dio()
        .get("${AppConstants.BaseUrl}/get_user_cartItems/$email")
        .then((value) async {
      for (var i in value.data["Names"]) {
        ProductClass? theItem;
        print(i['id']);
        await Dio()
            .get(
          "${AppConstants.BaseUrl}/get_products_by_id/${i["product"]}",
        )
            .then((v2) async {
          theItem = ProductClass(
              id: i["product"],
              quantity: i["quantity"],
              cartItemId: i["id"].toString(),
              englishName: v2.data["Names"][0]["name"],
              arabicName: v2.data["Names"][0]["ArabicName"],
              productSlug: v2.data["Names"][0]["productslug"],
              restaurant: i["Restaurant"],
              description: v2.data["Names"][0]["description"] ??
                  " No description for this Product",
              price: double.parse(v2.data["Names"][0]["price"].toString()),
              totalPrice:
                  double.parse(v2.data["Names"][0]["price"].toString()) *
                      double.parse(i["quantity"].toString()),
              category: v2.data["Names"][0]["category"],
              isBestOffer: v2.data["Names"][0]["Best_Offer"],
              isMostPopular: v2.data["Names"][0]["Most_Popular"],
              isNewProduct: v2.data["Names"][0]["New_Products"],
              creationDate: v2.data["Names"][0]["created"]);

          if (!itemImages.containsKey(v2.data["Names"][0]["category"])) {
            print("1111");
            await Dio()
                .get(
                    "${AppConstants.BaseUrl}/get_category_by_id/${v2.data["Names"][0]["category"]}")
                .then((value2) {
              print("2222");
              theItem!.itemImage = value2.data["Names"][0]["image"];
              itemImages.addAll({
                value.data["Names"][0]["category"]: value2.data["Names"][0]
                    ["image"]
              });
            });
          } else {
            theItem!.itemImage = itemImages[v2.data["Names"][0]["category"]];
          }
        }).catchError((onError) {
          print(onError);
        });

        ProductClass.CartItems.add(theItem!);
      }
      // ignore: avoid_print
    }).catchError((onError) => print(onError));
    print(ProductClass.CartItems);
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
  void getLocation() {
    emit(GetLocationsStatesLoading());
    Dio()
        .get(
      "${AppConstants.BaseUrl}/get_locations/",
    )
        .then((value) {
      Locations = value.data["Names"];
      for (var Location in Locations) {
        LocationsNames.add(Location["location_Name"]);
        LocationSlugList.add(Location["location_slug"]);
        LocationId.add(Location["id"]);
      }
      emit(GetLocationNamesStatesSuccefully());
    }).catchError((onError) {
      print("7a7a $LocationsNames");
    });
  }

  static List<dynamic> restuarantsOfSlugList = [];
  static int? PublicLocationId;
  void getRestaurantsOfLocation(context) {
    emit(getRestuarantSlugStateLoading());
    Locations.forEach((slug) async {
      if (slug["location_Name"] == currentLocation) {
        await Dio()
            .get(
                "${AppConstants.BaseUrl}/get_restaurants_by_location/${slug["location_slug"]}")
            .then((value) {
          restuarantsOfSlugList = value.data["Names"];
          PublicLocationId = slug["id"] - 1;
          ProductsCubit.get(context).GetMostSoldProducts(context);

          print(PublicLocationId);
          emit(getRestuarantsOfSlugStates());
        });
      } else {}
    });
  }

  List<dynamic> OrdersPending = [];
  void feesDistribution(
    context,
  ) async {
    await Dio()
        .get(
      "${AppConstants.BaseUrl}/get_24_orders/",
    )
        .then((value) {
      for (var i in value.data["Names"]) {
        if (i['status'] == 'Pending') {
          OrdersPending = i['id'];
        }
      }
    });
    // NavigateAndRemov(context, const ThankYou());
  }

  Future<void> deleteCartItem(BuildContext context, String cartItemId) async {
    await Dio()
        .delete("${AppConstants.BaseUrl}/delete_cartItems/$cartItemId")
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 1000),
          backgroundColor: Colors.green,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.done_rounded,
                color: Colors.white,
              ),
              Container(
                  margin: EdgeInsets.only(left: 10.w),
                  child: const Text("Item Deleted Successfully"))
            ],
          ),
        ),
      );
    }).catchError((onError) {
      print(onError);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 1000),
          backgroundColor: Colors.red,
          content: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.white,
              ),
              Text(
                "Something error happened try again !!",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<Widget> getMostSoldData(
    BuildContext context, {
    required String? restaurantId,
    required String? image,
    required String? restaurantName,
  }) async {
    Widget result = Container();
    await Dio()
        .get(
            "${AppConstants.BaseUrl}/get_category_of_restaurants/$restaurantId")
        .then((value) {
      result = ListView.separated(
          itemBuilder: ((context, index) {
            if (value.data["Names"][index] == null) {
              return const Loading();
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: CategoryCard(
                  press: () {
                    Navigation(
                      context,
                      CategoriesView(
                        categoryId: value.data["Names"][index]["id"].toString(),
                        category: value.data["Names"][index]["display_name"]
                            .toString(),
                        image: value.data["Names"][index]["image"].toString(),
                        restaurantName: restaurantName,
                        restaurantID: restaurantId,
                      ),
                    );
                  },
                  category: value.data["Names"][index]['display_name'],
                  image: DioHelper.dio!.options.baseUrl +
                      value.data["Names"][index]['image'],
                  description: "",
                ),
              );
            }
            // "${value.data["Names"][index]["display_name"]}")),
          }),
          separatorBuilder: ((context, index) {
            return const SizedBox(
              height: 20,
              child: Divider(),
            );
          }),
          itemCount: value.data["Names"].length);
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(milliseconds: 1500),
        content: Text("Something error try again later !!"),
        backgroundColor: Colors.red,
      ));
    });
    return result;
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
  Future<void> getPublicOrder(context, {int? LocationNumber}) async {
    emit(getTimeStateLoading());

    await Dio()
        .get(
            "${AppConstants.BaseUrl}/get_time_of_first_public_order_in_location/${PublicLocationId != null ? PublicLocationId! + 1 : LocationNumber}")
        .then((value) {
      if (value.data["count"] == 0) {
        count = value.data["count"];
      } else {
        count = value.data["count"];

        OrdersssPendeing = value.data["Names"];
        EndingOrder = value.data["end_on"];
        LengthOfPublicOrders = value.data["Names"].length - 1;
        LastOrder = value.data["Names"][LengthOfPublicOrders]["ordered_date"];
        // OrderId = value.data["Names"][LengthOfPublicOrders]["id"];
        print(count);
      }
      emit(getTimeStateSuccess());
    }).catchError((error) {
      print("7a7a $error");
      print(PublicLocationId! + 1);
      emit(getTimeStateFailier(error));
    });
  }

  static double? deliveryfees;
  static String? LocationName;
  Future<void> deliveryFees(context, {var locaionNumber}) async {
    emit(getDeliveryFeesLoadingState());
    print("semosemosemo $locaionNumber");
    await Dio().get("${AppConstants.BaseUrl}/get_Delivery_Fees/").then((value) {
      deliveryfees = value.data["Names"]
              [PublicLocationId == null ? locaionNumber - 1 : PublicLocationId]
          ["delivery_fees"];
      LocationName = value.data["Names"]
              [PublicLocationId == null ? locaionNumber - 1 : PublicLocationId]
          ["location"];

      emit(getDeliveryFeesState());
    }).catchError((onError) {
      print(onError);
    });
  }

  void ConfirmAllPublicOrders(context) {
    Dio().post(
      "${AppConstants.BaseUrl}/get_time_of_first_public_order_in_location/${PublicLocationId! + 1}",
    );
  }

  static CustomTimerController? timerController;
  void startTime(context) {
    timerController!.start();
    emit(timeStartedState());
  }

  Future<void> clostTime() async {
    timerController!.dispose();
    emit(timeFinishedState());
  }

  void cancelOrders(Orderid, context) {
    Dio().post("${AppConstants.BaseUrl}/cancel_order/$Orderid").then((value) {
      emit(cancelOrderSuccefull());
      print(cancelOrderSuccefull());
    }).catchError((onError) {
      emit(cancelOrderError(onError.toString()));
      print(cancelOrderError(onError));
      print(onError);
    });
  }

  void switchOrderToPrivate(context) {
    Dio().post(
        "${AppConstants.BaseUrl}/create_orders/${AuthCubit.get(context).EmailInforamtion}",
        data: {
          "first_name": AuthCubit.get(context).FirstName,
          "last_name": AuthCubit.get(context).LastName,
          "phone_number": AuthCubit.get(context).PhoneNumber,
          "email": AuthCubit.get(context).EmailInforamtion,
          "location_name": LocationName,
          "total_price_after_delivery":
              deliveryfees! + ProductClass.getSubtotal(),
          "totalPrice": ProductClass.getSubtotal(),
          "flag": "Mobile",
          "private": true,
          "status": "Pending",
          "user": AuthCubit.get(context).idInformation,
          "cart": cartID,
          "deliver_to": PublicLocationId! + 1
        }).then((value) {
      NavigateAndRemov(context, const ThankYou());
    });
  }

  bool clikable = true;

  void clickableChange() {
    Future.delayed(const Duration(minutes: 5, seconds: 4)).then((value) {
      clikable = false;
      emit(ClickableState());
    });
  }

  var endingOrderTimeSecond;

  void confirmOrder(context, bool? Private) async {
    await getPublicOrder(context).then((value) async {
      try {
        var endingOrderTime = DateTime.parse(EndingOrder);
        var TimeOfLastOrder = DateTime.parse(LastOrder);

        bool CheckingDifference = DateTime.now()
            .isBefore(endingOrderTime.add(const Duration(minutes: 1)));
        endingOrderTimeSecond =
            endingOrderTime.difference(DateTime.now()).inSeconds;
        if (CheckingDifference == false) {
          print("kakaka");
          await Dio().post(
              "${AppConstants.BaseUrl}/get_time_of_first_public_order_in_location/${PublicLocationId! + 1}",
              data: {}).then((value4) async {
            if (value4.statusCode == 200) {
              print("mm");

              Dio().post(
                  "${AppConstants.BaseUrl}/create_orders/${AuthCubit.get(context).EmailInforamtion}",
                  data: {
                    "first_name": AuthCubit.get(context).FirstName,
                    "last_name": AuthCubit.get(context).LastName,
                    "phone_number": AuthCubit.get(context).PhoneNumber,
                    "email": AuthCubit.get(context).EmailInforamtion,
                    "location_name": LocationName,
                    "total_price_after_delivery":
                        deliveryfees! + ProductClass.getSubtotal(),
                    "totalPrice": ProductClass.getSubtotal(),
                    "flag": "Mobile",
                    "private": Private,
                    "status": "Pending",
                    "user": AuthCubit.get(context).idInformation,
                    "cart": cartID,
                    "deliver_to": PublicLocationId! + 1
                  }).then((value) {
                Dio()
                    .get(
                        "${AppConstants.BaseUrl}/get_time_of_first_public_order_in_location/${PublicLocationId! + 1}")
                    .then((value1) {
                  if (Private == false) {
                    NavigateAndRemov(
                        context,
                        WaitingRoom(
                            OrderId: value1.data["Names"][0]["id"],
                            endingOrderTimeSecond: 1200,
                            count: 1,
                            TimeOfLastOrder: DateTime.now(),
                            LengthOfPublicOrders: 0));
                  } else {
                    NavigateAndRemov(context, const ThankYou());
                  }
                });
              }).catchError((onError) {
                print(onError.toString());
              });
            }
          });
        } else {
          print("mmm");

          await Dio().post(
              "${AppConstants.BaseUrl}/create_orders/${AuthCubit.get(context).EmailInforamtion}",
              data: {
                "first_name": AuthCubit.get(context).FirstName,
                "last_name": AuthCubit.get(context).LastName,
                "phone_number": AuthCubit.get(context).PhoneNumber,
                "email": AuthCubit.get(context).EmailInforamtion,
                "location_name": LocationName,
                "total_price_after_delivery":
                    deliveryfees! + ProductClass.getSubtotal(),
                "totalPrice": ProductClass.getSubtotal(),
                "flag": "Mobile",
                "private": Private,
                "status": "Pending",
                "user": AuthCubit.get(context).idInformation,
                "cart": cartID,
                "deliver_to": PublicLocationId! + 1
              }).then((value) async {
            if (Private == false) {
              await getPublicOrder(context).then((value) {
                var endingOrderTime = DateTime.parse(EndingOrder);
                var TimeOfLastOrder = DateTime.parse(LastOrder);
                endingOrderTimeSecond =
                    endingOrderTime.difference(DateTime.now()).inSeconds;
                var counter = count;
                NavigateAndRemov(
                    context,
                    WaitingRoom(
                        OrderId: OrderId,
                        endingOrderTimeSecond: endingOrderTimeSecond,
                        count: counter,
                        TimeOfLastOrder: TimeOfLastOrder,
                        LengthOfPublicOrders: LengthOfPublicOrders));
              });
            } else {
              NavigateAndRemov(context, const ThankYou());
            }
          }).catchError((onError) {
            print(onError.toString());
            print("mmaaam");
          });
        }
      } on FormatException {
        print("mmaaaaaaam");
        Dio().post(
            "${AppConstants.BaseUrl}/create_orders/${AuthCubit.get(context).EmailInforamtion}",
            data: {
              "first_name": AuthCubit.get(context).FirstName,
              "last_name": AuthCubit.get(context).LastName,
              "phone_number": AuthCubit.get(context).PhoneNumber,
              "email": AuthCubit.get(context).EmailInforamtion,
              "location_name": LocationName,
              "total_price_after_delivery":
                  deliveryfees! + ProductClass.getSubtotal(),
              "totalPrice": ProductClass.getSubtotal(),
              "flag": "Mobile",
              "private": Private,
              "status": "Pending",
              "user": AuthCubit.get(context).idInformation,
              "cart": cartID,
              "deliver_to": PublicLocationId! + 1
            }).then((value) async {
          if (Private == false) {
            // await getPublicOrder(context).then((value) {
            // var endingOrderTime = DateTime.parse(EndingOrder);
            // var TimeOfLastOrder = DateTime.parse(LastOrder);

            // endingOrderTimeSecond =
            //     endingOrderTime.difference(DateTime.now()).inSeconds;
            // var counter = count;
            // print(counter);

            NavigateAndRemov(
                context,
                WaitingRoom(
                    OrderId: 1,
                    endingOrderTimeSecond: 1200,
                    count: 1,
                    LengthOfPublicOrders: 2));
            // });
          } else {
            NavigateAndRemov(context, const ThankYou());
          }
        });
      }
    });
  }

  int? LocationNumber;
  bool? orderExistance;
  var TimeOf5minutes;
  bool CanCancelled = true;
  var OrderIdOfExistence;
  double? totalPrice;
  void checkOrderExistence(context) {
    emit(InitialcheckOrderExistance());
    Dio()
        .get(
            "${AppConstants.BaseUrl}/check_order_existence/${AuthCubit.get(context).EmailInforamtion}")
        .then((value) {
      if (value.data["Names"] == "[]" ||
          value.data["Names"][0]["status"] != "Pending") {
        emit(checkOrderExistanceSuccessfuly());
        orderExistance = false;
        print("a7a");
      } else {
        LocationNumber = value.data["Names"][0]["deliver_to"];
        totalPrice = value.data["Names"][0]["totalPrice"];
        print("aaaaaaa$totalPrice");
        emit(checkOrderExistanceSuccessfuly());

        Dio()
            .get(
                "${AppConstants.BaseUrl}/get_time_of_first_public_order_in_location/$LocationNumber")
            .then((value1) {
          OrderIdOfExistence = value.data["Names"][0]["id"];
          FirstOrderId = value1.data["Names"][0]["id"];
          count = (OrderIdOfExistence - FirstOrderId) + 1;
          EndingOrder = value1.data["end_on"];
          var endingOrderTime = DateTime.parse(EndingOrder);
          print(endingOrderTime.difference(DateTime.now()).inMinutes);
          var OrderedDateExistance =
              DateTime.parse(value.data["Names"][0]["ordered_date"]);

          endingOrderTimeSecond =
              endingOrderTime.difference(DateTime.now()).inSeconds;
          TimeOf5minutes =
              DateTime.now().difference(OrderedDateExistance).inMinutes;
          if (TimeOf5minutes >= 5) {
            CanCancelled = false;
          } else {}
          bool CheckingDifference = DateTime.now()
              .isBefore(endingOrderTime.add(const Duration(minutes: 1)));
          if (CheckingDifference == false) {
            Dio().post(
                "${AppConstants.BaseUrl}/get_time_of_first_public_order_in_location/$LocationNumber");
            print("om");
          } else {
            orderExistance = true;
          }
        });
      }
      emit(checkOrderExistanceSuccessfuly());
    }).catchError((error) {
      emit(checkOrderExistanceFailed(error));
      print(checkOrderExistanceFailed(error).toString());
    });
  }
}
