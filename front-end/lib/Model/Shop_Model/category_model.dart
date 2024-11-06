class ProductCategory {
  final int id;
  final String title;
  final int productCount;

  ProductCategory({
    required this.id,
    required this.title,
    required this.productCount,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      title: json['title'],
      productCount: json['product_count'],
    );
  }
}
