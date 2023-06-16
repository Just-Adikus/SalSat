import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salsat_marketplace/controllers/data_controller.dart';
import 'package:salsat_marketplace/models/product.dart';
import 'package:salsat_marketplace/screens/add_product_screen.dart';
import 'package:salsat_marketplace/screens/all_chats_screen.dart';
import 'package:salsat_marketplace/screens/notification_screen.dart';
import 'package:salsat_marketplace/screens/product_detail_screen.dart';
import 'package:salsat_marketplace/screens/profile_screen.dart';
import 'package:salsat_marketplace/screens/user_product_screen.dart';
import 'package:salsat_marketplace/widgets/custom_searchbar.dart';
import 'package:salsat_marketplace/widgets/horizontal_listview.dart';
import 'package:salsat_marketplace/widgets/image_carousel.dart';
import 'package:salsat_marketplace/widgets/my_bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final DataController controller = Get.put(DataController());
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Get.offAll(() => MainScreen());
        break;
      case 1:
        Get.offAll(() => AllChatsScreen());
        break;
      case 2:
        Get.offAll(() => AddProductScreen());
        break;
      case 3:
        Get.offAll(() => UserProductScreen());
        break;
      case 4:
        Get.offAll(() => ProfileScreen());
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.getAllProduct();
    });
  }

  Future<bool> checkIsFavorite(Product product) async {
    return await controller.isProductInFavorites(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.notifications_none_outlined,
            color: Colors.blue,
          ),
          onPressed: () {
            Get.to(() => NotificationScreen());
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: CustomSearchBar(),
                ),
                image_carousel,
                buildHeader("Категориялар"),
                SizedBox(height: 10),
                HorizontalList(),
                buildHeader("Жуырда қаралғандар"),
                SizedBox(height: 20),
                Builder(
                  builder: (context) {
                    // Use the Builder widget to create a new context
                    return buildProductsList();
                  },
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

  Padding buildHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
    );
  }

  Widget buildProductsList() {
    return GetBuilder<DataController>(
      init: controller,
      builder: (controller) {
        print(controller.allProduct);
        if (controller.allProduct.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: controller.allProduct.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final product = controller.allProduct[index];
              return buildProductCard(product);
            },
          );
        }
      },
    );
  }

  InkWell buildProductCard(Product product) {
    return InkWell(
      onTap: () async {
        Map<String, dynamic> userDetails =
            await controller.getUserById(product.userId);
        Get.to(() =>
            ProductDetailScreen(product: product, userDetails: userDetails));
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            buildProductImage(product),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  buildProductDetails(product),
                  buildProductPrice(product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildProductImage(Product product) {
    return Container(
      height: 180,
      width: 180,
      child: Image.network(
        product.productimage,
        fit: BoxFit.cover,
      ),
    );
  }

  Row buildProductDetails(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "${product.productname}",
            style: TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        FutureBuilder<bool>(
          future: checkIsFavorite(product),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Icon(Icons.error);
            } else {
              bool isFavorite = snapshot.data ?? false;
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () async {
                  bool isFavorite = await checkIsFavorite(product);
                  if (isFavorite) {
                    await controller.removeProductFromFavorites(product);
                  } else {
                    await controller.addProductToFavorites(product);
                  }
                },
              );
            }
          },
        ),
      ],
    );
  }

  Row buildProductPrice(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '${product.productprice} тг',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
