/*
*  pain_level_initial_screen.dart
*  KleinKlein Wireframes
*
*  Created by marc.
*  Copyright © 2018 Uni-Marburg. All rights reserved.
    */

import 'package:flutter/material.dart';
import 'package:implulsnew/screens/electrodes_mount_screen.dart';
import 'package:implulsnew/styles/h2.dart';
import 'package:implulsnew/styles/h3.dart';
import 'package:implulsnew/styles/button.dart';

class InitialPainLevelWidget extends StatefulWidget {
  @override
  _InitialPainLevelWidgetState createState() => _InitialPainLevelWidgetState();
}

class _InitialPainLevelWidgetState extends State<InitialPainLevelWidget> {

  void onButtonsContainedThreePressed(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => MountElectrodesWidget()));


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
                "Initial Pain Level",
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
            Center(
              child: ButtonButton(
                onPressed: () =>
                    this.onButtonsContainedThreePressed(context),
                child: Text(
                  "SUBMIT",
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
