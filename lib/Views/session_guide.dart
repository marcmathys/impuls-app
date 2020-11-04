import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/session.dart';
import 'package:impulsrefactor/Entities/therapist.dart';
import 'package:impulsrefactor/Views/Components/step_setup_component.dart';
import 'package:impulsrefactor/Views/Components/step_threshold_determination.dart';

class SessionGuide extends StatefulWidget {
  @override
  _SessionGuideState createState() => _SessionGuideState();
}

class _SessionGuideState extends State<SessionGuide> {
  int _currentStep = 0;
  String title = '';
  Session _session;

  @override
  void initState() {
    _session = Session();
    _session.confirmed = false;
    _session.date = DateTime.now();
//    _session.patientUID = patient.UID;
//    _session.therapistUIDs = [Therapist().uid];
    super.initState();
  }

  void nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  Widget _getCurrentStepWidget() {
    switch (_currentStep) {
      case 0:
        return Setup(nextStep);
        break;
      case 1:
        return ThresholdDetermination(nextStep, _session);
        break;
      case 2:
        return null;
        break;
      case 3:
        return null;
        break;
      case 4:
        return null;
        break;
      case 5:
        return null;
        break;
      case 6:
        return null;
        break;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _getCurrentStepWidget()),
    );
  }
}
