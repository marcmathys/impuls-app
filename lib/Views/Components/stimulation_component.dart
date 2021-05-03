import 'package:flutter/material.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/Helpers/calculator.dart';
import 'package:impulsrefactor/Services/bluetooth_service.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/States/session_state.dart';
import 'package:impulsrefactor/Views/Components/ekg_chart_component.dart';
import 'package:impulsrefactor/Views/Components/progress_bar_component.dart';
import 'package:impulsrefactor/app_constants.dart';
import 'package:provider/provider.dart';

class Stimulation extends StatefulWidget {
  _StimulationState createState() => _StimulationState();
}

class _StimulationState extends State<Stimulation> {
  GlobalKey<ProgressRingState> _progressBarKey = GlobalKey();
  bool _finished;
  bool _started = false;
  BtState _btState;
  BtService _btService;
  SessionState _sessionState;

  @override
  void initState() {
    super.initState();
    _finished = false;
    _btService = BtService();
    _btService.getEKGAndBPMData(context);
  }

  @override
  void dispose() {
    super.dispose();
    _btService.sendOffSignal(_btState.characteristics[AppConstants.EKG_CHARACTERISTIC_UUID]);
  }

  Widget build(BuildContext context) {
    if(!_started) {
      _btState = Provider.of<BtState>(context);
      _sessionState = Provider.of<SessionState>(context);
      List<int> bytes = ByteConversion.convertThresholdsToByteList(_sessionState.currentSession.sensoryThreshold, _sessionState.currentSession.painThreshold, _sessionState.currentSession.toleranceThreshold);
      _btService.sendStimulationBytes(context, bytes);
      _started = true;
    }

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
                    Text('IBI: ${Calculator.calculateIBI(Provider.of<BtState>(context).bpm)} ms'), //TODO: Wrap with Listener-Widget
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
                            BtService().cancelSubscriptions();
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
