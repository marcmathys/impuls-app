/*
*  electrodes_mount_screen.dart
*  KleinKlein Wireframes
*
*  Created by marc.
*  Copyright © 2018 Uni-Marburg. All rights reserved.
    */

import 'package:flutter/material.dart';
import 'package:implulsnew/styles/button.dart';
import 'package:implulsnew/styles/h2.dart';
import 'package:implulsnew/styles/h3.dart';
import 'package:implulsnew/screens/threshold_determination_screen.dart';

class MountElectrodesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MountElectrodesWidgetState();
}

class MountElectrodesWidgetState extends State<MountElectrodesWidget> {
  bool electrodesAttach = false;
  bool machineOn = false;

  /// box widget
  /// [title] is the name of the checkbox
  /// [boolValue] is the boolean value of the checkbox
  Widget checkBox(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
//        Text(title),
        Checkbox(
          value: boolValue,
          activeColor: Color(0xffD97676),
          onChanged: (bool value) {
            /// manage the state of each value
            setState(() {
              switch (title) {
                case "Att":
                  electrodesAttach = value;
                  break;
                case "On":
                  machineOn = value;
                  break;
              }
            });
          },
        )
      ],
    );
  }

  void onButtonsContainedPressed(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ThresholdDeterminationWidget()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Spacer(),
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                H2(
                  child: Text(
                    "Setup Instructions",
                    textAlign: TextAlign.left,
                    style: TextStyle(),
                  ),
                ),
                Row(
                  children: [
                    checkBox("On", machineOn),
                    H3(
                      child: Text(
                        "   Turn on Machines",
                        textAlign: TextAlign.left,
                        style: TextStyle(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    checkBox("Att", electrodesAttach),
                    H3(
                      child: Text(
                        "   Attach Electrodes",
                        textAlign: TextAlign.left,
                        style: TextStyle(),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: ButtonButton(
                    padding: EdgeInsets.all(0),
                    onPressed: ()  {if (machineOn == true) this.onButtonsContainedPressed(context);},
                    child: Text(
                      "BEGIN RATING",
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
