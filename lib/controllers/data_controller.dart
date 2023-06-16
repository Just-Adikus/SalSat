import 'dart:convert';
import 'dart:io';
import 'package:salsat_marketplace/models/message.dart';
import '/controllers/auth_controller.dart';
import '/controllers/comman_dailog.dart';
import '/models/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart ' as http;

class DataController extends GetxController {
  final firebaseInstance = FirebaseFirestore.instance;
  Map userProfileData = {'userName': ''};

  List<Product> loginUserData = [];
  List<Product> allProduct = [];
  List<Product> favoriteProducts = [];
  List<Product> transactions = [];
  List<String> categories = <String>[
    'Телефондар мен гаджеттер',
    'Компьютерлер',
    'Балалар тауарлары',
    'Косметика',
    'Тұрмыстық техника',
    'Аксессуарлар',
    'Киім',
    'Аяқ-киім',
    'Жиһаз',
    'Авто',
    'Кеңсе тауарлары',
    'Тұрмыстық тауарлар'
  ];
  AuthController authController = Get.put(AuthController());

  void onReady() {
    super.onReady();
    getAllProduct();
    getUserProfileData();
    getFavoriteProducts();
    getUserName();
  }

  Future<void> getUserProfileData() async {
    try {
      var response = await firebaseInstance
          .collection('userslist')
          .where('user_Id', isEqualTo: authController.currentUserId)
          .get();
      if (response.docs.length > 0) {
        userProfileData['userName'] = response.docs[0]['user_name'];
      }
      print(userProfileData);
    } on FirebaseException catch (e) {
      print(e);
    } catch (error) {
      print(error);
    }
  }

