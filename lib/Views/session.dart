import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:impulsrefactor/Views/Components/components.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Session extends StatefulWidget {
  bool _attachElectrodes = false;
  bool _turnedOnMachines = false;
  int _currentStep = 0;
  RestartableTimer _stimLockout = RestartableTimer(Duration(seconds: 2), () => {});
  int _painLevel = 200;

  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<Session> {
  @override
  void initState() {
    super.initState();
    widget._stimLockout = RestartableTimer(Duration(seconds: 2), () => {setState(() {})});
  }

  List<Step> getSteps(BuildContext context) {
    return [
      Step(
        title: Text('Setup'),
        isActive: true,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                Checkbox(
                  value: widget._attachElectrodes,
                  onChanged: (value) {
                    setState(() {
                      widget._attachElectrodes = value;
                    });
                  },
                ),
                Text('Attach Electrodes'),
              ],
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: widget._turnedOnMachines,
                  onChanged: (value) {
                    setState(() {
                      widget._turnedOnMachines = value;
                    });
                  },
                ),
                Text('Turn on machines'),
              ],
            ),
            RaisedButton(
              onPressed: widget._attachElectrodes && widget._turnedOnMachines ? nextStep : null, //TODO: Next step!
              child: Text('Begin Treatment'),
            ),
          ],
        ),
      ),
      Step(
        title: Text('Threshold determination'),
        isActive: false,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Stimulation level'),
                Text('${widget._painLevel} mA'),
                RaisedButton(
                  onPressed: !widget._stimLockout.isActive
                      ? () {
                          setState(() {
                            widget._stimLockout.reset();
                            widget._painLevel += 200;
                          });
                        }
                      : null,
                  child: Text('Stimulate'),
                ),
                Text('IBI: 825'),
              ],
            ),
            Text('Pain rating'),
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              shrinkWrap: true,
              crossAxisCount: 3,
              children: <Widget>[
                Container(),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('N/A')),
                ),
                Container(),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('1')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('2')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('3')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('4')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('5')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('6')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('7')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('8')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('9')),
                ),
                Container(),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('10')),
                ),
                Container(),
              ],
            ),
            RaisedButton(onPressed: nextStep, child: Text('Start stimulation')),
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
      Step(
        title: Text('Threshold determination'),
        isActive: false,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Stimulation level'),
                Text('${widget._painLevel} mA'),
                RaisedButton(
                  onPressed: !widget._stimLockout.isActive
                      ? () {
                          setState(() {
                            widget._stimLockout.reset();
                            widget._painLevel += 200;
                          });
                        }
                      : null,
                  child: Text('Stimulate'),
                ),
                Text('IBI: 825'),
              ],
            ),
            Text('Pain rating'),
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              shrinkWrap: true,
              crossAxisCount: 3,
              children: <Widget>[
                Container(),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('N/A')),
                ),
                Container(),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('1')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('2')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('3')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('4')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('5')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('6')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('7')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('8')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('9')),
                ),
                Container(),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('10')),
                ),
                Container(),
              ],
            ),
            RaisedButton(onPressed: nextStep, child: Text('Start stimulation')),
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
      Step(
        title: Text('Threshold determination'),
        isActive: false,
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Stimulation level'),
                Text('${widget._painLevel} mA'),
                RaisedButton(
                  onPressed: !widget._stimLockout.isActive
                      ? () {
                    setState(() {
                      widget._stimLockout.reset();
                      widget._painLevel += 200;
                    });
                  }
                      : null,
                  child: Text('Stimulate'),
                ),
                Text('IBI: 825'),
              ],
            ),
            Text('Pain rating'),
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              shrinkWrap: true,
              crossAxisCount: 3,
              children: <Widget>[
                Container(),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('N/A')),
                ),
                Container(),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('1')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('2')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('3')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('4')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('5')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('6')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('7')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('8')),
                ),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('9')),
                ),
                Container(),
                InkWell(
                  child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text('10')),
                ),
                Container(),
              ],
            ),
            RaisedButton(onPressed: nextStep, child: Text('End session')),
          ],
        ),
      ),
    ];
  }

  void nextStep() {
    widget._currentStep + 1 != 6
        ? setState(() {
            widget._currentStep += 1;
            widget._painLevel = 200; ///TODO: Debug!
    })
        : Navigator.of(context).pushNamed('/patient_select'); //TODO: Navigate to session finish
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: Components.appBar('Session'),
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
          currentStep: widget._currentStep,
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
