import 'dart:io';
import 'package:appmanga/forum/model/post_forum_model.dart';
import 'package:appmanga/forum/page/comment_widget.dart';
import 'package:appmanga/forum/service/post_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class PostPage extends StatefulWidget {
  final int threadId;

  PostPage({required this.threadId});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostService _service = PostService();
  late Future<List<Post>> _postsFuture;
  final TextEditingController _contentController = TextEditingController();
  int? _selectedPostId;
  List<File> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _postsFuture = _service.fetchPosts(widget.threadId);
  }

  void _refreshPosts() {
    setState(() {
      _postsFuture = _service.fetchPosts(widget.threadId);
    });
  }

  void _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedImages = result.paths.map((path) => File(path!)).toList();
        print('Selected images: $_selectedImages');
      });
    }
  }

  void _showCommentBottomSheet(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _contentController,
                  maxLines: 5,
                  minLines: 1,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Viết bình luận...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  children: _selectedImages.map((file) => Chip(label: Text(basename(file.path)))).toList(),
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.image, color: Colors.white),
                      onPressed: _pickImages,
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final content = _contentController.text;
                        if (content.isNotEmpty) {
                          await _service.postContent(content, widget.threadId, post: _selectedPostId, images: _selectedImages);
                          _contentController.clear();
                          _selectedPostId = null; // Clear the selected post ID after posting
                          _selectedImages = []; // Clear the selected images
                          Navigator.of(context).pop();
                          _refreshPosts();
                        }
                      },
                      child: Text('Send'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue, // Text color
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thảo luận', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 8),
                    Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox, color: Colors.white54, size: 48),
                    SizedBox(height: 8),
                    Text('No posts found.', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              );
            } else {
              final posts = snapshot.data!;
              final Map<int, List<Post>> repliesByParentId = {};

              for (var post in posts) {
                if (post.postId != null) {
                  repliesByParentId.putIfAbsent(post.postId!, () => []).add(post);
                }
              }

              return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  if (post.postId == null) {
                    return CommentWidget(
                      comment: post,
                      repliesByParentId: repliesByParentId,
                      formatDate: formatDate,
                      onReply: (parentId) {
                        setState(() {
                          _selectedPostId = parentId;
                        });
                        _showCommentBottomSheet(context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _refreshPosts,
            backgroundColor: Colors.black87,
            child: Icon(Icons.refresh, color: Colors.white),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              _selectedPostId = null; // Clear the selected post ID for new post
              _showCommentBottomSheet(context); // Pass the current BuildContext
            },
            backgroundColor: Colors.black87,
            child: Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