  Future<String> getUserName() async {
    try {
      var response = await firebaseInstance
          .collection('userslist')
          .where('user_Id', isEqualTo: authController.currentUserId)
          .get();
      if (response.docs.length > 0) {
        String userName = response.docs[0]['user_name'];
        userProfileData['userName'] = userName;
        print(userProfileData);
        return userName;
      } else {
        throw Exception('User not found');
      }
    } on FirebaseException catch (e) {
      print(e);
      throw e; // You might want to handle this in the calling function
    } catch (error) {
      print(error);
      throw error; // You might want to handle this in the calling function
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
        'user_Id': authController!.currentUserId, // используем новый метод
        "phone_number": productdata['phone_number'],
        'product_description': productdata['p_description'],
        'product_category': productdata['p_category'],
        'productlocation': productdata['p_location'],
        'productstate': productdata['p_state'] ?? false,
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
          .where('user_Id', isEqualTo: authController.currentUserId)
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
                productprice: result['product_price'] is double
                    ? result['product_price']
                    : double.parse(result['product_price']),
                productimage: result['product_image'],
                phonenumber: result['phone_number'],
                productuploaddate: result['product_upload_date'].toString(),
                productdescription: result['product_description'], // обновлено
                productcategory: result['product_category'],
                productlocation: result['productlocation'],
                productstate: result['productstate'] ?? false,
              ), // обновлено
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

  Future<Map<String, dynamic>> getUserNameById(String userId) async {
    try {
      var userResponse = await firebaseInstance
          .collection('userslist')
          .where('user_Id', isEqualTo: userId)
          .get();
      if (userResponse.docs.length > 0) {
        var userData = userResponse.docs[0].data();
        var userId = userData['user_Id'];
        var userName = userData['user_name'];
        return {'userName': userName, 'userId': userId};
      }
    } on FirebaseException catch (e) {
      print("Error $e");
    } catch (error) {
      print("error $error");
    }
    return {};
  }

  Future<List<Product>> getAllProduct() async {
    allProduct = [];
    try {
      final List<Product> loadedProducts = [];

      var response = await firebaseInstance
          .collection('productlist')
          .where('user_Id', isNotEqualTo: authController.currentUserId)
          .get();

      if (response.docs.length > 0) {
        response.docs.forEach((result) {
          print(result.data());
          print(result.id);
          final dynamic productPrice = result['product_price'];
          final bool productState = result['productstate'];
          loadedProducts.add(
            Product(
              productId: result.id,
              userId: result['user_Id'],
              productname: result['product_name'],
              productprice: double.parse(productPrice.toString()),
              productimage: result['product_image'],
              phonenumber: result['phone_number'],
              productuploaddate: result['product_upload_date'].toString(),
              productdescription: result['product_description'],
              productcategory: result['product_category'],
              productlocation: result['productlocation'],
              productstate: productState,
            ),
          );
        });
        allProduct.addAll(loadedProducts);
        update();
        print("Products: $loadedProducts");
      }
    } on FirebaseException catch (e) {
      print("Error: $e");
    } catch (error) {
      print("Error: $error");
    }

    return allProduct;
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

  Future<void> addProductToFavorites(Product product) async {
    try {
      if (product.userId != userProfileData['userId']) {
        // Добавление товара в коллекцию 'favorites' в Firestore
        await firebaseInstance.collection('favorites').add({
          'userId': authController.currentUserId,
          'productId': product.productId,
        });
        // Обновление списка favoriteProducts
        favoriteProducts.add(product);
        update(['favoritesBuilder']);
      }
    } catch (e) {
      print("Error adding product to favorites: $e");
    }
  }

  Future<void> removeProductFromFavorites(Product product) async {
    try {
      var favoriteDoc = await firebaseInstance
          .collection('favorites')
          .where('userId', isEqualTo: authController.currentUserId)
          .where('productId', isEqualTo: product.productId)
          .limit(1)
          .get();
      if (favoriteDoc.docs.isNotEmpty) {
        await firebaseInstance
            .collection('favorites')
            .doc(favoriteDoc.docs.first.id)
            .delete();
      }
      // Обновление списка favoriteProducts
      favoriteProducts.remove(product);
      update(['favoritesBuilder']);
    } catch (e) {
      print("Error removing product from favorites: $e");
    }
  }

// Проверка наличия товара в избранном
  Future<bool> isProductInFavorites(Product product) async {
    try {
      // Поиск товара в коллекции 'favorites' в Firestore
      var favoriteDoc = await firebaseInstance
          .collection('favorites')
          .where('userId', isEqualTo: authController.currentUserId)
          .where('productId', isEqualTo: product.productId)
          .limit(1)
          .get();

      // Если товар найден в избранном, возвращает true, иначе - false
      return favoriteDoc.docs.isNotEmpty;
    } catch (e) {
      print("Error checking product in favorites: $e");
      return false;
    }
  }

  Future<void> getFavoriteProducts() async {
    favoriteProducts = [];
    try {
      CommanDialog.showLoading();
      final List<Product> lodadedProduct = [];

      // Получить список избранных товаров для текущего пользователя
      var favoriteResponse = await firebaseInstance
          .collection('favorites')
          .where('userId', isEqualTo: authController.currentUserId)
          .get();

      // Список ID избранных товаров
      List favoriteProductIds =
          favoriteResponse.docs.map((doc) => doc['productId']).toList();

      // Получить избранные товары, исключая товары текущего пользователя
      var productResponse = await firebaseInstance
          .collection('productlist')
          .where('user_Id', isNotEqualTo: authController.currentUserId)
          .get();

      if (productResponse.docs.length > 0) {
        productResponse.docs.forEach((result) {
          print(result.data());
          print(result.id);
          final dynamic productPrice = result['product_price'];
          final bool productState = result['productstate'];
          lodadedProduct.add(
            Product(
              productId: result.id,
              userId: result['user_Id'],
              productname: result['product_name'],
              productprice: double.parse(productPrice.toString()),
              productimage: result['product_image'],
              phonenumber: result['phone_number'],
              productuploaddate: result['product_upload_date'].toString(),
              productdescription: result['product_description'],
              productcategory: result['product_category'],
              productlocation: result['productlocation'],
              productstate: productState,
            ),
          );
        });
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

  Future<void> conductNewTransaction(Product product) async {
    try {
      if (product.userId != userProfileData['userId']) {
        // Добавление товара в коллекцию 'favorites' в Firestore
        await firebaseInstance.collection('transactions').add({
          'userId': authController.currentUserId,
          'customer': getUserById(authController.currentUserId),
          'seller': getUserById(product.userId),
          'productId': product.productId,
          'product_name': product.productname,
          'price': product.productprice 
        });
        // Обновление списка favoriteProducts
        transactions.add(product);
        update(['transactionsBuilder']);
      }
    } catch (e) {
      print("Error conducting a transaction: $e");
    }
  }

  Future<List<Message>> getMessages() async {
    List<Message> messages = [];
    try {
      // Получение всех документов из коллекции "messages"
      QuerySnapshot querySnapshot =
          await firebaseInstance.collection('messages').get();
      Map<String, QueryDocumentSnapshot> lastMessages = {};

      // Сортировка сообщений по userId и timestamp
      querySnapshot.docs.sort((a, b) => a['userId'].compareTo(b['userId']) == 0
          ? a['timestamp'].compareTo(b['timestamp'])
          : a['userId'].compareTo(b['userId']));

      // Сохранение последнего сообщения каждого пользователя
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        lastMessages[doc['userId']] = doc;
      }

      // Преобразование документов в объекты Message и добавление их в список
      lastMessages.values.forEach((doc) {
        messages.add(Message(
          content: doc['content'],
          sender: doc['sender'],
          timestamp: doc['timestamp'].toDate(), // Если timestamp это Timestamp
          userId: doc['userId'],
        ));
      });
    } catch (e) {
      print("Error getting messages: $e");
    }
    return messages;
  }

  void clearUserData() {
    loginUserData.clear();
    userProfileData = {'userName': '', 'joinDate': ''};
  }
}
