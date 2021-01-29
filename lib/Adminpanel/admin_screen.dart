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
  TextEditingController _resistance;
  List<FittingPoint> _fittingPoints = [];
  FittingPoint _currentPoint;
  FocusNode enterStimulationValue;
  FocusNode enterVoltageFocusNode;

  //TODO: Remove debug lists!
  List<FittingPoint> _testingPoints = [
    FittingPoint(32, 9.8959592861),
    FittingPoint(64, 9.6933836147),
    FittingPoint(96, 9.4977724132),
    FittingPoint(128, 9.29743507881),
    FittingPoint(160, 9.1138294716),
    FittingPoint(192, 8.9385316487),
    FittingPoint(224, 8.7624895474),
    FittingPoint(255, 8.5978510944),
    FittingPoint(256, 8.5923006639),
    FittingPoint(287, 8.4294542771),
    FittingPoint(288, 8.4118326758),
    FittingPoint(319, 8.2506200822),
    FittingPoint(320, 8.2348302804),
    FittingPoint(351, 8.0709060888),
    FittingPoint(352, 8.0614868669),
    FittingPoint(383, 7.882314919),
    FittingPoint(384, 7.8709295968),
    FittingPoint(415, 7.6870801558),
    FittingPoint(416, 7.6732231211),
    FittingPoint(447, 7.4955419439),
    FittingPoint(479, 7.2930176798),
    FittingPoint(511, 7.0817085861),
    FittingPoint(543, 6.8772960715),
    FittingPoint(575, 6.6720329455),
    FittingPoint(607, 6.4614681764),
    FittingPoint(639, 6.2538288116),
    FittingPoint(671, 6.0402547113),
    FittingPoint(703, 5.8289456176),
    FittingPoint(735, 5.6347896032),
    FittingPoint(767, 5.4380793089),
    FittingPoint(799, 5.2470240722),
    FittingPoint(831, 5.0751738152),
    FittingPoint(863, 4.8675344505),
    FittingPoint(895, 4.7004803658),
    FittingPoint(927, 4.605170186),
    FittingPoint(959, 4.3820266347),
    FittingPoint(991, 4.3820266347),
    FittingPoint(1023, 4.248495242),
  ];

  @override
  void initState() {
    super.initState();
    _bluetoothService = BtService();
    _byteSendTextController = TextEditingController();
    _measuredVoltageTextController = TextEditingController();
    _resistance = TextEditingController(text: '1');
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

  void saveAmpsOnPressed(BuildContext context) {
      try {
        int resistance = int.parse(_resistance.value.text);

        _currentPoint.y = log((double.parse(_measuredVoltageTextController.text)/resistance) * 1000000);
        _fittingPoints.add(_currentPoint);
        _byteSendTextController.clear();
        _measuredVoltageTextController.clear();
        _currentPoint = FittingPoint(null, null);
        enterStimulationValue.requestFocus();
        setState(() {});
      } on FormatException {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Wrong number format of resistance or voltage')));
      } on IntegerDivisionByZeroException {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Resistance must not be zero')));
      }
        catch (_) {}
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
            'Coefficients: a = ${result.coefficients.first.toStringAsFixed(3)}, b = ${result.coefficients.elementAt(1).toStringAsFixed(3)}',
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
      appBar: Components().appBar(context, 'Admin'),
      body: Builder(builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text('Send Bytes to ESP for the voltage fitting process.'),
              TextField(
                style: _currentPoint?.x != null ? TextStyle(color: Colors.grey) : TextStyle(),
                controller: _resistance,
                decoration: InputDecoration(hintText: 'Enter resistance'),
              ),
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
                          ? () => saveAmpsOnPressed(context)
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
