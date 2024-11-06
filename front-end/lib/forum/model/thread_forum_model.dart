class Thread {
  int id;
  int categoryId;
  int authorId;
  String authorName;
  String title;
  bool pinned;
  bool locked;
  int firstPostId;
  int lastPostId;
  int replyCount;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;
  ThreadActions actions;

  Thread({
    required this.id,
    required this.categoryId,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.pinned,
    required this.locked,
    required this.firstPostId,
    required this.lastPostId,
    required this.replyCount,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.actions,
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      id: json['id'],
      categoryId: json['category_id'],
      authorId: json['author_id'],
      authorName: json['author_name'],
      title: json['title'],
      pinned: json['pinned'],
      locked: json['locked'],
      firstPostId: json['first_post_id'],
      lastPostId: json['last_post_id'],
      replyCount: json['reply_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      actions: ThreadActions.fromJson(json['actions']),
    );
  }
}

class ThreadActions {
  String postLock;
  String postUnlock;
  String postPin;
  String postUnpin;
  String postRename;
  String postMove;
  String deleteDelete;
  String postRestore;

  ThreadActions({
    required this.postLock,
    required this.postUnlock,
    required this.postPin,
    required this.postUnpin,
    required this.postRename,
    required this.postMove,
    required this.deleteDelete,
    required this.postRestore,
  });

  factory ThreadActions.fromJson(Map<String, dynamic> json) {
    return ThreadActions(
      postLock: json['post:lock'],
      postUnlock: json['post:unlock'],
      postPin: json['post:pin'],
      postUnpin: json['post:unpin'],
      postRename: json['post:rename'],
      postMove: json['post:move'],
      deleteDelete: json['delete:delete'],
      postRestore: json['post:restore'],
    );
  }
}
