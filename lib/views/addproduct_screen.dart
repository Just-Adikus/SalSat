import 'dart:io';

// import 'package:sal_sat/generated/locale_keys.g.dart';

import 'package:sal_sat/common/category_translations.dart';

import '/controllers/data_controller.dart';
import '/views/product_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:easy_localization/easy_localization.dart';
// import  'package:easy_localization/src/public_ext.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  DataController controller = Get.find();
  var _userImageFile;

  final _formKey = GlobalKey<FormState>();
Map<String, dynamic> productData = {
  "p_name": "",
  "p_price": "",
  "p_upload_date": DateTime.now().millisecondsSinceEpoch,
  "phone_number": "",
  "p_description": "", // добавлено
  "p_category":null, // добавлено
};


//add this method in AddProductScreen
  void _pickedImage(File image) {
    _userImageFile = image;
    print("Image got $_userImageFile");
  }

  addProduct() {
    if (_userImageFile == null) {
      Get.snackbar(
        "Opps",
        "Image Required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Theme.of(context).errorColor,
        colorText: Colors.white,
      );
      return;
    }

    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      print("Form is vaid ");

      print('Data for new product $productData');
      controller.addNewProduct(productData, _userImageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(('Add_New_Product'.tr)),
      ),
      body: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Product_Name'.tr,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product_Name_Required'.tr;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productData['p_name'] = value!;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Product_Price'.tr),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product_Price_Required'.tr;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productData['p_price'] = value!;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText:'Phone_Number'.tr),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone_Number_Required'.tr;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productData['phone_number'] = value!;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Product_Description'.tr),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product_Description_Required'.tr;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productData['p_description'] = value!;
                  },
                ),
                  DropdownButton<String>(
                  hint: Text('Product_Category'.tr),
                  value: productData['p_category'],
                  onChanged: (String? newValue) {
                    setState(() {
                      productData['p_category'] = newValue;
                    });
                  },
                  items: controller.categories.map<DropdownMenuItem<String>>((String categoryKey) {
                    return DropdownMenuItem<String>(
                      value: categoryKey,
                      child: Text(categoryTranslations[categoryKey]![Get.locale!.languageCode]!),
                    );
                  }).toList(),
                ),
                // TextFormField(
                //   keyboardType: TextInputType.text,
                //   decoration: InputDecoration(labelText: 'Product_Category'.tr),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Product_Category_Required'.tr;
                //     }
                //     return null;
                //   },
                //   onSaved: (value) {
                //     productData['p_category'] = value!;
                //   },
                // ),

                ProductImagePicker(_pickedImage),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: addProduct,
                  child: Text( 'Submit_Add'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
