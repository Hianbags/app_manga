import 'package:appmanga/Page/Shop_page/order/transaction.dart';

String formatChapterTitle(String title) {
  RegExp regex = RegExp(r'\d+$');
  Match? match = regex.firstMatch(title);
  if (match != null) {
    String lastNumber = match.group(0)!;
    return "Chapter " + lastNumber;
  } else {
    return title;
  }
}
String createUrl(Transaction transaction, String baseUrl) {
  Map<String, String> queryParams = transaction.toMap();
  String queryString = Uri(queryParameters: queryParams).query;
  return '$baseUrl?$queryString';
}