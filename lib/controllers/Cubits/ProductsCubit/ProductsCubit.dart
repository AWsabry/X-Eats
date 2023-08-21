import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xeats/controllers/Components/Product%20Class/Products_Class.dart';
import 'package:xeats/controllers/Cubits/OrderCubit/OrderCubit.dart';
import 'package:xeats/controllers/Cubits/ProductsCubit/ProductsStates.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/core/Constants/constants.dart';

enum Privacy { Private, Public }

class ProductsCubit extends Cubit<ProductsStates> {
  ProductsCubit() : super(SuperProductsStates());
  static ProductsCubit get(context) => BlocProvider.of(context);
  TextEditingController searchController = TextEditingController();

  List<dynamic> MostSold = [];
  Map itemImages = {};
  bool? NoMostSoldProducts;
  void GetMostSoldProducts(context) {
    MostSold.clear();
    emit(mostSoldProductsStateLoading());
    DioHelper.getdata(
        url:
            'get_products_mostSold_products/${OrderCubit.PublicLocationId! + 1}',
        query: {}).then((value) async {
      MostSold = value.data['Names'];
      if (MostSold.isEmpty) {
        NoMostSoldProducts = true;
      } else {
        NoMostSoldProducts = false;
      }
      emit(MostSoldProductsStateSuccessfull());
    }).catchError((error) {});
  }

  static List<dynamic> new_products = [];
  bool NoNewProducts = false;

  void NewProducts(context) {
    emit(newProductsStateLoading());
    DioHelper.getdata(
        url: 'get_products_new_products/${OrderCubit.PublicLocationId! + 1}',
        query: {}).then((value) {
      new_products = value.data['Names'];
      if (new_products.isEmpty) {
        NoNewProducts = true;
      } else {
        NoNewProducts = false;
      }
      emit(NewProductsStateSuccessfull());
    }).catchError((error) {
      emit(newProductsStateFailed(error));
    });
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
  var data;
  Future getListOfProducts(
    BuildContext context, {
    required String? CatId,
    required String? category,
    required String? restaurantName,
  }) async {
    await Dio()
        .get(
            "${AppConstants.BaseUrl}/get_products_of_restaurant_by_category/$id/$CatId")
        .then((value) {})
        .catchError((onError) {});
    data = Expanded(
      child: ListView.separated(
          separatorBuilder: ((context, index) {
            return const Divider();
          }),
          itemBuilder: (context, index) {
            return ProductClass(
              itemImage: image[index],
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
                image: image[index],
                category: category_name[index],
                CatId: CatId,
                restaurantName: restaurant_name[index],
                price: price[index]);
          },
          itemCount: ProductId.length),
    );

    return data;
  }

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
  Future<void> SearchOnListOfProduct(BuildContext context) async {
    await Future.wait(ProductId.map((productId) async {
      try {
        final response = await Dio()
            .get('${AppConstants.BaseUrl}/get_products_by_id/$productId');
        final name = response.data['Names'][0];

        image.add(name['image']);
        restaurant_name.add(name['restaurant_name']);
        category_name.add(name['category_name']);
        category.add(name['category']);
        isNewProduct.add(name['New_Products']);
        isMostPopular.add(name['Most_Popular']);
        isBestOffer.add(name['Best_Offer']);
        creationDate.add(name['created']);
        description.add(name['description']);
        restaurant.add(name['Restaurant']);
        id.add(name['id']);
        price.add(name['price']);
        EnglishName.add(name['name']);
        ArabicName.add(name['ArabicName']);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(milliseconds: 1500),
            content: Text('Something went wrong. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }));

    emit(SearhOnProductSuccessfull());
  }

  List<int> ProductId = [];

  Future GetIdOfProducts(
    BuildContext context, {
    required String? id,
  }) async {
    await Dio()
        .get("${AppConstants.BaseUrl}/get_products_by_restaurant_id/$id")
        .then((value) async {
      var products = value.data["Names"].where((product) =>
          product["name"]
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          product["ArabicName"]
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()));

      ProductId = products
          .where((product) => product["id"] is int)
          .map<int>((product) => product["id"] as int)
          .toList();
    });
    emit(ProductIdSuccessful());
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
        .get(
            "${AppConstants.BaseUrl}/get_products_of_restaurant_by_category/$id/$CatId")
        .then((value) async {
      data = Expanded(
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ProductClass(
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
              return const Divider();
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

  Privacy? privacy = Privacy.Public;
  void changePrivacyOrdertoPublic(Privacy? value) {
    privacy = value;
    print(ChangePrivacytoPublic());
    print(value);
    emit(ChangePrivacytoPublic());
  }
}
