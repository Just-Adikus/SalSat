import 'dart:convert';
import 'dart:io';

import 'package:sal_sat/common/category_translations.dart';

import '/controllers/auth_controller.dart';
import '/controllers/comman_dailog.dart';
import '/models/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart ' as http;

class DataController extends GetxController {
  final firebaseInstance = FirebaseFirestore.instance;
  Map userProfileData = {'userName': '', 'joinDate': ''};

  List<Product> loginUserData = [];

  List<Product> allProduct = [];
 
  List<Product> favoriteProducts = [];

  Function()? _onFavoritesUpdated;

  List<String> categories = categoryTranslations.keys.toList();

  // static const String API_URL = "https://your-server-url.com/api/";
  // static const String secret_key = "sk_test_51MwWpMCDtVBvbUR2eRefBTt4U9h01T8bDC5EDAUSdCv1MLvjV1vPVIHS40YbIS4GuifE8SDvCnm2S94AYyeVUl4S000cxS4xks";
  // static const Map<String, String> HEADERS = {
  //   "Content-Type": "application/json",
  //   "Authorization": "Bearer $secret_key",
  // };


  AuthController authController = Get.find();

  void onReady() {
    super.onReady();
    getAllProduct();
    getUserProfileData();
    getFavoriteProducts();
  }

