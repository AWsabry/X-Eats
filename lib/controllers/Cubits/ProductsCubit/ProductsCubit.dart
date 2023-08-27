import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:xeats/controllers/Components/Product%20Class/Products_Class.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsStates.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/core/Constants/constants.dart';
import 'package:xeats/core/logger.dart';

enum Privacy { Private, Public }

class ProductsCubit extends Cubit<ProductsStates> {
  ProductsCubit() : super(SuperProductsStates());
  static ProductsCubit get(context) => BlocProvider.of(context);
  TextEditingController searchController = TextEditingController();

  static List<dynamic> MostSold = [];
  Map itemImages = {};
  static bool? NoMostSoldProducts;
  Future<void> getMostSoldProducts(context) async {
    try {
      emit(mostSoldProductsStateLoading());
      var mostSoldProductsResonse = await DioHelper.getdata(
          url:
              'get_products_mostSold_products/${OrderCubit.PublicLocationId! + 1}',
          query: {});
      MostSold = mostSoldProductsResonse.data['Names'];
      if (MostSold.isEmpty) {
        NoMostSoldProducts = true;
      } else {
        NoMostSoldProducts = false;
      }
      emit(MostSoldProductsStateSuccessfull());
    } catch (error) {
      Logger().e("Error In No Most Sold Proudcts $error");
    }
  }

  static List<dynamic> new_products = [];
  static bool? NoNewProducts;

  Future<void> getNewProducts(context) async {
    try {
      emit(newProductsStateLoading());
      var NewProductsResponse = await DioHelper.getdata(
          url: 'get_products_new_products/${OrderCubit.PublicLocationId! + 1}',
          query: {});
      new_products = NewProductsResponse.data['Names'];
      if (new_products.isEmpty) {
        NoNewProducts = true;
      } else {
        NoNewProducts = false;
      }
      emit(NewProductsStateSuccessfull());
    } catch (error) {
      Logger().e("Error In No New Proudcts $error");
    }
  }

  static List<dynamic> getposters = [];
  void getPoster() {
    DioHelper.getdata(url: 'get_poster/', query: {}).then((value) {
      getposters = value.data['Names'];

      emit(getPosterStateSuccessfull());
    }).catchError((error) {});
  }

  final List<String> EnglishName = [];
  final List<String> ArabicName = [];

  Future<void> ClearProductsId() async {
    category_name.clear();
    restaurant_name.clear();
    image.clear();
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

// Displaying the UI when Searching on product
  final List<double> price = [];
  final List<int> id = [];
  final List<int> restaurant = [];
  final List<String> creationDate = [];
  final List<String> description = [];
  final List<bool> isBestOffer = [];
  final List<bool> isMostPopular = [];
  final List<bool> isNewProduct = [];
  final List<String> restaurant_name = [];
  final List<int> category = [];
  final List<String> category_name = [];
  final List<String> image = [];
  List<int> ProductId = [];

  List<dynamic> searchedProducts = [];
  bool? noProducts;
  Future GetSearchedProductsInRestaurant(context, String restaurantName) async {
    var data = "No Data";
    emit(newProductsStateLoading());
    AppLogger.e(restaurantName + searchController.text);
    await Dio()
        .get(
            "${AppConstants.BaseUrl}/get_searched_products_in_restaurant/$restaurantName/${searchController.text}")
        .then((value) {
      searchedProducts = value.data['Names'];
      // AppLogger.i(searchedProducts.toString());
      print(searchedProducts);
      if (searchedProducts.isEmpty) {
        noProducts = true;
      } else {
        noProducts = false;
      }
      emit(ProductSearchSuccess());
    }).catchError((error) {
      emit(ProductSearchFail(error));
    });
    return data;
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
    var getProductsByCategoryResponse = await Dio().get(
        "${AppConstants.BaseUrl}/get_products_of_restaurant_by_category/$id/$CatId");
    data = Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) {
            return ProductClass(
              itemImage: image,
              englishName: getProductsByCategoryResponse.data["Names"][index]
                  ["name"],
              arabicName: getProductsByCategoryResponse.data["Names"][index]
                  ["ArabicName"],
              price: getProductsByCategoryResponse.data["Names"][index]
                  ["price"],
              id: getProductsByCategoryResponse.data["Names"][index]["id"],
              description: getProductsByCategoryResponse.data["Names"][index]
                  ["description"],
              creationDate: getProductsByCategoryResponse.data["Names"][index]
                  ["created"],
              restaurant: getProductsByCategoryResponse.data["Names"][index]
                  ["Restaurant"],
              isBestOffer: getProductsByCategoryResponse.data["Names"][index]
                  ["Best_Offer"],
              isMostPopular: getProductsByCategoryResponse.data["Names"][index]
                  ["Most_Popular"],
              isNewProduct: getProductsByCategoryResponse.data["Names"][index]
                  ["New_Products"],
            ).productsOfCategory(context,
                image: image,
                category: category,
                CatId: CatId,
                restaurantName: restaurantName,
                price: getProductsByCategoryResponse.data["Names"][index]
                    ["price"]);
          },
          separatorBuilder: ((context, index) {
            return const Divider();
          }),
          itemCount: getProductsByCategoryResponse.data["Names"].length),
    );

    return data;
  }

  Privacy? privacy = Privacy.Public;
  void changePrivacyOrdertoPublic(Privacy? value) {
    privacy = value;
    print(ChangePrivacytoPublic());
    print(value);
    emit(ChangePrivacytoPublic());
  }
}
