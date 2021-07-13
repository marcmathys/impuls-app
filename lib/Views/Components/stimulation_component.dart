import 'package:flutter/material.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/States/session_step.dart';
import 'package:impulsrefactor/States/session_state.dart';
import 'package:impulsrefactor/States/stimulation_service.dart';
import 'package:impulsrefactor/Style/themes.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:impulsrefactor/Views/Components/progress_bar_component.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Stimulation extends StatefulWidget {
  final int stimulationNumber; //first or second

  Stimulation(this.stimulationNumber);

  _StimulationState createState() => _StimulationState();
}

class _StimulationState extends State<Stimulation> {
  GlobalKey<ProgressRingState> _progressBarKey = GlobalKey();
  bool _finished;

  @override
  void initState() {
    super.initState();

    _finished = false;
    List<int> sensory;
    List<int> pain;
    List<int> tolerance;

    if (widget.stimulationNumber == 1) {
      sensory = context.read(sessionProvider).sensoryThreshold.getRange(0, 2).toList();
      pain = context.read(sessionProvider).painThreshold.getRange(0, 2).toList();
      tolerance = context.read(sessionProvider).toleranceThreshold.getRange(0, 2).toList();
    } else {
      sensory = context.read(sessionProvider).sensoryThreshold.getRange(2, 4).toList();
      pain = context.read(sessionProvider).painThreshold.getRange(2, 4).toList();
      tolerance = context.read(sessionProvider).toleranceThreshold.getRange(2, 4).toList();
    }

    List<int> bytes = ByteConversion.convertThresholdsToByteList(sensory, pain, tolerance);
    context.read(stimulationServiceProvider.notifier).sendStimulationBytes(bytes);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.indigo)),
                child: Column(
                  children: <Widget>[
                    Text('Treatment progress', style: Themes.getDefaultTextStyle()),
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
                    SizedBox(height: 5),
                  ],
                ),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) => states.contains(MaterialState.disabled) ? Colors.black : Colors.blue,
                    ),
                  ),
                  onPressed: _finished
                      ? () {
                          context.read(sessionStepProvider.notifier).increment();
                        }
                      : null,
                  child: Text('Next threshold\ndetermination', style: Themes.getButtonTextStyle()))
            ],
          ),
        ),
        EKGChart(),
      ],
    );
  }
}
