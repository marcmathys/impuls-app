import 'package:flutter/material.dart';
import 'package:impulsrefactor/States/session_state.dart';
import 'package:impulsrefactor/Views/Debug/bluetooth_device_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Provider.of<SessionState>(context, listen: false).currentSession.prePainRating = _prePainRating;
    Provider.of<SessionState>(context, listen: false).incrementStep();
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
            Text('Turn on machines'),
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
            Text('Attach Electrodes'),
          ],
        ),
        Row(
          children: [
            DropdownButton(
              value: _prePainRating,
              items: dropdownMenuItemList.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(value: value, child: Text(value.toString()));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _prePainRating = value;
                });
              },
            ),
            Text('Enter patient initial pain rating'),
          ],
        ),
        ElevatedButton(
          onPressed: _attachElectrodes && _turnedOnMachines && _prePainRating != null && _showFittingCurveErrorMessage == true ? () => setupComplete() : null,
          child: Text('Begin Session'),
        ),
        Visibility(
            visible: _showFittingCurveErrorMessage ?? false,
            child: Text(
              'Error: No fitting curve configuration found. Please contact support.',
              style: TextStyle(color: Colors.red),
            )),
        BluetoothDevicePicker(),
      ],
    );
  }
}
