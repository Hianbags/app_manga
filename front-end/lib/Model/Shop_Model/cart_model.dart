import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'product_detail_model.dart'; // Import your ProductDetail model

class CartItem {
  final ProductDetail product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: ProductDetail.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

class Cart {
  List<CartItem> items = [];
  Database? _database;

  Future<void> _initDatabase() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'cart_database.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE cart(id INTEGER PRIMARY KEY, name TEXT, description TEXT, price REAL, images TEXT, created_at TEXT, updated_at TEXT, quantity INTEGER)",
          );
        },
        version: 1,
      );
      print("Database initialized and table created");
    }
  }

  Future<void> fetchCartFromDatabase() async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query('cart');
    items = List.generate(maps.length, (i) {
      return CartItem(
        product: ProductDetail.fromJson({
          ...maps[i],
          'images': jsonDecode(maps[i]['images']),
        }),
        quantity: maps[i]['quantity'],
      );
    });
    print("Fetched cart items from database: $items");
  }

  Future<void> saveItemToDatabase(CartItem item) async {
    await _initDatabase();
    await _database!.insert(
      'cart',
      {
        ...item.product.toJson(),
        'images': jsonEncode(item.product.images),
        'quantity': item.quantity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Saved item to database: ${item.toJson()}");
  }
  Future<void> updateItemQuantityInDatabase(CartItem item) async {
    await _initDatabase();
    await _database!.update(
      'cart',
      {
        'quantity': item.quantity,
      },
      where: 'id = ?',
      whereArgs: [item.product.id],
    );
    print("Updated item quantity in database: ${item.toJson()}");
  }

  Future<void> removeItemFromDatabase(CartItem item) async {
    await _initDatabase();
    await _database!.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [item.product.id],
    );
    print("Removed item from database: ${item.product.id}");
  }

  Future<void> clearCartInDatabase() async {
    await _initDatabase();
    await _database!.delete('cart');
    print("Cleared all items from database");
  }

  void addToCart(ProductDetail product) {
    var existingItem = items.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    if (existingItem.quantity == 0) {
      items.add(CartItem(product: product));
      saveItemToDatabase(CartItem(product: product));
    } else {
      existingItem.quantity++;
      updateItemQuantityInDatabase(existingItem);
    }
  }

  void removeFromCart(ProductDetail product) {
    var existingItem = items.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    if (existingItem.quantity > 1) {
      existingItem.quantity--;
      updateItemQuantityInDatabase(existingItem);
    } else if (existingItem.quantity == 1) {
      items.remove(existingItem);
      removeItemFromDatabase(existingItem);
    }
  }

  void clearCart() {
    items.clear();
    clearCartInDatabase();
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (var item in items) {
      totalPrice += item.product.price * item.quantity;
    }
    return totalPrice;
  }
}
