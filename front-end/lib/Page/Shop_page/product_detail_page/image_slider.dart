import 'package:flutter/material.dart';
import 'package:appmanga/Model/Shop_Model/product_detail_model.dart';

class ImageSlider extends StatefulWidget {
  final ProductDetail product;

  ImageSlider({required this.product});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            itemCount: widget.product.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.product.images[index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            color: Colors.black54,
            child: Text(
              '${_currentPage + 1} / ${widget.product.images.length}',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
