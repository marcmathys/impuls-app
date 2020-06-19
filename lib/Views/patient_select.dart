import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:impulsrefactor/Views/Components/components.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/firebase_handler.dart';

class PatientSelect extends StatefulWidget {
  @override
  _PatientSelectState createState() => _PatientSelectState();
}

class _PatientSelectState extends State<PatientSelect> {
  FirebaseUser user = FirebaseHandler().user;

  @override
  void initState() {
    super.initState();
    FirebaseHandler().retrievePatientData().then((value) => buildPatientWidgets(context));
  }

  List<Widget> buildPatientWidgets(BuildContext context) {
    List<Widget> patientWidgets = List();
    PatientList().patients.forEach((patient) {
      patientWidgets.add(patient.toWidget(context));
    });
    return patientWidgets;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Components.appBar('Hello'), //TODO: Implement display name! ${user != null ? ' ' + user.displayName : ''}
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.of(context).pushNamed('/debug'), child: Text('Debug')),
      body: Builder(builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            Text('Please select a patient from the list'),
            Flexible(
              child: ListView(
                children: buildPatientWidgets(context),
              ),
            ),
          ],
        );
      }),
    );
  }
}
