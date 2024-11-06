import 'package:appmanga/Model/Shop_Model/cart_provider_model.dart';
import 'package:appmanga/Model/Shop_Model/product_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomAppBar extends StatelessWidget {
  final ProductDetail product;

  CustomBottomAppBar({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.blue),
                  ),
                  textStyle: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  // Add product to cart
                  final cartProvider = Provider.of<CartProvider>(context, listen: false);
                  cartProvider.addToCart(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm vào giỏ hàng!'),
                    ),
                  );
                },
                child: Text('Thêm vào giỏ', style: TextStyle(color: Colors.blue)),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  // Implement purchase functionality
                },
                child: Text('Mua ngay'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
