import 'package:bitcoin_ticker/services/networking.dart';
import 'package:bitcoin_ticker/utilities/log_printer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

final logger = Logger(printer: MyLogfmtPrinter("coin_data"));

const kCryptoLookupURLBase = 'https://rest.coinapi.io/v1/exchangerate';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  // 'GBP',
  // 'HKD',
  // 'IDR',
  // 'ILS',
  // 'INR',
  // 'JPY',
  // 'MXN',
  // 'NOK',
  // 'NZD',
  // 'PLN',
  // 'RON',
  // 'RUB',
  // 'SEK',
  // 'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  int currentStatusCode = -999;

  Future<double> getPrice(
    String cryptoCode,
    String currencyCode,
  ) async {
    var params = {
      "apikey": dotenv.env['COINAPI_KEY'] ?? "COINAPI_KEY_NOT_SET",
    };
    final String queryString = _convertQueryMapToString(params);

    Uri uri = Uri.parse(
        "$kCryptoLookupURLBase/$cryptoCode/$currencyCode?$queryString");
    NetworkHelper nw = NetworkHelper();
    await nw.get(uri: uri);
    currentStatusCode = nw.statusCode;

    if (nw.statusCode == 200) {
      double lastPrice = await nw.result['rate'];
      logger.d("$cryptoCode:$currencyCode lastPrice=$lastPrice");
      return lastPrice;
    }

    logger.w("Returning infinity. Check the logic.");
    return double.infinity;
  }

  static String _convertQueryMapToString(Map queryMap) {
    //https://www.kindacode.com/article/dart-convert-map-to-query-string-and-vice-versa
    final String queryString = Uri(
      queryParameters: queryMap.map(
        (key, value) => MapEntry(
          key,
          value.toString(),
        ),
      ),
    ).query;

    return queryString;
  }
}
