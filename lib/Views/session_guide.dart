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

  void saveAndAdvanceStep(Map<int, int> stimRatingRound1, Map<int, int> stimRatingRound2, int round) {
    if (round == 2) {
      stimRatingRound1.forEach((key, value) {
        int average = (value + stimRatingRound2[key]) ~/ 2;
        _session.stimRating1.add(average);
      });
    } else {
      stimRatingRound1.forEach((key, value) {
        _session.stimRating1.add(value);
      });
    }
    _session.sensoryThreshold.addAll({stimRatingRound1[0], stimRatingRound2[0]});
    _session.painThreshold.addAll({stimRatingRound1[1], stimRatingRound2[1]});
    _session.toleranceThreshold.addAll({stimRatingRound1[10], stimRatingRound2[10]});
    nextStep();
  }

  Widget _getCurrentStepWidget() {
    switch (_currentStep) {
      case 0:
        return Setup(nextStep);
        break;
      case 1:
        return ThresholdDetermination(saveAndAdvanceStep);
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
