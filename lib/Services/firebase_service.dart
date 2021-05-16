import 'package:firebase_auth/firebase_auth.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/Entities/session.dart';
import 'package:impulsrefactor/Entities/therapist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal() {
    _auth = FirebaseAuth.instance;
  }

  FirebaseAuth _auth;
  User _user;

  User get user => _user;

  /// A method that searches for an already logged-in user and logs that user in
  void checkUserLogin() async {
    User user = _auth.currentUser;
    if (user != null) {
      _user = user;
      loadTherapist();
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = result.user;
    } catch (e) {
      Get.snackbar('Login failed', '');
    }
  }

  Future signOut() async {
    await _auth.signOut();
    _user = null;
  }

  listenForTherapistApprovalChange() async {
    /// TODO: Log out user if document['approved'] == false;
  }

  void loadTherapist() async {
    if (_user == null) {
      Get.snackbar('Login error', 'No Therapist loaded.');
      return;
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

      Get.toNamed('/patient_select');
    } catch (exception) {
      if (exception is AssertionError) {
        Get.snackbar('Login error', 'Therapist with UID ${user.uid} not found!');
        return;
      } else if (exception is FirebaseException && exception.code == 'permission-denied') {
        Get.snackbar('Permission error', 'Permission denied, access to Database is restricted!');
        return;
      }
      Get.snackbar('Unknown error', 'An unexpected error occurred: $exception');
      return;
    }
  }

  Future<void> addSessionsToPatient(Patient patient) async {
    ///TODO: implement automatic update?!
    if (patient.sessions.isNotEmpty) {
      return;
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('sessions').where('patientUID', isEqualTo: patient.uid).orderBy('date').get();

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
