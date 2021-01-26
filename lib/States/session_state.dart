import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/patient.dart';
import 'package:impulsrefactor/Entities/session.dart';

class SessionState extends ChangeNotifier {
  Patient currentPatient;
  Session currentSession;
  int _currentStep = 0;

  int get currentStep => _currentStep;

  void incrementStep() {
    _currentStep++;
    notifyListeners();
  }

  void decrementStep() {
    notifyListeners();
  }

  void resetState() {
    currentPatient = null;
    currentSession = null;
    _currentStep = 0;
  }
}