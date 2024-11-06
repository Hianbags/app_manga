import 'package:appmanga/DatabaseHelper/Shop_helper.dart';
import 'package:appmanga/Model/Shop_Model/product_model.dart';
import 'package:appmanga/Page/Shop_page/product_category_page.dart';
import 'package:appmanga/Service/Shop_service/produc_service.dart';
import 'package:flutter/material.dart';
import 'package:appmanga/Page/Shop_page/product_detail_page/app_bar.dart';
import 'package:appmanga/Page/Shop_page/product_detail_page/bottom_app_bar.dart';
import 'package:appmanga/Page/Shop_page/product_detail_page/image_slider.dart';
import 'package:appmanga/Page/Shop_page/product_detail_page/product_detail.dart';
import 'package:appmanga/Service/Shop_service/product_detail_service.dart';
import 'package:appmanga/Model/Shop_Model/product_detail_model.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  ProductDetailPage({required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<ProductDetail> _productDetailFuture;
  Future<List<Product>>? _recommendedProductsFuture;

  @override
  void initState() {
    super.initState();
    _productDetailFuture = ProductService().fetchProduct(widget.productId);
    _addViewedCategories();
  }

  Future<void> _addViewedCategories() async {
    try {
      ProductDetail productDetail = await _productDetailFuture;

      List<Category> categories = productDetail.category;

      await DatabaseCategoryHelper.addViewedCategories(categories);

      List<int> topThreeCategoryIds = await DatabaseCategoryHelper.getTopThreeCategoryIds();
      print('Top 3 Category IDs: $topThreeCategoryIds');

      _loadRecommendedProducts(topThreeCategoryIds);
    } catch (e) {
      print('Error in _addViewedCategories: $e');
    }
  }

  Future<void> _loadRecommendedProducts(List<int> categoryIds) async {
    try {
      setState(() {
        _recommendedProductsFuture = ProductListService().getProductsByCategoryIds(categoryIds);
      });
    } catch (e) {
      print('Error in _loadRecommendedProducts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: FutureBuilder<ProductDetail>(
        future: _productDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final product = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ImageSlider(product: product),
                        SizedBox(height: 16),
                        Divider(color: Colors.grey[200], thickness: 10),
                        SizedBox(height: 16),
                        ProductDetails(product: product),
                        SizedBox(height: 16),
                        Divider(color: Colors.grey[200], thickness: 10),
                        SizedBox(height: 16),
                        _buildRecommendedProductsSection(),
                      ],
                    ),
                  ),
                ),
                CustomBottomAppBar(product: product),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildRecommendedProductsSection() {
    return FutureBuilder<List<Product>>(
      future: _recommendedProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No recommendations available.'));
        } else {
          final recommendedProducts = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Có thể bạn quan tâm',
                  style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                ),
              ),
              SizedBox(height: 8),
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                physics: NeverScrollableScrollPhysics(), // Prevents GridView from scrolling
                shrinkWrap: true, // Makes the GridView take only the necessary height
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 8.0, // Horizontal space between items
                  mainAxisSpacing: 8.0, // Vertical space between items
                  childAspectRatio: 0.75, // Aspect ratio of the items
                ),
                itemCount: recommendedProducts.length,
                itemBuilder: (context, index) {
                  final product = recommendedProducts[index];
                  return ProductCard(product: product);
                },
              ),
            ],
          );
        }
      },
    );
  }
}
