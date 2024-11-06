class CategoryWithViewCount {
  final int id;
  final String title;
  final int categoryId;
  final int viewCount;

  CategoryWithViewCount({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.viewCount,
  });

  // Chuyển đổi từ Map thành CategoryWithViewCount
  factory CategoryWithViewCount.fromMap(Map<String, dynamic> map) {
    return CategoryWithViewCount(
      id: map['id'],
      title: map['title'],
      categoryId: map['category_id'],
      viewCount: map['view_count'],
    );
  }

  // Chuyển đổi từ CategoryWithViewCount thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category_id': categoryId,
      'view_count': viewCount,
    };
  }
}
