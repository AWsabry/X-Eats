import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xeats/X-Eats%20Delivery/calssificationFunctions.dart';

/////////////////////Phase 2///////////////////////
// void main() {
//   runApp(const MaterialApp(home: DeliveryScreen()));
// }

// Set<Marker> markers = Set<Marker>();

// class DeliveryScreen extends StatefulWidget {
//   const DeliveryScreen({super.key});

//   @override
//   State<DeliveryScreen> createState() => _DeliveryScreenState();
// }

// int num = 0;
// Set<Polyline> polylines = Set<Polyline>();

// class _DeliveryScreenState extends State<DeliveryScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: FutureBuilder(
//             future: LocationService.getOrdersAndChooseNearest(allOrders),
//             builder: (context, ss) {
//               if (ss.hasData) {
//                 return Stack(
//                   alignment: Alignment.bottomCenter,
//                   children: [
//                     GoogleMap(
//                       zoomControlsEnabled: false,
//                       myLocationButtonEnabled: true,
//                       myLocationEnabled: true,
//                       initialCameraPosition: const CameraPosition(
//                           target: LatLng(20.5543234567, 33.2345678765)),
//                       markers: markers,
//                       polylines: polylines,
//                       mapType: MapType.normal,
//                     ),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(children: allOrders),
//                     )
//                   ],
//                 );
//               } else {
//                 return Center(child: CircularProgressIndicator());
//               }
//             }));
//   }
// }

/////////////////////Phase 1///////////////////////

void main(List<String> args) {
  runApp(const MaterialApp(home: DeliveryScreen()));
}

int operation = 7;

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("X-Delivery"),
        actions: [
          DropdownButton(
              hint: operation == 7 ? Text("All") : Text("Today"),
              items: const [
                DropdownMenuItem(
                  child: Text("Today"),
                  value: 6,
                ),
                DropdownMenuItem(
                  child: Text("All"),
                  value: 7,
                ),
              ],
              onChanged: (value) {
                setState(() {
                  operation = value as int;
                });
              })
        ],
      ),
      body: FutureBuilder(
          future: getOrdersForDelivery(operation),
          builder: (ctx, ss) {
            print(ss.hasData);
            if (ss.hasData) {
              if (ss.data!.length == 0) {
                return const Center(
                  child: Text("No Orders for this time"),
                );
              } else {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return unpaidOrders[index];
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 5,
                      );
                    },
                    itemCount: unpaidOrders.length);
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
