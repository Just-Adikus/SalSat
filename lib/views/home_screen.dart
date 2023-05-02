
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:sal_sat/generated/locale_keys.g.dart';
import 'package:sal_sat/views/search_screen.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:easy_localization/easy_localization.dart';
// import  'package:easy_localization/src/public_ext.dart';
import '/controllers/data_controller.dart';
import '/views/addproduct_screen.dart';
import '/views/drawer_screen.dart';
import '/views/product_detail_screen.dart';
import 'package:expandable_text/expandable_text.dart';
class HomeScreen extends StatelessWidget {
  final DataController controller = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('All_Product_List'.tr),
        centerTitle: true,
        actions: [
          IconButton(
          onPressed: () {
              Get.to(() => SearchScreen());
            }, 
          icon:Icon(Icons.search)),
          IconButton(
            onPressed: () {
              Get.to(() => AddProductScreen());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: GetBuilder<DataController>(
        builder: (controller) => controller.allProduct.isEmpty
            ? Center(
                child: Text('NO_DATA_FOUND'.tr),
              )
            : ListView.builder(
                itemCount: controller.allProduct.length,
                itemBuilder: (context, index) {
                  final product = controller.allProduct[index];
                  return InkWell(
                    onTap: () async {
                      Map<String, dynamic> userDetails = await controller.getUserById(product.userId);
                      Get.to(() => ProductDetailScreen(product: product, userDetails: userDetails));
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
                                  "${'Product_Name'.tr} : ${product.productname}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${'Product_Price'.tr} : ${product.productprice.toString()}',
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
                                  Flexible(child: Text(
                                    '${'Product_Description'.tr}: ${product.productdescription}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                ), 
                                )             
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                    
                          //       Text(
                          //         'Uploader: ${controller.getUserById(product.userId)}',
                          //         style: TextStyle(fontWeight: FontWeight.bold),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
