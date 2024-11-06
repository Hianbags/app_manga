class PageModel {
  final String image;

  PageModel({required this.image});

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      image: json['image'],
    );
  }
}
