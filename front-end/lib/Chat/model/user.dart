class UserChatList {
  final int id;
  final String name;
  final String avatar;

  UserChatList({
    required this.id,
    required this.name,
    required this.avatar,

  });

  factory UserChatList.fromJson(Map<String, dynamic> json) {
    return UserChatList(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
    };
  }
}