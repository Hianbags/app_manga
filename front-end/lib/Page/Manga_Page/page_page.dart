import 'package:appmanga/Page/Manga_Page/Chapter_page/appbar.dart';
import 'package:appmanga/Page/Manga_Page/Chapter_page/bottomappbar.dart';
import 'package:appmanga/Page/Manga_Page/Chapter_page/chapterlist.dart';
import 'package:appmanga/Page/Manga_Page/Chapter_page/commentlist.dart';
import 'package:appmanga/Page/Manga_Page/Chapter_page/pageview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:page_flip/page_flip.dart';
import 'package:appmanga/Model/Manga_Model/manga_detail_model.dart';
import 'package:appmanga/Model/Manga_Model/page_model.dart';
import 'package:appmanga/Model/Manga_Model/comment_model.dart';
import 'package:appmanga/Model/Manga_Model/reading_history_model.dart';
import 'package:appmanga/Service/Manga_Service/page_service.dart';
import 'package:appmanga/Service/Manga_Service/comment_service.dart';
import 'package:appmanga/provider_model/Manga/reding_history.dart';


class ChapterPage extends StatefulWidget {
  final MangaDetail mangaDetail;
  final int chapterId;
  final int currentChapter;
  final int totalChapters;
  final List<dynamic> chapters;

  ChapterPage({
    required this.mangaDetail,
    required this.chapterId,
    required this.currentChapter,
    required this.totalChapters,
    required this.chapters,
  });

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  late Future<List<PageModel>> _futureChapterPages;
  late Future<CommentResponse> _futureComments;

  bool _isAppBarVisible = true;
  bool _isBottomAppBarVisible = true;
  bool _isReadingList = true;
  bool _isReadingBook = false;
  bool _isChapterListVisible = false;
  bool _isCommentListVisible = false;
  bool _isSortedByNewest = true;
  final _controller = GlobalKey<PageFlipWidgetState>();
  late int _currentChapterId;
  late int _currentChapterIndex;

  @override
  void initState() {
    super.initState();
    _currentChapterId = widget.chapterId;
    _currentChapterIndex = widget.currentChapter - 1;
    _futureChapterPages = ChapterService().fetchChapterPages(_currentChapterId);
    _futureComments = CommentService().fetchComments(widget.mangaDetail.id);
    _addReadingHistory(context);
  }

  void _toggleAppBarVisibility() {
    setState(() {
      if (_isChapterListVisible || _isCommentListVisible) {
        _isChapterListVisible = false;
        _isCommentListVisible = false;
      } else {
        _isAppBarVisible = !_isAppBarVisible;
        _isBottomAppBarVisible = !_isBottomAppBarVisible;
      }
    });
  }

  void _toggleChapterListVisibility() {
    setState(() {
      _isChapterListVisible = !_isChapterListVisible;
    });
  }

  void _toggleCommentListVisibility() {
    setState(() {
      _isCommentListVisible = !_isCommentListVisible;
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _isSortedByNewest = !_isSortedByNewest;
    });
  }

  void _navigateToChapter(int chapterId) {
    setState(() {
      _currentChapterId = chapterId;
      _futureChapterPages = ChapterService().fetchChapterPages(chapterId);
      _isChapterListVisible = false;
    });
    _addReadingHistory(context);
  }

  void _addReadingHistory(BuildContext context) async {
    final sortedChapters = _isSortedByNewest ? widget.chapters : widget.chapters.reversed.toList();
    final chapter = sortedChapters.firstWhere((c) => c.id == _currentChapterId);

    ReadingHistory newHistory = ReadingHistory(
      mangaId: widget.mangaDetail.id,
      title: widget.mangaDetail.title,
      image: widget.mangaDetail.image,
      currentChapter: ChapterReadingHistory(
        id: chapter.id,
        title: chapter.title,
      ),
    );
    await Provider.of<ReadingHistoryListNotifier>(context, listen: false).addReadingHistory(newHistory);
  }

  @override
  Widget build(BuildContext context) {
    final sortedChapters = _isSortedByNewest ? widget.chapters : widget.chapters.reversed.toList();
    final chapterTitle = sortedChapters.firstWhere((c) => c.id == _currentChapterId).title;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: _toggleAppBarVisibility,
            child: FutureBuilder<List<PageModel>>(
              future: _futureChapterPages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                } else {
                  return _isReadingList
                      ? PageListView(pages: snapshot.data!)
                      : PageBookView(pages: snapshot.data!, controller: _controller);
                }
              },
            ),
          ),
          if (_isAppBarVisible) ChapterAppBar(chapterTitle: chapterTitle, onChangeMode: _changeReadingMode),
          if (_isBottomAppBarVisible)
            ChapterBottomAppBar(
              currentChapterIndex: _currentChapterIndex,
              totalChapters: widget.totalChapters,
              onPreviousChapter: _navigateToPreviousChapter,
              onNextChapter: _navigateToNextChapter,
              onToggleChapterList: _toggleChapterListVisibility,
              onToggleCommentList: _toggleCommentListVisibility,
              mangaId: widget.mangaDetail.id,
            ),
          if (_isChapterListVisible)
            ChapterList(
              chapters: widget.chapters,
              currentChapterId: _currentChapterId,
              isSortedByNewest: _isSortedByNewest,
              onChapterTap: _navigateToChapter,
              onToggleSortOrder: _toggleSortOrder,
            ),
          if (_isCommentListVisible)
            CommentList(
              mangaId: widget.mangaDetail.id,
              futureComments: _futureComments,
              onRefreshComments: _refreshComments,
            ),
        ],
      ),
    );
  }

  void _navigateToPreviousChapter() {
    if (_currentChapterIndex > 0) {
      setState(() {
        _currentChapterIndex--;
        _currentChapterId = widget.chapters[_currentChapterIndex].id;
        _futureChapterPages = ChapterService().fetchChapterPages(_currentChapterId);
      });
      _addReadingHistory(context);
    }
  }

  void _navigateToNextChapter() {
    if (_currentChapterIndex < widget.totalChapters - 1) {
      setState(() {
        _currentChapterIndex++;
        _currentChapterId = widget.chapters[_currentChapterIndex].id;
        _futureChapterPages = ChapterService().fetchChapterPages(_currentChapterId);
      });
      _addReadingHistory(context);
    }
  }

  void _changeReadingMode(bool isReadingList) {
    setState(() {
      _isReadingList = isReadingList;
      _isReadingBook = !isReadingList;
    });
  }

  void _refreshComments() {
    setState(() {
      _futureComments = CommentService().fetchComments(widget.mangaDetail.id);
    });
  }
}
