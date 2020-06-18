import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/patient.dart';

class FirebaseHandler {
  static final FirebaseHandler _instance = FirebaseHandler._internal();
  factory FirebaseHandler() => _instance;

  FirebaseHandler._internal() {
    _auth = FirebaseAuth.instance;
  }

  FirebaseAuth _auth;
  FirebaseUser _user;

  FirebaseUser get user => _user;

  Future<bool> signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
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

  void retrievePatientData() {
    //TODO: Dummy code! Implement
    Patient a = Patient(Icons.add, 'Hans', 'Gretel', '1337');
    Patient b = Patient(Icons.ac_unit, 'Petra', 'Pan', '420');
    Patient c = Patient(Icons.access_time, 'Ben', 'Busy', '247');
    PatientList().patients = List();
    PatientList().patients.addAll([a,b,c]);
  }
}
