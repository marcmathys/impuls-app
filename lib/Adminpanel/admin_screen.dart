import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impulsrefactor/Adminpanel/fitting_curve_info_window.dart';
import 'package:impulsrefactor/Adminpanel/test_byte_array_bar.dart';
import 'package:impulsrefactor/Entities/fitting_curve.dart';
import 'package:impulsrefactor/Entities/fitting_lookup_table.dart';
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
  TextEditingController _microAmpereController;
  List<FittingPoint> _fittingPoints = [];
  FittingPoint _currentPoint;
  FocusNode enterStimulationValue;
  FocusNode enterVoltageFocusNode;
  String oldDataPoints;
  String oldResistance;
  bool confirmButtonLockout = true;
  SharedPreferences prefs;

  //TODO: Remove debug lists!
  List<FittingPoint> _testingPoints = [
    /**FittingPoint(32, 198.5),
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
        FittingPoint(1023, 0.7), **/

    FittingPoint(0, 234.5),
    FittingPoint(20, 206.5),
    FittingPoint(40, 179.5),
    FittingPoint(60, 158.0),
    FittingPoint(80, 140.5),
    FittingPoint(100, 123.5),
    FittingPoint(120, 111.0),
    FittingPoint(140, 98.5),
    FittingPoint(160, 89.0),
    FittingPoint(180, 79.5),
    FittingPoint(200, 70.5),
    FittingPoint(220, 63.5),
    FittingPoint(240, 57.0),
    FittingPoint(260, 51.5),
    FittingPoint(280, 45.5),
    FittingPoint(300, 41.5),
    FittingPoint(320, 37.0),
    FittingPoint(340, 33.0),
    FittingPoint(360, 29.0),
    FittingPoint(380, 25.0),
    FittingPoint(400, 23.0),
    FittingPoint(420, 20.5),
    FittingPoint(440, 18.0),
    FittingPoint(460, 16.0),
    FittingPoint(480, 14.0),
    FittingPoint(500, 12.5),
    FittingPoint(520, 10.5),
    FittingPoint(540, 9.5),
    FittingPoint(560, 8.0),
    FittingPoint(580, 7.0),
    FittingPoint(600, 6.0),
    FittingPoint(620, 5.5),
    FittingPoint(640, 4.7),
    FittingPoint(660, 4.1),
    FittingPoint(680, 3.5),
    FittingPoint(700, 3.1),
    FittingPoint(750, 2.2),
    FittingPoint(800, 1.6),
    FittingPoint(850, 1.2),
    FittingPoint(900, 1.0),
    FittingPoint(950, 0.8),
    FittingPoint(1000, 0.6),
    FittingPoint(1023, 0.5),
  ];

  @override
  void initState() {
    super.initState();
    _byteSendTextController = TextEditingController();
    _editXValueController = TextEditingController();
    _editYValueController = TextEditingController();
    _measuredVoltageTextController = TextEditingController();
    _resistance = TextEditingController(text: '10000');
    _microAmpereController = TextEditingController();
    _currentPoint = FittingPoint(null, null);
    enterStimulationValue = FocusNode();
    enterVoltageFocusNode = FocusNode();

    SharedPreferences.getInstance().then((preferences) {
      this.prefs = preferences;
      if (prefs.containsKey('fittingPointList')) {
        oldDataPoints = prefs.getString('fittingPointList');
      }
      if (prefs.containsKey('resistance')) {
        oldResistance = prefs.getString('resistance');
      }
      setState(() {});
    });
  }

  StatefulBuilder showFittingPointListDialog() {
    List<FittingPoint> fittingPointsUpdate = FittingCurveCalculator.performDeepCopy(_fittingPoints);

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
                _fittingPoints.addAll(FittingCurveCalculator.performDeepCopy(fittingPointsUpdate));
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
                        Text(fittingPointsUpdate.elementAt(index).decimalValue.toString(), style: Themes.getDefaultTextStyle()),
                        Text(fittingPointsUpdate.elementAt(index).volt.toString(), style: Themes.getDefaultTextStyle()),
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
    _editXValueController.text = points.elementAt(index).decimalValue.toString();
    _editYValueController.text = points.elementAt(index).volt.toString();

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
              points.elementAt(index).decimalValue = int.parse(_editXValueController.text);
              points.elementAt(index).volt = double.parse(_editYValueController.text);
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
        Get.snackbar('Device error', 'No device connected');
        return;
      }

      ByteData data = ByteData(3);
      data.setInt16(1, value, Endian.big);

      context.read(stimulationServiceProvider.notifier).sendStimulationBytes(data.buffer.asUint8List().toList());
      _currentPoint.decimalValue = value;
      enterVoltageFocusNode.requestFocus();
      confirmButtonLockout = false;
      setState(() {});
    } on FormatException {
      Get.snackbar('Format error', 'Wrong number format');
    } catch (exception) {
      Get.snackbar('Unknown error', '$exception');
    }
  }

  void addToFittingCurve() {
    try {
      _currentPoint.volt = double.parse(_measuredVoltageTextController.text);
      _fittingPoints.add(_currentPoint);
      _byteSendTextController.clear();
      _measuredVoltageTextController.clear();
      _microAmpereController.clear();
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

  addToLookupTableButtonPressed() {
    try {
      LookupTable.setLookupTableValue(_microAmpereController.text, int.parse(_byteSendTextController.text));
      _byteSendTextController.clear();
      _measuredVoltageTextController.clear();
      _microAmpereController.clear();
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
      points = points + '(${point.decimalValue.toString()}, ${point.volt.toStringAsFixed(2)}) ';
    });

    return points;
  }

  Column fittingPointsToColumn() {
    String decimal = 'Decimal';
    String volt = 'Volt';

    _fittingPoints.forEach((point) {
      decimal = '$decimal\n${point.decimalValue.toString()}';
      volt = '$volt\n${point.volt.toStringAsFixed(2)}';
    });

    return Column(
      children: [
        Text('Fitting points'),
        SizedBox(height: 5),
        Row(
          children: [
            Text(decimal, textAlign: TextAlign.start, style: Themes.getSmallTextStyle()),
            VerticalDivider(thickness: 3.0),
            Text(volt, textAlign: TextAlign.start, style: Themes.getSmallTextStyle()),
          ],
        ),
      ],
    );
  }

  Column lookupTableToColumn() {
    String microAmpere = 'µA';
    String integer = 'Integer value';

    LookupTable.getLookupTable().forEach((key, value) {
      microAmpere = '$microAmpere\n$key';
      integer = '$integer\n$value';
    });

    return Column(
      children: [
        Text('Lookup Table'),
        SizedBox(height: 5),
        Row(
          children: [
            Text(microAmpere, textAlign: TextAlign.start, style: Themes.getSmallTextStyle()),
            VerticalDivider(thickness: 3.0),
            Text(integer, textAlign: TextAlign.start, style: Themes.getSmallTextStyle()),
          ],
        ),
      ],
    );
  }

  void startFitting() async {
    List<FittingPoint> tmp = FittingCurveCalculator.performDeepCopy(_fittingPoints);
    int resistance = int.parse(_resistance.value.text);

    tmp.forEach((point) {
      point.volt = log((point.volt / resistance) * 1000000);
    });
    PolynomialFit result = await FittingCurveCalculator.calculate(tmp);

    if (result != null) {
      setState(() {
        oldDataPoints = fittingPointsToString();
        oldResistance = _resistance.text;
      });
      Map<String, double> coefficients = {};
      coefficients['first'] = result.coefficients[0];
      coefficients['second'] = result.coefficients[1];
      await FittingCurve.setFittingCurveCoefficient(coefficients);
      await prefs.setString('fittingPointList', oldDataPoints);
      await prefs.setString('resistance', oldResistance);
    } else
      Get.snackbar('Error', 'An error occurred while trying to fit the curve');
  }

  editMicroAmpereTextField(String voltageValue) {
    int value = int.parse(voltageValue);
    int resistance = 0;

    if (_resistance.text.isEmpty || _resistance.text == '0') {
      resistance = 1;
    } else {
      resistance = int.parse(_resistance.text);
    }

    setState(() {
      _microAmpereController.text = (value * 1000000 / resistance).toStringAsFixed(0);
    });
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
                controller: _resistance,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter resistance'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _byteSendTextController,
                      onChanged: (newValue) {
                        if (newValue != '') {
                          setState(() => confirmButtonLockout = true);
                        }
                      },
                      keyboardType: TextInputType.number,
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
              Divider(thickness: 2),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _measuredVoltageTextController,
                      onChanged: (voltageValue) => editMicroAmpereTextField(voltageValue),
                      focusNode: enterVoltageFocusNode,
                      readOnly: confirmButtonLockout,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Measured voltage as floating point'),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      onPressed: confirmButtonLockout ? null : () => addToFittingCurve(),
                      child: Text('Add to fitting curve', style: Themes.getButtonTextStyle()),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _microAmpereController,
                      readOnly: confirmButtonLockout,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Resulting µA'),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      onPressed: confirmButtonLockout ? null : () => addToLookupTableButtonPressed(),
                      child: Text('Add to lookup table', style: Themes.getButtonTextStyle()),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 2),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => null,
                    child: lookupTableToColumn(),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await showDialog(context: context, builder: (context) => showFittingPointListDialog());
                      setState(() {});
                    },
                    child: fittingPointsToColumn(),
                  ),
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    _fittingPoints.clear();
                    _fittingPoints.addAll(FittingCurveCalculator.performDeepCopy(_testingPoints));
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
              FittingCurveInfoWindow(
                  FittingCurve.getFittingCurveCoefficients()['first'].toStringAsFixed(3), FittingCurve.getFittingCurveCoefficients()['second'].toStringAsFixed(3), oldResistance, oldDataPoints),
              Divider(thickness: 2),
              BluetoothDevicePicker(),
            ],
          ),
        );
      }),
    );
  }
}
