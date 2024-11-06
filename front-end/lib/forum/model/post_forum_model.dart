class Post {
  int id;
  int threadId;
  int authorId;
  String avatar;
  String authorName;
  String content;
  List<String> images;
  int? postId;
  int sequence;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;
  PostActions actions;

  Post({
    required this.id,
    required this.threadId,
    required this.authorId,
    required this.avatar,
    required this.authorName,
    required this.content,
    required this.images,
    this.postId,
    required this.sequence,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.actions,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      threadId: json['thread_id'],
      authorId: json['author_id'],
      avatar: json['avatar'],
      authorName: json['author_name'],
      content: json['content'],
      images: List<String>.from(json['image'] ?? []),
      postId: json['post_id'],
      sequence: json['sequence'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      actions: PostActions.fromJson(json['actions']),
    );
  }
}

class PostActions {
  String patchUpdate;
  String deleteDelete;
  String postRestore;

  PostActions({
    required this.patchUpdate,
    required this.deleteDelete,
    required this.postRestore,
  });

  factory PostActions.fromJson(Map<String, dynamic> json) {
    return PostActions(
      patchUpdate: json['patch:update'],
      deleteDelete: json['delete:delete'],
      postRestore: json['post:restore'],
    );
  }
}
