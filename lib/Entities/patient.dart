import 'package:flutter/material.dart';
import 'package:impulsrefactor/firebase_handler.dart';

/// The entity class for a patient object. Contains a toWidget()-method mainly used to fill the ListView on PatientSelect
class Patient {
  //TODO: Negotiate right format. Icon? Custom image?
  IconData icon = Icons.edit; // Default values
  String name = '';
  String surname = '';
  String patientCode = '';

  Patient(this.icon, this.name, this.surname, this.patientCode);

  Widget toWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async { // TODO: Dummy code! Replace with Navigation to detailView
        FirebaseHandler().signOut();
        Navigator.of(context).pushNamed('/login');
      },
      child: Row(
        children: <Widget>[
          Icon(this.icon),
          Text(this.patientCode),
        ],
      ),
    );
  }
}

/// The list of all patients retrieved from firebase.
class PatientList {
  static final PatientList _instance = PatientList._internal();
  factory PatientList() => _instance;

  PatientList._internal();

  List<Patient> patients = List();
}
