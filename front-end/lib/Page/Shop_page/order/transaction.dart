import 'dart:convert';
import 'package:http/http.dart' as http;

class Transaction {
  final int amount;
  final String bankCode;
  final String bankTranNo;
  final String cardType;
  final String orderInfo;
  final String payDate;
  final String responseCode;
  final String tmnCode;
  final String transactionNo;
  final String transactionStatus;
  final String txnRef;
  final String secureHash;

  Transaction({
    required this.amount,
    required this.bankCode,
    required this.bankTranNo,
    required this.cardType,
    required this.orderInfo,
    required this.payDate,
    required this.responseCode,
    required this.tmnCode,
    required this.transactionNo,
    required this.transactionStatus,
    required this.txnRef,
    required this.secureHash,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: int.parse(json['vnp_Amount']),
      bankCode: json['vnp_BankCode'],
      bankTranNo: json['vnp_BankTranNo'],
      cardType: json['vnp_CardType'],
      orderInfo: json['vnp_OrderInfo'],
      payDate: json['vnp_PayDate'],
      responseCode: json['vnp_ResponseCode'],
      tmnCode: json['vnp_TmnCode'],
      transactionNo: json['vnp_TransactionNo'],
      transactionStatus: json['vnp_TransactionStatus'],
      txnRef: json['vnp_TxnRef'],
      secureHash: json['vnp_SecureHash'],
    );
  }

  Map<String, String> toMap() {
    return {
      'vnp_Amount': amount.toString(),
      'vnp_BankCode': bankCode,
      'vnp_BankTranNo': bankTranNo,
      'vnp_CardType': cardType,
      'vnp_OrderInfo': orderInfo,
      'vnp_PayDate': payDate,
      'vnp_ResponseCode': responseCode,
      'vnp_TmnCode': tmnCode,
      'vnp_TransactionNo': transactionNo,
      'vnp_TransactionStatus': transactionStatus,
      'vnp_TxnRef': txnRef,
      'vnp_SecureHash': secureHash,
    };
  }
}
Future<void> makePostRequest(String urlString) async {
  final url = Uri.parse(urlString);
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.post(url, headers: headers);
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Success: ${response.body}');
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}