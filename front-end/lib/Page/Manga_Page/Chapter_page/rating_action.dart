import 'package:appmanga/Service/Manga_Service/rating_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

void showRatingDialog(BuildContext context, int mangaId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return RatingDialog(mangaId: mangaId);
    },
  );
}

class RatingDialog extends StatefulWidget {
  final int mangaId;

  const RatingDialog({required this.mangaId, Key? key}) : super(key: key);

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Đánh giá truyện'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: StarRating(
              size: 30.0,
              rating: _rating,
              starCount: 5,
              color: Colors.amber,
              onRatingChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('hủy'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('gửi'),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            Navigator.of(context).pop();
            if (mounted) {
              final ratingService = RatingService();
              final result = await ratingService.submitRating(widget.mangaId, _rating.toInt());

              // Sử dụng messenger đã lưu để hiển thị SnackBar
              messenger.showSnackBar(
                SnackBar(content: Text(result['message'])),
              );
            }
          },
        ),
      ],
    );
  }
}
