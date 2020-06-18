import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:implulsnew/screens/logged_in_user_screen.dart';
import 'package:logger/logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
//  log();
}

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

//void log() {
//  logger.d("Log message with 2 methods");
//
//  loggerNoStack.i("Info message");
//
//  loggerNoStack.w("Just a warning!");
//
//  logger.e("Error! Something bad happened", "Test Error");
//
//  loggerNoStack.v({"key": 5, "value": "something"});
//
//  Future.delayed(Duration(seconds: 5), log);
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: Home());
  }
}

class Home extends StatelessWidget {
  void onLogoPressed(BuildContext context) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => Logo()));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FractionallySizedBox(
          heightFactor: 0.9,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: InkWell(
                onTap: () => onLogoPressed(context),
                child: Image.asset(
                  "assets/images/logoMPapp.png",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
