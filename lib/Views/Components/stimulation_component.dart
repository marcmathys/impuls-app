import 'package:flutter/material.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/States/session_step.dart';
import 'package:impulsrefactor/States/session_state.dart';
import 'package:impulsrefactor/States/stimulation_service.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:impulsrefactor/Views/Components/progress_bar_component.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Stimulation extends StatefulWidget {
  _StimulationState createState() => _StimulationState();
}

class _StimulationState extends State<Stimulation> {
  GlobalKey<ProgressRingState> _progressBarKey = GlobalKey();
  bool _finished;

  @override
  void initState() {
    super.initState();
    _finished = false;
    List<int> bytes =
        ByteConversion.convertThresholdsToByteList(context.read(sessionProvider).sensoryThreshold, context.read(sessionProvider).painThreshold, context.read(sessionProvider).toleranceThreshold);
    context.read(stimulationServiceProvider.notifier).sendStimulationBytes(bytes);
  }

  @override
  void dispose() {
    super.dispose();
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
                    Text('Treatment progress', style: Theme.of(context).textTheme.bodyText1),
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
                height: double.infinity,
                child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => states.contains(MaterialState.disabled) ? Colors.black : Colors.blue,
                      ),
                    ),
                    onPressed: _finished
                        ? () {
                            context.read(sessionStepProvider.notifier).increment();
                          }
                        : null,
                    child: Text('Next threshold\ndetermination', style: Theme.of(context).textTheme.bodyText1)),
              )
            ],
          ),
        ),
        //EKGChart(),
      ],
    );
  }
}
