import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/patient.dart';

/// The list of all patients retrieved from firebase.
class PatientList {
  static final PatientList _instance = PatientList._internal();

  factory PatientList() => _instance;

  PatientList._internal();

  List<Patient> patients = List();

  Patient addPatientFromSnapshot(QueryDocumentSnapshot snapshot) {
    Patient patient = Patient();

    patient.approved = snapshot.get('approved');
    patient.approvedDate = (snapshot.get('approvedDate') as Timestamp).toDate();
    patient.birthYear = snapshot.get('birthYear');
    patient.enrolDate = (snapshot.get('enrolDate') as Timestamp).toDate();
    patient.gender = snapshot.get('gender');
    patient.kg = snapshot.get('kg');
    patient.lastSessionDate = (snapshot.get('lastSessionDate') as Timestamp).toDate();
    patient.moodleID = snapshot.get('moodleID');
    patient.therapistUIDs = List.from(snapshot.get('therapistUIDs'));
    patient.uid = snapshot.id;
    //IconData icon = document.get('icon'); TODO: Get icon! (String?!)
    patient.icon = Icons.accessibility;

    this.patients.add(patient);
    return patient;
  }
}
