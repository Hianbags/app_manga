import 'dart:convert';
import 'package:appmanga/Page/Shop_page/order/OrderSuccessScreen.dart';
import 'package:appmanga/Page/Shop_page/order/transaction.dart';
import 'package:appmanga/init/format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vnpay_client/vnpay_client.dart';
import 'package:http/http.dart' as http;
import 'package:appmanga/Model/Shop_Model/cart_provider_model.dart';
import 'package:appmanga/Model/Shop_Model/shipping_address_model.dart';
import 'package:appmanga/Service/Shop_service/order_service.dart';
import 'package:appmanga/Page/Shop_page/shipping_address_page.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  ShippingAddress? selectedAddress;
  String _paymentMethod = 'COD';

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _onPaymentSuccess(value) {
    _showSnackBar('Thanh toán thành công!');
    Provider.of<CartProvider>(context, listen: false).clearCart();
    Navigator.pop(context);

  }


  void _onPaymentFailure(error) {
    _showSnackBar('Thanh toán thất bại: $error');
  }

  Future<void> _createOrder() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final productIds = cartProvider.cartItems.map((item) => item.product.id).toList();
    if (selectedAddress == null) {
      _showSnackBar('Vui lòng chọn địa chỉ giao hàng.');
      return;
    }

    final orderService = OrderService();
    final result = await orderService.createOrder(
      selectedAddress!.id.toString(),
      productIds,
    );

    if (result['status'] == 'success') {
      final orderId = result['data']['id'].toString();
      if (_paymentMethod == 'VNPay') {
        final url = Uri.parse('https://magiabaiser.id.vn/api/vnpay-payment');
        final response = await http.post(url, body: {
          'id_order': orderId,
          'amount': cartProvider.getTotalPrice().toStringAsFixed(0),
        });
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['code'] == '01') {
            showVNPayScreen(
              context,
              paymentUrl: responseData['data'],
              onPaymentSuccess: _onPaymentSuccess,
              onPaymentError: _onPaymentFailure,
            );
          } else {
            _showSnackBar('Lỗi khi tạo URL thanh toán: ${responseData['message']}');
          }
        } else {
          _showSnackBar('Lỗi khi kết nối đến server.');
        }
      } else {
        _showSnackBar('Đặt hàng thành công!');
        cartProvider.clearCart();
        Navigator.pop(context);
      }
    } else {
      _showSnackBar('Đặt hàng thất bại: ${result['message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Theme(
      data: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.red[500], foregroundColor: Colors.white),
        buttonTheme: ButtonThemeData(buttonColor: Colors.blue, textTheme: ButtonTextTheme.primary),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.grey[500],
          ),
        ),
        textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black), bodyText2: TextStyle(color: Colors.black)),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text('Xác nhận đơn hàng')),
        body: CustomScrollView(
          slivers: [
            _buildHeader('Địa chỉ nhận hàng'),
            _buildAddressCard(),
            _buildSelectAddressButton(),
            SliverToBoxAdapter(child: Divider()),
            _buildHeader('Danh sách sản phẩm'),
            _buildProductList(cartProvider),
            SliverToBoxAdapter(child: Divider()),
            _buildHeader('Phương thức thanh toán'),
            _buildPaymentMethodOptions(),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(cartProvider),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildAddressCard() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: selectedAddress != null
            ? Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tên người nhận: ${selectedAddress!.recipientName}'),
                Text('Số điện thoại: ${selectedAddress!.phoneNumber}'),
                Text('Địa chỉ: ${selectedAddress!.streetAddress}, ${selectedAddress!.ward}, ${selectedAddress!.district}, ${selectedAddress!.province}'),
              ],
            ),
          ),
        )
            : Text('Chưa có địa chỉ nhận hàng'),
      ),
    );
  }

  Widget _buildSelectAddressButton() {
    return SliverToBoxAdapter(
      child: Center(
        child: ElevatedButton(
          onPressed: _selectAddress,
          child: Text('Chọn địa chỉ'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(CartProvider cartProvider) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final cartItem = cartProvider.cartItems[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            child: ListTile(
              leading: Image.network(cartItem.product.images.first),
              title: Text(cartItem.product.name),
              subtitle: Text('${cartItem.product.price} VNĐ x ${cartItem.quantity}'),
            ),
          );
        },
        childCount: cartProvider.cartItems.length,
      ),
    );
  }

  Widget _buildPaymentMethodOptions() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          _buildPaymentOption('COD'),
          _buildPaymentOption('Chuyển khoản ngân hàng', 'Bank Transfer'),
          _buildPaymentOption('VNPay'),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, [String? value]) {
    value ??= title;
    return ListTile(
      title: Text(title),
      leading: Radio<String>(
        value: value,
        groupValue: _paymentMethod,
        onChanged: (String? value) {
          setState(() {
            _paymentMethod = value!;
          });
        },
      ),
    );
  }

  Widget _buildBottomBar(CartProvider cartProvider) {
    return BottomAppBar(
      color: Colors.white,
      child: Container(
        height: 70,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tổng thanh toán: ${cartProvider.getTotalPrice().toStringAsFixed(0)} VNĐ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox.expand(
                child: ElevatedButton(
                  onPressed: _createOrder,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red[500],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: Text('Mua hàng'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectAddress() async {
    final ShippingAddress? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShippingAddressPage()),
    );
    if (result != null) {
      setState(() {
        selectedAddress = result;
      });
    }
  }
}
