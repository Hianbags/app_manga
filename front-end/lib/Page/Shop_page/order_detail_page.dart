import 'package:appmanga/Model/Shop_Model/order_detail_model.dart';
import 'package:appmanga/Service/Shop_service/order_list_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import thêm để gọi API

class OrderDetailPage extends StatefulWidget {
  final int orderId;

  OrderDetailPage({required this.orderId});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Future<OrderDetail> futureOrderDetail;

  @override
  void initState() {
    super.initState();
    futureOrderDetail = OrderService().fetchOrderDetail(widget.orderId);
  }

  Future<void> _cancelOrder() async {
    try {
      final response = await http.put(
        Uri.parse('https://magiabaiser.id.vn/api/order/${widget.orderId}'),
        body: {'status': 'cancelled'},
      );
      print(response.statusCode);
      if (response.statusCode == 200) {

        setState(() {
          futureOrderDetail = OrderService().fetchOrderDetail(widget.orderId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đơn hàng đã được hủy thành công.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hủy đơn hàng thất bại.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin đơn hàng'),
      ),
      body: FutureBuilder<OrderDetail>(
        future: futureOrderDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Order not found'));
          } else {
            final order = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderInfoSection(order),
                    SizedBox(height: 20),
                    _buildStatusSection(order),
                    SizedBox(height: 20),
                    _buildProductsSection(order),
                    SizedBox(height: 20),
                    _buildTotalPriceSection(order),
                    SizedBox(height: 20),
                    _buildDatesSection(order),
                    if (order.status != 'cancelled') // Ẩn nút nếu đơn hàng đã hủy
                      Center(
                        child: ElevatedButton(
                          onPressed: _cancelOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text('Hủy đơn hàng'),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderInfoSection(OrderDetail order) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mã Đơn Hàng: ${order.id}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Người nhận: ${order.shippingAddress.recipientName}', style: TextStyle(fontSize: 16)),
              Text('Địa chỉ: ${order.shippingAddress.streetAddress}, ${order.shippingAddress.ward}, ${order.shippingAddress.district}, ${order.shippingAddress.province}'),
              Text('Số điện thoại: ${order.shippingAddress.phoneNumber}'),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusInVietnamese(String status) {
    switch (status) {
      case 'pending':
        return 'Đang chờ xử lý';
      case 'Processing':
        return 'Đang xử lý';
      case 'completed':
        return 'Đã hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'Processing':
        return Icons.sync;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  Widget _buildStatusSection(OrderDetail order) {
    String statusText = _getStatusInVietnamese(order.status);
    Color statusColor = _getStatusColor(order.status);
    IconData statusIcon = _getStatusIcon(order.status);

    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(0),
        color: statusColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 30),
              SizedBox(width: 10),
              Text(statusText, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: statusColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsSection(OrderDetail order) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sản phẩm:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Column(
                children: order.products.map((product) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: product.imagePath != null
                          ? Image.network(product.imagePath!, width: 50, height: 50)
                          : null,
                      title: Text(product.name),
                      subtitle: Text('Giá: ${product.price} x ${product.quantity}'),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalPriceSection(OrderDetail order) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng giá:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${order.totalPrice}', style: TextStyle(fontSize: 18, color: Colors.redAccent)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatesSection(OrderDetail order) {
    return Container(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ngày tạo: ${order.createdAt}', style: TextStyle(fontSize: 16)),
              Text('Ngày cập nhật: ${order.updatedAt}', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
