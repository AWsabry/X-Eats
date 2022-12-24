import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeats/controllers/Components/Global%20Components/AlertDialog.dart';
import 'package:xeats/controllers/Components/ItemClass.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/controllers/States.dart';
import 'package:xeats/controllers/Components/Components.dart';
import 'package:xeats/views/CategoryView/categoryView.dart';
import 'package:xeats/views/SignIn/SignIn.dart';

import 'Components/Categories Components/CategoryCard.dart';
import 'Components/Global Components/loading.dart';

class Xeatscubit extends Cubit<XeatsStates> {
  Xeatscubit() : super(SuperXeats());
  bool isPassword = true;
  bool isPassword1 = true;
  var Password = TextEditingController();
  var Password1 = TextEditingController();
  var XeatOtp1 = TextEditingController();
  var XeatOtp2 = TextEditingController();
  var XeatOtp3 = TextEditingController();
  var XeatOtp4 = TextEditingController();
  var XeatOtp5 = TextEditingController();
  var email = TextEditingController();
  var Firstname = TextEditingController();
  var Lastname = TextEditingController();
  var Phone = TextEditingController();
  var datecontroller = TextEditingController();

  // bool ShowLabel = true;
  // bool ShowLabel2 = true;
  // bool ShowLabel3 = true;
  // bool ShowLabel4 = true;

  ////////////////////////////////////////////////

  /////////////////////////////////////////
  static int? currentRestaurant;
  ///////////////////////////////////////////////

  // user data retrieved after logging in

  static Xeatscubit get(context) => BlocProvider.of(context);

  String BASEURL = "https://www.x-eats.com";

  List<dynamic> EmailInList = [];

//This Function Will Call when user Sign In Succefuly
  Future<List> getEmail(
    context, {
    // The Function Will Get The email of user and take it as EndPoint to show his information
    String? email,
  }) async {
    await DioHelper.getdata(url: "get_user_by_id/$email", query: {})
        .then((value) async {
      //EmailInformationList
      EmailInList = value.data['Names'];
      SharedPreferences userInf = await SharedPreferences.getInstance();
      userInf.setString('EmailInf', EmailInList[0]['email']);
      userInf.setString('FirstName', EmailInList[0]['first_name']);
      userInf.setString('LastName', EmailInList[0]['last_name']);
      userInf.setInt("Id", EmailInList[0]['id']);
      userInf.setDouble("wallet", EmailInList[0]['Wallet']);

      emit(SuccessGetInformation());
    }).catchError((onError) {
      emit(FailgetInformation());
      print(FailgetInformation());
    });
    return EmailInList;
  }

//-------------------- Function Separated to get his email if his email null then it will go to login if not then it will go to home page
  String? EmailInforamtion;
  String? FirstName;
  String? LastName;
  int? idInformation;
  double? wallet;

  Future<void> GettingUserData() async {
    SharedPreferences User = await SharedPreferences.getInstance();
    EmailInforamtion = User.getString('EmailInf');
    FirstName = User.getString('FirstName');
    LastName = User.getString('LastName');
    idInformation = User.getInt('Id');
    wallet = User.getDouble('wallet');
    emit(SuccessEmailProfile());
  }

  Future<void> signOut(context) async {
    SharedPreferences userInformation = await SharedPreferences.getInstance();
    userInformation.clear();
    Navigation(context, SignIn());
    emit(Cleared());
  }

  List<dynamic> cartList = [];

  Future<List> getCart(context, {String? email}) async {
    await Dio().get("$BASEURL/get_carts_by_id/$email").then((value) async {
      cartList = value.data['Names'];
      print(cartList[0]['id']);
      print("EMAIL" + " " + "$email");
      SharedPreferences userCartID = await SharedPreferences.getInstance();
      userCartID.setInt("cartIDSaved", cartList[0]['id']);
      emit(SuccessGetCartID());
    }).catchError((onError) {
      emit(FailedGetCartID());
    });
    return cartList;
  }

//-------------------- Function Separated to get his email if his email null then it will go to login if not then it will go to home page
  int? cartID;
  Future<void> CartData() async {
    SharedPreferences cart = await SharedPreferences.getInstance();
    cartID = cart.getInt('cartIDSaved');
    emit(SuccessGetCartID());
    print("LISTOOO" + '${cartList[0]}');
    print("BLA BLA" + " " "$cartID");
  }

