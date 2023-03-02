// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeats/controllers/Components/ItemClass.dart';
import 'package:xeats/controllers/Components/Requests%20Loading%20Components/RequstsLoading.dart';
import 'package:xeats/controllers/Components/Restaurant%20Components/RestaurantView.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/controllers/States.dart';
import 'package:xeats/controllers/Components/Components.dart';
import 'package:xeats/views/CategoryView/categoryView.dart';
import 'package:xeats/views/ResturantsMenu/ResturantsMenu.dart';
import 'package:xeats/views/SignIn/SignIn.dart';
import 'package:xeats/views/ThankYou/thankyou.dart';
import '../views/Cart/Cart.dart';
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
  var XeatOtp6 = TextEditingController();

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
  static Map currentRestaurant = {};
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
      userInf.setString("phonenumber", EmailInList[0]['PhoneNumber']);

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
  String? PhoneNumber;

  Future<void> GettingUserData() async {
    SharedPreferences User = await SharedPreferences.getInstance();
    EmailInforamtion = User.getString('EmailInf');
    FirstName = User.getString('FirstName');
    LastName = User.getString('LastName');
    idInformation = User.getInt('Id');
    wallet = User.getDouble('wallet');
    PhoneNumber = User.getString('phonenumber');
    emit(SuccessEmailProfile());
  }

  Future<void> signOut(context) async {
    SharedPreferences userInformation = await SharedPreferences.getInstance();
    userInformation.clear();
    Navigation(context, SignIn());
    emit(Cleared());
  }

  int? cartID;
  Future<void> getCartID() async {
    SharedPreferences userCartID = await SharedPreferences.getInstance();
    var d;
    if (userCartID.containsKey("cartIDSaved") &&
        (d = userCartID.getInt("cartIDSaved")) != null) {
      print("cart id is 1 : $cartID" + "$d");
      cartID = d;
    } else {
      print("cart id is 2 : $EmailInforamtion");
      await Dio()
          .get("$BASEURL/get_carts_by_id/$EmailInforamtion")
          .then((value) {
        userCartID.setInt("cartIDSaved", value.data["Names"][0]['id']);
        cartID = value.data["Names"][0]['id'];
        print("cart id is 3 : $cartID");
      });
    }
    emit(SuccessGetCartID());
  }

