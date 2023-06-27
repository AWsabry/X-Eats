// // ignore_for_file: use_build_context_synchronously, must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:xeats/controllers/Components/AppBar/AppBarCustomized.dart';
// import 'package:xeats/controllers/Components/General%20Components/Components.dart';
// import 'package:xeats/controllers/Cubits/ButtomNavigationBarCubit/navigationCubit.dart';
// import 'package:xeats/controllers/Cubits/RestauratsCubit/RestaurantsStates.dart';
// import 'package:xeats/controllers/Cubits/RestauratsCubit/RestuarantsCubit.dart';
// import 'package:xeats/views/Profile/Profile.dart';
// import 'package:xeats/views/Resturants/Resturants.dart';
// import '../../controllers/Components/Global Components/loading.dart';

// class SearchRestaurantsScreen extends StatefulWidget {
//   SearchRestaurantsScreen({
//     super.key,
//     required this.RestaurantId,
//     required this.imageOfRestaurant,
//     required this.restaurant_nameFromSearching,
//     required this.Restuarantsdata,
//   });
//   List<int> RestaurantId = [];
//   List<String> restaurant_nameFromSearching = [];
//   List<String> imageOfRestaurant = [];
//   List<dynamic> Restuarantsdata = [];

//   @override
//   State<SearchRestaurantsScreen> createState() =>
//       _SearchRestaurantsScreenState();
// }

// class _SearchRestaurantsScreenState extends State<SearchRestaurantsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RestuarantsCubit, RestuarantsStates>(
//       builder: (context, state) {
//         var navcubit = NavBarCubitcubit.get(context);

//         return Scaffold(
//           appBar: appBar(context,
//               title: "Restaurants Searching", subtitle: "Restarants Names"),
//           body: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                       width: MediaQuery.of(context).size.width * 0.8,
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: TextField(
//                         decoration: const InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 9),
//                             border: InputBorder.none,
//                             focusedBorder: InputBorder.none,
//                             enabledBorder: InputBorder.none,
//                             hintText: "Search For Restaurants",
//                             prefixIcon: Icon(Icons.search)),
//                         controller: RestuarantsCubit.get(context)
//                             .searchRestaurantsController,
//                         onSubmitted: (value) async {
//                           RestuarantsCubit.get(context).clearRestaurantId();
//                           await RestuarantsCubit.get(context)
//                               .GetIdOfResutarant(context)
//                               .then((value) {
//                             if (RestuarantsCubit.get(context)
//                                 .restaurant_nameFromSearching
//                                 .toString()
//                                 .toLowerCase()
//                                 .contains(RestuarantsCubit.get(context)
//                                     .searchRestaurantsController
//                                     .text
//                                     .toLowerCase())) {
//                               NavigationToSameScreen(
//                                   context,
//                                   SearchRestaurantsScreen(
//                                     restaurant_nameFromSearching:
//                                         RestuarantsCubit.get(context)
//                                             .restaurant_nameFromSearching,
//                                     RestaurantId: RestuarantsCubit.get(context)
//                                         .RestaurantId,
//                                     Restuarantsdata:
//                                         RestuarantsCubit.get(context)
//                                             .Restuarantsdata,
//                                     imageOfRestaurant:
//                                         RestuarantsCubit.get(context)
//                                             .imageOfRestaurant,
//                                   ));
//                             } else {
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(SnackBar(
//                                 duration: const Duration(milliseconds: 1500),
//                                 content: Text(
//                                     "There isn't Restaurant called ${RestuarantsCubit.get(context).searchRestaurantsController}"),
//                                 backgroundColor: Colors.red,
//                               ));
//                             }
//                           });
//                         },
//                       )),
//                   FutureBuilder(
//                       future:
//                           RestuarantsCubit.get(context).getListOfRestuarants(
//                         context,
//                         RestaurantId: widget.RestaurantId,
//                         restaurant_nameFromSearching:
//                             widget.restaurant_nameFromSearching,
//                         Restuarantsdata: widget.Restuarantsdata,
//                         imageOfRestaurant: widget.imageOfRestaurant,
//                       ),
//                       builder: ((context, snapshot) {
//                         if (snapshot.hasData) {
//                           return snapshot.data!;
//                         } else {
//                           return Center(
//                             child: Loading(),
//                           );
//                         }
//                       })),
//                 ],
//               ),
//             ),
//           ),
//           bottomNavigationBar: BottomNavigationBar(
//             selectedLabelStyle: GoogleFonts.poppins(),
//             backgroundColor: Colors.white,
//             items: navcubit.bottomitems,
//             currentIndex: 0,
//             onTap: (index) {
//               Navigator.pop(context);
//               RestuarantsCubit.get(context).clearRestaurantId();
//               if (index == 0) {
//                 RestuarantsCubit.get(context).clearRestaurantId();
//               } else if (index == 1) {
//                 RestuarantsCubit.get(context).clearRestaurantId();
//                 Navigation(context, const Restaurants());
//               } else {
//                 RestuarantsCubit.get(context).clearRestaurantId();
//                 Navigation(context, const Profile());
//               }
//             },
//           ),
//         );
//       },
//     );
//   }
// }
