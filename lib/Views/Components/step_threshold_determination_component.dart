import 'package:flutter/material.dart';
import 'package:impulsrefactor/Entities/fitting_lookup_table.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/Helpers/fitting_curve_calculator.dart';
import 'package:impulsrefactor/States/session_state.dart';
import 'package:impulsrefactor/States/session_step.dart';
import 'package:impulsrefactor/States/stimulation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulsrefactor/Style/themes.dart';

class ThresholdDetermination extends StatefulWidget {
  final int determinationNumber; //first, second or third

  ThresholdDetermination(this.determinationNumber);

  @override
  _ThresholdDeterminationState createState() => _ThresholdDeterminationState();
}

class _ThresholdDeterminationState extends State<ThresholdDetermination> {
  int _round;
  bool _roundInProgress;
  int _stimulationLevel;
  bool _stimLockout;
  Map<int, List<int>> _stimRatingRound1 = {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: [], 10: []};
  Map<int, List<int>> _stimRatingRound2 = {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: [], 10: []};
  Map<int, bool> _buttonLockouts = {-1: false, 0: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false, 8: false, 9: false, 10: false};
  bool _generalButtonLockout = true;

  @override
  void initState() {
    super.initState();
    _round = 1;
    _roundInProgress = true;
    _stimulationLevel = 0;
    _stimLockout = false;
  }

  void startNextRound() {
    setState(() {
      _round = 2;
      _roundInProgress = true;
      _stimulationLevel = 0;
      _stimLockout = false;
      _generalButtonLockout = true;
      _buttonLockouts = {-1: false, 0: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false, 8: false, 9: false, 10: false};
    });
  }

  void disableLowerButtons(int buttonPressed) {
    _buttonLockouts.forEach((key, value) {
      if (key < buttonPressed) {
        setState(() {
          _buttonLockouts[key] = true;
        });
      }
    });
  }

  addStimulationLevel(int buttonPressed) {
    if (_round == 1) {
      _stimRatingRound1[buttonPressed].add(_stimulationLevel);
    } else {
      _stimRatingRound2[buttonPressed].add(_stimulationLevel);
    }

    if (buttonPressed == 10) {
      setState(() {
        _stimLockout = true;
        _roundInProgress = false;
      });
    }

    disableLowerButtons(buttonPressed);
    setState(() {
      _generalButtonLockout = true;
      _stimLockout = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(border: Border(top: BorderSide(), bottom: BorderSide())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _roundInProgress && !_stimLockout
                      ? () async {
                          int fittedValue = 0;
                          fittedValue = LookupTable.getLookupTableValue((_stimulationLevel + 200).toString());
                          if (fittedValue == null) {
                            fittedValue = await FittingCurveCalculator.fitToCurve(_stimulationLevel + 200);
                          }
                          List<int> byteList = ByteConversion.convertIntToByteList(fittedValue);
                          if (byteList.isNotEmpty) {
                            context.read(stimulationServiceProvider.notifier).sendStimulationBytes(byteList);
                          }

                          setState(() {
                            _generalButtonLockout = false;
                            _roundInProgress = true;
                            _stimulationLevel += 200;
                            _stimLockout = true;
                          });
                        }
                      : null,
                  child: Text('Stimulate with ${_stimulationLevel + 200} µA', style: Themes.getButtonTextStyle()),
                ),
              ],
            ),
          ),
          Text('Pain rating', style: Themes.getDefaultTextStyle()),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: _generalButtonLockout || _buttonLockouts[-1]
                    ? null
                    : () {
                        setState(() {
                          _generalButtonLockout = true;
                          _stimLockout = false;
                        });
                      },
                child: Text('N/A'),
              ),
              ElevatedButton(
                onPressed: _generalButtonLockout || _buttonLockouts[0] ? null : () => addStimulationLevel(0),
                child: Text('0'),
              ),
              ElevatedButton(
                onPressed: _generalButtonLockout || _buttonLockouts[1] ? null : () => addStimulationLevel(1),
                child: Text('1'),
              ),
              ElevatedButton(
                onPressed: _generalButtonLockout || _buttonLockouts[2] ? null : () => addStimulationLevel(2),
                child: Text('2'),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: _generalButtonLockout || _buttonLockouts[3] ? null : () => addStimulationLevel(3),
                child: Text('3'),
              ),
              ElevatedButton(
                onPressed: _generalButtonLockout || _buttonLockouts[4] ? null : () => addStimulationLevel(4),
                child: Text('4'),
              ),
              ElevatedButton(
                onPressed: _generalButtonLockout || _buttonLockouts[5] ? null : () => addStimulationLevel(5),
                child: Text('5'),
              ),
              ElevatedButton(
                onPressed: _generalButtonLockout || _buttonLockouts[6] ? null : () => addStimulationLevel(6),
                child: Text('6'),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: _generalButtonLockout || _buttonLockouts[7] ? null : () => addStimulationLevel(7),
                child: Text('7'),
              ),
              ElevatedButton(
                onPressed: _generalButtonLockout || _buttonLockouts[8] ? null : () => addStimulationLevel(8),
                child: Text('8'),
              ),
              ElevatedButton(
                onPressed: _generalButtonLockout || _buttonLockouts[9] ? null : () => addStimulationLevel(9),
                child: Text('9'),
              ),
              ElevatedButton(
                onPressed: _generalButtonLockout || _buttonLockouts[10] ? null : () => addStimulationLevel(10),
                child: Text('10'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _roundInProgress
                    ? null
                    : () {
                        context.read(sessionProvider.notifier).addRatingAndThresholds(_stimRatingRound1, _stimRatingRound2, _round, widget.determinationNumber);
                        context.read(sessionStepProvider.notifier).increment();
                      },
                child: Text('Start therapy', style: Themes.getButtonTextStyle()),
              ),
              ElevatedButton(
                onPressed: _round == 1 && _roundInProgress == false && widget.determinationNumber == 3 ? startNextRound : null,
                child: Text('Start second round', style: Themes.getButtonTextStyle()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
