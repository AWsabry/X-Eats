// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:xeats/controllers/Components/Global%20Components/loading.dart';

// class NewProducts extends StatefulWidget {
//   const NewProducts({
//     Key? key,
//     this.image,
//     this.Colors,
//     this.Navigate,
//     required this.title,
//   }) : super(key: key);

//   final double raduisPadding = 8.0;
//   final double raduisButton = 10.0;
//   final String title;
//   final String? image;
//   final Color? Colors;
//   final VoidCallback? Navigate;

//   @override
//   State<NewProducts> createState() => _NewProductsState();
// }

// class _NewProductsState extends State<NewProducts> {
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width / 1.15;
//     double height = MediaQuery.of(context).size.height / 4;
//     return Column(
//       children: [
//         SizedBox(
//           height: height,
//           width: width,
//           child: Padding(
//             padding: EdgeInsets.all(widget.raduisPadding),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: widget.Colors,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(
//                           Radius.circular(widget.raduisButton)))),
//               onPressed: widget.Navigate,
//               child: Image(
//                 width: 200,
//                 image: CachedNetworkImageProvider(
//                   'https://x-eats.com/uploads/${widget.image!}',
//                 ),
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return const Center(
//                     child: Loading(),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//         Text(
//           widget.title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }
