import 'package:appmanga/Model/Shop_Model/order_model.dart';
import 'package:appmanga/Service/Shop_service/order_list_service.dart';
import 'package:flutter/material.dart';
import 'order_detail_page.dart'; // Import the OrderDetailPage

class OrderlistPage extends StatefulWidget {
  @override
  _OrderlistPageState createState() => _OrderlistPageState();
}

class _OrderlistPageState extends State<OrderlistPage> with SingleTickerProviderStateMixin {
  late Future<OrderResponse> futurePendingOrders;
  late Future<OrderResponse> futureProcessingOrders;
  late Future<OrderResponse> futureCompletedOrders;
  late Future<OrderResponse> futureCancelledOrders;

  @override
  void initState() {
    super.initState();
    futurePendingOrders = OrderService().fetchOrders('pending');
    futureProcessingOrders = OrderService().fetchOrders('processing');
    futureCompletedOrders = OrderService().fetchOrders('completed');
    futureCancelledOrders = OrderService().fetchOrders('cancelled');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Danh sách đơn hàng'),
          bottom: TabBar(
            isScrollable: true, // Make the tabs scrollable
            tabs: [
              Tab(text: 'Đang chờ xử lý'),
              Tab(text: 'Đang xử lý'),
              Tab(text: 'Hoàn thành'),
              Tab(text: 'Đã hủy'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderListView(futureOrders: futurePendingOrders),
            OrderListView(futureOrders: futureProcessingOrders),
            OrderListView(futureOrders: futureCompletedOrders),
            OrderListView(futureOrders: futureCancelledOrders),
          ],
        ),
      ),
    );
  }
}

class OrderListView extends StatelessWidget {
  final Future<OrderResponse> futureOrders;

  OrderListView({required this.futureOrders});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OrderResponse>(
      future: futureOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Order> orders = snapshot.data!.data;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Order order = orders[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailPage(orderId: order.id),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mã Đơn hàng: ${order.id}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('Tổng thanh toán: ${order.totalPrice} đ', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                        Text('Danh sách sản phẩm:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Column(
                          children: order.products.map((product) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(product.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                        SizedBox(height: 5),
                                        Text('số lượng: ${product.quantity}', style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                  Text('${product.price} đ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Center(child: Text('No Orders Found'));
      },
    );
  }
}
