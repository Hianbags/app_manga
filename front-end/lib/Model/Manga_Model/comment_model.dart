class Comment {
  final int id;
  final String user;
  final String content;
  final String createdAt;

  Comment({
    required this.id,
    required this.user,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? 0, // Provide default value
      user: json['user'] ?? 'Anonymous', // Provide default value
      content: json['content'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class CommentResponse {
  final List<Comment> data;
  final Links links;
  final Meta meta;

  CommentResponse({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? []; // Provide default value
    List<Comment> commentList = list.map((i) => Comment.fromJson(i)).toList();

    return CommentResponse(
      data: commentList,
      links: Links.fromJson(json['links'] ?? {}), // Provide default value
      meta: Meta.fromJson(json['meta'] ?? {}), // Provide default value
    );
  }
}

class Links {
  final String first;
  final String last;
  final String? prev;
  final String? next;

  Links({
    required this.first,
    required this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      first: json['first'] ?? '',
      last: json['last'] ?? '',
      prev: json['prev'],
      next: json['next'],
    );
  }
}

class Meta {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final int from;
  final int to;

  Meta({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.from,
    required this.to,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'] ?? 0,
      perPage: json['per_page'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
    );
  }
}
