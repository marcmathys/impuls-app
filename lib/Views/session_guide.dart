import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/session.dart';
import 'package:impulsrefactor/Views/Components/step_setup_component.dart';
import 'package:impulsrefactor/Views/Components/step_threshold_determination_component.dart';
import 'package:impulsrefactor/Views/Components/stimulation_component.dart';

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
//    _session.therapistUIDs.add(Therapist().uid);
    super.initState();
  }

  void nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void setupComplete(int prePainRating) {
    _session.prePainRating = prePainRating;
    nextStep();
  }

  void thresholdDeterminationComplete(Map<int, int> stimRatingRound1, Map<int, int> stimRatingRound2, int rounds) {
    if (rounds == 2) {
      stimRatingRound1.forEach((key, value) {
        int average = (value + stimRatingRound2[key]) ~/ 2;
        if (_session.stimRating1.isEmpty) {
          _session.stimRating1.add(average);
        } else if (_session.stimRating2.isEmpty) {
          _session.stimRating2.add(average);
        } else if (_session.stimRating3.isEmpty) {
          _session.stimRating3.add(average);
        }

        _session.sensoryThreshold.addAll({stimRatingRound1[0], stimRatingRound2[0]});
        _session.painThreshold.addAll({stimRatingRound1[1], stimRatingRound2[1]});
        _session.toleranceThreshold.addAll({stimRatingRound1[10], stimRatingRound2[10]});
      });
    } else {
      stimRatingRound1.forEach((key, value) {
        if (_session.stimRating1.isEmpty) {
          _session.stimRating1.add(value);
        } else if (_session.stimRating2.isEmpty) {
          _session.stimRating2.add(value);
        } else if (_session.stimRating3.isEmpty) {
          _session.stimRating3.add(value);
        }

        _session.sensoryThreshold.addAll({stimRatingRound1[0], stimRatingRound1[0]});
        _session.painThreshold.addAll({stimRatingRound1[1], stimRatingRound1[1]});
        _session.toleranceThreshold.addAll({stimRatingRound1[10], stimRatingRound1[10]});
      });
    }
    nextStep();
  }

  stimulationComplete() {
    nextStep();
  }

  Widget _getCurrentStepWidget() {
    switch (_currentStep) {
      case 0:
        return Setup(setupComplete);
        break;
      case 1:
        return ThresholdDetermination(thresholdDeterminationComplete, false);
        break;
      case 2:
        return Stimulation(stimulationComplete, 'second');
        break;
      case 3:
        return ThresholdDetermination(thresholdDeterminationComplete, false);
        break;
      case 4:
        return Stimulation(stimulationComplete, 'third');
        break;
      case 5:
        return ThresholdDetermination(thresholdDeterminationComplete, true);
        break;
      case 6:
        return Container(child: Center(child: Text('Done! (Temp screen)')));
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
