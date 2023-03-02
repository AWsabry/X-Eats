// import 'package:flutter/material.dart';

// class RestaurantClassItem extends StatelessWidget {
//   final String? image;
//   final int? restaurantId;
//   final String? restaurantName;

//   RestaurantClassItem({
//     super.key,
//     this.image,
//     this.restaurantId,
//     this.restaurantName,
//   }) {}

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           InkWell(
//             onTap: () {
//               Navigation(
//                   context,
//                   ResturantsMenu(
//                     data: Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: Row(
//                         children: [
//                           FutureBuilder(
//                             future: Dio().get(
//                                 "https://x-eats.com/get_restaurants_by_id/$restaurantId"),
//                             builder: ((context, AsyncSnapshot snapshot) {
//                               if (snapshot.hasData) {
//                                 return Container(
//                                   height: 130.h,
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color:
//                                             Color.fromARGB(74, 158, 158, 158)),
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(16.0),
//                                     child: Hero(
//                                       tag: restaurantName.toString(),
//                                       child: Image(
//                                         image: NetworkImage(
//                                           "https://x-eats.com${snapshot.data.data["Names"][0]["image"]}",
//                                         ),
//                                         loadingBuilder:
//                                             (context, child, loadingProgress) {
//                                           if (loadingProgress == null)
//                                             return child;
//                                           return Center(
//                                             child: Loading(),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 return Loading();
//                               }
//                             }),
//                           ),
//                           SizedBox(
//                             width: 20.w,
//                           ),
//                           Expanded(
//                             child: Container(
//                               height: MediaQuery.of(context).size.height / 9,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       englishName!,
//                                       style: GoogleFonts.poppins(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.bold),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     RestaurantId: restaurantId,
//                   ),
//                   duration: Duration(seconds: 2));
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Row(
//                 children: [
//                   FutureBuilder(
//                     future: Dio().get(
//                         "https://x-eats.com/get_restaurants_by_id/$restaurantId"),
//                     builder: ((context, AsyncSnapshot snapshot) {
//                       if (snapshot.hasData) {
//                         return Container(
//                           height: 130.h,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: Color.fromARGB(74, 158, 158, 158)),
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Hero(
//                               tag: restaurantName.toString(),
//                               child: Image(
//                                 image: NetworkImage(
//                                   "https://x-eats.com${snapshot.data.data["Names"][0]["image"]}",
//                                 ),
//                                 loadingBuilder:
//                                     (context, child, loadingProgress) {
//                                   if (loadingProgress == null) return child;
//                                   return Center(
//                                     child: Loading(),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         );
//                       } else {
//                         return Loading();
//                       }
//                     }),
//                   ),
//                   SizedBox(
//                     width: 20.w,
//                   ),
//                   Expanded(
//                     child: Container(
//                       height: MediaQuery.of(context).size.height / 9,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               englishName!,
//                               style: GoogleFonts.poppins(
//                                   fontSize: 13, fontWeight: FontWeight.bold),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
  
//   }
// }
