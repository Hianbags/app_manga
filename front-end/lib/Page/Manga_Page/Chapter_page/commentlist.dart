import 'package:flutter/material.dart';
import 'package:appmanga/Model/Manga_Model/comment_model.dart';
import 'package:appmanga/Service/Manga_Service/comment_service.dart';

class CommentList extends StatefulWidget {
  final int mangaId;
  final Future<CommentResponse> futureComments;
  final VoidCallback onRefreshComments;

  CommentList({
    required this.mangaId,
    required this.futureComments,
    required this.onRefreshComments,
  });

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AddCommentService _addCommentService = AddCommentService();

  Future<void> _submitComment() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _addCommentService.addComment(widget.mangaId, _commentController.text);
        _commentController.clear();
        widget.onRefreshComments();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bình luận thành công')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không thể bình luận: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 59.0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          border: Border(
            top: BorderSide(color: Colors.grey),
            left: BorderSide(color: Colors.grey),
            right: BorderSide(color: Colors.grey),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<CommentResponse>(
                future: widget.futureComments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                  } else if (snapshot.hasData && snapshot.data!.data.isEmpty) {
                    return Center(child: Text('Chưa có bình luận nào', style: TextStyle(color: Colors.white)));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.data.length,
                      itemBuilder: (context, index) {
                        final comment = snapshot.data!.data[index];
                        return ListTile(
                          title: Text(comment.user, style: TextStyle(color: Colors.white)),
                          subtitle: Text(comment.content, style: TextStyle(color: Colors.white)),
                          trailing: Text(comment.createdAt, style: TextStyle(color: Colors.grey)),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _commentController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Nhập bình luận của bạn',
                          hintStyle: TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black54,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập bình luận';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _submitComment,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
