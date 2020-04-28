
import 'package:flutter/material.dart';
import 'package:implulsnew/styles/h2.dart';
import 'package:implulsnew/styles/h3.dart';
import 'package:implulsnew/styles/button.dart';
import 'package:implulsnew/screens/logged_in_user_screen.dart';

class FinalPainLevelWidget extends StatefulWidget {
  @override
  _FinalPainLevelWidgetState createState() => _FinalPainLevelWidgetState();
}

class _FinalPainLevelWidgetState extends State<FinalPainLevelWidget> {

  void onLogOutPressed(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => Logo()));


  static double _rating=1;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            H2(
              child: Text(
                "Final Pain Level",
                textAlign: TextAlign.left,
                style: TextStyle(),
              ),
            ),
            H3(
              child: Text(
                "Rate from 0-10",
                textAlign: TextAlign.left,
                style: TextStyle(),
              ),
            ),
            Spacer(),
            FractionallySizedBox(
              widthFactor: 0.6,
              child: Slider(
                min: 0,
                max: 10,
                divisions: 100,
                activeColor: Colors.indigo,
                inactiveColor: Color(0xffD97676),
                value: _rating,
                onChanged: (newrating) {
                  setState(() => _rating = newrating);
                },
                label: "$_rating",
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ButtonButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () =>
                      this.onLogOutPressed(context),
                  child: Text(
                    "SUBMIT AND LOG OUT",
                    textAlign: TextAlign.left,
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
