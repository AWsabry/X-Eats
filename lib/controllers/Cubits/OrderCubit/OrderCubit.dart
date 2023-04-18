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

import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/views/CategoryView/categoryView.dart';
import 'package:xeats/views/ThankYou/thankyou.dart';

import '../../../views/Cart/cart.dart';

class OrderCubit extends Cubit<OrderStates> {
  OrderCubit() : super(SuperOrderStates());
  static OrderCubit get(context) => BlocProvider.of(context);

  String BASEURL = "https://www.x-eats.com";

  int? cartID;
  Future<void> getCartID(context) async {
    SharedPreferences userCartID = await SharedPreferences.getInstance();
    var d;
    if (userCartID.containsKey("cartIDSaved") &&
        (d = userCartID.getInt("cartIDSaved")) != null) {
      print("cart id is 1 : $cartID" + "$d");
      cartID = d;
    } else {
      print("cart id is 2 : ${AuthCubit.get(context).EmailInforamtion}");
      await Dio()
          .get(
              "$BASEURL/get_carts_by_id/${AuthCubit.get(context).EmailInforamtion}")
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
      // String? productName,
      // String? image,
      // String? phoneNumber,
      // String? email,
      // String? resturantName,
      double? price,
      double? totalPrice,
      int? restaurantId,
      String? timeShift,
      required ProductClass ProductObject}) async {
    isRequestFinished = false;
    emit(ButtonPressedLoading());

    await Dio().post(
      "$BASEURL/get_user_cartItems/${AuthCubit.get(context).EmailInforamtion}",
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
          "$BASEURL/get_user_cartItems/${AuthCubit.get(context).EmailInforamtion}",
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
          if (status == 304) {
            print("Data is Null or No Items in Cart");
          }
        });
        isRequestFinished = true;
        emit(ButtonPressedLoading());

        print("Updated in Cart");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1000),
            backgroundColor: Colors.blue,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.done_rounded,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.w),
                  child: Text(
                    "${value.data}",
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        );
      } else {
        print("Added To Cart");
        isRequestFinished = true;
        emit(ButtonPressedLoading());
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
                  child: Text(
                    "${value.data}",
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        );
      }
      bool isAlreadyAdded = false;
      for (Widget ProductLoop in ProductClass.CartItems) {
        try {
          ProductLoop = ProductLoop as ProductClass;
          if (ProductLoop.id == ProductObject.id) {
            print(ProductLoop.quantity.toString() +
                "  " +
                ProductObject.quantity.toString());
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
        isRequestFinished = true;
        emit(ButtonPressedLoading());
        var dioException = e as DioError;
        var status = dioException.response!.statusCode;
        var resp = dioException.response!.data;
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
                    "$resp",
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
    await Dio().get("$BASEURL/get_Delivery_Fees").then((value) async {
      await Dio().put(
          "$BASEURL/get_carts_by_id/${AuthCubit.get(context).EmailInforamtion}}",
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
        print("CARTITEM ERROR" + " " + '$status');
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

    await Dio().get("$BASEURL/get_user_cartItems/$email").then((value) async {
      for (var i in value.data["Names"]) {
        ProductClass? theItem;
        print(i['id']);
        await Dio()
            .get(
          "$BASEURL/get_products_by_id/${i["product"]}",
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
                    "$BASEURL/get_category_by_id/${v2.data["Names"][0]["category"]}")
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
    }).catchError((onError) => print(onError));
    print(ProductClass.CartItems);
    return ProductClass.CartItems;
  }

  // a function to confirm and checkout
  void confirmOrder(
    context,
  ) async {
    await Dio().get("$BASEURL/get_Delivery_Fees").then((value) async {
      await Dio().post(
          "$BASEURL/get_orders_by_email/${AuthCubit.get(context).EmailInforamtion}",
          data: {
            "first_name": AuthCubit.get(context).FirstName,
            "last_name": AuthCubit.get(context).LastName,
            "phone_number": AuthCubit.get(context).PhoneNumber,
            "email": AuthCubit.get(context).EmailInforamtion,
            "location_name": value.data["Names"][0]["location"],
            "total_price_after_delivery": value.data["Names"][0]
                    ["delivery_fees"] +
                ProductClass.getSubtotal(),
            "totalPrice": ProductClass.getSubtotal(),
            "flag": "Mobile",
            "private": false,
            "status": "Pending",
            "user": AuthCubit.get(context).idInformation,
            "cart": cartID,
            "deliver_to": 1
          }).then((value) {
        NavigateAndRemov(context, const ThankYou());
      }).catchError((onError) {});
    });
  }

  Future<void> deleteCartItem(BuildContext context, String cartItemId) async {
    await Dio().delete("$BASEURL/delete_cartItems/$cartItemId").then((value) {
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
        SnackBar(
          duration: const Duration(milliseconds: 1000),
          backgroundColor: Colors.red,
          content: Row(
            children: const [
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

  double? deliveryfees;
  Future<void> deliveryFees() async {
    await Dio().get("$BASEURL/get_Delivery_Fees").then((value) {
      deliveryfees = value.data["Names"][0]["delivery_fees"];
    }).catchError((onError) {
      print(onError);
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
        .get("$BASEURL/get_category_of_restaurants/$restaurantId")
        .then((value) {
      result = ListView.separated(
          itemBuilder: ((context, index) {
            if (value.data["Names"][index] == null) {
              return Loading();
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
            return SizedBox(
              child: Divider(),
              height: 20,
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
          "$BASEURL/notification_tokens",
          data: {"token": token},
        )
        .then((value) => print("WELCOME" + "${value.data}"))
        .catchError((e) {
          var dioException = e as DioError;

          print(dioException.response!.statusCode);
          if (dioException.response!.statusCode == 302) {
            print(dioException.response!.statusCode);
            print('Token Exist');
          }
        });
  }
}
