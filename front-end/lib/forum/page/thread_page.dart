import 'package:appmanga/forum/model/thread_forum_model.dart';
import 'package:appmanga/forum/page/post_page.dart';
import 'package:appmanga/forum/service/thread_service.dart';
import 'package:flutter/material.dart';

class ThreadPage extends StatefulWidget {
  final int categoryId;
  final bool addbutton;

  ThreadPage({required this.categoryId, required this.addbutton});

  @override
  _ThreadPageState createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final ThreadService _service = ThreadService();
  late Future<List<Thread>> _threadsFuture;

  @override
  void initState() {
    super.initState();
    _threadsFuture = _service.fetchThreads(widget.categoryId);
  }

  void _refreshThreads() {
    setState(() {
      _threadsFuture = _service.fetchThreads(widget.categoryId);
    });
  }

  void _showPostThreadTopSheet(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 32.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 32.0), // Spacer to align top fields properly
                        Expanded(
                          child: PostThreadForm(
                            categoryId: widget.categoryId,
                            onPostSuccess: () {
                              Navigator.pop(context);
                              _refreshThreads();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chủ đề', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder<List<Thread>>(
          future: _threadsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No threads found.', style: TextStyle(color: Colors.white)));
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final thread = snapshot.data![index];
                  return Card(
                    color: Colors.grey[850],
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      leading: Icon(Icons.forum, color: Colors.white70),
                      title: Text(thread.title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      subtitle: Text(
                        'Tác giả: ${thread.authorName}\nSố bình luận: ${thread.replyCount}',
                        style: TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostPage(threadId: thread.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      // Show FloatingActionButton only if addbutton is true
      floatingActionButton: widget.addbutton
          ? FloatingActionButton(
        onPressed: () {
          _showPostThreadTopSheet(context);
        },
        backgroundColor: Colors.black87,
        child: Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }
}
class PostThreadForm extends StatefulWidget {
  final int categoryId;
  final VoidCallback onPostSuccess;

  PostThreadForm({required this.categoryId, required this.onPostSuccess});

  @override
  _PostThreadFormState createState() => _PostThreadFormState();
}

class _PostThreadFormState extends State<PostThreadForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ThreadService _apiService = ThreadService();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset + 60, top: 16, left: 16, right: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Tiêu đề',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: 'Nội dung',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter content';
                      }
                      return null;
                    },
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: bottomInset + 16,
          right: 16,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _apiService.postThread(
                  widget.categoryId,
                  _titleController.text,
                  _contentController.text,
                ).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thread Posted')),
                  );
                  widget.onPostSuccess();
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to post thread')),
                  );
                });
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
            child: Text('Đăng lên', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
