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

    patient.enrolTime = (snapshot.get('enrolTime') as Timestamp).toDate();
    patient.approved = snapshot.get('approved');
    patient.approvedTime = (snapshot.get('approvedTime') as Timestamp).toDate();
    patient.birthYear = snapshot.get('birthYear');
    patient.currentSessionID = snapshot.get('currentSessionID');
    patient.gender = snapshot.get('gender');
    patient.kg = snapshot.get('kg');
    patient.lastSessionID = snapshot.get('lastSessionID');
    patient.lastSessionTime = (snapshot.get('lastSessionTime') as Timestamp).toDate();
    patient.sessionIDs = List.from(snapshot.get('sessionIDs'));
    patient.therapistIDs = List.from(snapshot.get('therapistIDs'));
    patient.therapistUIDs = List.from(snapshot.get('therapistUIDs'));
    patient.patientCode = snapshot.id;
    patient.icon = Icons.accessibility;
    //IconData icon = document.get('icon'); TODO: Get icon! (String?!)

    this.patients.add(patient);
    return patient;
  }
}
