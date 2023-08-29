// import 'package:flutter/material.dart';
// import 'package:xeats/controllers/Components/Global%20Components/CustomDivider.dart';
// import 'package:xeats/controllers/Components/Products%20Components/Product.dart';

// class ProductMenu extends StatefulWidget {
//   const ProductMenu({Key? key}) : super(key: key);

//   @override
//   State<ProductMenu> createState() => _ProductMenuState();
// }

// class _ProductMenuState extends State<ProductMenu> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       physics: const BouncingScrollPhysics(),
//       itemBuilder: (context, index) => const Product(
//           Data: "Shawrma Frakh\n" "شاورما فراخ",
//           Assets: "assets/Images/Shawrma.png",
//           Price: "EGP 35.00"),
//       separatorBuilder: (context, index) => const CustomDivider(),
//       itemCount: 10,
//     );
//   }
// }
