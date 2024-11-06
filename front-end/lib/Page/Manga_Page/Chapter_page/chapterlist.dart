import 'package:flutter/material.dart';

class ChapterList extends StatefulWidget {
  final List<dynamic> chapters;
  final int currentChapterId;
  final bool isSortedByNewest;
  final Function(int) onChapterTap;
  final VoidCallback onToggleSortOrder;

  ChapterList({
    required this.chapters,
    required this.currentChapterId,
    required this.isSortedByNewest,
    required this.onChapterTap,
    required this.onToggleSortOrder,
  });

  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  late List<dynamic> sortedChapters;

  @override
  void initState() {
    super.initState();
    _sortChapters();
  }

  @override
  void didUpdateWidget(ChapterList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.chapters != oldWidget.chapters || widget.isSortedByNewest != oldWidget.isSortedByNewest) {
      _sortChapters();
    }
  }

  void _sortChapters() {
    setState(() {
      sortedChapters = List.from(widget.chapters);
      if (widget.isSortedByNewest) {
        sortedChapters.sort((a, b) => b.id.compareTo(a.id));
      } else {
        sortedChapters.sort((a, b) => a.id.compareTo(b.id));
      }
    });
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chương',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(widget.isSortedByNewest ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white),
                    onPressed: () {
                      widget.onToggleSortOrder();
                      _sortChapters();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sortedChapters.length,
                itemBuilder: (context, index) {
                  final chapter = sortedChapters[index];
                  return Container(
                    color: chapter.id == widget.currentChapterId ? Colors.red : Colors.transparent,
                    child: ListTile(
                      title: Text(chapter.title, style: TextStyle(color: Colors.white)),
                      onTap: () {
                        widget.onChapterTap(chapter.id);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
