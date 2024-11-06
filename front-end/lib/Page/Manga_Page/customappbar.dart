import 'package:appmanga/Model/Manga_Model/manga_detail_model.dart';
import 'package:appmanga/Page/Manga_Page/page_page.dart';
import 'package:appmanga/Service/Manga_Service/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class CustomBottomAppBar extends StatefulWidget {
  final MangaDetail mangaDetail;

  CustomBottomAppBar({required this.mangaDetail});

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.mangaDetail.favorite;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: 0), weight: 1),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToChapterPage(BuildContext context, int chapterId, int currentChapter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterPage(
          mangaDetail: widget.mangaDetail,
          chapterId: chapterId,
          currentChapter: currentChapter,
          totalChapters: widget.mangaDetail.chapters.length,
          chapters: widget.mangaDetail.chapters,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade700, Colors.red.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(35.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildFixedSizeButton(
            'Đọc từ đầu',
            context,
            Colors.white,
            Colors.redAccent,
                () {
              _navigateToChapterPage(context, widget.mangaDetail.chapters.first.id, 1);
            },
          ),
          _buildFixedSizeButton(
            'Đọc mới nhất',
            context,
            Colors.white,
            Colors.redAccent,
                () {
              _navigateToChapterPage(context, widget.mangaDetail.chapters.last.id, widget.mangaDetail.chapters.length);
            },
          ),
          _buildFavoriteIcon(context),
        ],
      ),
    );
  }

  Widget _buildFixedSizeButton(
      String label,
      BuildContext context,
      Color textColor,
      Color backgroundColor,
      VoidCallback onPressed,
      ) {
    return Container(
      width: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
          elevation: 5,
        ),
      ),
    );
  }

  Widget _buildFavoriteIcon(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 0.0174533, // Convert degrees to radians
          child: child,
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent,
        ),
        child: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
            FavoriteService().markAsFavorite(widget.mangaDetail.id);
            _controller.forward(from: 0);
          },
        ),
      ),
    );
  }
}
