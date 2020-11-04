import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setup extends StatefulWidget {
  final VoidCallback _nextStep;

  Setup(this._nextStep);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  bool _attachElectrodes = false;
  bool _turnedOnMachines = false;

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
        RaisedButton(
          onPressed: _attachElectrodes && _turnedOnMachines ? widget._nextStep : null,
          child: Text('Begin Treatment'),
        ),
      ],
    );
  }
}