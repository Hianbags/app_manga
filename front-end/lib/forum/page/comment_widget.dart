import 'package:flutter/material.dart';
import 'package:appmanga/forum/model/post_forum_model.dart';

class CommentWidget extends StatelessWidget {
  final Post comment;
  final Map<int, List<Post>> repliesByParentId;
  final String Function(DateTime) formatDate;
  final void Function(int parentId) onReply;
  final bool isRoot;

  CommentWidget({
    required this.comment,
    required this.repliesByParentId,
    required this.formatDate,
    required this.onReply,
    this.isRoot = true,
  });

  @override
  Widget build(BuildContext context) {
    final replies = repliesByParentId[comment.id] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Colors.grey[850],
          margin: isRoot ? EdgeInsets.symmetric(vertical: 8.0) : EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(comment.avatar),
                          radius: 20,
                        ),
                        SizedBox(width: 8),
                        Text(comment.authorName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    Text(formatDate(comment.createdAt), style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                SizedBox(height: 8),
                Text(comment.content, style: TextStyle(color: Colors.white70)),
                SizedBox(height: 8),
                if (comment.images.isNotEmpty) ...[
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: comment.images.map((imageUrl) {
                      return Image.network(
                        imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  ),
                ],
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => onReply(comment.id),
                  child: Text(
                    'Reply',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (replies.isNotEmpty) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: replies.map((reply) {
              return CommentWidget(
                comment: reply,
                repliesByParentId: repliesByParentId,
                formatDate: formatDate,
                onReply: onReply,
                isRoot: false, // Đánh dấu đây không phải là bình luận gốc
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
