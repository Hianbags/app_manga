import 'dart:ffi';

class Category {
  int id;
  String title;
  String description;
  bool acceptsThreads;
  int? newestThreadId;
  int? latestActiveThreadId;
  int threadCount;
  int postCount;
  bool isPrivate;
  int left;
  int right;
  int? parentId;
  String color;
  DateTime createdAt;
  DateTime updatedAt;
  bool addThreadButton;
  Actions actions;

  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.acceptsThreads,
    required this.newestThreadId,
    required this.latestActiveThreadId,
    required this.threadCount,
    required this.postCount,
    required this.isPrivate,
    required this.left,
    required this.right,
    this.parentId,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    required this.addThreadButton,
    required this.actions,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      acceptsThreads: json['accepts_threads'],
      newestThreadId: json['newest_thread_id'],
      latestActiveThreadId: json['latest_active_thread_id'],
      threadCount: json['thread_count'],
      postCount: json['post_count'],
      isPrivate: json['is_private'],
      left: json['left'],
      right: json['right'],
      parentId: json['parent_id'],
      color: json['color'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      addThreadButton: json['add_thread_button'],
      actions: Actions.fromJson(json['actions']),
    );
  }
}

class Actions {
  String patchUpdate;
  String deleteDelete;

  Actions({
    required this.patchUpdate,
    required this.deleteDelete,
  });

  factory Actions.fromJson(Map<String, dynamic> json) {
    return Actions(
      patchUpdate: json['patch:update'],
      deleteDelete: json['delete:delete'],
    );
  }
}
