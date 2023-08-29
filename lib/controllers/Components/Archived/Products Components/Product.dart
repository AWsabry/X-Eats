// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:xeats/controllers/Components/General%20Components/Components.dart';

// class Product extends StatefulWidget {
//   const Product({
//     Key? key,
//     this.Data,
//     this.Assets,
//     this.Price,
//   }) : super(key: key);
//   final String? Data;
//   final String? Assets;
//   final String? Price;
//   @override
//   State<Product> createState() => _ProductState();
// }

// class _ProductState extends State<Product> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height / 4,
//         ),
//         InkWell(
//           onTap: () {
//             Navigation(context, widget);
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Row(
//               children: [
//                 Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       image: DecorationImage(
//                         image: AssetImage('${widget.Assets}'),
//                         fit: BoxFit.cover,
//                       )),
//                 ),
//                 const SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: SizedBox(
//                     height: 120,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             "${widget.Data}",
//                             style: GoogleFonts.poppins(fontSize: 20),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Text(
//                           '${widget.Price}',
//                           style: const TextStyle(color: Colors.black),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
