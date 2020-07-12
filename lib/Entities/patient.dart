import 'package:flutter/material.dart';

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
      onTap: () async {
        Navigator.of(context).pushNamed('/patient_details', arguments: this);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        color: Color(0xD4D4D4FF),
        height: MediaQuery.of(context).size.height / 15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(flex: 1, child: Icon(this.icon)),
            Flexible(flex: 2, child: Text(this.patientCode)),
            Flexible(flex: 1, child: Icon(Icons.keyboard_arrow_right)),
          ],
        ),
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
