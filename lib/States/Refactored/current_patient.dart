import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/Entities/patient.dart';

final currentPatientProvider = StateNotifierProvider<CurrentPatient, Patient>((ref) => CurrentPatient(null));

class CurrentPatient extends StateNotifier<Patient> {
  CurrentPatient(Patient patient) : super(null);

  setPatient(Patient patient) {
    state = patient;
  }
}
