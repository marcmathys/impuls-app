import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:implulsnew/bt/Bluetooth_screen.dart';
import 'package:provider/provider.dart';
import 'package:implulsnew/model/user_repository.dart';
import 'package:implulsnew/screens/login_screen.dart';
import 'package:implulsnew/screens/choose_patient_screen.dart';
import 'package:implulsnew/styles/button.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepository.instance(),
      child: Consumer<UserRepository>(
        builder: (context, UserRepository user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Splash();
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginPage();
            case Status.Authenticated:
              return UserInfoPage(user: user.user);
          }
          return null;},
      ),
    );
  }
}

class UserInfoPage extends StatelessWidget {
  final FirebaseUser user;

  void onButtonsChoosePressed(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => ChoosePatientWidget()));

  void onButtonsConnectPressed(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => FlutterBlueApp()));

  const UserInfoPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Development Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user.email),
            SizedBox(
              height: 15.0,
            ),
            ButtonButton(
              padding: EdgeInsets.all(30),
              onPressed: () => this.onButtonsConnectPressed(context),
              child: Text(
                "Lets get the device conncted",
                textAlign: TextAlign.left,
                style: TextStyle(),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            ButtonButton(
              padding: EdgeInsets.all(30),
              onPressed: () => this.onButtonsChoosePressed(context),
              child: Text(
                "Lets get started",
                textAlign: TextAlign.left,
                style: TextStyle(),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              child: Text("All DONE and SIGN OUT"),
              onPressed: () => Provider.of<UserRepository>(context, listen: false).signOut(),
            )
          ],
        ),
      ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Splash Screen"),
      ),
    );
  }
}

