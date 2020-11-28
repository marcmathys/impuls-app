import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/Entities/session.dart';
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

  /// A method that searches for an already logged-in user and logs that user in
  Future<bool> getCurrentUser() async {
    User user = _auth.currentUser;
    if (user != null) {
      _user = user;
      String statusMessage = await loadTherapist();
      if (statusMessage == 'OK') {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

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
    await _auth.signOut();
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
      therapist.moodleID = document.get('moodleID');
      therapist.name = document.get('name');
      therapist.phone = document.get('phone');
      therapist.uid = user.uid;

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

  Future<void> addSessionsToPatient(Patient patient) async {
    ///TODO: implement automatic update?!
    if (patient.sessions.isNotEmpty) {
      return;
    }

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('sessions').where('patientUID', isEqualTo: patient.uid).orderBy('date').get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        Session session = Session();

        session.prePainRating = document.get('prePainRating');
        session.confirmed = document.get('confirmed');
        session.confirmedDate = (document.get('confirmedDate') as Timestamp).toDate();
        session.date = (document.get('date') as Timestamp).toDate();
        session.deviceUID = document.get('deviceUID');
        session.location = document.get('location');
        session.notes = document.get('notes');
        session.painThreshold = List.from(document.get('painThreshold'));
        session.patientUID = document.get('patientUID');
        session.postPainRating = document.get('postPainRating');
        session.sensoryThreshold = List.from(document.get('sensoryThreshold'));
        session.stimRating1 = List.from(document.get('stimRating1'));
        session.stimRating2 = List.from(document.get('stimRating2'));
        session.therapistUIDs = List.from(document.get('therapistUIDs'));
        session.toleranceThreshold = List.from(document.get('toleranceThreshold'));
        session.uid = document.id;

        if (!patient.sessions.contains(session)) {
          patient.sessions.add(session);
        }
      });
    }
  }
}
