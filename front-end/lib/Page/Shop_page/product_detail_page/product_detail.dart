import 'package:appmanga/Page/Shop_page/product_detail_page/expandable_description.dart';
import 'package:flutter/material.dart';
import 'package:appmanga/Model/Shop_Model/product_detail_model.dart';

class ProductDetails extends StatelessWidget {
  final ProductDetail product;

  ProductDetails({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0), // Thêm padding xung quanh tất cả các widget trừ Divider
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thương hiệu: Nam pro',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Row(
                    children: [
                      _buildTag('TOP DEAL', Colors.red),
                      SizedBox(width: 10),
                      _buildTag('CHÍNH HÃNG', Colors.blue),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                product.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '5,0',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Icon(Icons.star, color: Colors.orange, size: 16),
                  SizedBox(width: 5),
                  Text(
                    '(100 đánh giá)',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(width: 10),
                  Text(product.category.toList().map((e) => e.title).join(', '),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                '${product.price.toString()} VND',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        Divider(color: Colors.grey[200], thickness: 10),
        Padding(
          padding: EdgeInsets.all(16.0), // Thêm padding cho ExpandableDescription và các widget khác
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpandableDescription(description: product.description),
              SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}