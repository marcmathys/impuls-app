import 'package:flutter/material.dart';
import 'package:impulsrefactor/States/session_step.dart';
import 'package:impulsrefactor/States/session_state.dart';
import 'package:impulsrefactor/Views/Debug/bluetooth_device_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Setup extends StatefulWidget {
  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  bool _attachElectrodes = false;
  bool _turnedOnMachines = false;
  List<int> dropdownMenuItemList = List.generate(11, (index) => index);
  int _prePainRating;
  bool _showFittingCurveErrorMessage;

  void setupComplete() {
    context.read(sessionProvider).prePainRating = _prePainRating;
    context.read(sessionStepProvider.notifier).increment();
  }

  checkFittingCurveCoefficients() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey('fittingCurveFirstCoefficient') && prefs.containsKey('fittingCurveSecondCoefficient')) {
        _showFittingCurveErrorMessage = false;
      } else {
        _showFittingCurveErrorMessage = true;
        setState(() {});
      }
    });
  }

  Widget build(BuildContext context) {
    if (_showFittingCurveErrorMessage == null) {
      checkFittingCurveCoefficients();
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Checkbox(
              value: _turnedOnMachines,
              onChanged: (value) {
                setState(() {
                  _turnedOnMachines = value;
                });
              },
            ),
            Text('Turn on machines', style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(
              value: _attachElectrodes,
              onChanged: (value) {
                setState(() {
                  _attachElectrodes = value;
                });
              },
            ),
            Text('Attach Electrodes', style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
        Row(
          children: [
            DropdownButton(
              value: _prePainRating,
              items: dropdownMenuItemList.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(value: value, child: Text(value.toString(), style: Theme.of(context).textTheme.bodyText1));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _prePainRating = value;
                });
              },
            ),
            Text('Enter patient initial pain rating', style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
        ElevatedButton(
          onPressed: _attachElectrodes && _turnedOnMachines && _prePainRating != null && _showFittingCurveErrorMessage == false ? () => setupComplete() : null,
          child: Text('Begin Session', style: Theme.of(context).textTheme.bodyText1),
        ),
        Visibility(visible: _showFittingCurveErrorMessage ?? false, child: Text('Error: No fitting curve configuration found. Please contact support.', style: Theme.of(context).textTheme.bodyText2)),
        BluetoothDevicePicker(),
      ],
    );
  }
}
