import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:impulsrefactor/Entities/medical_data.dart';

class BTState extends ChangeNotifier {
  static final BTState _instance = BTState._internal();
  factory BTState() => _instance;

  BTState._internal();

  List<MedicalData> _ekgPoints = [MedicalData(DateTime.now(), 0, 0)];
  Map<Guid, BluetoothCharacteristic> _characteristics = {};
  double _bpm = 0.0;
  int _error;
  int _brs;

  int get brs => _brs;

  set brs(int value) {
    _brs = value;
    notifyListeners();
  }

  int get error => _error;

  set error(int value) {
    _error = value;
    notifyListeners();
  }

  Map<Guid, BluetoothCharacteristic> get characteristics => _characteristics;

  set characteristics(Map<Guid, BluetoothCharacteristic> value) {
    _characteristics = value;
  }

  double get bpm => _bpm;

  set bpm(double value) {
    _bpm = value;
    notifyListeners();
  }

  List<MedicalData> get ekgPoints => _ekgPoints;

  set ekgPoints(List<MedicalData> value) {
    _ekgPoints = value;
  }
}