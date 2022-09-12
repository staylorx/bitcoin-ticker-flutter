import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/utilities/log_printer.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

final logger = Logger(printer: MyLogfmtPrinter("price_screen"));

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  PriceScreenState createState() => PriceScreenState();
}

class PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  double btcPrice = double.infinity;
  double ethPrice = double.infinity;
  double ltcPrice = double.infinity;

  CoinData coinData = CoinData();

  @override
  void initState() {
    getPrice(selectedCurrency);
    super.initState();
  }

  void getPrice(String currencyCode) async {
    CoinData coinData = CoinData();
    double btcPrice2 = await coinData.getPrice('BTC', currencyCode);
    double ethPrice2 = await coinData.getPrice('ETH', currencyCode);
    double ltcPrice2 = await coinData.getPrice('LTC', currencyCode);

    setState(() {
      selectedCurrency = currencyCode;
      btcPrice = btcPrice2;
      ethPrice = ethPrice2;
      ltcPrice = ltcPrice2;
    });
  }

  CupertinoPicker iOSPicker() {
    List<Widget> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = Text(currency);
      dropdownItems.add(newItem);
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        logger.d('$selectedIndex');
      },
      children: dropdownItems,
    );
  }

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      items: dropdownItems,
      value: selectedCurrency,
      onChanged: (value) {
        logger.d("$value");

        setState(() {
          getPrice(value!);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PaddedCard(
            cryptoCode: 'BTC',
            price: btcPrice,
            selectedCurrency: selectedCurrency,
          ),
          PaddedCard(
            cryptoCode: 'ETH',
            price: ethPrice,
            selectedCurrency: selectedCurrency,
          ),
          PaddedCard(
            cryptoCode: 'LTC',
            price: ltcPrice,
            selectedCurrency: selectedCurrency,
          ),
          SizedBox(
            height: 300, //hardcode... Expanded(flex)?
            child: Container(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Platform.isIOS ? iOSPicker() : getDropdownButton()],
            ),
          ),
        ],
      ),
    );
  }
}

class PaddedCard extends StatelessWidget {
  const PaddedCard({
    Key? key,
    required this.cryptoCode,
    required this.price,
    required this.selectedCurrency,
  }) : super(key: key);

  final double price;
  final String selectedCurrency;
  final String cryptoCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 28.0,
          ),
          child: Text(
            '1 $cryptoCode = ${price.toStringAsFixed(2)} $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
