import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:impulsrefactor/Views/Components/components.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SessionStepper extends StatefulWidget {
  @override
  _SessionStepperState createState() => _SessionStepperState();
}

class _SessionStepperState extends State<SessionStepper> {
  int _currentStep = 0;
  RestartableTimer _stimLockout = RestartableTimer(Duration(seconds: 2), () => {});
  int _painLevel = 200;

  @override
  void initState() {
    super.initState();
    _stimLockout = RestartableTimer(Duration(seconds: 2), () => {setState(() {})});
  }

  List<Step> getSteps(BuildContext context) {
    return [

      Step(
        title: Text('Stimulation'),
        isActive: true,
        content: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                  child: Column(
                    children: <Widget>[
                      Text('Treatment progress'),
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width / 2,
                        lineHeight: 20,
                        animation: true,
                        animationDuration: 80000,

                        /// 8 Minutes: 480000
                        center: Text('%'),
                        percent: 1.0,
                      ),
                      Row(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: nextStep,
                            child: Text('Continue'),
                          ),
                          RaisedButton(
                            onPressed: () => {},
                            child: Text('Stop Treatment'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                  child: Column(
                    children: <Widget>[
                      Text('Stimulation level: --'),
                      Text('IBI: 801'),
                    ],
                  ),
                ),
              ],
            ),
            EKGChart(),
          ],
        ),
      ),
      Step(
        title: Text('Stimulation'),
        isActive: true,
        content: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                  child: Column(
                    children: <Widget>[
                      Text('Treatment progress'),
                      LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width / 2,
                        lineHeight: 20,
                        animation: true,
                        animationDuration: 80000,

                        /// 8 Minutes: 480000
                        center: Text('%'),
                        percent: 1.0,
                      ),
                      Row(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: nextStep,
                            child: Text('Continue'),
                          ),
                          RaisedButton(
                            onPressed: () => {},
                            child: Text('Stop Treatment'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                  child: Column(
                    children: <Widget>[
                      Text('Stimulation level: --'),
                      Text('IBI: 801'),
                    ],
                  ),
                ),
              ],
            ),
            EKGChart(),
          ],
        ),
      ),
    ];
  }

  void nextStep() {
    _currentStep + 1 != 6
        ? setState(() {
            _currentStep += 1;
            _painLevel = 200; ///TODO: Debug!
    })
        : Navigator.of(context).pushNamed('/patient_select'); //TODO: Navigate to session finish
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: Components.appBar(context, 'Session'),
        body: Stepper(
          controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return Row(
              children: <Widget>[
                Container(
                  child: null,
                ),
                Container(
                  child: null,
                ),
              ],
            );
          },
          type: StepperType.horizontal,
          currentStep: _currentStep,
          steps: getSteps(context),
          /**Step(),/// Setup Instructions
              Step(),/// Threshold
              Step(),/// Stim
              Step(),/// Threshold
              Step(),/// Stim
              Step(),/// Threshold**/
        ),
      ),
    );
  }
}
