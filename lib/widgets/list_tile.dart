import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salsat_marketplace/controllers/data_controller.dart';
import 'package:salsat_marketplace/models/product.dart';
import 'package:salsat_marketplace/screens/product_detail_screen.dart';

class ProductTile extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;

  ProductTile({required this.product, required this.isFavorite, required this.onFavoriteChanged});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DataController controller = Get.find();
        Map<String, dynamic> userDetails = await controller.getUserById(widget.product.userId);
        Get.to(() => ProductDetailScreen(product: widget.product, userDetails: userDetails));
      },
      child: GridTile(
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: Container(
                  height: 180,
                  width: 180,
                  child: Image.network(
                    widget.product.productimage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                            "${widget.product.productname}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                          onPressed: () async {
                            final DataController controller = Get.find();
                            if (_isFavorite) {
                              await controller.removeProductFromFavorites(widget.product);
                            } else {
                              await controller.addProductToFavorites(widget.product);
                            }
                            bool isFavorite = await controller.isProductInFavorites(widget.product);
                            setState(() {
                              _isFavorite = isFavorite;
                            });
                            widget.onFavoriteChanged(_isFavorite);
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${widget.product.productprice} тг',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}