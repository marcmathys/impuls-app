import 'package:flutter/material.dart';
import 'package:implulsnew/screens/logged_in_user_screen.dart';
import 'package:flutter/services.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(MyApp());
  });
}


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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: InkWell(
                  onTap: () => onLogoPressed(context),
                  child: Image.asset(
                    "assets/images/screen-shot-2020-03-14-at-102826-pm.png",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
