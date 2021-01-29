import 'package:flutter/material.dart';
import 'package:impulsrefactor/Helpers/byte_conversion.dart';
import 'package:impulsrefactor/Helpers/fitting_curve_calculator.dart';
import 'package:impulsrefactor/Services/bluetooth_service.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:provider/provider.dart';

class ThresholdDetermination extends StatefulWidget {
  final Function(Map<int, int>, Map<int, int>, int round) _onDeterminationEnd;
  final bool isThirdDetermination;

  ThresholdDetermination(this._onDeterminationEnd, this.isThirdDetermination);

  @override
  _ThresholdDeterminationState createState() => _ThresholdDeterminationState();
}

class _ThresholdDeterminationState extends State<ThresholdDetermination> {
  int _round = 1;
  bool _roundInProgress = true;
  int _stimulationLevel = 0;
  bool _stimLockout = false;
  Map<int, int> _stimRatingRound1 = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0};
  Map<int, int> _stimRatingRound2 = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0, 10: 0};
  Map<int, bool> _buttonLockouts = {
    -1: false,
    0: false,
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
    6: false,
    7: false,
    8: false,
    9: false,
    10: false
  };
  bool _generalButtonLockout = true;

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
      if (_stimRatingRound1[buttonPressed] == 0) {
        _stimRatingRound1[buttonPressed] = _stimulationLevel;
      }
    } else {
      if (_stimRatingRound2[buttonPressed] == 0) {
        _stimRatingRound2[buttonPressed] = _stimulationLevel;
      }
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  onPressed: _roundInProgress && !_stimLockout
                      ? () async {
                          int fittedValue = await FittingCurveCalculator.fitToCurve(_stimulationLevel + 200);
                          List<int> byteList = ByteConversion.convertIntToByteList(fittedValue);
                          BtService().sendStimulationBytes(context, byteList);

                          setState(() {
                            _generalButtonLockout = false;
                            _roundInProgress = true;
                            _stimulationLevel += 200;
                            _stimLockout = true;
                          });
                        }
                      : null,
                  child: Text('Stimulate with ${_stimulationLevel + 200} µA'),
                ),
                Text('IBI: 825'), //TODO: Connect to ESP
              ],
            ),
          ),
          Text('Pain rating'),
          Row(
            children: <Widget>[
              FlatButton(
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
              FlatButton(
                onPressed: _generalButtonLockout || _buttonLockouts[0] ? null : () => addStimulationLevel(0),
                child: Text('0'),
              ),
              FlatButton(
                onPressed: _generalButtonLockout || _buttonLockouts[1] ? null : () => addStimulationLevel(1),
                child: Text('1'),
              ),
              FlatButton(
                onPressed: _generalButtonLockout || _buttonLockouts[2] ? null : () => addStimulationLevel(2),
                child: Text('2'),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: _generalButtonLockout || _buttonLockouts[3] ? null : () => addStimulationLevel(3),
                child: Text('3'),
              ),
              FlatButton(
                onPressed: _generalButtonLockout || _buttonLockouts[4] ? null : () => addStimulationLevel(4),
                child: Text('4'),
              ),
              FlatButton(
                onPressed: _generalButtonLockout || _buttonLockouts[5] ? null : () => addStimulationLevel(5),
                child: Text('5'),
              ),
              FlatButton(
                onPressed: _generalButtonLockout || _buttonLockouts[6] ? null : () => addStimulationLevel(6),
                child: Text('6'),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: _generalButtonLockout || _buttonLockouts[7] ? null : () => addStimulationLevel(7),
                child: Text('7'),
              ),
              FlatButton(
                onPressed: _generalButtonLockout || _buttonLockouts[8] ? null : () => addStimulationLevel(8),
                child: Text('8'),
              ),
              FlatButton(
                onPressed: _generalButtonLockout || _buttonLockouts[9] ? null : () => addStimulationLevel(9),
                child: Text('9'),
              ),
              FlatButton(
                onPressed: _generalButtonLockout || _buttonLockouts[10] ? null : () => addStimulationLevel(10),
                child: Text('10'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: _roundInProgress ? null : () => widget._onDeterminationEnd(_stimRatingRound1, _stimRatingRound2, _round),
                child: Text('Start therapy'),
              ),
              RaisedButton(
                onPressed: _round == 1 && _roundInProgress == false && widget.isThirdDetermination == false ? startNextRound : null,
                child: Text('Start second round'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