  static List<dynamic> Get_Category = [];
  void GetCategory() {
    DioHelper.getdata(url: 'get_category/', query: {}).then((value) {
      Get_Products = value.data['Names'];

      emit(ProductsSuccess());
    }).catchError((error) {
      print(ProductsFail(error.toString()));
    });
  }

  static List<dynamic> Get_Products = [];
  void GetProducts() {
    DioHelper.getdata(url: 'get_products/', query: {}).then((value) {
      Get_Products = value.data['Names'];
      print(Get_Products);
      emit(ProductsSuccess());
    }).catchError((error) {
      print(ProductsFail(error.toString()));
    });
  }

  static List<dynamic> MostSold = [];
  Map itemImages = {};

  void GetMostSoldProducts() {
    DioHelper.getdata(url: 'get_products_mostSold_products/', query: {})
        .then((value) async {
      MostSold = value.data['Names'];
      var data;
      FoodItem? theItem;

      emit(ProductsSuccess());
    }).catchError((error) {
      print(ProductsFail(error.toString()));
    });
  }

  static List<dynamic> new_products = [];
  void NewProducts() {
    DioHelper.getdata(url: 'get_products_new_products/', query: {})
        .then((value) {
      new_products = value.data['Names'];
      emit(ProductsSuccess());
    }).catchError((error) {
      print(ProductsFail(error.toString()));
    });
  }

  static List<dynamic> getposters = [];
  void getPoster() {
    DioHelper.getdata(url: 'get_poster/', query: {}).then((value) {
      getposters = value.data['Names'];
      print(getposters);
      emit(ProductsSuccess());
    }).catchError((error) {
      print(ProductsFail(error.toString()));
    });
  }

  static List<dynamic> ResturantsList = [];

  void GetResturants() async {
    emit(ProductsLoading());
    DioHelper.getdata(
      url: 'get_restaurants/',
      query: {},
    ).then((value) {
      ResturantsList = value.data['Names'];
      emit(ProductsSuccess());
    }).catchError((error) {
      emit(ProductsFail(error.toString()));
    });
  }

  Future<void> getCurrentAvailableOrderRestauant() async {
    await Dio()
        .get("$BASEURL/get_user_cartItems/$EmailInforamtion")
        .then((value) {
      if (value.data["Names"].length == 0) {
        currentRestaurant = null;
      } else {
        currentRestaurant = value.data["Names"][0]["Restaurant"];
      }
    });
  }

  // function to add item to the cart
  Future<void> addToCart({
    int? productId,
    int? quantity,
    int? cartItemId,
    double? price,
    double? totalPrice,
    int? restaurantId,
    String? timeShift,
  }) async {
    await Dio().post(
      "$BASEURL/get_user_cartItems/$EmailInforamtion",
      data: {
        "user": idInformation,
        "cart": cartID,
        "product": productId,
        "price": price,
        "quantity": quantity,
        "totalOrderItemPrice": totalPrice,
        "Restaurant": restaurantId,
        "order_shift": "25"
      },
    ).then((value) {
      DioError? dioException;

      print(value);
    }).catchError((e) {
      var dioException = e as DioError;
      var status = dioException.response!.statusCode;
      var resp = dioException.response!.data;
      if (status == 403) {
        print("Not the Same Rest");
      }
    });
  }

  void updateCartPrice() async {
    await Dio().put("$BASEURL/get_carts_by_id/$EmailInforamtion", data: {
      "total_price": FoodItem.getSubtotal(),
      "total_after_delivery":
          (FoodItem.deliveryFee + FoodItem.getSubtotal()).toDouble()
    }).then((value) {
      print(value);
    }).catchError((e) {
      var dioException = e as DioError;
      var status = dioException.response!.statusCode;
      print("CARTITEM ERROR" + " " + '$status');
    });
  }

  // function to get the food data(image, name in arabic and english, price , category. ...) by (productId)
  void getProductById({required String id}) async {
    await Dio()
        .get("$BASEURL/get_products/$id")
        .then((value) => print(value.data))
        .catchError((onError) => print(onError));
  }

  List<dynamic> cartItems = [];

