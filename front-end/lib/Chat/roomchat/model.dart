class RoomChat {
  final int id;
  final String name;
  final String description;
  RoomChat({
    required this.id,
    required this.name,
    required this.description,
  });
  factory RoomChat.fromJson(Map<String, dynamic> json) {
    return RoomChat(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}