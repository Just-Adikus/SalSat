import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:sal_sat/generated/locale_keys.g.dart';
import 'package:sal_sat/models/product_model.dart';
import 'package:sal_sat/views/search_screen.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:easy_localization/easy_localization.dart';
// import  'package:easy_localization/src/public_ext.dart';
import '/controllers/data_controller.dart';
import '/views/addproduct_screen.dart';
import '/views/drawer_screen.dart';
import '/views/product_detail_screen.dart';
import 'package:expandable_text/expandable_text.dart';

class FavoritesScreen extends StatelessWidget {
  final DataController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'.tr),
        centerTitle: true,
      ),
      body: GetBuilder<DataController>(
        id: 'favoritesBuilder',
        builder: (controller) => controller.favoriteProducts.isEmpty
            ? Center(
                child: Text('No_Favorites_Found'.tr),
              )
            : ListView.builder(
                itemCount: controller.favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.favoriteProducts[index];
                  return InkWell(
                    onTap: () async {
                      Map<String, dynamic> userDetails =
                          await controller.getUserById(product.userId);
                      Get.to(() => ProductDetailScreen(
                          product: product, userDetails: userDetails));
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            child: Image.network(
                              product.productimage,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "${'Product_Name'.tr}: ${product.productname}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${'Product_Price'.tr} : ${product.productprice.toString()}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(height: 10),
                                Flexible(
                                  child: Text(
                                    '${'Product_Description'.tr}: ${product.productdescription}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // ElevatedButton(
                          //     onPressed: () {
                          //       controller.removeProductFromFavorites(product);
                          //     },
                          //     child: Text("Remove from favorites"),
                          //   ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}