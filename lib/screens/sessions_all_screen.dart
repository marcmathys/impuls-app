//TODO make graphs and make up and down arroes work changing the session number

import 'package:flutter/material.dart';
import 'package:implulsnew/screens/session_review_screen.dart';
import 'package:implulsnew/styles/button.dart';
import 'package:implulsnew/styles/h3.dart';
import 'package:implulsnew/styles/h5.dart';
import 'package:implulsnew/screens/pain_level_final_screen.dart';

class AllSessionsResultsWidget extends StatelessWidget {
  void onEndSessionPressed(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => FinalPainLevelWidget()));

  void onIconNavigationArrowDropUp24pxPressed(BuildContext context) {}

  void onIconNavigationArrowDropDown24pxPressed(BuildContext context) {}

  void goToSession(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => SessionReviewWidget()));

  final int sessionNumber = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                H3(
                  child: Text(
                    "Results Review",
                    textAlign: TextAlign.left,
                    style: TextStyle(),
                  ),
                ),
                buildSessionControl(context),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                H5(
                  child: Text(
                    "Thresholds by Session",
                    textAlign: TextAlign.left,
                    style: TextStyle(),
                  ),
                ),
                H5(
                  child: Text(
                    "Pain Levels by Session",
                    textAlign: TextAlign.left,
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.all(10.0),
//                  decoration: BoxDecoration(
//                    border: Border.all(),
//                  ),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      Row(
//                        children: [
//                          Image.asset(
//                            "assets/images/path-2020.png",
//                          ),
//                          Text(
//                            " Sensory Threshold",
//                            textAlign: TextAlign.left,
//                            style: TextStyle(),
//                          ),
//                        ],
//                      ),
//                      Row(
//                        children: [
//                          Image.asset(
//                            "assets/images/path-2022.png",
//                          ),
//                          Text(
//                            " Pain Tolerance",
//                            textAlign: TextAlign.left,
//                            style: TextStyle(),
//                          ),
//                        ],
//                      ),
//                      Row(
//                        children: <Widget>[
//                          Image.asset(
//                            "assets/images/path-2021.png",
//                          ),
//                          Text(
//                            " Pain Threshold",
//                            textAlign: TextAlign.left,
//                            style: TextStyle(),
//                          ),
//                        ],
//                      ),
//                    ],
//                  ),
//                ),
//                Container(
//                  padding: EdgeInsets.all(10.0),
//                  decoration: BoxDecoration(
//                    border: Border.all(),
//                  ),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      Row(
//                        children: [
//                          Image.asset(
//                            "assets/images/path-2020.png",
//                          ),
//                          Text(
//                            " Before",
//                            textAlign: TextAlign.left,
//                            style: TextStyle(),
//                          ),
//                        ],
//                      ),
//                      Row(
//                        children: [
//                          Image.asset(
//                            "assets/images/path-2022.png",
//                          ),
//                          Text(
//                            " After",
//                            textAlign: TextAlign.left,
//                            style: TextStyle(),
//                          ),
//                        ],
//                      ),
//                    ],
//                  ),
//                ),
//              ],
//            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GraphBox(),
                  SizedBox.fromSize(),
                  GraphBox(),
                ]),
            Row(
              children: [
                Text(
                  "Stimulation Level (mA)",
                  textAlign: TextAlign.left,
                  style: TextStyle(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () => this.onEndSessionPressed(context),
                  child: Text(
                    "SESSION END",
                    textAlign: TextAlign.left,
                    style: TextStyle(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Row buildSessionControl(BuildContext context) {
    return Row(
      children: [
        FlatButton(
          onPressed: () => this.onIconNavigationArrowDropUp24pxPressed(context),
          color: Color.fromARGB(0, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          textColor: Color.fromARGB(255, 0, 0, 0),
          padding: EdgeInsets.all(0),
          child: Image.asset(
            "assets/images/icon-navigation-arrow-drop-up-24px.png",
          ),
        ),
        ButtonButton(
          padding: EdgeInsets.all(0),
          onPressed: () => this.goToSession(context),
          child: Text(
            "SESSION $sessionNumber REVIEW",
            textAlign: TextAlign.left,
            style: TextStyle(),
          ),
        ),
        FlatButton(
          onPressed: () =>
              this.onIconNavigationArrowDropDown24pxPressed(context),
          color: Color.fromARGB(0, 0, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          textColor: Color.fromARGB(255, 0, 0, 0),
          padding: EdgeInsets.all(0),
          child: Image.asset(
            "assets/images/icon-navigation-arrow-drop-down-24px.png",
          ),
        ),
      ],
    );
  }
}
