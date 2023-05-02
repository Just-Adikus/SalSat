// import 'package:sal_sat/generated/locale_keys.g.dart';

import '/controllers/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:easy_localization/easy_localization.dart';
// import  'package:easy_localization/src/public_ext.dart';
class LoginUserProductScreen extends StatefulWidget {
  const LoginUserProductScreen({Key? key}) : super(key: key);

  @override
  State<LoginUserProductScreen> createState() => _LoginUserProductScreenState();
}

class _LoginUserProductScreenState extends State<LoginUserProductScreen> {
  final DataController controller = Get.find();

  final editPriceValue = TextEditingController();

  editProduct(productID, produtPrice) {
    editPriceValue.text = produtPrice.toString();
    Get.bottomSheet(
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        child: Container(
          color: Colors.white,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Enter_new_price'.tr),
                  controller: editPriceValue,
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.editProduct(productID, editPriceValue.text);
                  },
                  child: Text('Submit'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getLoginUserProduct();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('My_Product'.tr),
      ),
      body: GetBuilder<DataController>(
        builder: (controller) => controller.loginUserData.isEmpty
            ? Center(
                child: Text('NO_DATA_FOUND_PLEASE_ADD_DATA'.tr),
              )
            : ListView.builder(
                itemCount: controller.loginUserData.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: Image.network(
                            controller.loginUserData[index].productimage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${'Product_Name'.tr}: ${controller.loginUserData[index].productname}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${'Product_Price'.tr}: ${controller.loginUserData[index].productprice.toString()}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${'Product_Description'.tr}: ${controller.loginUserData[index].productdescription}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${'Product_Category'.tr}: ${controller.loginUserData[index].productcategory}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  editProduct(
                                      controller.loginUserData[index].productId,
                                      controller
                                          .loginUserData[index].productprice);
                                },
                                child: Text('Edit'.tr),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  controller.deleteProduct(controller
                                      .loginUserData[index].productId);
                                },
                                child: Text('Delete'.tr),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
