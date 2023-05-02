import 'package:flutter/material.dart';

class Product {
  final String productname;
  final double productprice;
  final String productuploaddate;
  final String productimage;
  final String userId;
  final int phonenumber;
  final String productId;
  final String productdescription; // добавлено поле для описания товара
  final String productcategory; // добавлено поле для категории товара

  Product(
      {required this.productname,
      required this.productprice,
      required this.productuploaddate,
      required this.userId,
      required this.productimage,
      required this.phonenumber,
      required this.productId,
      required this.productdescription, // обновлено для описания товара
      required this.productcategory}); // обновлено для категории товара
}
