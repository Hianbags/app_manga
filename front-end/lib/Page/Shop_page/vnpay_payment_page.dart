import 'package:flutter/material.dart';
import 'package:vnpay_client/vnpay_client.dart';


class vnpay_page extends StatefulWidget {
  const vnpay_page({Key? key}) : super(key: key);

  @override
  State<vnpay_page> createState() => _MyAppState();
}

class _MyAppState extends State<vnpay_page> {
  @override
  void initState() {
    super.initState();
  }

  final paymentUrl = 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=10000000&vnp_BankCode=NCB&vnp_Command=pay&vnp_CreateDate=20240806170005&vnp_CurrCode=VND&vnp_IpAddr=127.0.0.1&vnp_Locale=VN&vnp_OrderInfo=Thanh+to%C3%A1n+h%C3%B3a+%C4%91%C6%A1n+cho+%C4%91%C6%A1n+h%C3%A0ng+s%E1%BB%91+100000&vnp_OrderType=billpayment&vnp_ReturnUrl=https%3A%2F%2Flocalhost%2Fvnpay_php%2Fvnpay_return.php&vnp_TmnCode=EPCM7LL3&vnp_TxnRef=100000&vnp_Version=2.1.0&vnp_SecureHash=ad7a090d0bab1991acab85dd55443e09460f341e22d46e37802a68a807721efd3f661d05a48697f96d568d444c6df6295b0e6cf8f033d0751798ae72f8a26d7e';

  void _onPaymentSuccess(data) {}

  void _onPaymentFailure(error) {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (BuildContext context) {
              return OutlinedButton(
                onPressed: () {
                  showVNPayScreen(
                    context,
                    paymentUrl: paymentUrl,
                    onPaymentSuccess: _onPaymentSuccess,
                    onPaymentError: _onPaymentFailure,
                  );
                },
                child: const Text('Click me'),
              );
            },
          ),
        ),
      ),
    );
  }
}
