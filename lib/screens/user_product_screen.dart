import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salsat_marketplace/controllers/data_controller.dart';
import 'package:salsat_marketplace/models/product.dart';
import 'package:salsat_marketplace/screens/add_product_screen.dart';
import 'package:salsat_marketplace/screens/all_chats_screen.dart';
import 'package:salsat_marketplace/screens/main_screen_dart.dart';
import 'package:salsat_marketplace/screens/product_detail_screen.dart';
import 'package:salsat_marketplace/screens/profile_screen.dart';
import 'package:salsat_marketplace/widgets/my_bottom_navbar.dart';

class UserProductScreen extends StatefulWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen>
    with TickerProviderStateMixin {
  final DataController controller = Get.put(DataController());
  int _selectedIndex = 3;
  int _selectedIndexTabBar = 0;
  late TabController _tabController;
  final editPriceValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndexTabBar = _tabController.index;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getLoginUserProduct();
      controller.getFavoriteProducts();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
        break;
      case 1:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AllChatsScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AddProductScreen()));
        break;
      case 3:
        break;
      case 4:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Менің жарнамаларым',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black.withOpacity(0.5),
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Жарнамалар'),
              Tab(text: 'Таңдаулылар'),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndexTabBar,
              children: [
                GetBuilder<DataController>(
                  builder: (controller) => controller.loginUserData.isEmpty
                      ? Center(
                          child: Text('NO_DATA_FOUND_PLEASE_ADD_DATA'),
                        )
                      : ListView.builder(
                          itemCount: controller.loginUserData?.length ?? 0,
                          itemBuilder: (context, index) {
                            final product = controller.loginUserData?[index];
                            if (product == null) {
                              return SizedBox();
                            }
                            return Card(
                              child: ListTile(
                                onTap: () async {
                                  Map<String, dynamic> userDetails =
                                      await controller
                                          .getUserById(product.userId);
                                  Get.to(() => ProductDetailScreen(
                                      product: product,
                                      userDetails: userDetails));
                                },
                                leading: Image.network(product.productimage),
                                title: Text(product.productname ?? ''),
                                subtitle: Text('${product.productprice}'),
                                trailing: Wrap(
                                  spacing: 12,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Жаңа бағасы'),
                                                content: TextField(
                                                  controller: editPriceValue,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Жаңа бағасын енгізіңіз"),
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Мақұлдау'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      double? newPrice =
                                                          double.tryParse(
                                                              editPriceValue
                                                                  .text);
                                                      if (newPrice != null) {
                                                        controller.editProduct(
                                                            product.productId,
                                                            newPrice);
                                                      } else {
                                                        print(
                                                            "Unable to convert price to double");
                                                      }
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Болдырмау'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        controller
                                            .deleteProduct(product.productId);
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                GetBuilder<DataController>(
                  id: 'favoritesBuilder',
                  builder: (controller) => controller.favoriteProducts.isEmpty
                      ? Center(
                          child: Text('NO_DATA_FOUND_PLEASE_ADD_DATA'),
                        )
                      : ListView.builder(
                          itemCount: controller.favoriteProducts.length,
                          itemBuilder: (context, index) {
                            final product = controller.favoriteProducts[index];
                            return Card(
                              child: ListTile(
                                onTap: () async {
                                  Map<String, dynamic> userDetails =
                                      await controller
                                          .getUserById(product.userId);
                                  Get.to(() => ProductDetailScreen(
                                      product: product,
                                      userDetails: userDetails));
                                },
                                leading: Image.network(product.productimage),
                                title: Text(product.productname),
                                subtitle: Text('${product.productprice}'),
                                trailing: Wrap(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          controller.removeProductFromFavorites(
                                              product);
                                        },
                                        icon: Icon(
                                          Icons.favorite_outlined,
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
