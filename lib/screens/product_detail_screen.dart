import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:salsat_marketplace/models/product.dart';
import 'package:salsat_marketplace/controllers/data_controller.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:salsat_marketplace/screens/chat_screen.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:salsat_marketplace/screens/payment_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final Map<String, dynamic> userDetails;

  ProductDetailScreen({required this.product, required this.userDetails});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFavorite = false;
  bool _isUsedProduct = false;
  LatLng? producLocation;

  @override
  void initState() {
    super.initState();
    _isUsedProduct = widget.product.productstate;
    checkIsFavorite();
  }

  Future<void> checkIsFavorite() async {
    final DataController controller = Get.find();
    bool isFavorite = await controller.isProductInFavorites(widget.product);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  Future<LatLng> getLatLngFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    // Проверка, вернул ли запрос какое-либо местоположение
    if (locations.isEmpty) {
      throw Exception('No location found for $address');
    }
    // Используем первое местоположение в списке
    Location location = locations.first;
    // Создаем объект LatLng из координат местоположения
    LatLng latLng = LatLng(location.latitude, location.longitude);
    return latLng;
  }

  Future<LatLng> getLtLng(String address) async {
    return await getLatLngFromAddress(address);
  }

  @override
  Widget build(BuildContext context) {
    final DataController controller = Get.find();
    final bool isFavorite = false;
    Widget? widgetToDisplay;
    Widget? textToDisplay;
    Widget? tick;

    if (!_isUsedProduct) {
      widgetToDisplay = ElevatedButton(
        onPressed: () {
          Map<String, dynamic> productData = {
            'sellerName': widget.userDetails['userName'],
            'productId': widget.product.productId,
            'productName': widget.product.productname,
            'productPrice': widget.product.productprice,
            'productAddress': widget.product.productlocation.toString(),
          };

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(productData: productData),
            ),
          );
        },
        child: Text('Сатып алу'),
      );

      tick = Icon(
        Icons.verified_user,
        color: Colors.blue,
      );
    }

    if (_isUsedProduct) {
      textToDisplay = Text(
        'Қолданыста болған тауар',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
      );
    } else {
      textToDisplay = Text(
        'Жаңа тауар',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Тауар жайлы ақпарат',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder<DataController>(
          id: 'favoritesBuilder',
          builder: (controller) {
            return Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  FanCarouselImageSlider(
                    imagesLink: [widget.product.productimage],
                    isAssets: false,
                    initalPageIndex: 0,
                    sliderWidth: double.infinity,
                    sliderHeight: 250,
                    indicatorActiveColor: Colors.blue,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.productname,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w400),
                      ),
                      IconButton(
                        icon: Icon(_isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border),
                        onPressed: () async {
                          if (_isFavorite) {
                            await controller
                                .removeProductFromFavorites(widget.product);
                          } else {
                            await controller
                                .addProductToFavorites(widget.product);
                          }
                          checkIsFavorite();
                        },
                      ),
                      if (tick != null) tick!,
                    ],
                  ),
                  Text(
                    '${widget.product.productprice.toInt().toString()} ₸',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: Colors.black,
                    ),
                    title: Text(
                      '${widget.userDetails['userName']}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      'Сатушы',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  Divider(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                    title: Text(
                      '${widget.product.productlocation.toString()}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Divider(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.call_outlined,
                      color: Colors.black,
                    ),
                    title: Text(
                      '${widget.product.phonenumber.toString()}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Divider(
                    height: 10,
                  ),
                  ListTile(
                      leading: Icon(
                        Icons.local_mall_outlined,
                        color: Colors.black,
                      ),
                      title: Text('Тауар күйі',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      subtitle: textToDisplay!),
                  // if (textToDisplay != null) textToDisplay!,
                  Divider(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.shopping_basket_outlined,
                      color: Colors.black,
                    ),
                    title: Text('Категория',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${widget.product.productcategory}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  Divider(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.format_align_justify,
                      color: Colors.black,
                    ),
                    title: Text('Сипаттамасы',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${widget.product.productdescription}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // SizedBox(height: 10),
                  // SizedBox(height: 10),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (widgetToDisplay != null) widgetToDisplay!,
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> userDetails = await controller
                              .getUserNameById(widget.product.userId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                userDetails: userDetails,
                              ),
                            ),
                          );
                        },
                        child: Text('Сатушымен хабарласу'),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
