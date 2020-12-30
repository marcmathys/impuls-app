import 'package:flutter/material.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:impulsrefactor/Views/Components/progress_bar_component.dart';

class Stimulation extends StatefulWidget {
  final Function() _onStimulationEnd;
  final String _advanceToThresholdNumberText;

  Stimulation(this._onStimulationEnd, this._advanceToThresholdNumberText);

  _StimulationState createState() => _StimulationState();
}

class _StimulationState extends State<Stimulation> {
  GlobalKey<ProgressBarState> progressBarKey = GlobalKey();
  bool _isFinished = true;

  ///TODO: Set this to false and to true when the stimulation is finished!

  @override
  void dispose() {
    super.dispose();
    ///TODO: Trash ESP listeners!
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                child: Column(
                  children: <Widget>[
                    Text('Treatment progress'),
                    SizedBox(height: 5),
                    ProgressBar(key: progressBarKey, duration: 80, backgroundColor: Colors.grey, foregroundColor: Colors.red),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Container(
                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                child: Column(
                  children: <Widget>[
                    Text('Stimulation level: --'),
                    Text('IBI: 801'),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              FlatButton(
                height: double.infinity,
                  onPressed: () {
                    _isFinished ? widget._onStimulationEnd() : null;
                  },
                  color: Colors.blue,
                  child: Text('Advance\nto ${widget._advanceToThresholdNumberText}\nthreshold\ndetermination'))
            ],
          ),
        ),
        EKGChart(),
      ],
    );
  }
}
