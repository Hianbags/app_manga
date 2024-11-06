import 'package:appmanga/Model/Shop_Model/product_detail_model.dart';
import 'package:flutter/material.dart';
import 'cart_model.dart'; // Import your Cart model

class CartProvider extends ChangeNotifier {
  Cart _cart = Cart();

  List<CartItem> get cartItems => _cart.items;

  CartProvider() {
    initializeCart();
  }

  Future<void> initializeCart() async {
    await _cart.fetchCartFromDatabase();
    notifyListeners();
  }

  void addToCart(ProductDetail product) {
    _cart.addToCart(product);
    notifyListeners();
  }

  void removeFromCart(ProductDetail product) {
    _cart.removeFromCart(product);
    notifyListeners();
  }

  void clearCart() {
    _cart.clearCart();
    notifyListeners();
  }

  double getTotalPrice() {
    return _cart.getTotalPrice();
  }
}