  Future<void> getUserProfileData() async {
    try {
      var response = await firebaseInstance
          .collection('userslist')
          .where('user_Id', isEqualTo: authController.userId)
          .get();
      if (response.docs.length > 0) {
        userProfileData['userName'] = response.docs[0]['user_name'];
        userProfileData['joinDate'] = response.docs[0]['joinDate'];
      }
      print(userProfileData);
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  Future<void> addNewProduct(Map productdata, File image) async {
    var pathimage = image.toString();
    var temp = pathimage.lastIndexOf('/');
    var result = pathimage.substring(temp + 1);
    print(result);
    final ref =
        FirebaseStorage.instance.ref().child('product_images').child(result);
    var response = await ref.putFile(image);
    print("Updated $response");
    var imageUrl = await ref.getDownloadURL();

    try {
      CommanDialog.showLoading();
      var response = await firebaseInstance.collection('productlist').add({
        'product_name': productdata['p_name'],
        'product_price': productdata['p_price'],
        "product_upload_date": productdata['p_upload_date'],
        'product_image': imageUrl,
        'user_Id': authController.userId,
        "phone_number": productdata['phone_number'],
        'product_description': productdata['p_description'], // добавлено
        'product_category': productdata['p_category'], // добавлено
      });
      print("Firebase response1111 $response");
      CommanDialog.hideLoading();
      Get.back();
    } catch (exception) {
      CommanDialog.hideLoading();
      print("Error Saving Data at firestore $exception");
    }
  }

  Future<void> getLoginUserProduct() async {
    print("loginUserData YEs $loginUserData");
    loginUserData = [];
    try {
      CommanDialog.showLoading();
      final List<Product> lodadedProduct = [];
      var response = await firebaseInstance
          .collection('productlist')
          .where('user_Id', isEqualTo: authController.userId)
          .get();

      if (response.docs.length > 0) {
        response.docs.forEach(
          (result) {
            print(result.data());
            print("Product ID  ${result.id}");
            lodadedProduct.add(
              Product(
                  productId: result.id,
                  userId: result['user_Id'],
                  productname: result['product_name'],
                  productprice: double.parse(result['product_price']),
                  productimage: result['product_image'],
                  phonenumber: int.parse(result['phone_number']),
                  productuploaddate: result['product_upload_date'].toString(),
                  productdescription:
                      result['product_description'], // обновлено
                  productcategory: result['product_category']), // обновлено
            );
          },
        );
      }
      loginUserData.addAll(lodadedProduct);
      update();
      CommanDialog.hideLoading();
    } on FirebaseException catch (e) {
      CommanDialog.hideLoading();
      print("Error $e");
    } catch (error) {
      CommanDialog.hideLoading();
      print("error $error");
    }
  }

  Future<Map<String, dynamic>> getUserById(String userId) async {
    try {
      var userResponse = await firebaseInstance
          .collection('userslist')
          .where('user_Id', isEqualTo: userId)
          .get();
      if (userResponse.docs.length > 0) {
        var userData = userResponse.docs[0].data();
        var userName = userData['user_name'];
        var phoneNumber = userData['phone_number'];
        return {'userName': userName, 'phoneNumber': phoneNumber};
      }
    } on FirebaseException catch (e) {
      print("Error $e");
    } catch (error) {
      print("error $error");
    }
    return {};
  }

  Future<void> getAllProduct() async {
    allProduct = [];
    try {
      CommanDialog.showLoading();
      final List<Product> lodadedProduct1 = [];
      var response = await firebaseInstance
          .collection('productlist')
          .where('user_Id', isNotEqualTo: authController.userId)
          .get();
      if (response.docs.length > 0) {
        response.docs.forEach(
          (result) {
            print(result.data());
            print(result.id);
            lodadedProduct1.add(
              Product(
                  productId: result.id,
                  userId: result['user_Id'],
                  productname: result['product_name'],
                  productprice: double.parse(result['product_price']),
                  productimage: result['product_image'],
                  phonenumber: int.parse(result['phone_number']),
                  productuploaddate: result['product_upload_date'].toString(),
                  productdescription:
                      result['product_description'], // обновлено
                  productcategory: result['product_category']), // обновлено
            );
          },
        );
        allProduct.addAll(lodadedProduct1);
        update();
      }

      CommanDialog.hideLoading();
    } on FirebaseException catch (e) {
      CommanDialog.hideLoading();
      print("Error $e");
    } catch (error) {
      CommanDialog.hideLoading();
      print("error $error");
    }
  }

  Future editProduct(productId, price) async {
    print("Product Id  $productId");
    try {
      CommanDialog.showLoading();
      await firebaseInstance
          .collection("productlist")
          .doc(productId)
          .update({"product_price": price}).then((_) {
        CommanDialog.hideLoading();
        getLoginUserProduct();
      });
    } catch (error) {
      CommanDialog.hideLoading();
      CommanDialog.showErrorDialog();

      print(error);
    }
  }

  Future deleteProduct(String productId) async {
    print("Product Iddd  $productId");
    try {
      CommanDialog.showLoading();
      await firebaseInstance
          .collection("productlist")
          .doc(productId)
          .delete()
          .then((_) {
        CommanDialog.hideLoading();
        getLoginUserProduct();
      });
    } catch (error) {
      CommanDialog.hideLoading();
      CommanDialog.showErrorDialog();
      print(error);
    }
  }


  void setOnFavoritesUpdated(Function()? callback) {
    _onFavoritesUpdated = callback;
  }

  void addProductToFavorites(Product product) {
    if (!favoriteProducts.contains(product)) {
      favoriteProducts.add(product);
      update(['favoritesBuilder']);
    }
  }

  void removeProductFromFavorites(Product product) {
    favoriteProducts.remove(product);
    update(['favoritesBuilder']);
  }

 bool isProductInFavorites(Product product) {
  return favoriteProducts.contains(product);
}

Future<void> getFavoriteProducts() async {
  favoriteProducts = [];
  try {
    CommanDialog.showLoading();
    final List<Product> lodadedProduct = [];
    var response = await firebaseInstance
        .collection('productlist')
        .where('user_Id', isEqualTo: authController.userId)
        .get();

    if (response.docs.length > 0) {
      response.docs.forEach(
        (result) {
          print(result.data());
          print("Product ID  ${result.id}");
          lodadedProduct.add(
            Product(
                productId: result.id,
                userId: result['user_Id'],
                productname: result['product_name'],
                productprice: double.parse(result['product_price']),
                productimage: result['product_image'],
                phonenumber: int.parse(result['phone_number']),
                productuploaddate: result['product_upload_date'].toString(),
                productdescription:
                    result['product_description'], // обновлено
                productcategory: result['product_category']), // обновлено
          );
        },
      );
    }
    favoriteProducts.addAll(lodadedProduct);
    update(['favoritesBuilder']); // Добавлен вызов update
    CommanDialog.hideLoading();
  } on FirebaseException catch (e) {
    CommanDialog.hideLoading();
    print("Error $e");
  } catch (error) {
    CommanDialog.hideLoading();
    print("error $error");
  }
}

  // Future<void> createCharge(String paymentMethodId, double amount) async {
  //   final url = "${API_URL}create_charge";
  //   final body =
  //       json.encode({"paymentMethodId": paymentMethodId, "amount": amount});

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: HEADERS,
  //       body: body,
  //     );
  //     if (response.statusCode == 200) {
  //       return;
  //     } else {
  //       throw Exception("Failed to create charge: ${response.body}");
  //     }
  //   } catch (e) {
  //     throw Exception("Failed to create charge: ${e.toString()}");
  //   }
  // }

  void clearUserData() {
    loginUserData.clear();
    userProfileData = {'userName': '', 'joinDate': ''};
  }
}
