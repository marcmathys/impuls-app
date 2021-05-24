import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impulsrefactor/Adminpanel/fitting_curve_info_window.dart';
import 'package:impulsrefactor/Adminpanel/test_byte_array_bar.dart';
import 'package:impulsrefactor/Entities/fitting_point.dart';
import 'package:impulsrefactor/Helpers/fitting_curve_calculator.dart';
import 'package:impulsrefactor/States/connected_device.dart';
import 'package:impulsrefactor/States/stimulation_service.dart';
import 'package:impulsrefactor/Style/themes.dart';
import 'package:impulsrefactor/Views/Components/app_wide_components.dart';
import 'package:impulsrefactor/Views/Debug/bluetooth_device_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  TextEditingController _byteSendTextController;
  TextEditingController _measuredVoltageTextController;
  TextEditingController _resistance;
  TextEditingController _editXValueController;
  TextEditingController _editYValueController;
  List<FittingPoint> _fittingPoints = [];
  FittingPoint _currentPoint;
  FocusNode enterStimulationValue;
  FocusNode enterVoltageFocusNode;
  String oldDataPoints;
  String oldFirstCoefficient;
  String oldSecondCoefficient;
  String oldResistance;
  bool confirmButtonLockout = true;
  SharedPreferences prefs;

  //TODO: Remove debug lists!
  List<FittingPoint> _testingPoints = [
    FittingPoint(32, 198.5),
    FittingPoint(64, 162.1),
    FittingPoint(96, 133.3),
    FittingPoint(128, 109.1),
    FittingPoint(160, 90.8),
    FittingPoint(192, 76.2),
    FittingPoint(224, 63.9),
    FittingPoint(255, 54.2),
    FittingPoint(256, 53.9),
    FittingPoint(287, 45.8),
    FittingPoint(288, 45.0),
    FittingPoint(319, 38.3),
    FittingPoint(320, 37.7),
    FittingPoint(351, 32.0),
    FittingPoint(352, 31.7),
    FittingPoint(383, 26.5),
    FittingPoint(384, 26.2),
    FittingPoint(415, 21.8),
    FittingPoint(416, 21.5),
    FittingPoint(447, 18.0),
    FittingPoint(479, 14.7),
    FittingPoint(511, 11.9),
    FittingPoint(543, 9.7),
    FittingPoint(575, 7.9),
    FittingPoint(607, 6.4),
    FittingPoint(639, 5.2),
    FittingPoint(671, 4.2),
    FittingPoint(703, 3.4),
    FittingPoint(735, 2.8),
    FittingPoint(767, 2.3),
    FittingPoint(799, 1.9),
    FittingPoint(831, 1.6),
    FittingPoint(863, 1.3),
    FittingPoint(895, 1.1),
    FittingPoint(927, 1.0),
    FittingPoint(959, 0.8),
    FittingPoint(991, 0.8),
    FittingPoint(1023, 0.7),
  ];

  @override
  void initState() {
    super.initState();
    _byteSendTextController = TextEditingController();
    _editXValueController = TextEditingController();
    _editYValueController = TextEditingController();
    _measuredVoltageTextController = TextEditingController();
    _resistance = TextEditingController(text: '10000');
    _currentPoint = FittingPoint(null, null);
    enterStimulationValue = FocusNode();
    enterVoltageFocusNode = FocusNode();
    SharedPreferences.getInstance().then((preferences) {
      this.prefs = preferences;
      if (prefs.containsKey('fittingPointList')) {
        oldDataPoints = prefs.getString('fittingPointList');
      }
      if (prefs.containsKey('fittingCurveFirstCoefficient') && prefs.containsKey('fittingCurveSecondCoefficient')) {
        oldFirstCoefficient = prefs.getDouble('fittingCurveFirstCoefficient').toStringAsFixed(3);
        oldSecondCoefficient = prefs.getDouble('fittingCurveSecondCoefficient').toStringAsFixed(3);
      }
      if (prefs.containsKey('resistance')) {
        oldResistance = prefs.getString('resistance');
      }
      setState(() {});
    });
  }

  StatefulBuilder showFittingPointListDialog() {
    List<FittingPoint> fittingPointsUpdate = performDeepCopy(_fittingPoints);

    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        actions: [
          ElevatedButton(
              onPressed: () {
                fittingPointsUpdate.clear();
                setState(() {});
              },
              child: Icon(Icons.delete)),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.cancel)),
          ElevatedButton(
              onPressed: () {
                _fittingPoints.clear();
                _fittingPoints.addAll(performDeepCopy(fittingPointsUpdate));
                Navigator.of(context).pop();
              },
              child: Icon(Icons.check)),
        ],
        content: SizedBox(
          height: MediaQuery.of(context).size.height - 20,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: fittingPointsUpdate.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showDialog(context: context, builder: (context) => showFittingPointEditDialog(fittingPointsUpdate, index));
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(fittingPointsUpdate.elementAt(index).x.toString(), style: Themes.getDefaultTextStyle()),
                        Text(fittingPointsUpdate.elementAt(index).y.toString(), style: Themes.getDefaultTextStyle()),
                      ],
                    ),
                  ),
                  Divider(thickness: 2),
                  SizedBox(height: 10)
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  AlertDialog showFittingPointEditDialog(List<FittingPoint> points, int index) {
    _editXValueController.text = points.elementAt(index).x.toString();
    _editYValueController.text = points.elementAt(index).y.toString();

    return AlertDialog(
      actions: [
        ElevatedButton(
            onPressed: () {
              points.removeAt(index);
              Navigator.pop(context);
              setState(() {});
            },
            child: Icon(Icons.delete)),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.cancel)),
        ElevatedButton(
            onPressed: () {
              points.elementAt(index).x = int.parse(_editXValueController.text);
              points.elementAt(index).y = double.parse(_editYValueController.text);
              Navigator.of(context).pop();
            },
            child: Icon(Icons.check)),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _editXValueController,
            decoration: InputDecoration(labelText: 'Stimulation'),
          ),
          TextField(
            controller: _editYValueController,
            decoration: InputDecoration(labelText: 'Voltage'),
          ),
        ],
      ),
    );
  }

  void sendBytesToESP(BuildContext context) {
    try {
      int value = int.parse(_byteSendTextController.value.text);
      if (value < 0 || value > 1023) {
        Get.snackbar('Format error', 'Value must be between 0 and 1023');
        return;
      }
      if (context.read(connectedDeviceProvider) == null) {
        Get.snackbar('Format error', 'Value must be between 0 and 1023');
        return;
      }

      String radixString = value.toString().padLeft(9, '0');
      List<int> octList = [
        int.parse(radixString.substring(0, 3)),
        int.parse(radixString.substring(3, 6)),
        int.parse(radixString.substring(6, 9)),
      ];
      context.read(stimulationServiceProvider.notifier).sendStimulationBytes(octList);
      _currentPoint.x = value;
      enterVoltageFocusNode.requestFocus();
      confirmButtonLockout = false;
      setState(() {});
    } on FormatException {
      Get.snackbar('Format error', 'Wrong number format');
    } catch (exception) {
      Get.snackbar('Unknown error', '$exception');
    }
  }

  void saveAmpsOnPressed(BuildContext context) {
    try {
      _currentPoint.y = double.parse(_measuredVoltageTextController.text);
      _fittingPoints.add(_currentPoint);
      _byteSendTextController.clear();
      _measuredVoltageTextController.clear();
      _currentPoint = FittingPoint(null, null);
      enterStimulationValue.requestFocus();
      confirmButtonLockout = true;
      setState(() {});
    } on FormatException {
      Get.snackbar('Format error', 'Wrong number format of resistance or voltage');
    } on IntegerDivisionByZeroException {
      Get.snackbar('Format error', 'Resistance must not be zero');
    } catch (exception) {
      Get.snackbar('Unknown error', '$exception');
    }
  }

  String fittingPointsToString() {
    String points = '';
    _fittingPoints.forEach((point) {
      points = points + '(${point.x.toString()}, ${point.y.toStringAsFixed(2)}) ';
    });

    return points;
  }

  void startFitting() async {
    List<FittingPoint> tmp = performDeepCopy(_fittingPoints);
    int resistance = int.parse(_resistance.value.text);

    tmp.forEach((point) {
      point.y = log((point.y / resistance) * 1000000);
    });
    PolynomialFit result = await FittingCurveCalculator.calculate(tmp);

    if (result != null) {
      setState(() {
        oldFirstCoefficient = result.coefficients.first.toStringAsFixed(3);
        oldSecondCoefficient = result.coefficients.elementAt(1).toStringAsFixed(3);
        oldDataPoints = fittingPointsToString();
        oldResistance = _resistance.text;
      });
      await prefs.setDouble('fittingCurveFirstCoefficient', result.coefficients.first);
      await prefs.setDouble('fittingCurveSecondCoefficient', result.coefficients.elementAt(1));
      await prefs.setString('fittingPointList', oldDataPoints);
      await prefs.setString('resistance', oldResistance);
    } else
      Get.snackbar('Error', 'An error occurred while trying to fit the curve');
  }

  List<FittingPoint> performDeepCopy(List<FittingPoint> listToCopy) {
    List<FittingPoint> copy = [];

    listToCopy.forEach((fittingPoint) {
      copy.add(FittingPoint(fittingPoint.x, fittingPoint.y));
    });

    return copy;
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
              Text('Send Bytes to ESP for the voltage fitting process.', style: Themes.getDefaultTextStyle()),
              TextField(
                style: _currentPoint?.x != null ? TextStyle(color: Colors.grey) : TextStyle(),
                controller: _resistance,
                decoration: InputDecoration(labelText: 'Enter resistance'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _byteSendTextController,
                      onChanged: (newValue) => setState(() => confirmButtonLockout = true),
                      decoration: InputDecoration(labelText: 'Enter stimulation as decimal (0-1023)'),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: ElevatedButton(
                      onPressed: () => sendBytesToESP(context),
                      child: Text('Send', style: Themes.getButtonTextStyle()),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: enterVoltageFocusNode,
                      readOnly: confirmButtonLockout,
                      controller: _measuredVoltageTextController,
                      decoration: InputDecoration(labelText: 'Enter measured voltage as floating point'),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: ElevatedButton(
                      onPressed: confirmButtonLockout ? null : () => saveAmpsOnPressed(context),
                      child: Text('Confirm', style: Themes.getButtonTextStyle()),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              GestureDetector(
                  onTap: () async {
                    await showDialog(context: context, builder: (context) => showFittingPointListDialog());
                    setState(() {});
                  },
                  child: Text(fittingPointsToString(), textAlign: TextAlign.start, style: Themes.getDefaultTextStyle())),
              Center(
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    _fittingPoints.clear();
                    _fittingPoints.addAll(performDeepCopy(_testingPoints));
                  }),
                  child: Text('Load test data set', style: Themes.getButtonTextStyle()),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _fittingPoints.isNotEmpty ? () => startFitting() : null,
                  child: Text('Start fitting with given points', style: Themes.getButtonTextStyle()),
                ),
              ),
              ByteArrayTestBar(),
              FittingCurveInfoWindow(oldFirstCoefficient, oldSecondCoefficient, oldResistance, oldDataPoints),
              Divider(thickness: 2),
              BluetoothDevicePicker(),
            ],
          ),
        );
      }),
    );
  }
}
