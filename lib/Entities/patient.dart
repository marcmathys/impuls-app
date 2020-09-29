import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/session.dart';

/// The entity class for a patient object. Contains a toWidget()-method mainly used to fill the ListView on PatientSelect
class Patient {
  DateTime enrolTime;
  bool approved;
  DateTime approvedTime;
  int birthYear;
  String currentSessionID;
  String gender;
  double kg;
  String lastSessionID;
  DateTime lastSessionTime;
  List<String> sessionIDs;
  List<String> therapistIDs;
  List<String> therapistUIDs;
  String patientCode;
  IconData icon;
  List<Session> sessions;

  Patient({this.enrolTime, this.approved, this.approvedTime, this.birthYear, this.currentSessionID, this.gender, this.kg, this.lastSessionID, this.lastSessionTime, this.sessionIDs,
      this.therapistIDs, this.therapistUIDs, this.patientCode, this.icon, this.sessions}); // Default values
}

