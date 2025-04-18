import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:xeats/controllers/Cubits/AuthCubit/cubit.dart';
import 'package:xeats/controllers/Cubits/RestauratsCubit/RestaurantsStates.dart';
import 'package:xeats/controllers/Dio/DioHelper.dart';
import 'package:xeats/core/Constants/constants.dart';

class RestuarantsCubit extends Cubit<RestuarantsStates> {
  RestuarantsCubit() : super(SuperRestuarantsStates());
  static RestuarantsCubit get(context) => BlocProvider.of(context);

//--------- Get The All Resturants Inside The resturants Menu Widget --------/////////////
  Response? restaurantByCategoryResponse;
  String? restaurantByCategoryImage;
  Future<Response?> getRestaurantCategories(
    BuildContext context, {
    required String? restaurantId,
    required String? image,
    required String? restaurantName,
  }) async {
    try {
      restaurantByCategoryResponse = await Dio().get(
          "${AppConstants.BaseUrl}/get_category_of_restaurants/$restaurantId");
    } catch (error) {
      Logger().e("Error In Category Restarants");
    }
    return restaurantByCategoryResponse;
  }

  TextEditingController searchRestaurantsController = TextEditingController();
  var RestuarantsUI;
  //---------Display The UI result of searching about resturants--------/////
  // Future getListOfRestuarants(
  //   BuildContext context, {
  //   required List<dynamic>? Restuarantsdata,
  //   required List<int>? RestaurantId,
  //   required List<String>? imageOfRestaurant,
  //   required List<String>? restaurant_nameFromSearching,
  // }) async {
  //   await Dio()
  //       .get("${AppConstants.BaseUrl}/get_restaurants")
  //       .then((value) {})
  //       .catchError((onError) {});
  //   RestuarantsUI = Column(
  //     children: [
  //       Row(
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(15.0),
  //             child: Text('Restaurants Founded',
  //                 style: Theme.of(context).textTheme.titleSmall),
  //           ),
  //         ],
  //       ),
  //       ListView.separated(
  //         shrinkWrap: true,
  //         physics: const BouncingScrollPhysics(),
  //         itemBuilder: (context, index) {
  //           if (imageOfRestaurant![index] == null) {
  //             return const Loading();
  //           } else {
  //             return InkWell(
  //               onTap: () {
  //                 Navigation(
  //                     context,
  //                     ResturantsMenu(
  //                       data: Restuarantsdata![index],
  //                       RestaurantId: RestaurantId[index],
  //                     ));
  //               },
  //               child: Row(children: [
  //                 Container(
  //                   height: 130.h,
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                       color: Theme.of(context).primaryColor,
  //                     ),
  //                     borderRadius: BorderRadius.circular(10.0),
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(16.0),
  //                     child: CachedNetworkImage(
  //                       progressIndicatorBuilder: (context, url, progress) =>
  //                           const Center(
  //                         child: Loading(
  //                             // value: progress.progress,
  //                             ),
  //                       ),
  //                       imageUrl:
  //                           '${AppConstants.BaseUrl}${imageOfRestaurant[index]}',
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 20.w,
  //                 ),
  //                 Expanded(
  //                   child: SizedBox(
  //                     height: MediaQuery.of(context).size.height / 7,
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         Column(children: [
  //                           Text(
  //                               overflow: TextOverflow.ellipsis,
  //                               maxLines: 1,
  //                               restaurant_nameFromSearching![index],
  //                               style: GoogleFonts.poppins(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 18,
  //                               )),
  //                         ]),
  //                         SizedBox(
  //                           height: 10.h,
  //                         ),
  //                         const Row(children: [
  //                           Icon(
  //                             Icons.star,
  //                             color: Colors.amber,
  //                           ),
  //                           Text(' 4.1'),
  //                           Text(' (100+)')
  //                         ]),
  //                         SingleChildScrollView(
  //                           scrollDirection: Axis.horizontal,
  //                           child: Row(
  //                             children: [
  //                               const Icon(Icons.timer_sharp),
  //                               Text(
  //                                 ' 45 mins',
  //                                 style: GoogleFonts.poppins(
  //                                     fontWeight: FontWeight.w400),
  //                               ),
  //                               SizedBox(
  //                                 width: 15.w,
  //                               ),
  //                               const Icon(Icons.delivery_dining_outlined),
  //                               SizedBox(
  //                                 width: 2.w,
  //                               ),
  //                               Text(
  //                                 'X-Eats Delivery',
  //                                 style: GoogleFonts.poppins(
  //                                     fontWeight: FontWeight.w400),
  //                               ),
  //                             ],
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ]),
  //             );
  //           }
  //         },
  //         separatorBuilder: (context, index) {
  //           return const Divider();
  //         },
  //         itemCount: RestaurantId!.length,
  //       )
  //     ],
  //   );

  //   return RestuarantsUI;
  // }

  List<dynamic> RestuarantsSearchedList = [];
  bool isSearched = false;
  void searchOnRestaurants(String value) {
    emit(LoadingSearchingState());
    DioHelper.getdata(url: "get_searched_restaurants/$value").then((value) {
      RestuarantsSearchedList = value.data["Names"];
      emit(RestaurantsFounded());
    }).catchError((onError) {
      print(onError);
    });
  }

//---------- Clear The ID Because Searching more than once
  void clearRestaurantsSearched() {
    RestuarantsSearchedList.clear();
    emit(ClearRestaurantsSearchList());
  }

  final List<String> restaurant_nameFromSearching = [];

  final List<String> imageOfRestaurant = [];
  static Map currentRestaurant = {};

//----- Knowing the avalable order restuarants that allowed to user to show
  Future<void> getCurrentAvailableOrderRestauant(context) async {
    var getCurrentAvailableOrderRestauantResponse = await Dio().get(
        "${AppConstants.BaseUrl}/get_user_cartItems/${AuthCubit.get(context).userEmailShared}");

    if (getCurrentAvailableOrderRestauantResponse.data["Names"].length == 0) {
      currentRestaurant = {};
    } else {
      final dataFromApi = await Dio().get(
          "${AppConstants.BaseUrl}/get_restaurants_by_id/${getCurrentAvailableOrderRestauantResponse.data["Names"][0]["Restaurant"]}");
      currentRestaurant = dataFromApi.data["Names"][0];
    }
  }

  Future<String?> getRestaurantName(String id) async {
    String? restaurantName;
    try {
      var getRestaurantNameResponse =
          await Dio().get("${AppConstants.BaseUrl}/get_restaurants_by_id/$id");

      restaurantName =
          getRestaurantNameResponse.data["Names"][0]["Name"].toString();
    } catch (error) {
      Logger().e("getRestaurantName error $error");
    }
    return restaurantName;
  }
}
