import 'package:appmanga/Model/Shop_Model/cart_provider_model.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:appmanga/Page/Shop_page/cart_page.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: _buildCircleIconButton(Icons.arrow_back, () {
      Navigator.pop(context);
    }),
    actions: [
      _buildCircleIconButton(Icons.share, () {
        // TODO: Add share functionality
      }),
      Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          return _buildCircleIconButtonWithBadge(
            icon: Icons.shopping_cart,
            badgeContent: Text(
              cartProvider.cartItems.length.toString(),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          );
        },
      ),
    ],
  );
}

Widget _buildCircleIconButton(IconData icon, VoidCallback onPressed) {
  return Container(
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey[700]?.withOpacity(0.5),
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    ),
  );
}

Widget _buildCircleIconButtonWithBadge({
  required IconData icon,
  required Widget badgeContent,
  required VoidCallback onPressed,
}) {
  return Container(
    child: badges.Badge(
      badgeContent: badgeContent,
      position: badges.BadgePosition.topEnd(top: 1, end: 1),
      child: _buildCircleIconButton(icon, onPressed),
    ),
  );
}