//-------------------- Function Separated to get his email if his email null then it will go to login if not then it will go to home page

  Future<List<DropdownMenuItem<String>>> getTimings() async {
    List<DropdownMenuItem<String>> availableTimings = [];
    List<DropdownMenuItem<String>> timings = [
      DropdownMenuItem(
        child: Text("11:00 AM"),
        value: "11:00 AM",
      ),
      DropdownMenuItem(
        child: Text("1:00 PM"),
        value: "1:00 PM",
      ),
      DropdownMenuItem(
        child: Text("3:00 PM"),
        value: "3:00 PM",
      ),
      DropdownMenuItem(
        child: Text("6:00 PM"),
        value: "6:00 PM",
      )
    ];
    await Dio().get("$BASEURL/get_order_timing").then((value) {
      String timingId1 = value.data["Names"][0]["end_order"];
      if (timingId1 == "11:00:00") {
        availableTimings.add(timings[0]);
      } else if (timingId1 == "13:00:00") {
        availableTimings.add(timings[0]);
        availableTimings.add(timings[1]);
      } else if (timingId1 == "15:00:00") {
        availableTimings.add(timings[0]);
        availableTimings.add(timings[1]);
        availableTimings.add(timings[2]);
      } else if (int.parse("${timingId1[0]}${timingId1[1]}") < 11) {
      } else {
        availableTimings = timings;
      }
    }).catchError((onError) => print(onError));
    return availableTimings;
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
        .then((value) async {
      if (value.data["Names"].length == 0) {
        currentRestaurant = {};
      } else {
        var dataFromApi = await Dio().get(
            "$BASEURL/get_restaurants_by_id/${value.data["Names"][0]["Restaurant"]}");
        currentRestaurant = dataFromApi.data["Names"][0];
      }
    });
  }

  Future<String?> getRestaurantName(String id) async {
    String? restaurantName;
    await Dio().get("$BASEURL/get_restaurants_by_id/$id").then((value) {
      restaurantName = value.data["Names"][0]["Name"].toString();
    }).catchError((onError) {
      restaurantName = onError.response!.statusCode.toString();
    });
    return restaurantName;
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
      required FoodItem foodItemObject}) async {
    isRequestFinished = false;
    emit(ButtonPressedLoading());

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
      },
    ).then((value) async {
      if (value.statusCode == 202) {
        await Dio().put(
          "$BASEURL/get_user_cartItems/$EmailInforamtion",
          data: {
            "id": cartItemId,
            // "product_name": productName,
            // "image": image,
            // "restaurant_name": resturantName,
            "user": idInformation,
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
      for (Widget foodItemLoop in FoodItem.CartItems) {
        try {
          foodItemLoop = foodItemLoop as FoodItem;
          if (foodItemLoop.id == foodItemObject.id) {
            print(foodItemLoop.quantity.toString() +
                "  " +
                foodItemObject.quantity.toString());
            foodItemLoop.quantity = foodItemObject.quantity;
            isAlreadyAdded = true;
            break;
          }
        } catch (e) {
          continue;
        }
      }
      if (!isAlreadyAdded) {
        FoodItem.CartItems.add(foodItemObject);
      }
      updateCartPrice();
      Navigation(context, const Cart());
    }).catchError(
      (e) {
        isRequestFinished = true;
        emit(ButtonPressedLoading());
        var dioException = e as DioError;
        var status = dioException.response!.statusCode;
        var resp = dioException.response!.data;
        print(resp);
        print(e);
        print("User $idInformation");
        print("Product Id $productId");
        print("q $quantity");
        print("CartId $cartID");
        print("Cart Item Id $cartItemId");
        print("price $price");
        print("Total Price $totalPrice");
        print("Restaurants Id $restaurantId");
        print("Time Shift $timeShift");
        print("Food Item $foodItemObject");

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

  void updateCartPrice() async {
    await Dio().get("$BASEURL/get_Delivery_Fees").then((value) async {
      await Dio().put("$BASEURL/get_carts_by_id/$EmailInforamtion", data: {
        "total_price": FoodItem.getSubtotal(),
        "total_after_delivery":
            (value.data["Names"][0]["delivery_fees"] + FoodItem.getSubtotal())
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

        FoodItem.CartItems.add(theItem!);
      }
    }).catchError((onError) => print(onError));
    print(FoodItem.CartItems);
    return FoodItem.CartItems;
  }

  // a function to confirm and checkout
  void confirmOrder(
    context,
  ) async {
    await Dio().get("$BASEURL/get_Delivery_Fees").then((value) async {
      await Dio().post("$BASEURL/get_orders_by_email/$EmailInforamtion", data: {
        "user": idInformation,
        "total_price_after_delivery":
            value.data["Names"][0]["delivery_fees"] + FoodItem.getSubtotal(),
        "totalPrice": FoodItem.getSubtotal(),
        "cart": cartID,
        "first_name": FirstName,
        "last_name": LastName,
        "phone_number": PhoneNumber,
        "flag": "Mobile"
      }).then((value) {
        NavigateAndRemov(context, const ThankYou());
      }).catchError((onError) => print(onError));
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

  Future<Widget> getRestaurantCategories(
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
                          categoryId:
                              value.data["Names"][index]['id'].toString(),
                          image: value.data["Names"][index]["image"],
                          restaurantName: restaurantName,
                          restaurantID: restaurantId),
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(milliseconds: 1000),
        content: Text("Something error try again later !!"),
        backgroundColor: Colors.red,
      ));
    });
    return result;
  }

//         );

  List<String> EnglishName = [];
  List<String> ArabicName = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController searchRestaurantsController = TextEditingController();

  Future<void> ClearId() async {
    ProductId.clear();
    EnglishName.clear();
    ArabicName.clear();
    price.clear();
    id.clear();
    restaurant.clear();
    description.clear();
    isBestOffer.clear();
    isMostPopular.clear();
    isNewProduct.clear();
    creationDate.clear();
    emit(ClearProductId());
  }

  var data;
  var RestuarantsUI;
  Future getListOfRestuarants(
    BuildContext context, {
    required List<dynamic>? Restuarantsdata,
    required List<int>? RestaurantId,
    required List<String>? imageOfRestaurant,
    required List<String>? restaurant_nameFromSearching,
  }) async {
    await Dio()
        .get("$BASEURL/get_restaurants")
        .then((value) {})
        .catchError((onError) {});
    RestuarantsUI = Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Restaurants Founded',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (imageOfRestaurant![index] == null) {
              return Loading();
            } else {
              return InkWell(
                onTap: () {
                  Navigation(
                      context,
                      ResturantsMenu(
                        data: Restuarantsdata![index],
                        RestaurantId: RestaurantId[index],
                      ));
                },
                child: Row(children: [
                  Container(
                    height: 130.h,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromARGB(74, 158, 158, 158)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Image.network(
                          'https://www.x-eats.com' + imageOfRestaurant[index],
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: Loading(),
                            );
                          },
                        )),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(children: [
                            Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                '${restaurant_nameFromSearching![index]}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                          ]),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            Text(' 4.1'),
                            Text(' (100+)')
                          ]),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Icon(Icons.timer_sharp),
                                Text(
                                  ' 45 mins',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Icon(Icons.delivery_dining_outlined),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  'X-Eats Delivery',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              );
            }
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: RestaurantId!.length,
        )
      ],
    );
    return RestuarantsUI;
  }

  Future getListOfProducts(
    BuildContext context, {
    required String? CatId,
    required String? image,
    required String? category,
    required String? restaurantName,
  }) async {
    await Dio()
        .get("$BASEURL/get_products_of_restaurant_by_category/$id/$CatId")
        .then((value) {})
        .catchError((onError) {});
    data = Expanded(
      child: ListView.separated(
          separatorBuilder: ((context, index) {
            return Divider();
          }),
          itemBuilder: (context, index) {
            return FoodItem(
              itemImage: image,
              englishName: EnglishName[index],
              arabicName: ArabicName[index],
              price: price[index],
              id: id[index],
              description: description[index],
              creationDate: creationDate[index],
              restaurant: restaurant[index],
              isBestOffer: isBestOffer[index],
              isMostPopular: isMostPopular[index],
              isNewProduct: isNewProduct[index],
            ).Search(context,
                image: image,
                category: category,
                CatId: CatId,
                restaurantName: restaurantName,
                price: price[index]);
          },
          itemCount: ProductId.length),
    );

    return data;
  }

  List<double> price = [];
  List<int> id = [];
  List<int> restaurant = [];
  List<String> creationDate = [];
  List<String> description = [];
  List<bool> isBestOffer = [];
  List<bool> isMostPopular = [];
  List<bool> isNewProduct = [];
  List<String> restaurant_name = [];
  List<int> category = [];
  List<String> category_name = [];
  List<String> image = [];
  Future<void> SearchOnListOfProduct(
    BuildContext context,
  ) async {
    for (var i = 0; i < ProductId.length; i++) {
      await Dio()
          .get("$BASEURL/get_products_by_id/${ProductId[i]}")
          .then((value) async {
        image.add(value.data["Names"][0]["image"]);
        restaurant_name.add(value.data["Names"][0]["restaurant_name"]);
        category_name.add(value.data["Names"][0]["category_name"]);
        category.add(value.data["Names"][0]["category"]);
        isNewProduct.add(value.data["Names"][0]["New_Products"]);
        isMostPopular.add(value.data["Names"][0]["Most_Popular"]);
        isBestOffer.add(value.data["Names"][0]["Best_Offer"]);
        creationDate.add(value.data["Names"][0]["created"]);
        description.add(value.data["Names"][0]["description"]);
        restaurant.add(value.data["Names"][0]["Restaurant"]);
        id.add(value.data["Names"][0]["id"]);
        price.add(value.data["Names"][0]["price"]);
        EnglishName.add(value.data["Names"][0]["name"]);
        ArabicName.add(value.data["Names"][0]["ArabicName"]);
      }).catchError((e) {
        print("The error is $e");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Text("Something error try again later !!"),
          backgroundColor: Colors.red,
        ));
      });
      emit(SearhOnProductSuccessfull());
    }
  }

  List<int> ProductId = [];
  var ProductName;
  Future GetIdOfProducts(
    BuildContext context, {
    required String? id,
  }) async {
    await Dio()
        .get("$BASEURL/get_products_by_restaurant_id/$id")
        .then((value) async {
      for (var i = 0; i < value.data["Names"].length; i++) {
        if (value.data["Names"][i]["name"]
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            value.data["Names"][i]["ArabicName"]
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase())) {
          if (value.data["Names"][i]["id"] is int) {
            ProductId.add(value.data["Names"][i]["id"]);
            print(ProductId);
          }
        }
      }
    });
    emit(ProductIdSuccefull());
  }

  List<int> RestaurantId = [];
  List<dynamic> Restuarantsdata = [];
  Future GetIdOfResutarant(
    BuildContext context,
  ) async {
    await Dio().get("$BASEURL/get_restaurants").then((value) async {
      for (var i = 0; i < value.data["Names"].length; i++) {
        if (value.data["Names"][i]["Name"]
            .toString()
            .toLowerCase()
            .contains(searchRestaurantsController.text.toLowerCase())) {
          if (value.data["Names"][i]["id"] is int) {
            RestaurantId.add(value.data["Names"][i]["id"]);
            Restuarantsdata.add(value.data["Names"][i]);
            print(RestaurantId);
          }
        }
      }
    });
    emit(RestaurantIdSuccefull());
  }

  Future<void> clearRestaurantId() async {
    imageOfRestaurant.clear();
    restaurant_nameFromSearching.clear();
    RestaurantId.clear();
    emit(ClearRestaurantsIdState());
  }

  List<String> restaurant_nameFromSearching = [];

  List<String> imageOfRestaurant = [];
  Future<void> SearchOnListOfRestuarant(
    BuildContext context,
  ) async {
    for (var i = 0; i < RestaurantId.length; i++) {
      await Dio()
          .get("$BASEURL/get_restaurants_by_id/${RestaurantId[i]}")
          .then((value) async {
        imageOfRestaurant.add(value.data["Names"][0]["image"]);
        restaurant_nameFromSearching.add(value.data["Names"][0]["Name"]);
      }).catchError((e) {
        print("The error is $e");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Text("Something error try again later !!"),
          backgroundColor: Colors.red,
        ));
      });
      emit(SearhOnRestaurantSuccessfull());
    }
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
      data = Expanded(
        child: ListView.separated(
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
                  restaurantName: restaurantName,
                  price: value.data["Names"][index]["price"]);
            },
            separatorBuilder: ((context, index) {
              return Divider();
            }),
            itemCount: value.data["Names"].length),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(milliseconds: 1500),
        content: Text("Something error try again later !!"),
        backgroundColor: Colors.red,
      ));
    });
    return data;
  }

  double? deliveryfees;
  Future<void> deliveryFees() async {
    await Dio().get("$BASEURL/get_Delivery_Fees").then((value) {
      deliveryfees = value.data["Names"][0]["delivery_fees"];
      emit(GetDeliveryFeesState());
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

  // Future<String> gettingCategoryImages(String categoryID) async {
  //   String? image;
  //   await Dio()
  //       .get("https://www.x-eats.com/get_category_by_id/$categoryID")
  //       .then((value) {
  //     image = value.data["Names"][0]["image"].toString();
  //   });
  //   return image!;
  // }
}
