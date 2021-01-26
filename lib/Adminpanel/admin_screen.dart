import 'dart:math';

import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:impulsrefactor/Entities/fitting_point.dart';
import 'package:impulsrefactor/Helpers/fitting_curve_calculator.dart';
import 'package:impulsrefactor/Services/bluetooth_service.dart';
import 'package:impulsrefactor/States/bluetooth_state.dart';
import 'package:impulsrefactor/Views/Components/app_wide_components.dart';
import 'package:impulsrefactor/Views/Debug/bluetooth_device_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  BtService _bluetoothService;
  TextEditingController _byteSendTextController;
  TextEditingController _measuredVoltageTextController;
  List<FittingPoint> _fittingPoints = [];
  FittingPoint _currentPoint;
  FocusNode enterStimulationValue;
  FocusNode enterVoltageFocusNode;

  //TODO: Remove debug lists!
  List<FittingPoint> _testingPoints = [
    FittingPoint(32, 19.85),
    FittingPoint(64, 16.21),
    FittingPoint(96, 13.33),
    FittingPoint(128, 10.91),
    FittingPoint(160, 9.08),
    FittingPoint(192, 7.62),
    FittingPoint(224, 6.39),
    FittingPoint(255, 5.42),
    FittingPoint(256, 5.39),
    FittingPoint(287, 4.58),
    FittingPoint(288, 4.50),
    FittingPoint(319, 3.83),
    FittingPoint(320, 3.77),
    FittingPoint(351, 3.20),
    FittingPoint(352, 3.17),
    FittingPoint(383, 2.65),
    FittingPoint(384, 2.62),
    FittingPoint(415, 2.18),
    FittingPoint(416, 2.15),
    FittingPoint(447, 1.80),
    FittingPoint(479, 1.47),
    FittingPoint(511, 1.19),
    FittingPoint(543, 0.97),
    FittingPoint(575, 0.79),
    FittingPoint(607, 0.64),
    FittingPoint(639, 0.52),
    FittingPoint(671, 0.42),
    FittingPoint(703, 0.34),
    FittingPoint(735, 0.28),
    FittingPoint(767, 0.23),
    FittingPoint(799, 0.19),
    FittingPoint(831, 0.16),
    FittingPoint(863, 0.13),
    FittingPoint(895, 0.11),
    FittingPoint(927, 0.10),
    FittingPoint(959, 0.08),
    FittingPoint(991, 0.08),
    FittingPoint(1023, 0.07),
  ];

  @override
  void initState() {
    super.initState();
    _bluetoothService = BtService();
    _byteSendTextController = TextEditingController();
    _measuredVoltageTextController = TextEditingController();
    _currentPoint = FittingPoint(null, null);
    enterStimulationValue = FocusNode();
    enterVoltageFocusNode = FocusNode();
  }

  void sendBytesOnPressed(BuildContext context) {
    try {
      int value = int.parse(_byteSendTextController.value.text);
      if (value > 1023 || value < 0) {
        throw FormatException();
      }
      if (Provider.of<BtState>(context, listen: false).device == null) {
        throw Exception('No device connected.');
      }

      String radixString = value.toRadixString(8).padLeft(9, '0');
      List<int> octList = [int.parse(radixString.substring(0, 3)), int.parse(radixString.substring(3, 6)), int.parse(radixString.substring(6, 9))];
      _bluetoothService.sendStimulationBytes(context, octList);
      _currentPoint.x = value;
      enterVoltageFocusNode.requestFocus();
      setState(() {});
    } on FormatException {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Wrong number format')));
    } catch (exception) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('$exception')));
    }
  }

  String fittingPointsToString() {
    String points = '';
    _fittingPoints.forEach((point) {
      points = points + '(${point.x.toString()}, ${point.y.toString()}) ';
    });

    return points;
  }

  void startFitting(BuildContext context) async {
    PolynomialFit result = await FittingCurveCalculator.calculate(_fittingPoints);
    if (result != null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: EasyRichText(
            'Formula: ${exp(result.coefficients.first).toStringAsFixed(3)}e${result.coefficients.elementAt(1).toStringAsFixed(3)}',
            patternList: [
              EasyRichTextPattern(
                  targetString: result.coefficients.elementAt(1).toStringAsFixed(3),
                  superScript: true,
                  stringBeforeTarget: 'e',
                  matchWordBoundaries: false),
            ],
          ),
        ),
      );
    } else
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Error occurred while trying to fit the curve!'),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Components.appBar(context, 'Admin'),
      body: Builder(builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Send Bytes to ESP for the voltage fitting process.'),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    style: _currentPoint?.x != null ? TextStyle(color: Colors.grey) : TextStyle(),
                    readOnly: _currentPoint?.x != null,
                    controller: _byteSendTextController,
                    decoration: InputDecoration(hintText: 'Enter stimulation as decimal (0-1023)'),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: RaisedButton(
                      onPressed: _currentPoint?.x == null ? () => sendBytesOnPressed(context) : null,
                      child: Text('Send'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: enterVoltageFocusNode,
                      readOnly: _currentPoint?.x == null,
                      controller: _measuredVoltageTextController,
                      decoration: InputDecoration(hintText: 'Enter measured voltage as floating point'),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: RaisedButton(
                      onPressed: _currentPoint?.x != null
                          ? () {
                              try {
                                _currentPoint.y = double.parse(_measuredVoltageTextController.text);
                                _fittingPoints.add(_currentPoint);
                                _byteSendTextController.clear();
                                _measuredVoltageTextController.clear();
                                _currentPoint = FittingPoint(null, null);
                                enterStimulationValue.requestFocus();
                                setState(() {});
                              } catch (_) {}
                            }
                          : null,
                      child: Text('Confirm'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(fittingPointsToString(), textAlign: TextAlign.start),
              Center(
                child: RaisedButton(
                  onPressed: () => setState(() {
                    _fittingPoints = _testingPoints;
                  }),
                  child: Text('Load test data set'),
                ),
              ),
              Center(
                child: RaisedButton(
                  onPressed: _fittingPoints.isNotEmpty ? () => startFitting(context) : null,
                  child: Text('Start fitting with given points'),
                ),
              ),
              Divider(thickness: 2),
              Selector<BtState, BluetoothDevice>(
                  selector: (_, state) => state.device,
                  builder: (_, device, __) {
                    return Text('Currently connected to: ${device?.id ?? 'none'} ${device?.name ?? ''}');
                  }),
              BluetoothDevicePicker(),
            ],
          ),
        );
      }),
    );
  }
}
