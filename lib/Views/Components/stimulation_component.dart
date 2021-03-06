import 'package:flutter/material.dart';
import 'package:impulsrefactor/States/session_state.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:impulsrefactor/Views/Components/progress_bar_component.dart';
import 'package:provider/provider.dart';

class Stimulation extends StatefulWidget {
  _StimulationState createState() => _StimulationState();
}

class _StimulationState extends State<Stimulation> {
  GlobalKey<ProgressRingState> _progressBarKey = GlobalKey();
  bool _finished = false;
  bool ekgStarted = false;

  @override
  void dispose() {
    super.dispose(); //TODO: Stop listening to values!
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                child: Column(
                  children: <Widget>[
                    Text('Treatment progress'),
                    SizedBox(height: 5),
                    ProgressRing(
                        key: _progressBarKey,
                        duration: 10,
                        //TODO: Set to correct duration!
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.red,
                        onFinished: () => setState(() {
                              _finished = true;
                            })),
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
              Container(
                height: double.infinity,
                child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => states.contains(MaterialState.disabled) ? Colors.black : Colors.blue,
                      ),
                    ),
                    onPressed: _finished
                        ? () {
                            Provider.of<SessionState>(context, listen: false).incrementStep();
                          }
                        : null,
                    child: Text('Next threshold\ndetermination')),
              )
            ],
          ),
        ),
        EKGChart(),
      ],
    );
  }
}
