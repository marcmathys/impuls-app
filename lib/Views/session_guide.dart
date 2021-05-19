import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    context.read(sessionProvider.notifier).startNewSession();
  }

  Widget _getCurrentStepWidget(int currentStep) {
    switch (currentStep) {
      case 0:
        return Setup();
        break;
      case 1:
        return ThresholdDetermination(false);
        break;
      case 2:
        return Stimulation();
        break;
      case 3:
        return ThresholdDetermination(false);
        break;
      case 4:
        return Stimulation();
        break;
      case 5:
        return ThresholdDetermination(true);
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
                              Get.toNamed('patient_select');
                            },
                            child: Text('Confirm', style: Theme.of(context).textTheme.bodyText1)),
                      ],
                    ));
            return false;
          },
          child: Consumer(
            builder: (context, watch, child) {
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
