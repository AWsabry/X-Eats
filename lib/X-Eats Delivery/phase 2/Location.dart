// import 'dart:ffi';

// import 'package:delivery_feature/main.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import '../DeliveryOredrs.dart';

// List<Map> orders = [
//   {
//     "id": 301,
//     "ordered_date": "2022-12-22T10:31:56.199692+02:00",
//     "paid": true,
//     "comment": "",
//     "totalPrice": 132.0,
//     "total_price_after_delivery": 142.0,
//     "flag": "Web",
//     "cancelled": false,
//     "user": 30,
//     "cart": 28,
//     "from": [31.003779, 31.415506],
//     "to": [31.004505, 31.412137]
//   },
//   {
//     "id": 341,
//     "ordered_date": "2022-12-12T06:01:56.199692+02:00",
//     "paid": true,
//     "comment": "",
//     "totalPrice": 122.0,
//     "total_price_after_delivery": 132.0,
//     "flag": "Web",
//     "cancelled": false,
//     "user": 30,
//     "cart": 22,
//     "from": [31.002209, 31.401971],
//     "to": [30.989361, 31.425521]
//   }
// ];

// Map<String, List>?
//     previousLocations; //{idOfOrder : [distance , time , polyline]}
// // this map data is for memoization to not making a request for an already measured distance

// LatLng? currentFromLocation, currentToLocation;

// /////////////////////////////
// class LocationService {
//   static const String API_KEY = "AIzaSyBZtW9sVUCyfuId91S_nEEU2N21eDc74qI";
//   static LatLng? currentLocation;
//   static void getCurrentLocation() async {
//     if (await Geolocator.checkPermission() == LocationPermission.denied) {
//       await Geolocator.requestPermission();
//     }
//     await Geolocator.getCurrentPosition().then((value) {
//       currentLocation = LatLng(value.latitude, value.longitude);
//       print("Location is done");
//     });
//   }

//   static void getDirections(LatLng from, LatLng to) async {
//     var data = await Dio().get(
//         "https://maps.googleapis.com/maps/api/directions/json?origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}&key=AIzaSyBZtW9sVUCyfuId91S_nEEU2N21eDc74qI");
//     polylines.clear();

//     List<PointLatLng> points = PolylinePoints()
//         .decodePolyline(data.data["routes"][0]["overview_polyline"]["points"]);
//     polylines.add(Polyline(
//         polylineId: PolylineId("direction"),
//         points: points
//             .map((point) => LatLng(point.latitude, point.longitude))
//             .toList()));
//     getCurrentLocation();
//     var fromCurrentToFrom = await Dio().get(
//         "https://maps.googleapis.com/maps/api/directions/json?origin=${LocationService.currentLocation!.latitude},${LocationService.currentLocation!.longitude}&destination=${from.latitude},${from.longitude}&key=AIzaSyBZtW9sVUCyfuId91S_nEEU2N21eDc74qI");
//     points = PolylinePoints().decodePolyline(
//         fromCurrentToFrom.data["routes"][0]["overview_polyline"]["points"]);
//     polylines.add(Polyline(
//         color: Colors.blue,
//         polylineId: PolylineId("direction2"),
//         points: points
//             .map((point) => LatLng(point.latitude, point.longitude))
//             .toList()));
//   }

//   static void addFromAndToLocationsMarkersOnMap(LatLng from, LatLng to) async {
//     markers.clear();
//     markers.add(Marker(
//         markerId: MarkerId("from"),
//         position: from,
//         icon:
//             BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));
//     markers.add(Marker(
//       markerId: MarkerId("to"),
//       position: to,
//     ));
//   }

//   static Future<DeliveryOrder?> getOrdersAndChooseNearest(
//       List<DeliveryOrder> orders) async {
//     /*this function must be called after the "getOrdersForDelivery" function to take the
//      all orders as a parameter for it which will be in either "unpaidOrders" or "paidOrders"
//      lists of DeliveryOrder data type, and at the end it will return the neareast order to pass
//      it to another funtion to be handeld in the backend as an accepted order from the delivery man
//       */

//     markers.clear(); // to clear all the markers on the map
//     polylines.clear(); // to clear all the polylines and directions on the map
//     int time; // this will hold the time in minutes of the trip between "Current" location and "From" location only
//     double theSmallestDistance = double
//         .infinity; // this variable is to hold the distance condition that we are testing if the current distance is less than or not and it will be in KM
//     String?
//         currentPolylineData; // to store the polyline of the nearest order to use it in the next steps in drawing the directions
//     DeliveryOrder?
//         theNearestOrder; // this variable will hold the nearest order after executing the forEach loop in line 124

