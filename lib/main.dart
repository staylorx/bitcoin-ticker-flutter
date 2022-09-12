import 'package:bitcoin_ticker/utilities/log_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'price_screen.dart';
import 'package:logger/logger.dart';

final logger = Logger(printer: MyLogfmtPrinter("main"));

void main() async {
  if (kReleaseMode) {
    Logger.level = Level.info;
    logger.d("main: Setting production mode");
    await dotenv.load(fileName: ".env.prod");
  } else {
    Logger.level = Level.debug;
    logger.d("main: Setting development mode");
    await dotenv.load(fileName: ".env.dev");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.lightBlue,
          scaffoldBackgroundColor: Colors.white),
      home: const PriceScreen(),
    );
  }
}
