import 'package:appmanga/Page/Manga_Page/Chapter_page/rating_action.dart';
import 'package:flutter/material.dart';

class ChapterBottomAppBar extends StatelessWidget {
  final int currentChapterIndex;
  final int totalChapters;
  final VoidCallback onPreviousChapter;
  final VoidCallback onNextChapter;
  final VoidCallback onToggleChapterList;
  final VoidCallback onToggleCommentList;
  final int mangaId;
  ChapterBottomAppBar({
    required this.currentChapterIndex,
    required this.totalChapters,
    required this.onPreviousChapter,
    required this.onNextChapter,
    required this.onToggleChapterList,
    required this.onToggleCommentList,
    required this.mangaId,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: 60.0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: currentChapterIndex > 0 ? Colors.white : Colors.grey),
              onPressed: currentChapterIndex > 0 ? onPreviousChapter : null,
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: onToggleChapterList,
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.comment, color: Colors.white),
                  onPressed: onToggleCommentList,
                ),
                IconButton(
                  icon: Icon(Icons.star, color: Colors.white),
                  onPressed: () {
                    showRatingDialog(context, mangaId);
                  },
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: currentChapterIndex < totalChapters - 1 ? Colors.white : Colors.grey),
              onPressed: currentChapterIndex < totalChapters - 1 ? onNextChapter : null,
            ),
          ],
        ),
      ),
    );
  }
}
