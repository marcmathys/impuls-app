import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/session.dart';

/// The entity class for a patient object. Contains a toWidget()-method mainly used to fill the ListView on PatientSelect
class Patient {
  bool approved;
  DateTime approvedDate;
  String birthYear;
  DateTime enrolDate;
  String gender;
  double kg;
  DateTime lastSessionDate;
  String moodleID;
  List<String> therapistUIDs;
  IconData icon;
  List<Session> sessions = [];
  String uid;

  Patient(
      {this.enrolDate,
      this.approved,
      this.approvedDate,
      this.birthYear,
      this.gender,
      this.kg,
      this.lastSessionDate,
      this.therapistUIDs,
      this.moodleID,
      this.icon,
      this.uid}); // Default values
}
