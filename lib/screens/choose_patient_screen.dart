//TODO Get patient list from mysql server, capture the patient which is clicked on, chnge color on hover to encourage choosing the patient
/*
*  choose_patient_screen.dart
*  KleinKlein Wireframes
*
*  Created by marc.
*  Copyright © 2018 Uni-Marburg. All rights reserved.
    */

import 'package:flutter/material.dart';
import 'package:implulsnew/screens/choose_session_screen.dart';
import 'package:implulsnew/styles/button.dart';
import 'package:implulsnew/styles/h3.dart';

const String Therapist = "Kati";

class ChoosePatientWidget extends StatelessWidget {
//  final FirebaseUser user;
//
//  const ChoosePatientWidget({Key key, this.user}) : super(key: key);
  ChoosePatientWidget({Key key, this.userId, this.logoutCallback})
      : super(key: key);

  final VoidCallback logoutCallback;
  final String userId;


  void onSwitchPressed(BuildContext context) {}

  void onButtonsContainedPressed(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => ChooseSessionWidget()));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: <Widget>[
            Spacer(),
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    "Welcome $Therapist",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 60,
                    ),
                  ),
                  H3(
                    child: Text(
                      "Select Patient",
                      textAlign: TextAlign.left,
                      style: TextStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: _myListView(context),
                  ),
                  Spacer(),
                  Center(
                    child: ButtonButton(
                      padding: EdgeInsets.all(10),
                      onPressed: () => this.onButtonsContainedPressed(context),
                      child: Text(
                        "SUBMIT",
                        textAlign: TextAlign.left,
                        style: TextStyle(),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

Widget _myListView(BuildContext context) {
  final titles = [
    'bike',
    'boat',
    'bus',
    'car',
    'railway',
    'run',
    'subway',
    'transit',
    'walk'
  ];

  final icons = [
    Icons.directions_bike,
    Icons.directions_boat,
    Icons.directions_bus,
    Icons.directions_car,
    Icons.directions_railway,
    Icons.directions_run,
    Icons.directions_subway,
    Icons.directions_transit,
    Icons.directions_walk
  ];

  return ListView.builder(
    itemCount: titles.length,
    itemBuilder: (context, index) {
      return Card(
        //                           <-- Card widget
        child: InkWell(
          onTap: () {
            print('$titles');
          },
          child: ListTile(
            leading: Icon(icons[index]),
            title: Text(titles[index]),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      );
    },
  );
}
