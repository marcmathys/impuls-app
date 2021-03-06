import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/session.dart';
import 'package:impulsrefactor/Entities/therapist.dart';
import 'package:impulsrefactor/States/session_state.dart';
import 'package:impulsrefactor/Views/Components/app_wide_components.dart';
import 'package:impulsrefactor/Views/Components/step_setup_component.dart';
import 'package:impulsrefactor/Views/Components/step_threshold_determination_component.dart';
import 'package:impulsrefactor/Views/Components/stimulation_component.dart';
import 'package:provider/provider.dart';

class SessionGuide extends StatefulWidget {
  @override
  _SessionGuideState createState() => _SessionGuideState();
}

class _SessionGuideState extends State<SessionGuide> {
  String title = 'Session';
  SessionState sessionState;

  @override
  void initState() {
    super.initState();
    sessionState = Provider.of<SessionState>(context, listen: false);

    sessionState.currentSession = Session();
    sessionState.currentSession.confirmed = false;
    sessionState.currentSession.date = DateTime.now();
    sessionState.currentSession.patientUID = sessionState.currentPatient.uid;
    sessionState.currentSession.therapistUIDs.add(Therapist().uid);
  }

  void thresholdDeterminationComplete(Map<int, int> stimRatingRound1, Map<int, int> stimRatingRound2, int rounds) {
    if (rounds == 2) {
      stimRatingRound1.forEach((key, value) {
        int average = (value + stimRatingRound2[key]) ~/ 2;
        if (sessionState.currentSession.stimRating1.isEmpty) {
          sessionState.currentSession.stimRating1.add(average);
        } else if (sessionState.currentSession.stimRating2.isEmpty) {
          sessionState.currentSession.stimRating2.add(average);
        } else if (sessionState.currentSession.stimRating3.isEmpty) {
          sessionState.currentSession.stimRating3.add(average);
        }

        sessionState.currentSession.sensoryThreshold.addAll({stimRatingRound1[0], stimRatingRound2[0]});
        sessionState.currentSession.painThreshold.addAll({stimRatingRound1[1], stimRatingRound2[1]});
        sessionState.currentSession.toleranceThreshold.addAll({stimRatingRound1[10], stimRatingRound2[10]});
      });
    } else {
      stimRatingRound1.forEach((key, value) {
        if (sessionState.currentSession.stimRating1.isEmpty) {
          sessionState.currentSession.stimRating1.add(value);
        } else if (sessionState.currentSession.stimRating2.isEmpty) {
          sessionState.currentSession.stimRating2.add(value);
        } else if (sessionState.currentSession.stimRating3.isEmpty) {
          sessionState.currentSession.stimRating3.add(value);
        }

        sessionState.currentSession.sensoryThreshold.addAll({stimRatingRound1[0], stimRatingRound1[0]});
        sessionState.currentSession.painThreshold.addAll({stimRatingRound1[1], stimRatingRound1[1]});
        sessionState.currentSession.toleranceThreshold.addAll({stimRatingRound1[10], stimRatingRound1[10]});
      });
    }
    sessionState.incrementStep();
  }

  Widget _getCurrentStepWidget(BuildContext context) {
    switch (Provider.of<SessionState>(context).currentStep) {
      case 0:
        return Setup();
        break;
      case 1:
        return ThresholdDetermination(thresholdDeterminationComplete, false);
        break;
      case 2:
        return Stimulation();
        break;
      case 3:
        return ThresholdDetermination(thresholdDeterminationComplete, false);
        break;
      case 4:
        return Stimulation();
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
      appBar: Components().appBar(context, title),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Do you want to return to the patient selection screen?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Abort')),
                    TextButton(
                        onPressed: () {
                          sessionState.resetState();
                          Navigator.of(context).popUntil(ModalRoute.withName('/patient_select'));
                        },
                        child: Text('Confirm')),
                  ],
                ));
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _getCurrentStepWidget(context),
          ),
        ),
      ),
    );
  }
}
