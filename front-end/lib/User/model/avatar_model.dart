class Avatar {
  final int id;
  final String image;

  Avatar({required this.id, required this.image});

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      id: json['id'],
      image: json['image'],
    );
  }
}
