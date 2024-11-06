import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ExpandableDescription extends StatefulWidget {
  final String description;

  ExpandableDescription({required this.description});

  @override
  _ExpandableDescriptionState createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mô tả sản phẩm',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: _isExpanded ? null : 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.white, width: 1.0),
                color: Colors.white,
              ),
              clipBehavior: Clip.antiAlias,
              child: Html(
                data: widget.description,
                style: {
                  "body": Style(
                    fontSize: FontSize(16.0),
                    color: Colors.black,
                  ),
                  'img': Style(
                    width: Width(MediaQuery.of(context).size.width, Unit.auto),
                    height: Height(MediaQuery.of(context).size.width, Unit.auto),
                    alignment: Alignment.center,
                  ),
                },
              ),
            ),
            if (!_isExpanded)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(12.0),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.grey.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Xem tất cả',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 5.0,
                                color: Colors.black38,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.expand_more,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (_isExpanded)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Thu gọn',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 5.0,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.expand_less,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}