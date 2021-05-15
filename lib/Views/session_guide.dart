import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/session.dart';
import 'package:impulsrefactor/Entities/therapist.dart';
import 'package:impulsrefactor/States/current_patient.dart';
import 'package:impulsrefactor/States/session_step.dart';
import 'package:impulsrefactor/States/session_state.dart';
import 'package:impulsrefactor/Views/Components/app_wide_components.dart';
import 'package:impulsrefactor/Views/Components/step_setup_component.dart';
import 'package:impulsrefactor/Views/Components/step_threshold_determination_component.dart';
import 'package:impulsrefactor/Views/Components/stimulation_component.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionGuide extends StatefulWidget {
  @override
  _SessionGuideState createState() => _SessionGuideState();
}

class _SessionGuideState extends State<SessionGuide> {
  String title = 'Session';

  @override
  void initState() {
    super.initState();
    Session session = Session();
    session.confirmed = false;
    session.date = DateTime.now();
    session.patientUID = context.read(currentPatientProvider).uid;
    session.therapistUIDs.add(Therapist().uid);
    context.read(sessionProvider.notifier).setSession(session);
  }

  ///TODO: Why are the Thresholds List<int>?
  void thresholdDeterminationComplete(Map<int, int> stimRatingRound1, Map<int, int> stimRatingRound2, int rounds) {
    if (rounds == 2) {
      stimRatingRound1.forEach((key, value) {
        int average = (value + stimRatingRound2[key]) ~/ 2;
        if (context.read(sessionProvider).stimRating1.isEmpty) {
          context.read(sessionProvider).stimRating1.add(average);
        } else if (context.read(sessionProvider).stimRating2.isEmpty) {
          context.read(sessionProvider).stimRating2.add(average);
        } else if (context.read(sessionProvider).stimRating3.isEmpty) {
          context.read(sessionProvider).stimRating3.add(average);
        }

        context.read(sessionProvider).sensoryThreshold.addAll({stimRatingRound1[0], stimRatingRound2[0]});
        context.read(sessionProvider).painThreshold.addAll({stimRatingRound1[1], stimRatingRound2[1]});
        context.read(sessionProvider).toleranceThreshold.addAll({stimRatingRound1[10], stimRatingRound2[10]});
      });
    } else {
      stimRatingRound1.forEach((key, value) {
        if (context.read(sessionProvider).stimRating1.isEmpty) {
          context.read(sessionProvider).stimRating1.add(value);
        } else if (context.read(sessionProvider).stimRating2.isEmpty) {
          context.read(sessionProvider).stimRating2.add(value);
        } else if (context.read(sessionProvider).stimRating3.isEmpty) {
          context.read(sessionProvider).stimRating3.add(value);
        }

        context.read(sessionProvider).sensoryThreshold.addAll({stimRatingRound1[0], stimRatingRound1[0]});
        context.read(sessionProvider).painThreshold.addAll({stimRatingRound1[1], stimRatingRound1[1]});
        context.read(sessionProvider).toleranceThreshold.addAll({stimRatingRound1[10], stimRatingRound1[10]});
      });
    }
    context.read(sessionStepProvider.notifier).increment();
  }

  Widget _getCurrentStepWidget(int currentStep) {
    switch (currentStep) {
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
        return Container(child: Center(child: Text('Done! (Temp screen)', style: Theme.of(context).textTheme.bodyText1)));
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
                      title: Text('Do you want to return to the patient selection screen?', style: Theme.of(context).textTheme.bodyText1),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Abort', style: Theme.of(context).textTheme.bodyText1)),
                        TextButton(
                            onPressed: () {
                              // TODO: context.read(sessionProvider).resetState();
                              // TODO: BtService().cancelSubscriptions();
                              Navigator.of(context).popUntil(ModalRoute.withName('/patient_select'));
                            },
                            child: Text('Confirm', style: Theme.of(context).textTheme.bodyText1)),
                      ],
                    ));
            return false;
          },
          child: Consumer(
            builder: ( context, watch, child) {
              int currentStep = watch(sessionStepProvider);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _getCurrentStepWidget(currentStep),
              );
            },
          ),
        ),
      ),
    );
  }
}
