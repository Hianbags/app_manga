import 'package:flutter/material.dart';

class ChapterAppBar extends StatelessWidget {
  final String chapterTitle;
  final Function(bool) onChangeMode;

  ChapterAppBar({
    required this.chapterTitle,
    required this.onChangeMode,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
          ),
          child: Text(
            chapterTitle,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.black,
                    title: Text('Chọn chế độ đọc', style: TextStyle(color: Colors.white)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            onChangeMode(true);
                            Navigator.of(context).pop();
                          },
                          child: Text('Chế độ lướt trang', style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: () {
                            onChangeMode(false);
                            Navigator.of(context).pop();
                          },
                          child: Text('Chế độ đọc sách', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
