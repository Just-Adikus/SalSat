
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salsat_marketplace/controllers/data_controller.dart';
import 'package:salsat_marketplace/screens/search_screen.dart';

class CustomSearchBar extends StatefulWidget {
  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  double _minPrice = 0;
  double _maxPrice = 1000000;
  String? _selectedCategory;
  final DataController controller = Get.find();  // Get the DataController instance using GetX

  // void _showFilterDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: Text('Сүзгілеу'),
  //             content: SingleChildScrollView(
  //               child: Column(
  //                 children: [
  //                   Text("Бағасы"),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: TextField(
  //                           keyboardType: TextInputType.number,
  //                           onChanged: (value) {
  //                             setState(() {
  //                               _minPrice = double.parse(value);
  //                             });
  //                           },
  //                           decoration: InputDecoration(
  //                             hintText: "Минималды",
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(width: 10),
  //                       Expanded(
  //                         child: TextField(
  //                           keyboardType: TextInputType.number,
  //                           onChanged: (value) {
  //                             setState(() {
  //                               _maxPrice = double.parse(value);
  //                             });
  //                           },
  //                           decoration: InputDecoration(
  //                             hintText: "Максималды",
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   DropdownButton<String>(
  //                     hint: Text(
  //                       'Категория',
  //                       style: TextStyle(color: Colors.black),
  //                     ),
  //                     value: _selectedCategory,
  //                     onChanged: (String? newValue) {
  //                       setState(() {
  //                         _selectedCategory = newValue;
  //                       });
  //                     },
  //                     items: controller.categories
  //                         .map<DropdownMenuItem<String>>((String categoryKey) {
  //                       return DropdownMenuItem<String>(
  //                         value: categoryKey,
  //                         child: Text(categoryKey),
  //                       );
  //                     }).toList(),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 child: Text('Өшіру'),
  //                 onPressed: () {
  //                   setState(() {
  //                     _minPrice = 0;
  //                     _maxPrice = 10000;
  //                     _selectedCategory = null;
  //                   });
  //                 },
  //               ),
  //               TextButton(
  //                 child: Text('Қолдану'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                   _applyFilters();
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // void _applyFilters() {
  //   // Здесь нужно применить фильтры и обновить данные
  // }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onTap: () {
            Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchScreen()),
    );
        // _showFilterDialog();
      },
      onChanged: (value) {
        setState(() {
          _searchText = value;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: 'Іздеу',
        hintStyle: TextStyle(
          letterSpacing: 0,
        ),
        alignLabelWithHint: true,
        prefixIcon: Icon(Icons.search, color: Colors.black),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear, color: Colors.black),
          onPressed: () {
            setState(() {
              _searchController.clear();
              _searchText = '';
            });
          },
        ),
      ),
    );
  }
}
