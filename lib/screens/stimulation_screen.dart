/*
*  stimulation_screen.dart
*  KleinKlein Wireframes
*
*  Created by marc.
*  Copyright © 2018 Uni-Marburg. All rights reserved.
    */

import 'package:flutter/material.dart';
import 'package:implulsnew/screens/choose_patient_screen.dart';
import 'package:implulsnew/styles/button.dart';
import 'package:implulsnew/styles/h2.dart';
import 'package:implulsnew/styles/h3.dart';
import 'package:implulsnew/styles/h4.dart';
import 'package:implulsnew/screens/threshold_determination_screen.dart';
import 'package:implulsnew/values/values.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StimulationWidget extends StatelessWidget {
  void onStimStartPressed(BuildContext context) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => ThresholdDeterminationWidget()));
//
// TODO 1.1 See 1 - ADD Streams and Graphs and make variables work.  Initially everything can be done locally on the device - get Bluetooth working.

  void onPausePressed(BuildContext context) {}

  void onCancelPressed(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => ChoosePatientWidget()));

  void onStimFinishedPressed(BuildContext context) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => ThresholdDeterminationWidget()));

  final int instStimA = 1200;
  final int instIBI = 750;
  final int stimNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                H2(
                  child: Text(
                    "Stimulation $stimNumber  ",
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                ),
                FlatButton(
                  onPressed: () =>
                      // TODO 1. upon pressed 1. chnage to grey 2. make inoperable, 3. send stim message to device; after stim 1 in finished change 1. stimNumber to 2, 2. make start button operable and original color, on pressed disable
                      this.onStimStartPressed(context),
                  color: AppColors.secondaryElement,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  textColor: Color.fromARGB(255, 255, 255, 255),
                  padding: EdgeInsets.all(0),
                  child: Text(
                    " START ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 32,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 400,
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        H4(
                          child: Text(
                            "Treatment Progress",
                            textAlign: TextAlign.left,
                            style: TextStyle(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: LinearPercentIndicator(
                                width: 300,
                                animation: true,
                                lineHeight: 20.0,
                                animationDuration: 2000,
                                percent: 0.9,
                                center: Text("90.0%"),
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: Colors.greenAccent,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                              onPressed: () => this.onPausePressed(context),
                              color: AppColors.secondaryElement,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                              textColor: Color.fromARGB(255, 255, 255, 255),
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "PAUSE",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            ButtonButton(
                              color: Color.fromARGB(255, 246, 7, 7),
                              padding: EdgeInsets.all(0),
                              onPressed: () => this.onCancelPressed(context),
                              child: Text(
                                "CANCEL",
                                textAlign: TextAlign.left,
                                style: TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 400,
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        H4(
                          child: Text(
                            "Stim Level: $instStimA mA",
                            textAlign: TextAlign.left,
                            style: TextStyle(),
                          ),
                        ),
                        ButtonButton(
                          color: AppColors.secondaryBackground,
                          padding: EdgeInsets.all(0),
                          onPressed: () => this.onStimFinishedPressed(context),
                          child: Text(
                            "STIM FINISHED - GO TO RATING",
                            textAlign: TextAlign.left,
                            style: TextStyle(),
                          ),
                        ),
                        H4(
                          child: Text(
                            "IBI: $instIBI mSec",
                            textAlign: TextAlign.left,
                            style: TextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 920,
              height: 280,
              child: Card(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    H3(
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          "EKG  ",
                          textAlign: TextAlign.center,
                          style: TextStyle(),
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/images/image-5.png",
                      fit: BoxFit.none,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
