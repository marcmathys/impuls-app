import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Setup extends StatefulWidget {
  final Function(int) _setupComplete;

  Setup(this._setupComplete);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  bool _attachElectrodes = false;
  bool _turnedOnMachines = false;
  List<int> dropdownMenuItemList = List.generate(11, (index) => index);
  int _prePainRating;

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
            Text('Enter patient initial pain rating')
          ],
        ),
        RaisedButton(
          onPressed: _attachElectrodes && _turnedOnMachines && _prePainRating != null ? () => widget._setupComplete(_prePainRating) : null,
          child: Text('Begin Treatment'),
        ),
      ],
    );
  }
}
