// ignore_for_file: unused_import

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salsat_marketplace/controllers/auth_controller.dart';
import 'package:salsat_marketplace/controllers/comman_dailog.dart';
import 'package:salsat_marketplace/models/product.dart';
import 'package:salsat_marketplace/screens/all_chats_screen.dart';
import 'package:salsat_marketplace/screens/main_screen_dart.dart';
import 'package:salsat_marketplace/screens/profile_screen.dart';
import 'package:salsat_marketplace/screens/user_product_screen.dart';
import 'package:salsat_marketplace/widgets/image_picker.dart';
import 'package:salsat_marketplace/widgets/my_bottom_navbar.dart';
import 'package:salsat_marketplace/controllers/data_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final DataController controller = Get.put(DataController());
  var _userImageFile;
  String? _locationAddress;
  final TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isUsedProduct = false;
  Map<String, dynamic> productData = {
    "p_name": "",
    "p_price": "",
    "p_upload_date": DateTime.now().millisecondsSinceEpoch,
    "phone_number": "",
    "p_description": "", // добавлено
    "p_category": null,
    "p_location": "" ,
    "p_state":false   // добавлено
  };
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllChatsScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProductScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProductScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

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


  Future<void> _getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission(context);
      if (hasPermission) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          setState(() {
            _locationAddress =
                '${placemark.street}, ${placemark.postalCode} ${placemark.locality}, ${placemark.country}';
            _addressController.text = _locationAddress!;
          });
        }
      } else {
        // Обработать случай, когда разрешение не предоставлено
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Разрешение на доступ к геолокации'),
              content: Text(
                  'Для использования данного функционала требуется разрешение на доступ к геолокации.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Закрыть'),
                ),
                TextButton(
                  onPressed: () {
                    // Повторно запросить разрешение
                    requestLocationPermission(context);
                    Navigator.of(context).pop();
                  },
                  child: Text('Повторить запрос'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> requestLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Показать диалоговое окно с предупреждением
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Разрешение на доступ к геолокации'),
              content: Text(
                  'Для использования данного функционала требуется разрешение на доступ к геолокации.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Закрыть'),
                ),
                TextButton(
                  onPressed: () {
                    // Повторно запросить разрешение
                    requestLocationPermission(context);
                    Navigator.of(context).pop();
                  },
                  child: Text('Повторить запрос'),
                ),
              ],
            );
          },
        );
      }
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          "Жарнама қосу",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Атауы',
                      labelStyle: TextStyle(color: Colors.black)),
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
                  decoration: InputDecoration(
                      labelText: 'Бағасы',
                      labelStyle: TextStyle(color: Colors.black)),
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
                  decoration: InputDecoration(
                      labelText: 'Телефон нөмірі',
                      labelStyle: TextStyle(color: Colors.black)),
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
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: 'Сипаттама',
                      labelStyle: TextStyle(color: Colors.black)),
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
                Container(
                  width: 200, // Set the desired width
                  height: 60, // Set the desired height
                  child: DropdownButton<String>(
                  focusColor: Colors.black ,
                  iconEnabledColor: Colors.black,
                  iconDisabledColor: Colors.black,
                    hint: Text(
                      'Категория',
                      style: TextStyle(color: Colors.black),
                    ),
                    value: productData['p_category'],
                    onChanged: (String? newValue) {
                      setState(() {
                        productData['p_category'] = newValue;
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
                ),
                TextFormField(
                  controller: _addressController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Локация',
                    labelStyle: TextStyle(color: Colors.black),
                    suffixIcon: IconButton(
                      color: Colors.black,
                      onPressed: () async {
                        _getCurrentLocation();
                      },
                      icon: Icon(Icons.location_on),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Product_Location_Required'.tr;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productData['p_location'] = value!;
                  },
                ),
                SizedBox(height: 15),
                ProductImagePicker(_pickedImage),
                SizedBox(height: 5),
                Theme(
                data:ThemeData(
                  primarySwatch: Colors.blue,
                  unselectedWidgetColor: Colors.black, // Your color
                ), 
                child: CheckboxListTile(
                  title: Text('Қолданылған тауар'),
                  value: isUsedProduct,
                  onChanged: (value) {
                    setState(() {
                      isUsedProduct = value!;
                      productData['p_state'] = isUsedProduct;
                    });
                  },
                ),),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    addProduct();
                  },
                  child: Text(
                    "Тауар қосу",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
