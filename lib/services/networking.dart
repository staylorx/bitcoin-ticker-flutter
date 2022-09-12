import 'dart:convert';

import 'package:bitcoin_ticker/utilities/log_printer.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:http/retry.dart';

final logger = Logger(printer: MyLogfmtPrinter('networking'));

class NetworkHelper {
  late Map result;
  late int statusCode;

  Future<void> get({required Uri uri}) async {
    final client = RetryClient(http.Client());
    try {
      var response = await client.get(uri);
      logger.d({
        "msg": "get()",
        "statusCode": response.statusCode,
        "body": response.body,
      });
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
      }
    } finally {
      client.close();
    }
  }
}
