// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:salsat_marketplace/controllers/data_controller.dart';
// import 'package:salsat_marketplace/widgets/image_picker.dart';
// import 'package:salsat_marketplace/widgets/my_bottom_navbar.dart';

// class AddMultipleProductsScreen extends StatefulWidget {
//   const AddMultipleProductsScreen({Key? key}) : super(key: key);

//   @override
//   _AddMultipleProductsScreenState createState() => _AddMultipleProductsScreenState();
// }

// class _AddMultipleProductsScreenState extends State<AddMultipleProductsScreen> {
//   DataController controller = Get.find();

//   final _formKey = GlobalKey<FormState>();
//   List<Map<String, dynamic>> productsData = [];
//   List<File> images = [];

//   void _onItemTapped(int index) {
//     // implement navigation logic...
//   }

//   void _pickedImage(File image) {
//     images.add(image);
//     print("Image got ${images.last}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         title: Text(
//           "Жарнама қосу",
//           style: TextStyle(color: Colors.black),
//         ),
//         elevation: 0,
//       ),
//       body: ListView.builder(
//         itemCount: productsData.length + 1,
//         itemBuilder: (ctx, index) {
//           if (index == productsData.length) {
//             return ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   productsData.add({
//                     "p_name": "",
//                     "p_price": "",
//                     "p_upload_date": DateTime.now().millisecondsSinceEpoch,
//                     "phone_number": "",
//                     "p_description": "",
//                     "p_category": null,
//                   });
//                 });
//               },
//               child: Text("Add Product"),
//             );
//           }
//           return Card(
//             child: Container(
//               padding: EdgeInsets.all(10),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     // add your form fields here...
//                     ProductImagePicker(_pickedImage),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           // Use your addMultipleProducts method here
//                           // You might need to modify it to use controller.addMultipleProducts
//                           // controller.addMultipleProducts(productsData, images);
//                         }
//                       },
//                       child: Text("Тауар қосу",
//                         style: TextStyle(fontSize: 20),),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: MyBottomNavigationBar(
//         currentIndex: 2,  // adjust as per your requirement
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }
