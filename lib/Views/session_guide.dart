import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impulsrefactor/States/session_step.dart';
import 'package:impulsrefactor/States/session_state.dart';
import 'package:impulsrefactor/Style/themes.dart';
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

  Widget _getCurrentStepWidget(int currentStep) {
    switch (currentStep) {
      case 0:
        return Setup();
        break;
      case 1:
        return ThresholdDetermination(1);
        break;
      case 2:
        return Stimulation(1);
        break;
      case 3:
        return ThresholdDetermination(2);
        break;
      case 4:
        return Stimulation(2);
        break;
      case 5:
        return ThresholdDetermination(3);
        break;
      case 6:
        return Container(child: Center(child: Text('Done! (Temp screen)', style: Themes.getErrorTextStyle())));
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
            Get.dialog(AlertDialog(
              title: Text('Do you want to return to the patient selection screen?', style: Themes.getHeadingTextStyle()),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Abort', style: Themes.getButtonTextStyle())),
                TextButton(
                    onPressed: () {
                      Get.until((route) => Get.currentRoute == '/patient_select');
                      // TODO: BtService().cancelSubscriptions();
                      context.read(sessionProvider.notifier).abandonSession();
                    },
                    child: Text('Confirm', style: Themes.getButtonTextStyle())),
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
