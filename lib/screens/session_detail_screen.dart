//TODO amke graph of EKG data
/*
*  session_detail_screen.dart
*  KleinKlein Wireframes
*
*  Created by marc.
*  Copyright © 2018 Uni-Marburg. All rights reserved.
    */

import 'package:flutter/material.dart';
import 'package:implulsnew/screens/session_review_screen.dart';
import 'package:implulsnew/styles/button.dart';

class SessionDetailWidget extends SessionReviewWidget {
  void onButton3BackContainedATextLightCopyPressed(BuildContext context) =>
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SessionReviewWidget()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Session $sessionNumber Detail",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromARGB(222, 0, 0, 0),
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w300,
                          fontSize: 48,
                          letterSpacing: -0.75,
                        ),
                      ),
                      ButtonButton(
//                  padding: EdgeInsets.all(0),
                        onPressed: () => this
                            .onButton3BackContainedATextLightCopyPressed(
                                context),
                        child: Text(
                          "BACK TO SESSION REVIEW",
                          textAlign: TextAlign.left,
                          style: TextStyle(),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        "EKG",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromARGB(222, 0, 0, 0),
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          letterSpacing: -0.375,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 75,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 216, 216, 216),
                      border: Border.all(
                        width: 1,
                        color: Color.fromARGB(255, 151, 151, 151),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        "Blood Pressure",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromARGB(222, 0, 0, 0),
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          letterSpacing: -0.375,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 75,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 216, 216, 216),
                      border: Border.all(
                        width: 1,
                        color: Color.fromARGB(255, 151, 151, 151),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        "BRS",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color.fromARGB(222, 0, 0, 0),
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          letterSpacing: -0.375,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 75,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 216, 216, 216),
                      border: Border.all(
                        width: 1,
                        color: Color.fromARGB(255, 151, 151, 151),
                      ),
                    ),
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
