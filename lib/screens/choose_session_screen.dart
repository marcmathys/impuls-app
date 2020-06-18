//TODO dates and existing patients need to be put into the List from mysql - for new sessions the streams need to be set up. double click to review a session or setup a new session
/*
*  choose_session_screen.dart
*  KleinKlein Wireframes
*
*  Created by marc.
*  Copyright © 2018 Uni-Marburg. All rights reserved.
    */

import 'package:flutter/material.dart';
import 'package:implulsnew/screens/choose_patient_screen.dart';
import 'package:implulsnew/styles/button.dart';
import 'pain_level_initial_screen.dart';

const String PatientCode = "012345";

class ChooseSessionWidget extends StatelessWidget {
  void onButtonsContainedThreePressed(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => ChoosePatientWidget()));

  void onNewSessionTap(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => InitialPainLevelWidget()));

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Text(
                  "Select Session for $PatientCode",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w400,
                    fontSize: 60,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: _myListView(context),
                ),
                Card(
                  //                           <-- Card widget
                  child: InkWell(
                    onDoubleTap: () =>
                      this.onNewSessionTap(context),
                    child: Container(
                      color: Color(0xffD97676).withOpacity(0.3),

                      child: ListTile(
                        leading: Text('DateTime.now()'),
                        title: Text('NEW Session'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Center(
                  child: ButtonButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () =>
                        this.onButtonsContainedThreePressed(context),
                    child: Text(
                      "BACK",
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
    );
  }
}

Widget _myListView(BuildContext context) {
  //TODO get details from mysql
  final sessions = [
    'Session 1',
    'Session 2',
    'Session 3',
    'Session 4',
    'Session 5',
    'Session 6',
    'Session 7',
    'Session 8',
    'Session 9',
  ];

  final dates = [
    'January 3, 2020',
    'January 3, 2020',
    'January 3, 2020',
    'January 3, 2020',
    'January 3, 2020',
    'January 3, 2020',
    'January 3, 2020',
    'January 3, 2020',
    'January 3, 2020',
  ];

  return ListView.builder(
    itemCount: sessions.length,
    itemBuilder: (context, index) {
      return Card(
        //                           <-- Card widget
        child: InkWell(
          onTap: () {
            print('$sessions');
            //TODO send to SessionReview with the session that was clicked - as a double cick betton
          },
          child: ListTile(
            leading: Text(dates[index]),
            title: Text(sessions[index]),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      );
    },
  );
}

