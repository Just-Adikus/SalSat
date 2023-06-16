import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salsat_marketplace/models/product.dart';
import 'package:salsat_marketplace/controllers/data_controller.dart';
import 'package:salsat_marketplace/screens/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DataController controller = Get.find<DataController>();
  TextEditingController searchController = TextEditingController();
  List filteredProducts = [];

  double? minPrice;
  double? maxPrice;
  String? selectedCategory;

  void filterProducts(String searchText, double? minPrice, double? maxPrice,
      String? selectedCategory) {
    List<Product> products = controller.allProduct;
    List<Product> tempFilteredProducts = [];

    products.forEach((product) {
      if (product.productname
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        if (minPrice != null &&
            maxPrice != null &&
            product.productprice >= minPrice &&
            product.productprice <= maxPrice) {
          if (selectedCategory != null &&
              product.productcategory == selectedCategory) {
            tempFilteredProducts.add(product);
          } else if (selectedCategory == null) {
            tempFilteredProducts.add(product);
          }
        } else if (minPrice == null && maxPrice == null) {
          if (selectedCategory != null &&
              product.productcategory == selectedCategory) {
            tempFilteredProducts.add(product);
          } else if (selectedCategory == null) {
            tempFilteredProducts.add(product);
          }
        }
      }
    });

    setState(() {
      filteredProducts = tempFilteredProducts;
    });
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double minPrice = 0;
        double maxPrice = 10000;
        String? selectedCategory;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Сүзгілеу'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // Price Range filter
                    Text("Бағасы".tr),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              minPrice = double.parse(value);
                            },
                            decoration: InputDecoration(
                              hintText: "Минималды".tr,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              maxPrice = double.parse(value);
                            },
                            decoration: InputDecoration(
                              hintText: "Максималды".tr,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Category filter
                    DropdownButton<String>(
                      hint: Text(
                        'Категория',
                        style: TextStyle(color: Colors.black),
                      ),
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      items: controller.categories
                          .map<DropdownMenuItem<String>>((String categoryKey) {
                        return DropdownMenuItem<String>(
                          value: categoryKey,
                          child: Text(categoryKey),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Тазарту'.tr),
                  onPressed: () {
                    setState(() {
                      minPrice = 0;
                      maxPrice = 10000;
                      selectedCategory = null;
                    });
                    filterProducts(searchController.text, null, null, null);
                  },
                ),
                TextButton(
                  child: Text('Қолдау'.tr),
                  onPressed: () {
                    Navigator.of(context).pop();
                    filterProducts(searchController.text, minPrice, maxPrice,
                        selectedCategory);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: searchController,
          onChanged: (text) {
            filterProducts(text, minPrice, maxPrice, selectedCategory);
          },
          decoration: InputDecoration(
            hintText: 'Іздеу',
            border: InputBorder.none,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.black,
            ),
            onPressed: showFilterDialog,
          ),
        ],
        elevation: 0,
      ),
      body: filteredProducts.isEmpty
          ? Center(
              child: Text('Not_found'.tr),
            )
          : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      product.productimage,
                      fit: BoxFit.cover,
                      width: 50,
                    ),
                    title: Text(product.productname),
                    subtitle: Text('${product.productprice}'),
                    onTap: () async {
                      Map<String, dynamic> userDetails =
                          await controller.getUserById(product.userId);
                      Get.to(() => ProductDetailScreen(
                          product: product, userDetails: userDetails));
                    },
                  ),
                );
              },
            ),
    );
  }
}