//     //////////////////// this section is to get the current Location positions ///////////////////
//     if (await Geolocator.checkPermission() == LocationPermission.denied) {
//       await Geolocator.requestPermission();
//     }
//     await Geolocator.getCurrentPosition().then((pos) async {
//       currentLocation = LatLng(pos.latitude, pos.longitude);
//       /* this section is to get the distance between "from" positions in each DeliveryOrder in
//          the parameter orders list and the current user positions to get the nearest location 
//       */
//       for (DeliveryOrder dOrder in orders) {
//         if (previousLocations!.containsKey(dOrder.id)) {
//           if (theNearestOrder == null ||
//               theSmallestDistance >
//                   double.parse(previousLocations![dOrder]![0])) {
//             theNearestOrder = dOrder;
//             theSmallestDistance = double.parse(previousLocations![dOrder]![0]);
//             time = int.parse(previousLocations![dOrder]![1]);
//             currentPolylineData = previousLocations![dOrder]![0];
//           }
//         } else {
//           // this line to get the distance by google maps API
//           await Dio()
//               .get(
//                   "https://maps.googleapis.com/maps/api/directions/json?origin=${LocationService.currentLocation!.latitude},${LocationService.currentLocation!.longitude}&destination=${dOrder.from.latitude},${dOrder.from.longitude}&key=$API_KEY")
//               .then((distanceFromCurrentToFrom) {
//             var distance = distanceFromCurrentToFrom.data["routes"][0]["legs"]
//                     [0]["distance"]["text"]
//                 .split(" "); // this will be the distance
//             var time = distanceFromCurrentToFrom.data["routes"][0]["legs"][0]
//                     ["duration"]["text"]
//                 .split(" "); // this will be the time for this trip

//             previousLocations!.addAll({
//               dOrder.id: [
//                 double.parse(distance[0]),
//                 time[0],
//                 distanceFromCurrentToFrom.data["routes"][0]["overview_polyline"]
//                     ["points"]
//               ]
//             });

//             if (theNearestOrder == null ||
//                 theSmallestDistance > double.parse(distance[0])) {
//               theNearestOrder = dOrder;
//               theSmallestDistance = double.parse(distance[0]);
//               time = int.parse(time[0]);
//               currentPolylineData = distanceFromCurrentToFrom.data["routes"][0]
//                   ["overview_polyline"]["points"];
//             }
//           }).catchError((onError) => print(onError));
//         }
//       }
//       ///////////////////////////////////////////////////////////////////
//       ///
//       //////////////////// in this section we are responsible to put the markers on the map/////
//       markers.add(Marker(
//           // marker for the user's current location
//           markerId: const MarkerId("current"),
//           position: currentLocation as LatLng,
//           icon:
//               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
//       markers.add(Marker(
//           // marker for "From" location
//           markerId: const MarkerId("from"),
//           position: theNearestOrder!.from,
//           icon: BitmapDescriptor.defaultMarkerWithHue(
//               BitmapDescriptor.hueGreen)));
//       markers.add(Marker(
//         // marker for "To" location
//         markerId: const MarkerId("to"),
//         position: theNearestOrder!.to,
//       ));

//       ///////////////////////////////////////////////////////////////////////////
//       ///
//       /////////////////////// this section will decode and draw the polylines on the map ///////
//       List<PointLatLng> points =
//           PolylinePoints().decodePolyline(currentPolylineData as String);
//       polylines.add(Polyline(
//           //the direction line from current location to the "from" location
//           color: Colors.blue,
//           width: 2,
//           polylineId: PolylineId("directionFromCurrentToFrom"),
//           points: points
//               .map((point) => LatLng(point.latitude, point.longitude))
//               .toList()));
//       var distanceFromFromPlaceToDestination = await Dio().get(
//           // to get the direction data between the "From" and "To"
//           "https://maps.googleapis.com/maps/api/directions/json?origin=${theNearestOrder!.from.latitude},${theNearestOrder!.from.longitude}&destination=${theNearestOrder!.to.latitude},${theNearestOrder!.to.longitude}&key=$API_KEY");
//       points = PolylinePoints().decodePolyline(
//           distanceFromFromPlaceToDestination.data["routes"][0]
//               ["overview_polyline"]["points"]);
//       polylines.add(Polyline(
//           // the direction line from "From" location to "To" location
//           color: Colors.red,
//           width: 2,
//           polylineId: PolylineId("directionFromFromPlaceToDestination"),
//           points: points
//               .map((point) => LatLng(point.latitude, point.longitude))
//               .toList()));

//       //////////////////////////////////////////////////////////////////////
//       /////////////////////////////////////////////////////////////////////////////////
//     });
//     return theNearestOrder;
//   }
// }
