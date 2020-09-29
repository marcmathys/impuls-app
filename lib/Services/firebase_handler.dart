import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/Entities/therapist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHandler {
  static final FirebaseHandler _instance = FirebaseHandler._internal();

  factory FirebaseHandler() => _instance;

  FirebaseHandler._internal() {
    _auth = FirebaseAuth.instance;
  }

  FirebaseAuth _auth;
  User _user;

  User get user => _user;

  Future<bool> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = result.user;
      return _user == null ? false : true;
    } catch (e) {
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _user = null;
  }

  listenForTherapistApprovalChange() async {
    /// TODO: Log out user if document['approved'] == false;
  }

  Future<String> loadTherapist() async {
    if (_user == null) {
      return 'Therapist login failed!';
    }

    String path = 'therapists/${user.uid}';
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance.doc(path).get();
      Therapist therapist = Therapist();

      therapist.address = document.get('address');
      therapist.approved = document.get('approved');
      therapist.approvedTimestamp = (document.get('approvedTimestamp') as Timestamp).toDate();
      therapist.clinicID = document.get('clinicID');
      therapist.email = document.get('email');
      therapist.espMac = document.get('espMac');
      therapist.lastName = document.get('lastName');
      therapist.lastSession = (document.get('lastSession') as Timestamp).toDate();
      therapist.moodleID = document.get('moodleID');
      therapist.name = document.get('name');
      therapist.patients = List.from(document.get('patients'));
      therapist.phone = document.get('phone');

      return 'OK';
    } catch (exception) {
      if (exception is AssertionError) {
        return 'Therapist with UID ${user.uid} not found!';
      } else if (exception is FirebaseException && exception.code == 'permission-denied') {
        return 'Permission denied, access to Database is restricted!';
      }
      return 'An unexpected error occurred: $exception';
    }
  }

  Future<Patient> loadPatients(String patientID) async {
    String path = 'patients/$patientID';
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance.doc(path).get();
      Patient patient = Patient();

      patient.enrolTime = (document.get('enrolTime') as Timestamp).toDate();
      patient.approved = document.get('approved');
      patient.approvedTime = (document.get('approvedTime') as Timestamp).toDate();
      patient.birthYear = document.get('birthYear');
      patient.currentSessionID = document.get('currentSessionID');
      patient.gender = document.get('gender');
      patient.kg = document.get('kg');
      patient.lastSessionID = document.get('lastSessionID');
      patient.lastSessionTime = (document.get('lastSessionTime') as Timestamp).toDate();
      patient.sessionIDs = List.from(document.get('sessionIDs'));
      patient.therapistIDs = List.from(document.get('therapistIDs'));
      patient.therapistUIDs = List.from(document.get('therapistUIDs'));
      patient.patientCode = document.get('patientCode');
      //IconData icon = document.get('icon'); TODO: Get icon! (String?!)

      return patient;
    } catch (exception) {
      if (exception is AssertionError) {
        throw 'Patient with ID $patientID not found!';
      } else if (exception is PlatformException) {
        throw 'Access to Database is restricted!';
      }
      throw 'An unexpected error occurred: $exception';
    }
  }
}
