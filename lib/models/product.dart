class Product {
  final String productname;
  final double productprice;
  final String productuploaddate;
  late final String productimage;
  final String userId;
  final String phonenumber; 
  late final String productId;
  final String productdescription;
  final String productcategory;
  final String productlocation;
  bool productstate;

  Product(
      {required this.productname,
      required this.productprice,
      required this.productuploaddate,
      required this.userId,
      required this.productimage,
      required this.phonenumber,
      required this.productId,
      required this.productdescription,
      required this.productcategory,
      required this.productlocation,
      required this.productstate});
      
  Map<String, dynamic> toJson() {
    return {
      'productname': productname,
      'productprice': productprice,
      'productuploaddate': productuploaddate,
      'productimage': productimage,
      'userId': userId,
      'phonenumber': phonenumber,
      'productId': productId,
      'productdescription': productdescription,
      'productcategory': productcategory,
      'productlocation': productlocation,
      'productstate' : productstate
    };
  }
}

