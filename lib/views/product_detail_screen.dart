// import 'package:sal_sat/generated/locale_keys.g.dart';

import 'package:flutter/material.dart';
import 'package:sal_sat/views/payment_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:stripe_payment/stripe_payment.dart';
// import 'package:easy_localization/easy_localization.dart';
// import  'package:easy_localization/src/public_ext.dart';
import '/controllers/data_controller.dart';
import '/models/product_model.dart';
// import 'package:slang/slang.dart';
import 'package:photo_view/photo_view.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Map<String, dynamic> userDetails;

  ProductDetailScreen({required this.product, required this.userDetails});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

  // void _initiatePayment(BuildContext context) {
  //   StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
  //       .then((PaymentMethod paymentMethod) {
  //     DataController()
  //         .createCharge(paymentMethod.id!, product.productprice)
  //         .then((_) => _handlePaymentSuccess())
  //         .catchError((e) => _handlePaymentError(e));
  //   }).catchError((e) {
  //     _handlePaymentError(e);
  //   });
  // }
 class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFavorite = false;

  // void _toggleFavorite() {
  //   setState(() {
  //     _isFavorite = !_isFavorite;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final DataController controller = Get.find();
    final bool isFavorite = controller.isProductInFavorites(widget.product);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product_Details'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<DataController>(
          id: 'favoritesBuilder',
          builder: (controller) {
            final bool isFavorite = controller.isProductInFavorites(widget.product);

            return Column(
              children: [
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoView(
                          imageProvider: NetworkImage(widget.product.productimage),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 200,
                    width: 300,
                    child: Image.network(
                      widget.product.productimage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  widget.product.productname,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '${'Product_Category'.tr}: ${widget.product.productcategory}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '${'Product_Price'.tr}: ${widget.product.productprice.toString()}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '${'Product_Description'.tr}: ${widget.product.productdescription}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '${'Seller_Name'.tr}: ${widget.userDetails['userName']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '${'Phone_Number'.tr}: ${widget.product.phonenumber.toString()}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(),
                          ),
                        );
                      },
                      child: Text('Buy_Now'.tr),
                    ),
                    ElevatedButton(
                      onPressed: launchChat,
                      child: Text('Contact_Seller'.tr),
                    ),
                    IconButton(
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                      onPressed: () {
                        if (isFavorite) {
                          controller.removeProductFromFavorites(widget.product);
                        } else {
                          controller.addProductToFavorites(widget.product);
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

     Future<void> launchChat() async {
    final String phoneNumber = widget.product.phonenumber.toString();
    final bool isWhatsAppInstalled =
        await launch('whatsapp://send?phone=$phoneNumber');

    if (isWhatsAppInstalled) {
      await launch('whatsapp://send?phone=$phoneNumber');
    } else {
      // If neither WhatsApp nor Telegram is installed, show an error message
      Get.snackbar(
        'Error',
        'No chat app found on this device',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
 
 
  // void _handlePaymentSuccess() {
  //   Get.snackbar(
  //     'Success',
  //     'Payment successful!',
  //     snackPosition: SnackPosition.BOTTOM,
  //   );
  // }

  // void _handlePaymentError(dynamic error) {
  //   Get.snackbar(
  //     'Error',
  //     'Payment failed: ${error.toString()}',
  //     snackPosition: SnackPosition.BOTTOM,
  //   );
  // }

  // void _handlePaymentCancelled() {
  //   Get.snackbar(
  //     'Error',
  //     'Payment cancelled',
  //     snackPosition: SnackPosition.BOTTOM,
  //   );
  // }
}