  Future<List> getCartItems(
    context, {
    // The Function Will Get The email of user and take it as EndPoint to show his information
    String? email,
  }) async {
    FoodItem.CartItems.clear();

    Map itemImages = {};

    await Dio().get("$BASEURL/get_user_cartItems/$email").then((value) async {
      for (var i in value.data["Names"]) {
        FoodItem? theItem;
        print(i['id']);
        await Dio()
            .get(
          "$BASEURL/get_products_by_id/${i["product"]}",
        )
            .then((v2) async {
          theItem = FoodItem(
              id: i["product"],
              quantity: i["quantity"],
              cartItemId: i["id"].toString(),
              englishName: v2.data["Names"][0]["name"],
              arabicName: v2.data["Names"][0]["ArabicName"],
              productSlug: v2.data["Names"][0]["productslug"],
              restaurant: i["Restaurant"],
              description: v2.data["Names"][0]["description"] ??
                  " No description for this Product",
              price: double.parse(v2.data["Names"][0]["price"].toString()) *
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
        print("caaaaaaaaaaaaaaaaaaaaaaaaaaaaart");

        print("caaaaaaaaaaaaaaaaaaaaaaaaaaaaart");
        FoodItem.CartItems.add(theItem!);
      }
    }).catchError((onError) => print(onError));
    print(FoodItem.CartItems);
    return FoodItem.CartItems;
  }

  // a function to confirm and checkout
  void confirmOrder(
    context, {
    int? id,
  }) async {
    await Dio()
        .post("$BASEURL/get_orders/", data: {
          "user": id,
          "total_price_after_delivery":
              FoodItem.deliveryFee + FoodItem.getSubtotal(),
          "paid": false,
          "totalPrice": FoodItem.getSubtotal(),
          "cart": cartID
        })
        .then((value) => print(value))
        .catchError((onError) => print(onError));
  }

  Future<void> deleteCartItem(BuildContext context, String cartItemId) async {
    await Dio().delete("$BASEURL/delete_cartItems/$cartItemId").then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Row(
            children: [
              Icon(
                Icons.done,
                color: Colors.white,
              ),
              Text(
                "Item deleted successfully",
                style: TextStyle(color: Colors.white),
              ),
            ],
          )));
    }).catchError((onError) {
      print(onError);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
          )));
    });
  }

  Future<Widget> getCurrentCategories(
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
                        category: value.data["Names"][index]['display_name'],
                        categoryId: value.data["Names"][index]['id'].toString(),
                        image: value.data["Names"][index]["image"],
                        restaurantName: restaurantName,
                        restaurantId,
                      ),
                    );
                  },
                  category:
                      value.data["Names"][index]['display_name'].toString(),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something error try again later !!"),
        backgroundColor: Colors.red,
      ));
    });
    return result;
  }

  Future getCurrentProducts(
    BuildContext context, {
    required String? id,
    required String? CatId,
    required String? image,
    required String? category,
    required String? restaurantName,
  }) async {
    var data;
    await Dio()
        .get("$BASEURL/get_products_of_restaurant_by_category/$id/$CatId")
        .then((value) async {
      data = ListView.separated(
          itemBuilder: (context, index) {
            return FoodItem(
              itemImage: image,
              englishName: value.data["Names"][index]["name"],
              arabicName: value.data["Names"][index]["ArabicName"],
              price: value.data["Names"][index]["price"],
              id: value.data["Names"][index]["id"],
              description: value.data["Names"][index]["description"],
              creationDate: value.data["Names"][index]["created"],
              restaurant: value.data["Names"][index]["Restaurant"],
              isBestOffer: value.data["Names"][index]["Best_Offer"],
              isMostPopular: value.data["Names"][index]["Most_Popular"],
              isNewProduct: value.data["Names"][index]["New_Products"],
            ).productsOfCategory(context,
                image: image,
                category: category,
                CatId: CatId,
                restaurantName: restaurantName);
          },
          separatorBuilder: ((context, index) {
            return Divider();
          }),
          itemCount: value.data["Names"].length);
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something error try again later !!"),
        backgroundColor: Colors.red,
      ));
    });
    return data;
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
                        restaurantId,
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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

  Future<String> gettingCategoryImages(String categoryID) async {
    String? image;
    await Dio()
        .get("https://www.x-eats.com/get_category_by_id/$categoryID")
        .then((value) {
      image = value.data["Names"][0]["image"].toString();
    });
    return image!;
  }
}
