import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:impulsrefactor/Views/Components/chart_component.dart';
import 'package:impulsrefactor/Views/Components/components.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/bluetooth_handler.dart';
import 'package:impulsrefactor/firebase_handler.dart';

class PatientSelect extends StatefulWidget {
  @override
  _PatientSelectState createState() => _PatientSelectState();
}

class _PatientSelectState extends State<PatientSelect> {
  FirebaseUser user = FirebaseHandler().user;
  BluetoothHandler _handler = BluetoothHandler();

  List<Widget> buildPatientWidgets(BuildContext context) {
    List<Widget> patientWidgets = List();
    PatientList().patients.forEach((patient) {
      patientWidgets.add(patient.toWidget(context));
    });
    return patientWidgets;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Components.appBar('Hello${user != null ? ' ' + user.displayName : ''}'),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Text('Please select a patient from the list'),
              Flexible(
                child: ListView(
                  children: buildPatientWidgets(context),
                ),
              ),
              Chart(),
              RaisedButton(
                color: Colors.amberAccent,
                onPressed: () {
                  _handler.scanForDevices().then((code) => Components.loginErrorSnackBar(context, code));
                },
                child: Text('Connect'),
              ),
              RaisedButton(
                color: Colors.amberAccent,
                onPressed: () => _handler.getEKGData(),
                child: Text('Get Data'),
              ),
              RaisedButton(
                color: Colors.amberAccent,
                onPressed: () => _handler.sendOffSignal(_handler.ekgSubscription),
                child: Text('Send stop Signal'),
              ),
            ],
          );
        }
      ),
    );
  }
}
