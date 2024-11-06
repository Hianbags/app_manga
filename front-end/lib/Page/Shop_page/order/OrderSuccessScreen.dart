import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt đơn thành công'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Đơn hàng của bạn đã được đặt thành công!',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Điều hướng tới trang mua sắm
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ShoppingScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text('Tiếp tục mua sắm'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Điều hướng tới trang quản lý đơn hàng
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderManagementScreen()),
                );
              },
              child: Text('Vào quản lý đơn hàng'),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mua sắm'),
      ),
      body: Center(
        child: Text('Trang mua sắm'),
      ),
    );
  }
}

class OrderManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn hàng'),
      ),
      body: Center(
        child: Text('Trang quản lý đơn hàng'),
      ),
    );
  }
}
